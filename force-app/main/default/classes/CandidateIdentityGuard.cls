public with sharing class CandidateIdentityGuard {
    public static void preventDuplicateContacts(List<Candidate__c> candidates) {
        Set<Id> contactIds = new Set<Id>();
        Set<Id> candidateIds = new Set<Id>();

        for (Candidate__c candidate : candidates) {
            if (candidate.Contact__c != null) {
                contactIds.add(candidate.Contact__c);
            }
            if (candidate.Id != null) {
                candidateIds.add(candidate.Id);
            }
        }

        if (contactIds.isEmpty()) {
            return;
        }

        Map<Id, Id> candidateByContact = new Map<Id, Id>();
        for (Candidate__c existingCandidate : [
            SELECT Id, Contact__c
            FROM Candidate__c
            WHERE Contact__c IN :contactIds AND Id NOT IN :candidateIds
        ]) {
            candidateByContact.put(existingCandidate.Contact__c, existingCandidate.Id);
        }

        Set<Id> contactsSeenInTransaction = new Set<Id>();
        for (Candidate__c candidate : candidates) {
            if (candidate.Contact__c == null) {
                continue;
            }

            if (
                candidateByContact.containsKey(candidate.Contact__c) ||
                contactsSeenInTransaction.contains(candidate.Contact__c)
            ) {
                candidate.Contact__c.addError(
                    'This Contact is already linked to another candidate profile.'
                );
            } else {
                contactsSeenInTransaction.add(candidate.Contact__c);
            }
        }
    }
}
