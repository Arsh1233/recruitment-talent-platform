Savepoint phase3BatchA = Database.setSavepoint();

try {
    String suffix = String.valueOf(DateTime.now().getTime());

    Department__c department = new Department__c(
        Name = 'Batch A Department ' + suffix,
        Department_code__c = 'BA-' + suffix,
        Is_Active__c = true
    );
    insert department;

    Position__c position = new Position__c(
        Name = 'Batch A Position ' + suffix,
        Department__c = department.Id,
        Position_code__c = 'POS-' + suffix,
        Job_Level__c = 'Entry',
        Is_Active__c = true
    );
    insert position;

    Skill__c skill = new Skill__c(
        Name = 'Batch A Skill ' + suffix,
        Skill_code__c = 'SK-' + suffix,
        Category__c = 'Salesforce',
        Normalized_Name__c = 'batch a skill ' + suffix,
        Is_Active__c = true
    );
    insert skill;

    Account portalAccount = new Account(Name = 'Batch A Portal Account ' + suffix);
    insert portalAccount;

    Contact portalContact = new Contact(
        AccountId = portalAccount.Id,
        FirstName = 'Synthetic',
        LastName = 'Candidate',
        Email = 'batch-a-' + suffix + '@example.invalid'
    );
    insert portalContact;

    Candidate__c candidate = new Candidate__c(
        Contact__c = portalContact.Id,
        First_Name__c = 'Synthetic',
        Last_Name__c = 'Candidate',
        Email__c = portalContact.Email,
        Phone__c = '+1 555 010 0000',
        Profile_Status__c = 'Active',
        Is_Consent_Available__c = true,
        Is_Resume_Verified__c = true
    );
    insert candidate;

    candidate = [
        SELECT Contact__c, Normalized_Email__c, Normalized_Phone__c
        FROM Candidate__c
        WHERE Id = :candidate.Id
    ];
    System.assertEquals(portalContact.Id, candidate.Contact__c);
    System.assertEquals(portalContact.Email.toLowerCase(), candidate.Normalized_Email__c);
    System.assertNotEquals(null, candidate.Normalized_Phone__c);

    Candidate__c duplicateContactCandidate = new Candidate__c(
        Contact__c = portalContact.Id,
        First_Name__c = 'Another',
        Last_Name__c = 'Candidate',
        Email__c = 'different-' + suffix + '@example.invalid',
        Profile_Status__c = 'Active'
    );
    Database.SaveResult duplicateCandidateResult = Database.insert(duplicateContactCandidate, false);
    System.assertEquals(false, duplicateCandidateResult.isSuccess(), 'Contact must remain unique across candidates.');

    Employee__c manager = new Employee__c(
        Employee_Number__c = 'MGR-' + suffix,
        Department__c = department.Id,
        Position__c = position.Id,
        Employment_Type__c = 'Permanent',
        Employment_Status__c = 'Active'
    );
    insert manager;

    Employee__c employee = new Employee__c(
        Candidate__c = candidate.Id,
        Employee_Number__c = 'EMP-' + suffix,
        Department__c = department.Id,
        Position__c = position.Id,
        Reporting_Manager__c = manager.Id,
        Employment_Type__c = 'Permanent',
        Employment_Status__c = 'Active'
    );
    insert employee;

    employee = [SELECT Reporting_Manager__c FROM Employee__c WHERE Id = :employee.Id];
    System.assertEquals(manager.Id, employee.Reporting_Manager__c);

    Department__c duplicateCode = new Department__c(
        Name = 'Duplicate Department ' + suffix,
        Department_code__c = department.Department_code__c
    );
    Database.SaveResult duplicateDepartmentResult = Database.insert(duplicateCode, false);
    System.assertEquals(false, duplicateDepartmentResult.isSuccess(), 'Department code must be unique.');

    System.debug(LoggingLevel.INFO, 'PHASE3_BATCH_A=SUCCESS');
} finally {
    Database.rollback(phase3BatchA);
}
