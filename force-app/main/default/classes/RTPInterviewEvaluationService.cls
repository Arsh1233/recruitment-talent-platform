/**
 * Narrow gateway for interviewer-owned evaluations.
 *
 * Interview Evaluation is master-detail to Interview, so direct object access
 * would expose sibling evaluations through parent sharing. This documented
 * without-sharing exception is authorized by a custom permission, confirms
 * user-mode access to the assigned Interview, derives the interviewer from the
 * session, filters every evaluation query by that user, and copies only an
 * explicit field allowlist. It is never a general-purpose evaluation API.
 */
public without sharing class RTPInterviewEvaluationService {
    private static final String REQUIRED_PERMISSION =
        'RTP_Submit_Interview_Evaluation';

    public class EvaluationInput {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public Id interviewId { get; set; }
        @AuraEnabled public Decimal technicalScore { get; set; }
        @AuraEnabled public Decimal problemSolvingScore { get; set; }
        @AuraEnabled public Decimal experienceScore { get; set; }
        @AuraEnabled public Decimal communicationScore { get; set; }
        @AuraEnabled public Decimal roleSuitabilityScore { get; set; }
        @AuraEnabled public String recommendation { get; set; }
        @AuraEnabled public String comments { get; set; }
        @AuraEnabled public Boolean submitted { get; set; }
    }

    public class EvaluationView {
        @AuraEnabled public Id id { get; set; }
        @AuraEnabled public Id interviewId { get; set; }
        @AuraEnabled public Decimal technicalScore { get; set; }
        @AuraEnabled public Decimal problemSolvingScore { get; set; }
        @AuraEnabled public Decimal experienceScore { get; set; }
        @AuraEnabled public Decimal communicationScore { get; set; }
        @AuraEnabled public Decimal roleSuitabilityScore { get; set; }
        @AuraEnabled public Decimal overallScore { get; set; }
        @AuraEnabled public String recommendation { get; set; }
        @AuraEnabled public String comments { get; set; }
        @AuraEnabled public Boolean submitted { get; set; }
        @AuraEnabled public Datetime submittedAt { get; set; }
        @AuraEnabled public Boolean reopened { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static EvaluationView getMyEvaluation(Id interviewId) {
        authorizeAssignedInterview(interviewId);

        List<Interview_Evaluation__c> evaluations = [
            SELECT Id, Interview__c,
                Technical_Score__c, Problem_Solving_Score__c,
                Experience_Score__c, Communication_Score__c,
                Role_Suitability_Score__c, Overall_Score__c,
                Recommendation__c, Comments__c,
                Is_Submitted__c, Submitted_At__c, Is_Reopened__c
            FROM Interview_Evaluation__c
            WHERE Interview__c = :interviewId
            AND Interviewer__c = :UserInfo.getUserId()
            LIMIT 1
        ];
        return evaluations.isEmpty() ? null : toView(evaluations[0]);
    }

    @AuraEnabled
    public static Id saveMyEvaluation(EvaluationInput requestedEvaluation) {
        if (requestedEvaluation == null || requestedEvaluation.interviewId == null) {
            throw handled('An interview is required.');
        }

        authorizeAssignedInterview(requestedEvaluation.interviewId);
        Id currentUserId = UserInfo.getUserId();
        Interview_Evaluation__c evaluationToSave;

        if (requestedEvaluation.id == null) {
            evaluationToSave = new Interview_Evaluation__c(
                Interview__c = requestedEvaluation.interviewId,
                Interviewer__c = currentUserId
            );
        } else {
            List<Interview_Evaluation__c> existingEvaluations = [
                SELECT Id, Interview__c, Interviewer__c,
                    Is_Submitted__c, Is_Reopened__c
                FROM Interview_Evaluation__c
                WHERE Id = :requestedEvaluation.id
                AND Interview__c = :requestedEvaluation.interviewId
                AND Interviewer__c = :currentUserId
                LIMIT 1
            ];
            if (existingEvaluations.isEmpty()) {
                throw handled('You can edit only your own evaluation.');
            }
            evaluationToSave = existingEvaluations[0];
            if (evaluationToSave.Is_Submitted__c && !evaluationToSave.Is_Reopened__c) {
                throw handled('The submitted evaluation is locked.');
            }
        }

        evaluationToSave.Technical_Score__c = requestedEvaluation.technicalScore;
        evaluationToSave.Problem_Solving_Score__c = requestedEvaluation.problemSolvingScore;
        evaluationToSave.Experience_Score__c = requestedEvaluation.experienceScore;
        evaluationToSave.Communication_Score__c = requestedEvaluation.communicationScore;
        evaluationToSave.Role_Suitability_Score__c = requestedEvaluation.roleSuitabilityScore;
        evaluationToSave.Recommendation__c = requestedEvaluation.recommendation;
        evaluationToSave.Comments__c = requestedEvaluation.comments;
        evaluationToSave.Is_Submitted__c = requestedEvaluation.submitted == true;
        if (requestedEvaluation.submitted == true) {
            evaluationToSave.Submitted_At__c = System.now();
        }

        Database.UpsertResult saveResult = Database.upsert(evaluationToSave, false);
        if (!saveResult.isSuccess()) {
            throw handled('The evaluation could not be saved.');
        }
        return saveResult.getId();
    }

    private static void authorizeAssignedInterview(Id interviewId) {
        if (interviewId == null) {
            throw handled('An interview is required.');
        }
        if (!FeatureManagement.checkPermission(REQUIRED_PERMISSION)) {
            throw handled('You do not have permission to manage interview evaluations.');
        }
        if (!Schema.sObjectType.interview__c.isAccessible() ||
            !Schema.sObjectType.interview__c.fields.Primary_Interviewer__c.isAccessible()) {
            throw handled('You do not have permission to access this interview.');
        }

        List<interview__c> assignedInterviews = [
            SELECT Id
            FROM interview__c
            WHERE Id = :interviewId
            AND Primary_Interviewer__c = :UserInfo.getUserId()
            WITH USER_MODE
            LIMIT 1
        ];
        if (assignedInterviews.isEmpty()) {
            throw handled('You are not assigned to this interview.');
        }
    }

    private static EvaluationView toView(Interview_Evaluation__c evaluation) {
        EvaluationView result = new EvaluationView();
        result.id = evaluation.Id;
        result.interviewId = evaluation.Interview__c;
        result.technicalScore = evaluation.Technical_Score__c;
        result.problemSolvingScore = evaluation.Problem_Solving_Score__c;
        result.experienceScore = evaluation.Experience_Score__c;
        result.communicationScore = evaluation.Communication_Score__c;
        result.roleSuitabilityScore = evaluation.Role_Suitability_Score__c;
        result.overallScore = evaluation.Overall_Score__c;
        result.recommendation = evaluation.Recommendation__c;
        result.comments = evaluation.Comments__c;
        result.submitted = evaluation.Is_Submitted__c;
        result.submittedAt = evaluation.Submitted_At__c;
        result.reopened = evaluation.Is_Reopened__c;
        return result;
    }

    private static AuraHandledException handled(String message) {
        AuraHandledException exceptionValue = new AuraHandledException(message);
        exceptionValue.setMessage(message);
        return exceptionValue;
    }
}
