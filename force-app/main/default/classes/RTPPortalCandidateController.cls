/** Candidate-safe portal API. Identity is always derived from User.ContactId. */
public with sharing class RTPPortalCandidateController {
    public class CandidateProfile {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String firstName { get; set; }
        @AuraEnabled public String lastName { get; set; }
        @AuraEnabled public String email { get; set; }
        @AuraEnabled public String phone { get; set; }
        @AuraEnabled public String currentJobTitle { get; set; }
        @AuraEnabled public Decimal totalExperience { get; set; }
        @AuraEnabled public String currentLocation { get; set; }
        @AuraEnabled public String preferredLocation { get; set; }
        @AuraEnabled public String preferredWorkMode { get; set; }
    }

    public class ApplicationSummary {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public String jobTitle { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public Datetime submittedAt { get; set; }
        @AuraEnabled public Date withdrawalDate { get; set; }
        @AuraEnabled public String withdrawalReason { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static CandidateProfile getMyProfile() {
        try {
            Id candidateId = RTPCandidateContext.getCurrentCandidateId();
            Candidate__c candidate = [
                SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c,
                    Current_Job_Title__c, Total_Experience__c,
                    Current_Location__c, Preferred_Location__c,
                    Preferred_Work_Mode__c
                FROM Candidate__c
                WHERE Id = :candidateId
                WITH USER_MODE
                LIMIT 1
            ];

            CandidateProfile result = new CandidateProfile();
            result.id = candidate.Id;
            result.firstName = candidate.First_Name__c;
            result.lastName = candidate.Last_Name__c;
            result.email = candidate.Email__c;
            result.phone = candidate.Phone__c;
            result.currentJobTitle = candidate.Current_Job_Title__c;
            result.totalExperience = candidate.Total_Experience__c;
            result.currentLocation = candidate.Current_Location__c;
            result.preferredLocation = candidate.Preferred_Location__c;
            result.preferredWorkMode = candidate.Preferred_Work_Mode__c;
            return result;
        } catch (Exception exceptionValue) {
            throw handled('Your candidate profile is unavailable.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<ApplicationSummary> getMyApplications() {
        try {
            Id candidateId = RTPCandidateContext.getCurrentCandidateId();
            List<ApplicationSummary> results = new List<ApplicationSummary>();
            for (Job_Application__c application : [
                SELECT Id, Status__c, Submitted_At__c,
                    Withdrawal_Date__c, Withdrawal_Reason__c,
                    Job_Opening__r.Public_Job_Title__c
                FROM Job_Application__c
                WHERE Candidate__c = :candidateId
                WITH USER_MODE
                ORDER BY CreatedDate DESC
            ]) {
                results.add(toSummary(application));
            }
            return results;
        } catch (Exception exceptionValue) {
            throw handled('Your applications are unavailable.');
        }
    }

    @AuraEnabled(cacheable=true)
    public static ApplicationSummary getMyApplication(Id applicationId) {
        if (applicationId == null) {
            throw handled('An application is required.');
        }
        try {
            Id candidateId = RTPCandidateContext.getCurrentCandidateId();
            List<Job_Application__c> applications = [
                SELECT Id, Status__c, Submitted_At__c,
                    Withdrawal_Date__c, Withdrawal_Reason__c,
                    Job_Opening__r.Public_Job_Title__c
                FROM Job_Application__c
                WHERE Id = :applicationId
                AND Candidate__c = :candidateId
                WITH USER_MODE
                LIMIT 1
            ];
            if (applications.isEmpty()) {
                throw handled('The application is not available.');
            }
            return toSummary(applications[0]);
        } catch (AuraHandledException exceptionValue) {
            throw exceptionValue;
        } catch (Exception exceptionValue) {
            throw handled('The application is not available.');
        }
    }

    private static ApplicationSummary toSummary(Job_Application__c application) {
        ApplicationSummary result = new ApplicationSummary();
        result.id = application.Id;
        result.jobTitle = application.Job_Opening__r.Public_Job_Title__c;
        result.status = application.Status__c;
        result.submittedAt = application.Submitted_At__c;
        result.withdrawalDate = application.Withdrawal_Date__c;
        result.withdrawalReason = application.Withdrawal_Reason__c;
        return result;
    }

    private static AuraHandledException handled(String message) {
        AuraHandledException exceptionValue = new AuraHandledException(message);
        exceptionValue.setMessage(message);
        return exceptionValue;
    }
}
