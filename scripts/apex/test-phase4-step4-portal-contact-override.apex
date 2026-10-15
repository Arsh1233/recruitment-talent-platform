// Security regression check: a caller-supplied Contact is overwritten by the
// before-save flow. All changes are rolled back after assertions.

Savepoint portalContactTestSavepoint = Database.setSavepoint();

List<Job_Application__c> applications = [
    SELECT Id, Candidate__r.Contact__c, Portal_Contact__c
    FROM Job_Application__c
    WHERE Candidate__r.Contact__c != null
    LIMIT 1
];
System.assert(!applications.isEmpty(), 'A Job Application with a candidate Contact is required for this check.');

Job_Application__c applicationRecord = applications[0];
List<Contact> otherContacts = [
    SELECT Id
    FROM Contact
    WHERE Id != :applicationRecord.Candidate__r.Contact__c
    LIMIT 1
];
System.assert(!otherContacts.isEmpty(), 'A second Contact is required for the override check.');

applicationRecord.Portal_Contact__c = otherContacts[0].Id;
update applicationRecord;

Job_Application__c refreshedApplication = [
    SELECT Candidate__r.Contact__c, Portal_Contact__c
    FROM Job_Application__c
    WHERE Id = :applicationRecord.Id
];
System.assertEquals(
    refreshedApplication.Candidate__r.Contact__c,
    refreshedApplication.Portal_Contact__c,
    'The flow must overwrite a caller-supplied Portal Contact.'
);

Database.rollback(portalContactTestSavepoint);
System.debug(LoggingLevel.INFO, 'PORTAL_CONTACT_OVERRIDE_TEST=SUCCESS');
