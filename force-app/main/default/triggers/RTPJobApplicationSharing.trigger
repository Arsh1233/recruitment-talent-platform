trigger RTPJobApplicationSharing on Job_Application__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
