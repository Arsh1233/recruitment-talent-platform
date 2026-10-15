trigger RTPSuccessionNominationSharing on Succession_Nomination__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
