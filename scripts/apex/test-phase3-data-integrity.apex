Savepoint integritySavepoint = Database.setSavepoint();
Integer passed = 0;
Integer failed = 0;
Integer pending = 0;

try {
    // Reference-data counts
    Boolean countCheck =
        [SELECT COUNT() FROM Department__c WHERE Department_code__c LIKE 'SYN-%'] == 3 &&
        [SELECT COUNT() FROM Position__c WHERE Position_code__c LIKE 'SYN-%'] == 9 &&
        [SELECT COUNT() FROM Skill__c WHERE Skill_code__c LIKE 'SYN-%'] == 22 &&
        [SELECT COUNT() FROM Candidate__c WHERE Email__c LIKE '%@example.invalid'] == 3 &&
        [SELECT COUNT() FROM Employee__c WHERE Employee_Number__c LIKE 'SYN-%'] == 2 &&
        [SELECT COUNT() FROM Job_Opening__c WHERE Public_Job_Title__c LIKE 'Synthetic %'] == 2;
    if (countCheck) { passed++; System.debug('PHASE3_TEST|reference_counts|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|reference_counts|FAIL'); }

    // Required-field enforcement
    Database.SaveResult missingDepartment = Database.insert(
        new Position__c(Name='Synthetic Missing Department', Position_code__c='SYN-INVALID-POS', Job_Level__c='Entry'),
        false
    );
    if (!missingDepartment.isSuccess()) { passed++; System.debug('PHASE3_TEST|required_fields|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|required_fields|FAIL'); }

    // Invalid numeric and date values
    Database.SaveResult negativeExperience = Database.insert(
        new Candidate__c(First_Name__c='Invalid', Last_Name__c='Experience', Email__c='invalid.experience@example.invalid', Profile_Status__c='Active', Total_Experience__c=-1),
        false
    );
    if (!negativeExperience.isSuccess()) { passed++; System.debug('PHASE3_TEST|invalid_candidate_experience|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|invalid_candidate_experience|FAIL'); }

    Candidate__c jordan = [SELECT Id, Contact__c FROM Candidate__c WHERE Email__c='jordan.lee@example.invalid' LIMIT 1];
    Candidate__c casey = [SELECT Id FROM Candidate__c WHERE Email__c='casey.morgan@example.invalid' LIMIT 1];
    Job_Opening__c developerOpening = [SELECT Id, Requisition__c, Position__c FROM Job_Opening__c WHERE Public_Job_Title__c='Synthetic Salesforce Developer Opening' LIMIT 1];
    Job_Opening__c qualityOpening = [SELECT Id FROM Job_Opening__c WHERE Public_Job_Title__c='Synthetic Quality Engineer Opening' LIMIT 1];
    Job_Application__c jordanApplication = [SELECT Id, Candidate__c, Job_Opening__c FROM Job_Application__c WHERE Candidate__c=:jordan.Id AND Job_Opening__c=:developerOpening.Id LIMIT 1];
    Job_Application__c caseyApplication = [SELECT Id FROM Job_Application__c WHERE Candidate__c=:casey.Id AND Job_Opening__c=:qualityOpening.Id LIMIT 1];
    Employee__c employee = [SELECT Id, Reporting_Manager__c FROM Employee__c WHERE Employee_Number__c='SYN-EMP-002' LIMIT 1];

    Database.SaveResult invalidEmploymentDates = Database.insert(
        new Employment_Experience__c(Candidate__c=jordan.Id, Employer__c='Synthetic Invalid Employer', Job_Title__c='Invalid Dates', Start_Date__c=Date.today(), End_Date__c=Date.today().addDays(-1)),
        false
    );
    if (!invalidEmploymentDates.isSuccess()) { passed++; System.debug('PHASE3_TEST|invalid_employment_dates|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|invalid_employment_dates|FAIL'); }

    // Duplicate identity and active-application controls
    Database.SaveResult duplicateContact = Database.insert(
        new Candidate__c(Contact__c=jordan.Contact__c, First_Name__c='Duplicate', Last_Name__c='Identity', Email__c='duplicate.identity@example.invalid', Profile_Status__c='Active'),
        false
    );
    if (!duplicateContact.isSuccess()) { passed++; System.debug('PHASE3_TEST|duplicate_candidate_contact|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|duplicate_candidate_contact|FAIL'); }

    Database.SaveResult duplicateApplication = Database.insert(
        new Job_Application__c(Candidate__c=casey.Id, Job_Opening__c=qualityOpening.Id, Status__c='Draft'),
        false
    );
    if (!duplicateApplication.isSuccess()) { passed++; System.debug('PHASE3_TEST|duplicate_active_application|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|duplicate_active_application|FAIL'); }

    // Candidate -> Application -> Interview -> Offer -> Employee
    Integer recruitmentChain = [
        SELECT COUNT()
        FROM Offer__c
        WHERE Application__c=:jordanApplication.Id
        AND Application__r.Candidate__c=:jordan.Id
    ];
    Integer interviewChain = [SELECT COUNT() FROM interview__c WHERE Application__c=:jordanApplication.Id];
    if (recruitmentChain == 1 && interviewChain == 1 && employee.Id != null) {
        passed++; System.debug('PHASE3_TEST|candidate_application_interview_offer_employee|PASS');
    } else { failed++; System.debug('PHASE3_TEST|candidate_application_interview_offer_employee|FAIL'); }

    // Employee -> Review -> Development Plan
    Performance_Review__c review = [SELECT Id, Total_Goal_Weight__c FROM Performance_Review__c WHERE Employee__c=:employee.Id LIMIT 1];
    Integer developmentChain = [SELECT COUNT() FROM Development_Plan__c WHERE Employee__c=:employee.Id AND Performance_Review__c=:review.Id];
    if (developmentChain == 1) { passed++; System.debug('PHASE3_TEST|employee_review_development_plan|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|employee_review_development_plan|FAIL'); }

    // Employee -> Succession Nomination -> Readiness Assessment
    Succession_Nomination__c nomination = [SELECT Id, Latest_Readiness__c, Latest_Assessment_Date__c FROM Succession_Nomination__c WHERE Employee__c=:employee.Id LIMIT 1];
    Integer readinessChain = [SELECT COUNT() FROM Readiness_Assessment__c WHERE Succession_Nomination__c=:nomination.Id];
    if (readinessChain == 1) { passed++; System.debug('PHASE3_TEST|employee_nomination_readiness|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|employee_nomination_readiness|FAIL'); }

    // Application -> Match Result -> Criterion Results and explainability
    Match_Result__c matchResult = [SELECT Id, Total_Criterion_Weight__c, Calculated_Criterion_Score__c FROM Match_Result__c WHERE Application__c=:caseyApplication.Id LIMIT 1];
    List<Match_Criterion_Result__c> criteria = [SELECT Id, Criterion_Name__c, Required_Value__c, Candidate_Value__c, Weight__c, Score__c, Is_Matched__c, Is_Mandatory__c, Explanation__c FROM Match_Criterion_Result__c WHERE Match_Result__c=:matchResult.Id];
    Boolean criteriaComplete = criteria.size() == 3;
    for (Match_Criterion_Result__c criterion : criteria) {
        criteriaComplete = criteriaComplete && criterion.Criterion_Name__c != null && criterion.Required_Value__c != null && criterion.Candidate_Value__c != null && criterion.Weight__c != null && criterion.Score__c != null && criterion.Explanation__c != null;
    }
    if (criteriaComplete) { passed++; System.debug('PHASE3_TEST|application_match_criteria|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|application_match_criteria|FAIL'); }

    // Rollups
    Onboarding_Plan__c onboarding = [SELECT Total_Tasks__c, Completed_Tasks__c, Completion_Percentage__c FROM Onboarding_Plan__c WHERE Employee__c=:employee.Id LIMIT 1];
    Boolean onboardingRollup = onboarding.Total_Tasks__c == 4 && onboarding.Completed_Tasks__c == 2 && onboarding.Completion_Percentage__c == 50;
    if (onboardingRollup) { passed++; System.debug('PHASE3_TEST|onboarding_rollups|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|onboarding_rollups|FAIL|total=' + onboarding.Total_Tasks__c + '|completed=' + onboarding.Completed_Tasks__c + '|percentage=' + onboarding.Completion_Percentage__c); }

    if (review.Total_Goal_Weight__c == 100) { passed++; System.debug('PHASE3_TEST|performance_goal_weight_rollup|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|performance_goal_weight_rollup|FAIL|value=' + review.Total_Goal_Weight__c); }

    if (nomination.Latest_Assessment_Date__c != null && nomination.Latest_Readiness__c != null) { passed++; System.debug('PHASE3_TEST|succession_latest_assessment|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|succession_latest_assessment|FAIL'); }

    if (matchResult.Total_Criterion_Weight__c == 100 && matchResult.Calculated_Criterion_Score__c != null) { passed++; System.debug('PHASE3_TEST|match_rollups|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|match_rollups|FAIL|weight=' + matchResult.Total_Criterion_Weight__c + '|score=' + matchResult.Calculated_Criterion_Score__c); }

    // Inactive reference enforcement: test actual save behavior.
    Skill__c inactiveSkill = new Skill__c(Name='Synthetic Inactive Skill', Skill_code__c='SYN-INACTIVE-SKILL', Category__c='Testing', Normalized_Name__c='synthetic inactive skill', Is_Active__c=false);
    insert inactiveSkill;
    Database.SaveResult inactiveSkillUse = Database.insert(
        new Job_Skill_Requirement__c(Job_Opening__c=developerOpening.Id, Skill__c=inactiveSkill.Id, Job_Skill_Requirement_Fields__c='Optional', Requirement_Version__c=99, Active__c=true),
        false
    );
    if (!inactiveSkillUse.isSuccess()) { passed++; System.debug('PHASE3_TEST|inactive_reference_enforcement|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|inactive_reference_enforcement|FAIL|inactive skill was accepted'); }

    // Relationship traversal for reporting.
    Integer reportTraversalOne = [SELECT COUNT() FROM Job_Application__c WHERE Candidate__r.Email__c LIKE '%@example.invalid' AND Job_Opening__r.Requisition__r.Department__r.Department_code__c='SYN-ENG'];
    Integer reportTraversalTwo = [SELECT COUNT() FROM Development_Action__c WHERE Development_Plan__r.Performance_Review__r.Employee__r.Employee_Number__c='SYN-EMP-002'];
    Integer reportTraversalThree = [SELECT COUNT() FROM Readiness_Assessment__c WHERE Succession_Nomination__r.Critical_Position__r.Position__r.Position_code__c='SYN-ENGMGR'];
    if (reportTraversalOne > 0 && reportTraversalTwo > 0 && reportTraversalThree > 0) { passed++; System.debug('PHASE3_TEST|report_relationship_traversal|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|report_relationship_traversal|FAIL'); }

    // Candidate isolation requires external users and Phase 4 sharing metadata.
    Set<Id> syntheticContactIds = new Set<Id>();
    for (Candidate__c candidate : [SELECT Contact__c FROM Candidate__c WHERE Email__c LIKE '%@example.invalid']) if (candidate.Contact__c != null) syntheticContactIds.add(candidate.Contact__c);
    Integer externalUsers = [SELECT COUNT() FROM User WHERE ContactId IN :syntheticContactIds];
    if (externalUsers >= 2) {
        pending++; System.debug('PHASE3_TEST|external_candidate_isolation|PENDING|external users exist but interactive sharing test is required');
    } else {
        pending++; System.debug('PHASE3_TEST|external_candidate_isolation|PENDING|Phase 4 external users and sharing are not configured');
    }

    // Historical deletion behavior: an Application with Interview, Offer and Onboarding links must resist casual deletion.
    Database.DeleteResult historicalDelete = Database.delete(jordanApplication, false);
    if (!historicalDelete.isSuccess()) { passed++; System.debug('PHASE3_TEST|historical_delete_protection|PASS'); }
    else { failed++; System.debug('PHASE3_TEST|historical_delete_protection|FAIL|application was deletable by administrator'); }

    System.debug('PHASE3_SUMMARY|passed=' + passed + '|failed=' + failed + '|pending=' + pending);
} finally {
    Database.rollback(integritySavepoint);
}
