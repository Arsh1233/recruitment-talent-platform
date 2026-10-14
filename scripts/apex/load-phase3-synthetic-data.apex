// Synthetic Phase 3 demonstration data only. Safe to rerun.
// All emails use the reserved example.invalid domain.

Id runningUserId = UserInfo.getUserId();
Date today = Date.today();

// Departments
List<Department__c> departments = new List<Department__c>{
    new Department__c(Name = 'Synthetic Engineering', Department_code__c = 'SYN-ENG', Is_Active__c = true),
    new Department__c(Name = 'Synthetic People Operations', Department_code__c = 'SYN-HR', Is_Active__c = true),
    new Department__c(Name = 'Synthetic Product and Delivery', Department_code__c = 'SYN-PD', Is_Active__c = true)
};
upsert departments Department_code__c;
Map<String, Department__c> departmentByCode = new Map<String, Department__c>();
for (Department__c department : departments) {
    departmentByCode.put(department.Department_code__c, department);
}

// Positions
List<Position__c> positions = new List<Position__c>{
    new Position__c(Name='Synthetic Salesforce Developer', Position_code__c='SYN-SFDEV', Department__c=departmentByCode.get('SYN-ENG').Id, Job_Level__c='Mid-Level', Is_Active__c=true, Critical_Role_Eligible__c=true),
    new Position__c(Name='Synthetic Senior Salesforce Developer', Position_code__c='SYN-SRSFDEV', Department__c=departmentByCode.get('SYN-ENG').Id, Job_Level__c='Senior', Is_Active__c=true, Critical_Role_Eligible__c=true),
    new Position__c(Name='Synthetic Quality Engineer', Position_code__c='SYN-QAENG', Department__c=departmentByCode.get('SYN-ENG').Id, Job_Level__c='Mid-Level', Is_Active__c=true),
    new Position__c(Name='Synthetic DevOps Engineer', Position_code__c='SYN-DEVOPS', Department__c=departmentByCode.get('SYN-ENG').Id, Job_Level__c='Mid-Level', Is_Active__c=true, Critical_Role_Eligible__c=true),
    new Position__c(Name='Synthetic Engineering Manager', Position_code__c='SYN-ENGMGR', Department__c=departmentByCode.get('SYN-ENG').Id, Job_Level__c='Manager', Is_Active__c=true, Critical_Role_Eligible__c=true),
    new Position__c(Name='Synthetic Product Manager', Position_code__c='SYN-PRODMGR', Department__c=departmentByCode.get('SYN-PD').Id, Job_Level__c='Manager', Is_Active__c=true, Critical_Role_Eligible__c=true),
    new Position__c(Name='Synthetic Business Analyst', Position_code__c='SYN-BA', Department__c=departmentByCode.get('SYN-PD').Id, Job_Level__c='Mid-Level', Is_Active__c=true),
    new Position__c(Name='Synthetic Talent Recruiter', Position_code__c='SYN-REC', Department__c=departmentByCode.get('SYN-HR').Id, Job_Level__c='Mid-Level', Is_Active__c=true),
    new Position__c(Name='Synthetic HR Business Partner', Position_code__c='SYN-HRBP', Department__c=departmentByCode.get('SYN-HR').Id, Job_Level__c='Senior', Is_Active__c=true, Critical_Role_Eligible__c=true)
};
upsert positions Position_code__c;
Map<String, Position__c> positionByCode = new Map<String, Position__c>();
for (Position__c positionRecord : positions) {
    positionByCode.put(positionRecord.Position_code__c, positionRecord);
}

// Skills
List<Skill__c> skills = new List<Skill__c>{
    new Skill__c(Name='Apex', Skill_code__c='SYN-APEX', Category__c='Salesforce', Normalized_Name__c='apex', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Lightning Web Components', Skill_code__c='SYN-LWC', Category__c='Salesforce', Normalized_Name__c='lightning web components', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Salesforce Flow', Skill_code__c='SYN-FLOW', Category__c='Salesforce', Normalized_Name__c='salesforce flow', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='SOQL', Skill_code__c='SYN-SOQL', Category__c='Salesforce', Normalized_Name__c='soql', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Experience Cloud', Skill_code__c='SYN-EXPCLOUD', Category__c='Salesforce', Normalized_Name__c='experience cloud', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Salesforce Security', Skill_code__c='SYN-SFSEC', Category__c='Security', Normalized_Name__c='salesforce security', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='JavaScript', Skill_code__c='SYN-JS', Category__c='Programming Language', Normalized_Name__c='javascript', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Java', Skill_code__c='SYN-JAVA', Category__c='Programming Language', Normalized_Name__c='java', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Python', Skill_code__c='SYN-PYTHON', Category__c='Programming Language', Normalized_Name__c='python', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='SQL', Skill_code__c='SYN-SQL', Category__c='Database', Normalized_Name__c='sql', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Git', Skill_code__c='SYN-GIT', Category__c='DevOps', Normalized_Name__c='git', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='CI/CD', Skill_code__c='SYN-CICD', Category__c='DevOps', Normalized_Name__c='ci/cd', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Azure', Skill_code__c='SYN-AZURE', Category__c='Cloud', Normalized_Name__c='azure', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='AWS', Skill_code__c='SYN-AWS', Category__c='Cloud', Normalized_Name__c='aws', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Automated Testing', Skill_code__c='SYN-AUTOTEST', Category__c='Testing', Normalized_Name__c='automated testing', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Manual Testing', Skill_code__c='SYN-MANTEST', Category__c='Testing', Normalized_Name__c='manual testing', Is_Active__c=true, Is_Technical_Skill__c=true),
    new Skill__c(Name='Business Analysis', Skill_code__c='SYN-BUSAN', Category__c='Business Analysis', Normalized_Name__c='business analysis', Is_Active__c=true),
    new Skill__c(Name='Requirements Management', Skill_code__c='SYN-REQMGT', Category__c='Business Analysis', Normalized_Name__c='requirements management', Is_Active__c=true),
    new Skill__c(Name='Project Management', Skill_code__c='SYN-PROJMGT', Category__c='Project Management', Normalized_Name__c='project management', Is_Active__c=true),
    new Skill__c(Name='Communication', Skill_code__c='SYN-COMM', Category__c='Communication', Normalized_Name__c='communication', Is_Active__c=true),
    new Skill__c(Name='Leadership', Skill_code__c='SYN-LEAD', Category__c='Leadership', Normalized_Name__c='leadership', Is_Active__c=true),
    new Skill__c(Name='Stakeholder Management', Skill_code__c='SYN-STAKE', Category__c='Project Management', Normalized_Name__c='stakeholder management', Is_Active__c=true)
};
upsert skills Skill_code__c;
Map<String, Skill__c> skillByCode = new Map<String, Skill__c>();
for (Skill__c skill : skills) {
    skillByCode.put(skill.Skill_code__c, skill);
}

// Candidate portal identity records
Account candidateAccount;
List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Synthetic Candidate Portal Account' LIMIT 1];
if (existingAccounts.isEmpty()) {
    candidateAccount = new Account(Name='Synthetic Candidate Portal Account');
    insert candidateAccount;
} else {
    candidateAccount = existingAccounts[0];
}

Set<String> candidateEmails = new Set<String>{
    'jordan.lee@example.invalid',
    'casey.morgan@example.invalid',
    'taylor.singh@example.invalid'
};
Map<String, Contact> contactByEmail = new Map<String, Contact>();
for (Contact contact : [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email IN :candidateEmails]) {
    contactByEmail.put(contact.Email.toLowerCase(), contact);
}
List<Contact> contactsToInsert = new List<Contact>();
if (!contactByEmail.containsKey('jordan.lee@example.invalid')) contactsToInsert.add(new Contact(AccountId=candidateAccount.Id, FirstName='Jordan', LastName='Lee', Email='jordan.lee@example.invalid', Phone='+1 202-555-0101'));
if (!contactByEmail.containsKey('casey.morgan@example.invalid')) contactsToInsert.add(new Contact(AccountId=candidateAccount.Id, FirstName='Casey', LastName='Morgan', Email='casey.morgan@example.invalid', Phone='+1 202-555-0102'));
if (!contactByEmail.containsKey('taylor.singh@example.invalid')) contactsToInsert.add(new Contact(AccountId=candidateAccount.Id, FirstName='Taylor', LastName='Singh', Email='taylor.singh@example.invalid', Phone='+1 202-555-0103'));
if (!contactsToInsert.isEmpty()) insert contactsToInsert;
for (Contact contact : [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email IN :candidateEmails]) {
    contactByEmail.put(contact.Email.toLowerCase(), contact);
}

Map<String, Candidate__c> candidateByEmail = new Map<String, Candidate__c>();
for (Candidate__c candidate : [SELECT Id, Email__c FROM Candidate__c WHERE Email__c IN :candidateEmails]) {
    candidateByEmail.put(candidate.Email__c.toLowerCase(), candidate);
}
List<Candidate__c> candidatesToUpsert = new List<Candidate__c>();
List<String> orderedEmails = new List<String>{'jordan.lee@example.invalid','casey.morgan@example.invalid','taylor.singh@example.invalid'};
List<String> firstNames = new List<String>{'Jordan','Casey','Taylor'};
List<String> lastNames = new List<String>{'Lee','Morgan','Singh'};
List<Decimal> experienceYears = new List<Decimal>{4.5,3,5};
for (Integer i = 0; i < orderedEmails.size(); i++) {
    String email = orderedEmails[i];
    Candidate__c candidate = candidateByEmail.get(email);
    if (candidate == null) candidate = new Candidate__c();
    candidate.Contact__c = contactByEmail.get(email).Id;
    candidate.First_Name__c = firstNames[i];
    candidate.Last_Name__c = lastNames[i];
    candidate.Email__c = email;
    candidate.Profile_Status__c = 'Active';
    candidate.Is_Consent_Available__c = true;
    candidate.Is_Resume_Verified__c = true;
    candidate.Total_Experience__c = experienceYears[i];
    candidate.Current_Location__c = 'Synthetic City';
    candidate.Preferred_Location__c = 'Synthetic City';
    candidate.Source__c = 'Import';
    candidatesToUpsert.add(candidate);
}
upsert candidatesToUpsert;
candidateByEmail.clear();
for (Candidate__c candidate : [SELECT Id, Email__c FROM Candidate__c WHERE Email__c IN :candidateEmails]) {
    candidateByEmail.put(candidate.Email__c.toLowerCase(), candidate);
}

// Employees and reporting hierarchy
Employee__c manager = new Employee__c(
    Employee_Number__c='SYN-EMP-001',
    Department__c=departmentByCode.get('SYN-ENG').Id,
    Position__c=positionByCode.get('SYN-ENGMGR').Id,
    Employment_Type__c='Permanent',
    Employment_Status__c='Active',
    Joining_Date__c=today.addYears(-5),
    Location__c='Synthetic City'
);
upsert manager Employee_Number__c;
Employee__c employee = new Employee__c(
    Employee_Number__c='SYN-EMP-002',
    Candidate__c=candidateByEmail.get('jordan.lee@example.invalid').Id,
    Department__c=departmentByCode.get('SYN-ENG').Id,
    Position__c=positionByCode.get('SYN-SFDEV').Id,
    Reporting_Manager__c=manager.Id,
    Employment_Type__c='Permanent',
    Employment_Status__c='Active',
    Joining_Date__c=today.addYears(-1),
    Location__c='Synthetic City'
);
upsert employee Employee_Number__c;

// Requisitions and openings. Existing synthetic openings make reruns reuse their requisitions.
Map<String, Job_Opening__c> openingByTitle = new Map<String, Job_Opening__c>();
Set<String> openingTitles = new Set<String>{'Synthetic Salesforce Developer Opening','Synthetic Quality Engineer Opening'};
for (Job_Opening__c opening : [SELECT Id, Public_Job_Title__c, Requisition__c, Position__c FROM Job_Opening__c WHERE Public_Job_Title__c IN :openingTitles]) {
    openingByTitle.put(opening.Public_Job_Title__c, opening);
}

if (!openingByTitle.containsKey('Synthetic Salesforce Developer Opening')) {
    Job_Requisition__c requisition = new Job_Requisition__c(
        Department__c=departmentByCode.get('SYN-ENG').Id,
        Position__c=positionByCode.get('SYN-SFDEV').Id,
        Number_of_Openings__c=2,
        Version_Number__c=1,
        Status__c='Approved',
        Approved_By__c=runningUserId,
        Approved_At__c=System.now(),
        Target_Hiring_Date__c=today.addDays(60),
        Minimum_Experience__c=2,
        Maximum_Experience__c=6,
        Business_Justification__c='SYNTHETIC-PHASE3 Salesforce developer requirement'
    );
    insert requisition;
    Job_Opening__c opening = new Job_Opening__c(
        Requisition__c=requisition.Id,
        Position__c=positionByCode.get('SYN-SFDEV').Id,
        Public_Job_Title__c='Synthetic Salesforce Developer Opening',
        Public_Description__c='Synthetic opening used only for Phase 3 data validation.',
        Status__c='Published', Is_Published__c=true,
        Publication_Date__c=today, Application_Deadline__c=today.addDays(45),
        Number_of_Openings__c=2, Number_Filled__c=0,
        Requirements_Version__c=1, Location__c='Synthetic City'
    );
    insert opening;
    openingByTitle.put(opening.Public_Job_Title__c, opening);
}

if (!openingByTitle.containsKey('Synthetic Quality Engineer Opening')) {
    Job_Requisition__c requisition = new Job_Requisition__c(
        Department__c=departmentByCode.get('SYN-ENG').Id,
        Position__c=positionByCode.get('SYN-QAENG').Id,
        Number_of_Openings__c=1,
        Version_Number__c=1,
        Status__c='Approved',
        Approved_By__c=runningUserId,
        Approved_At__c=System.now(),
        Target_Hiring_Date__c=today.addDays(60),
        Minimum_Experience__c=2,
        Maximum_Experience__c=5,
        Business_Justification__c='SYNTHETIC-PHASE3 quality engineer requirement'
    );
    insert requisition;
    Job_Opening__c opening = new Job_Opening__c(
        Requisition__c=requisition.Id,
        Position__c=positionByCode.get('SYN-QAENG').Id,
        Public_Job_Title__c='Synthetic Quality Engineer Opening',
        Public_Description__c='Synthetic opening used only for Phase 3 data validation.',
        Status__c='Published', Is_Published__c=true,
        Publication_Date__c=today, Application_Deadline__c=today.addDays(45),
        Number_of_Openings__c=1, Number_Filled__c=0,
        Requirements_Version__c=1, Location__c='Synthetic City'
    );
    insert opening;
    openingByTitle.put(opening.Public_Job_Title__c, opening);
}

// Applications
List<List<String>> applicationPairs = new List<List<String>>{
    new List<String>{'jordan.lee@example.invalid','Synthetic Salesforce Developer Opening'},
    new List<String>{'casey.morgan@example.invalid','Synthetic Quality Engineer Opening'},
    new List<String>{'taylor.singh@example.invalid','Synthetic Salesforce Developer Opening'}
};
Map<String, Job_Application__c> applicationByPair = new Map<String, Job_Application__c>();
Set<Id> syntheticCandidateIds = new Set<Id>();
Set<Id> syntheticOpeningIds = new Set<Id>();
for (Candidate__c candidate : candidateByEmail.values()) syntheticCandidateIds.add(candidate.Id);
for (Job_Opening__c opening : openingByTitle.values()) syntheticOpeningIds.add(opening.Id);
for (Job_Application__c application : [SELECT Id, Candidate__c, Job_Opening__c, Status__c FROM Job_Application__c WHERE Candidate__c IN :syntheticCandidateIds AND Job_Opening__c IN :syntheticOpeningIds]) {
    applicationByPair.put(application.Candidate__c + '-' + application.Job_Opening__c, application);
}
List<Job_Application__c> applicationsToInsert = new List<Job_Application__c>();
for (List<String> pair : applicationPairs) {
    Id candidateId = candidateByEmail.get(pair[0]).Id;
    Id openingId = openingByTitle.get(pair[1]).Id;
    String key = candidateId + '-' + openingId;
    if (!applicationByPair.containsKey(key)) {
        applicationsToInsert.add(new Job_Application__c(
            Candidate__c=candidateId,
            Job_Opening__c=openingId,
            Status__c='Submitted',
            Submitted_At__c=System.now(),
            Is_Candidate_Consent_Confirmed__c=true,
            Candidate_Profile_Version__c=1,
            Job_Requirements_Version__c=1,
            Source__c='Career Site'
        ));
    }
}
if (!applicationsToInsert.isEmpty()) insert applicationsToInsert;
applicationByPair.clear();
for (Job_Application__c application : [SELECT Id, Candidate__c, Job_Opening__c, Status__c FROM Job_Application__c WHERE Candidate__c IN :syntheticCandidateIds AND Job_Opening__c IN :syntheticOpeningIds]) {
    applicationByPair.put(application.Candidate__c + '-' + application.Job_Opening__c, application);
}

Id jordanApplicationId = applicationByPair.get(candidateByEmail.get('jordan.lee@example.invalid').Id + '-' + openingByTitle.get('Synthetic Salesforce Developer Opening').Id).Id;
Id caseyApplicationId = applicationByPair.get(candidateByEmail.get('casey.morgan@example.invalid').Id + '-' + openingByTitle.get('Synthetic Quality Engineer Opening').Id).Id;

// Interview and evaluation
List<interview__c> interviews = [SELECT Id FROM interview__c WHERE Application__c=:jordanApplicationId AND Round_Number__c=1 LIMIT 1];
interview__c syntheticInterview;
if (interviews.isEmpty()) {
    syntheticInterview = new interview__c(
        Application__c=jordanApplicationId,
        Round_Number__c=1,
        Interview_Type__c='Technical',
        Status__c='Scheduled',
        Scheduled_Start__c=System.now().addDays(7),
        Scheduled_End__c=System.now().addDays(7).addHours(1),
        Primary_Interviewer__c=runningUserId,
        Scheduled_By__c=runningUserId,
        Interview_Mode__c='Video',
        Is_Candidate_Confirmed__c=true,
        Confirmation_At__c=System.now(),
        Consolidated_Score__c=4.2,
        Consolidated_Recommendation__c='Hire'
    );
    insert syntheticInterview;
} else syntheticInterview = interviews[0];

if ([SELECT COUNT() FROM Interview_Evaluation__c WHERE Interview__c=:syntheticInterview.Id AND Interviewer__c=:runningUserId] == 0) {
    insert new Interview_Evaluation__c(
        Interview__c=syntheticInterview.Id, Interviewer__c=runningUserId,
        Technical_Score__c=4, Problem_Solving_Score__c=4,
        Experience_Score__c=4, Communication_Score__c=5,
        Role_Suitability_Score__c=4, Overall_Score__c=4.2,
        Recommendation__c='Hire', Comments__c='Synthetic evaluation.',
        Is_Submitted__c=true, Submitted_At__c=System.now().addDays(-7)
    );
}

// Accepted offer and hired application
List<Offer__c> offers = [SELECT Id FROM Offer__c WHERE Application__c=:jordanApplicationId LIMIT 1];
Offer__c syntheticOffer;
if (offers.isEmpty()) {
    syntheticOffer = new Offer__c(
        Application__c=jordanApplicationId, Version_Number__c=1,
        Status__c='Accepted', Candidate_Response__c='Accepted',
        Offered_Position__c=positionByCode.get('SYN-SFDEV').Id, Offered_Salary__c=75000,
        Sent_Date__c=today.addDays(-6), Response_Date__c=today.addDays(-5),
        Joining_Date__c=today.addDays(14), Expiration_Date__c=today.addDays(7),
        Location__c='Synthetic City', Work_Mode__c='Hybrid'
    );
    insert syntheticOffer;
} else syntheticOffer = offers[0];
Job_Application__c jordanApplication = new Job_Application__c(Id=jordanApplicationId, Status__c='Hired', Hired_Date__c=today);
update jordanApplication;

// Onboarding plan and four tasks (two completed) for rollup verification
List<Onboarding_Plan__c> plans = [SELECT Id FROM Onboarding_Plan__c WHERE Employee__c=:employee.Id AND Application__c=:jordanApplicationId LIMIT 1];
Onboarding_Plan__c onboardingPlan;
if (plans.isEmpty()) {
    onboardingPlan = new Onboarding_Plan__c(
        Employee__c=employee.Id, Application__c=jordanApplicationId, Offer__c=syntheticOffer.Id,
        Coordinator__c=runningUserId, Status__c='In Progress',
        Planned_Start_Date__c=today, Joining_Date__c=today.addDays(14)
    );
    insert onboardingPlan;
} else onboardingPlan = plans[0];
if ([SELECT COUNT() FROM Onboarding_Task__c WHERE Onboarding_Plan__c=:onboardingPlan.Id] == 0) {
    insert new List<Onboarding_Task__c>{
        new Onboarding_Task__c(Name='Synthetic Submit Documents', Onboarding_Plan__c=onboardingPlan.Id, Task_Category__c='Candidate', Assigned_Candidate__c=candidateByEmail.get('jordan.lee@example.invalid').Id, Due_Date__c=today.addDays(3), Is_Mandatory__c=true, Status__c='Completed', Completed_Date__c=today, Complete_Notes__c='Synthetic completion.', Display_Order__c=1),
        new Onboarding_Task__c(Name='Synthetic Verify Documents', Onboarding_Plan__c=onboardingPlan.Id, Task_Category__c='HR', Assigned_User__c=runningUserId, Due_Date__c=today.addDays(5), Is_Mandatory__c=true, Status__c='Completed', Completed_Date__c=today, Complete_Notes__c='Synthetic completion.', Display_Order__c=2),
        new Onboarding_Task__c(Name='Synthetic Prepare Equipment', Onboarding_Plan__c=onboardingPlan.Id, Task_Category__c='IT', Assigned_User__c=runningUserId, Due_Date__c=today.addDays(10), Is_Mandatory__c=true, Status__c='Not Started', Display_Order__c=3),
        new Onboarding_Task__c(Name='Synthetic Manager Introduction', Onboarding_Plan__c=onboardingPlan.Id, Task_Category__c='Manager', Assigned_User__c=runningUserId, Due_Date__c=today.addDays(15), Is_Mandatory__c=false, Status__c='Not Started', Display_Order__c=4)
    };
}

// Performance cycle, review, goals, development plan and action
Performance_Cycle__c performanceCycle;
List<Performance_Cycle__c> cycles = [SELECT Id FROM Performance_Cycle__c WHERE Name='Synthetic FY2027 Performance Cycle' LIMIT 1];
if (cycles.isEmpty()) {
    performanceCycle = new Performance_Cycle__c(Name='Synthetic FY2027 Performance Cycle', Start_Date__c=Date.newInstance(2027,1,1), End_Date__c=Date.newInstance(2027,12,31), Goal_Setting_Deadline__c=Date.newInstance(2027,1,31), Self_Assessment_Deadline__c=Date.newInstance(2027,11,30), Manager_Review_Deadline__c=Date.newInstance(2027,12,15), Status__c='Draft', Is_Active__c=true);
    insert performanceCycle;
} else performanceCycle = cycles[0];
List<Performance_Review__c> reviews = [SELECT Id FROM Performance_Review__c WHERE Cycle__c=:performanceCycle.Id AND Employee__c=:employee.Id AND Version_Number__c=1 LIMIT 1];
Performance_Review__c performanceReview;
if (reviews.isEmpty()) {
    performanceReview = new Performance_Review__c(Cycle__c=performanceCycle.Id, Employee__c=employee.Id, Reviewing_Manager__c=manager.Id, Version_Number__c=1, Status__c='Goal Setting');
    insert performanceReview;
} else performanceReview = reviews[0];
if ([SELECT COUNT() FROM Performance_Goal__c WHERE Performance_Review__c=:performanceReview.Id] == 0) {
    insert new List<Performance_Goal__c>{
        new Performance_Goal__c(Name='Synthetic Delivery Goal', Performance_Review__c=performanceReview.Id, Weight__c=40, Status__c='In Progress', Progress_Percentage__c=50),
        new Performance_Goal__c(Name='Synthetic Quality Goal', Performance_Review__c=performanceReview.Id, Weight__c=30, Status__c='Not Started', Progress_Percentage__c=0),
        new Performance_Goal__c(Name='Synthetic Development Goal', Performance_Review__c=performanceReview.Id, Weight__c=30, Status__c='Not Started', Progress_Percentage__c=0)
    };
}
List<Development_Plan__c> developmentPlans = [SELECT Id FROM Development_Plan__c WHERE Employee__c=:employee.Id AND Performance_Review__c=:performanceReview.Id LIMIT 1];
Development_Plan__c developmentPlan;
if (developmentPlans.isEmpty()) {
    developmentPlan = new Development_Plan__c(Employee__c=employee.Id, Performance_Review__c=performanceReview.Id, Target_Position__c=positionByCode.get('SYN-SRSFDEV').Id, Manager__c=manager.Id, Status__c='Active', Start_Date__c=today, Target_Date__c=today.addMonths(6), Purpose__c='Synthetic development plan.');
    insert developmentPlan;
} else developmentPlan = developmentPlans[0];
if ([SELECT COUNT() FROM Development_Action__c WHERE Development_Plan__c=:developmentPlan.Id] == 0) {
    insert new Development_Action__c(Name='Synthetic Advanced Apex Training', Development_Plan__c=developmentPlan.Id, Target_Skill__c=skillByCode.get('SYN-APEX').Id, Activity_Type__c='Training', Action_Owner__c=employee.Id, Due_Date__c=today.addMonths(3), Status__c='Not Started', Success_Measure__c='Complete synthetic assessment.');
}

// Critical position, nomination and readiness assessment
Critical_Position__c criticalPosition;
List<Critical_Position__c> criticalPositions = [SELECT Id FROM Critical_Position__c WHERE Name='Synthetic Engineering Manager Critical Position' LIMIT 1];
if (criticalPositions.isEmpty()) {
    criticalPosition = new Critical_Position__c(Name='Synthetic Engineering Manager Critical Position', Position__c=positionByCode.get('SYN-ENGMGR').Id, Current_Employee__c=manager.Id, Department__c=departmentByCode.get('SYN-ENG').Id, Criticality__c='Mission Critical', Vacancy_Risk__c='Medium', Business_Impact__c='Synthetic impact description.', Target_Successor_Count__c=2, Review_Frequency__c='Quarterly', Last_Reviewed_Date__c=today, Next_Review_Date__c=today.addMonths(3), Is_Active__c=true);
    insert criticalPosition;
} else criticalPosition = criticalPositions[0];
List<Succession_Nomination__c> nominations = [SELECT Id FROM Succession_Nomination__c WHERE Critical_Position__c=:criticalPosition.Id AND Employee__c=:employee.Id LIMIT 1];
Succession_Nomination__c nomination;
if (nominations.isEmpty()) {
    nomination = new Succession_Nomination__c(Critical_Position__c=criticalPosition.Id, Employee__c=employee.Id, Nominated_BY__c=runningUserId, Status__c='Under Review', Recommended_Readiness__c='Ready Within Two Years', Nomination_Date__c=today, Recommendation_Explanation__c='Synthetic succession nomination.', Is_Development_Required__c=true, Is_Conflict_Disclosed__c=false);
    insert nomination;
} else nomination = nominations[0];
List<Readiness_Assessment__c> readinessAssessments = [SELECT Id, Recommended_Readiness__c FROM Readiness_Assessment__c WHERE Succession_Nomination__c=:nomination.Id LIMIT 1];
if (readinessAssessments.isEmpty()) {
    insert new Readiness_Assessment__c(Succession_Nomination__c=nomination.Id, Assessment_Date__c=today, Skills_Score__c=72, Experience_Score__c=70, Performance_Score__c=75, Certification_Score__c=65, Development_Progress_Score__c=55, Manager_Assessment__c='Synthetic assessment for schema validation.', Recommended_Readiness__c='Ready Within Two Years', Rules_Version__c='1', Explanation__c='Synthetic readiness explanation.', Is_Superseded__c=false);
} else {
    // Re-save the existing assessment so the latest-readiness maintenance Flow can repair the parent after metadata changes.
    update readinessAssessments[0];
}

// Explainable match result and criterion results
List<Match_Result__c> matchResults = [SELECT Id, Status__c FROM Match_Result__c WHERE Application__c=:caseyApplicationId AND Match_Type__c='Pre-Interview' LIMIT 1];
Match_Result__c matchResult;
if (matchResults.isEmpty()) {
    matchResult = new Match_Result__c(Application__c=caseyApplicationId, Job_Opening__c=openingByTitle.get('Synthetic Quality Engineer Opening').Id, Match_Type__c='Pre-Interview', Status__c='Pending', Requirements_Version__c=1, Rules_Version__c='1', Calculated_By__c=runningUserId, Calculated_At__c=System.now(), Overall_Score__c=80, Recommendation__c='Match');
    insert matchResult;
} else matchResult = matchResults[0];
if ([SELECT COUNT() FROM Match_Criterion_Result__c WHERE Match_Result__c=:matchResult.Id] == 0) {
    insert new List<Match_Criterion_Result__c>{
        new Match_Criterion_Result__c(Match_Result__c=matchResult.Id, Criterion_Type__c='Mandatory Skill', Criterion_Name__c='Automated Testing', Skill__c=skillByCode.get('SYN-AUTOTEST').Id, Required_Value__c='Required', Candidate_Value__c='Demonstrated', Weight__c=40, Score__c=85, Is_Matched__c=true, Is_Mandatory__c=true, Explanation__c='Synthetic matched criterion.', Display_Order__c=1),
        new Match_Criterion_Result__c(Match_Result__c=matchResult.Id, Criterion_Type__c='Mandatory Skill', Criterion_Name__c='Manual Testing', Skill__c=skillByCode.get('SYN-MANTEST').Id, Required_Value__c='Required', Candidate_Value__c='Demonstrated', Weight__c=30, Score__c=80, Is_Matched__c=true, Is_Mandatory__c=true, Explanation__c='Synthetic matched criterion.', Display_Order__c=2),
        new Match_Criterion_Result__c(Match_Result__c=matchResult.Id, Criterion_Type__c='Experience', Criterion_Name__c='Relevant Experience', Required_Value__c='2 years', Candidate_Value__c='3 years', Weight__c=30, Score__c=75, Is_Matched__c=true, Is_Mandatory__c=false, Explanation__c='Synthetic experience criterion.', Display_Order__c=3)
    };
}

System.debug(LoggingLevel.INFO, 'PHASE3_SYNTHETIC_DATA=SUCCESS');
