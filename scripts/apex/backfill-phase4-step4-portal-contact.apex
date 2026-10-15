// One-time, idempotent backfill for Phase 4 Step 4.
// Re-saving each record invokes the active before-save flow. The protected
// Portal_Contact__c fields do not need to be exposed through field permissions.

Integer attempted = 0;
Integer succeeded = 0;
Integer failed = 0;

List<Job_Application__c> applications = [SELECT Id, Candidate__c FROM Job_Application__c];
Database.SaveResult[] applicationResults = Database.update(applications, false);
attempted += applicationResults.size();
for (Database.SaveResult result : applicationResults) {
    if (result.isSuccess()) succeeded++;
    else {
        failed++;
        for (Database.Error errorRecord : result.getErrors())
            System.debug(LoggingLevel.ERROR, 'PORTAL_CONTACT_BACKFILL application=' + result.getId() + ' error=' + errorRecord.getMessage());
    }
}

List<Certification__c> certifications = [SELECT Id, Candidate__c FROM Certification__c];
Database.SaveResult[] certificationResults = Database.update(certifications, false);
attempted += certificationResults.size();
for (Database.SaveResult result : certificationResults) {
    if (result.isSuccess()) succeeded++;
    else {
        failed++;
        for (Database.Error errorRecord : result.getErrors())
            System.debug(LoggingLevel.ERROR, 'PORTAL_CONTACT_BACKFILL certification=' + result.getId() + ' error=' + errorRecord.getMessage());
    }
}

List<interview__c> interviews = [SELECT Id, Application__c FROM interview__c];
Database.SaveResult[] interviewResults = Database.update(interviews, false);
attempted += interviewResults.size();
for (Database.SaveResult result : interviewResults) {
    if (result.isSuccess()) succeeded++;
    else {
        failed++;
        for (Database.Error errorRecord : result.getErrors())
            System.debug(LoggingLevel.ERROR, 'PORTAL_CONTACT_BACKFILL interview=' + result.getId() + ' error=' + errorRecord.getMessage());
    }
}

List<Offer__c> offers = [SELECT Id, Application__c FROM Offer__c];
Database.SaveResult[] offerResults = Database.update(offers, false);
attempted += offerResults.size();
for (Database.SaveResult result : offerResults) {
    if (result.isSuccess()) succeeded++;
    else {
        failed++;
        for (Database.Error errorRecord : result.getErrors())
            System.debug(LoggingLevel.ERROR, 'PORTAL_CONTACT_BACKFILL offer=' + result.getId() + ' error=' + errorRecord.getMessage());
    }
}

System.debug(LoggingLevel.INFO,
    'PORTAL_CONTACT_BACKFILL attempted=' + attempted +
    ' succeeded=' + succeeded +
    ' failed=' + failed
);
