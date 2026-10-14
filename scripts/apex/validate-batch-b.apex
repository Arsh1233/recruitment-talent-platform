Savepoint phase3BatchB = Database.setSavepoint();

try {
    String suffix = String.valueOf(DateTime.now().getTime());

    Department__c department = new Department__c(
        Name = 'Batch B Department ' + suffix,
        Department_code__c = 'BB-' + suffix,
        Is_Active__c = true
    );
    insert department;

    Position__c position = new Position__c(
        Name = 'Batch B Position ' + suffix,
        Department__c = department.Id,
        Position_code__c = 'POSB-' + suffix,
        Job_Level__c = 'Entry',
        Is_Active__c = true
    );
    insert position;

    Skill__c skill = new Skill__c(
        Name = 'Batch B Skill ' + suffix,
        Skill_code__c = 'SKB-' + suffix,
        Category__c = 'Salesforce',
        Normalized_Name__c = 'batch b skill ' + suffix,
        Is_Active__c = true
    );
    insert skill;

    Account portalAccount = new Account(Name = 'Batch B Portal Account ' + suffix);
    insert portalAccount;
    Contact portalContact = new Contact(
        AccountId = portalAccount.Id,
        FirstName = 'Synthetic',
        LastName = 'Applicant',
        Email = 'batch-b-' + suffix + '@example.invalid'
    );
    insert portalContact;

    Candidate__c candidate = new Candidate__c(
        Contact__c = portalContact.Id,
        First_Name__c = 'Synthetic',
        Last_Name__c = 'Applicant',
        Email__c = portalContact.Email,
        Profile_Status__c = 'Active',
        Is_Consent_Available__c = true,
        Is_Resume_Verified__c = true
    );
    insert candidate;

    Job_Requisition__c requisition = new Job_Requisition__c(
        Department__c = department.Id,
        Position__c = position.Id,
        Number_of_Openings__c = 1,
        Version_Number__c = 1,
        Status__c = 'Approved',
        Approved_By__c = UserInfo.getUserId(),
        Approved_At__c = System.now()
    );
    insert requisition;

    Job_Opening__c opening = new Job_Opening__c(
        Requisition__c = requisition.Id,
        Position__c = position.Id,
        Status__c = 'Draft',
        Number_of_Openings__c = 1,
        Number_Filled__c = 0,
        Requirements_Version__c = 1
    );
    insert opening;

    Job_Skill_Requirement__c requirement = new Job_Skill_Requirement__c(
        Job_Opening__c = opening.Id,
        Skill__c = skill.Id,
        Job_Skill_Requirement_Fields__c = 'Mandatory',
        Requirement_Version__c = 1,
        Active__c = true
    );
    insert requirement;

    Candidate_Skill__c candidateSkill = new Candidate_Skill__c(
        Candidate__c = candidate.Id,
        Skill__c = skill.Id,
        Proficiency__c = '1 - Beginner',
        Is_Active__c = true
    );
    insert candidateSkill;

    Education__c education = new Education__c(
        Candidate__c = candidate.Id,
        Institution__c = 'Synthetic University',
        Qualification__c = 'Synthetic Degree'
    );
    insert education;

    Employment_Experience__c experience = new Employment_Experience__c(
        Candidate__c = candidate.Id,
        Employer__c = 'Synthetic Employer',
        Job_Title__c = 'Synthetic Role',
        Start_Date__c = Date.today().addYears(-1),
        End_Date__c = Date.today()
    );
    insert experience;

    Job_Application__c application = new Job_Application__c(
        Candidate__c = candidate.Id,
        Job_Opening__c = opening.Id,
        Status__c = 'Draft'
    );
    insert application;

    requirement = [SELECT Composite_Key__c FROM Job_Skill_Requirement__c WHERE Id = :requirement.Id];
    candidateSkill = [SELECT Composite_Key__c FROM Candidate_Skill__c WHERE Id = :candidateSkill.Id];
    application = [SELECT Active_Application_Key__c FROM Job_Application__c WHERE Id = :application.Id];

    System.assertNotEquals(null, requirement.Composite_Key__c);
    System.assertNotEquals(null, candidateSkill.Composite_Key__c);
    System.assertNotEquals(null, application.Active_Application_Key__c);

    Candidate_Skill__c duplicateCandidateSkill = new Candidate_Skill__c(
        Candidate__c = candidate.Id,
        Skill__c = skill.Id
    );
    Database.SaveResult duplicateSkillResult = Database.insert(duplicateCandidateSkill, false);
    System.assertEquals(false, duplicateSkillResult.isSuccess(), 'Candidate and skill must be unique.');

    Job_Application__c duplicateApplication = new Job_Application__c(
        Candidate__c = candidate.Id,
        Job_Opening__c = opening.Id,
        Status__c = 'Draft'
    );
    Database.SaveResult duplicateApplicationResult = Database.insert(duplicateApplication, false);
    System.assertEquals(false, duplicateApplicationResult.isSuccess(), 'Only one active application is allowed.');

    System.debug(LoggingLevel.INFO, 'PHASE3_BATCH_B=SUCCESS');
} finally {
    Database.rollback(phase3BatchB);
}
