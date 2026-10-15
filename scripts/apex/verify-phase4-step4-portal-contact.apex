// Dynamic SOQL lets Apex system context verify the protected automation fields.

Integer applicationMismatches = 0;
for (SObject recordValue : Database.query(
    'SELECT Candidate__r.Contact__c, Portal_Contact__c FROM Job_Application__c'
)) {
    SObject candidate = recordValue.getSObject('Candidate__r');
    Id expectedContactId = candidate == null ? null : (Id) candidate.get('Contact__c');
    if (expectedContactId == null || (Id) recordValue.get('Portal_Contact__c') != expectedContactId) applicationMismatches++;
}

Integer certificationMismatches = 0;
for (SObject recordValue : Database.query(
    'SELECT Candidate__c, Candidate__r.Contact__c, Portal_Contact__c FROM Certification__c'
)) {
    SObject candidate = recordValue.getSObject('Candidate__r');
    Id expectedContactId = candidate == null ? null : (Id) candidate.get('Contact__c');
    if (
        (recordValue.get('Candidate__c') != null && expectedContactId == null) ||
        (Id) recordValue.get('Portal_Contact__c') != expectedContactId
    ) certificationMismatches++;
}

Integer interviewMismatches = 0;
for (SObject recordValue : Database.query(
    'SELECT Application__r.Portal_Contact__c, Portal_Contact__c FROM interview__c'
)) {
    SObject applicationRecord = recordValue.getSObject('Application__r');
    Id expectedContactId = applicationRecord == null ? null : (Id) applicationRecord.get('Portal_Contact__c');
    if (expectedContactId == null || (Id) recordValue.get('Portal_Contact__c') != expectedContactId) interviewMismatches++;
}

Integer offerMismatches = 0;
for (SObject recordValue : Database.query(
    'SELECT Application__r.Portal_Contact__c, Portal_Contact__c FROM Offer__c'
)) {
    SObject applicationRecord = recordValue.getSObject('Application__r');
    Id expectedContactId = applicationRecord == null ? null : (Id) applicationRecord.get('Portal_Contact__c');
    if (expectedContactId == null || (Id) recordValue.get('Portal_Contact__c') != expectedContactId) offerMismatches++;
}

System.debug(LoggingLevel.INFO,
    'PORTAL_CONTACT_VERIFY applications=' + applicationMismatches +
    ' certifications=' + certificationMismatches +
    ' interviews=' + interviewMismatches +
    ' offers=' + offerMismatches
);

System.assertEquals(0, applicationMismatches, 'Job Application Portal Contact mismatches remain.');
System.assertEquals(0, certificationMismatches, 'Certification Portal Contact mismatches remain.');
System.assertEquals(0, interviewMismatches, 'Interview Portal Contact mismatches remain.');
System.assertEquals(0, offerMismatches, 'Offer Portal Contact mismatches remain.');
