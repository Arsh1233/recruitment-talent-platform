// Reconcile all internal recruitment and succession shares after deployment.
RTPRecordSharingService.rebuildAll();
System.debug(LoggingLevel.INFO, 'RTP_INTERNAL_SHARING_BACKFILL=SUCCESS');
