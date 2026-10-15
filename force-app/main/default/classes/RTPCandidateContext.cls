/**
 * Resolves the current candidate exclusively from the authenticated User's
 * ContactId. Browser-provided Candidate or Contact IDs are never accepted.
 */
public with sharing class RTPCandidateContext {
    public class CandidateAccessException extends Exception {}

    @TestVisible
    private static Id contactIdOverride;

    public static Id getCurrentCandidateId() {
        Id contactId = contactIdOverride;
        if (contactId == null) {
            List<User> currentUsers = [
                SELECT ContactId
                FROM User
                WHERE Id = :UserInfo.getUserId()
                LIMIT 1
            ];
            contactId = currentUsers.isEmpty() ? null : currentUsers[0].ContactId;
        }

        if (contactId == null) {
            throw new CandidateAccessException(
                'A candidate profile is not available for this user.'
            );
        }

        List<Candidate__c> candidates = [
            SELECT Id
            FROM Candidate__c
            WHERE Contact__c = :contactId
            LIMIT 1
        ];
        if (candidates.isEmpty()) {
            throw new CandidateAccessException(
                'A candidate profile is not available for this user.'
            );
        }
        return candidates[0].Id;
    }
}
