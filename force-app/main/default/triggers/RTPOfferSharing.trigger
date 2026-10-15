trigger RTPOfferSharing on Offer__c (
    after insert, after update, after delete, after undelete
) {
    RTPRecordSharingService.requestRebuild();
}
