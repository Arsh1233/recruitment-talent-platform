trigger RTPCriticalPositionSharing on Critical_Position__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
