/** Candidate-safe read API for public job listings. */
public with sharing class RTPPortalJobController {
    public class JobCard {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String title { get; set; }
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String location { get; set; }
        @AuraEnabled public String workMode { get; set; }
        @AuraEnabled public Date applicationDeadline { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<JobCard> getPublishedJobs() {
        try {
            assertPublicJobAccess();
            List<JobCard> results = new List<JobCard>();
            for (Job_Opening__c opening : [
                SELECT Id, Public_Job_Title__c, Public_Description__c,
                    Location__c, Work_Mode__c, Application_Deadline__c
                FROM Job_Opening__c
                WHERE Is_Portal_Visible__c = TRUE
                ORDER BY Public_Job_Title__c
            ]) {
                JobCard card = new JobCard();
                card.id = opening.Id;
                card.title = opening.Public_Job_Title__c;
                card.description = opening.Public_Description__c;
                card.location = opening.Location__c;
                card.workMode = opening.Work_Mode__c;
                card.applicationDeadline = opening.Application_Deadline__c;
                results.add(card);
            }
            return results;
        } catch (Exception exceptionValue) {
            throw handled('Published jobs are temporarily unavailable.');
        }
    }

    private static void assertPublicJobAccess() {
        if (!Schema.sObjectType.Job_Opening__c.isAccessible() ||
            !Schema.sObjectType.Job_Opening__c.fields.Public_Job_Title__c.isAccessible() ||
            !Schema.sObjectType.Job_Opening__c.fields.Public_Description__c.isAccessible() ||
            !Schema.sObjectType.Job_Opening__c.fields.Location__c.isAccessible() ||
            !Schema.sObjectType.Job_Opening__c.fields.Work_Mode__c.isAccessible() ||
            !Schema.sObjectType.Job_Opening__c.fields.Application_Deadline__c.isAccessible()) {
            throw handled('Published jobs are temporarily unavailable.');
        }
    }

    private static AuraHandledException handled(String message) {
        AuraHandledException exceptionValue = new AuraHandledException(message);
        exceptionValue.setMessage(message);
        return exceptionValue;
    }
}
