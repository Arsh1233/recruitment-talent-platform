trigger RTPJobRequisitionSharing on Job_Requisition__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
