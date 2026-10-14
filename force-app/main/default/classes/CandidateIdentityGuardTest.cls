@IsTest
private class CandidateIdentityGuardTest {
    @IsTest
    static void preventsOneContactFromOwningTwoCandidateProfiles() {
        Account portalAccount = new Account(Name = 'Synthetic Candidate Account');
        insert portalAccount;

        Contact portalContact = new Contact(
            AccountId = portalAccount.Id,
            LastName = 'Synthetic Candidate',
            Email = 'identity-guard@example.invalid'
        );
        insert portalContact;

        insert new Candidate__c(
            Contact__c = portalContact.Id,
            First_Name__c = 'First',
            Last_Name__c = 'Candidate',
            Email__c = 'first-candidate@example.invalid',
            Profile_Status__c = 'Active'
        );

        Candidate__c duplicateCandidate = new Candidate__c(
            Contact__c = portalContact.Id,
            First_Name__c = 'Second',
            Last_Name__c = 'Candidate',
            Email__c = 'second-candidate@example.invalid',
            Profile_Status__c = 'Active'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateCandidate, false);
        Test.stopTest();

        System.assertEquals(false, result.isSuccess());
        System.assertEquals(
            StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,
            result.getErrors()[0].getStatusCode()
        );
    }
}
