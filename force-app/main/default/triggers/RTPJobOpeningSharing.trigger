trigger RTPJobOpeningSharing on Job_Opening__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
