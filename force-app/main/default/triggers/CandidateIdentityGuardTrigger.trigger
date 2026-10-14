trigger CandidateIdentityGuardTrigger on Candidate__c (before insert, before update) {
    CandidateIdentityGuard.preventDuplicateContacts(Trigger.new);
}
