/**
 * Maintains internal record access for recruitment and succession records.
 *
 * Access is represented by custom Apex sharing reasons so that reassignment can
 * remove only the access managed by this service. The rebuild is intentionally
 * performed asynchronously after the originating transaction commits.
 */
public without sharing class RTPRecordSharingService {
    private static final String RECRUITER_GROUP = 'RTP_All_Recruiters';
    private static final String SUCCESSION_GROUP = 'RTP_Succession_Committee';
    private static final String TEAM_CAUSE = 'Recruitment_Team__c';
    private static final String RECRUITER_CAUSE = 'Recruiter_Assignment__c';
    private static final String HIRING_MANAGER_CAUSE = 'Hiring_Manager_Assignment__c';
    private static final String INTERVIEWER_CAUSE = 'Interviewer_Assignment__c';
    private static final String SUCCESSION_CAUSE = 'Succession_Committee__c';

    private static Boolean rebuildQueued = false;

    /** Queue one rebuild for the current transaction. */
    public static void requestRebuild() {
        if (rebuildQueued) {
            return;
        }
        rebuildQueued = true;
        System.enqueueJob(new RebuildJob());
    }

    /** Public entry point for administrative backfills and tests. */
    public static void rebuildAll() {
        Map<String, Id> groupIds = loadGroups();
        SharePlan plan = new SharePlan();

        registerManagedCauses(plan);

        Map<Id, Job_Requisition__c> requisitions = new Map<Id, Job_Requisition__c>([
            SELECT Id, OwnerId, Assigned_Recruiter__c, Hiring_Manager__c
            FROM Job_Requisition__c
        ]);
        Map<Id, Job_Opening__c> openings = new Map<Id, Job_Opening__c>([
            SELECT Id, OwnerId, Requisition__c, Assigned_Recruiter__c
            FROM Job_Opening__c
        ]);
        Map<Id, Job_Application__c> applications = new Map<Id, Job_Application__c>([
            SELECT Id, OwnerId, Candidate__c, Job_Opening__c, Assigned_Recruiter__c
            FROM Job_Application__c
        ]);
        Map<Id, Candidate__c> candidates = new Map<Id, Candidate__c>([
            SELECT Id, OwnerId
            FROM Candidate__c
        ]);
        List<interview__c> interviews = [
            SELECT Id, OwnerId, Application__c, Primary_Interviewer__c
            FROM interview__c
        ];
        List<Offer__c> offers = [
            SELECT Id, OwnerId, Application__c
            FROM Offer__c
        ];

        Id recruiterGroupId = groupIds.get(RECRUITER_GROUP);
        Map<Id, Set<Id>> openingRecruiters = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> applicationRecruiters = new Map<Id, Set<Id>>();
        Map<Id, Id> applicationHiringManagers = new Map<Id, Id>();

        for (Job_Requisition__c requisition : requisitions.values()) {
            if (recruiterGroupId != null) {
                plan.add('Job_Requisition__Share', requisition.Id, recruiterGroupId, 'Edit', TEAM_CAUSE);
            }
            plan.addUnlessOwner(
                'Job_Requisition__Share', requisition.Id, requisition.OwnerId,
                requisition.Assigned_Recruiter__c, 'Edit', RECRUITER_CAUSE
            );
            plan.addUnlessOwner(
                'Job_Requisition__Share', requisition.Id, requisition.OwnerId,
                requisition.Hiring_Manager__c, 'Edit', HIRING_MANAGER_CAUSE
            );
        }

        for (Job_Opening__c opening : openings.values()) {
            if (recruiterGroupId != null) {
                plan.add('Job_Opening__Share', opening.Id, recruiterGroupId, 'Edit', TEAM_CAUSE);
            }

            Set<Id> recruiters = new Set<Id>();
            addIfPresent(recruiters, opening.Assigned_Recruiter__c);
            Job_Requisition__c requisition = requisitions.get(opening.Requisition__c);
            if (requisition != null) {
                addIfPresent(recruiters, requisition.Assigned_Recruiter__c);
            }
            openingRecruiters.put(opening.Id, recruiters);
            for (Id recruiterId : recruiters) {
                plan.addUnlessOwner(
                    'Job_Opening__Share', opening.Id, opening.OwnerId,
                    recruiterId, 'Edit', RECRUITER_CAUSE
                );
            }
            // Job Opening is Public Read Only internally. That already supplies
            // the hiring manager's required read access without an over-broad Edit share.
        }

        for (Job_Application__c application : applications.values()) {
            Set<Id> recruiters = new Set<Id>();
            addIfPresent(recruiters, application.Assigned_Recruiter__c);
            if (openingRecruiters.containsKey(application.Job_Opening__c)) {
                recruiters.addAll(openingRecruiters.get(application.Job_Opening__c));
            }
            applicationRecruiters.put(application.Id, recruiters);

            Job_Opening__c opening = openings.get(application.Job_Opening__c);
            Job_Requisition__c requisition = opening == null
                ? null
                : requisitions.get(opening.Requisition__c);
            Id hiringManagerId = requisition == null ? null : requisition.Hiring_Manager__c;
            applicationHiringManagers.put(application.Id, hiringManagerId);

            for (Id recruiterId : recruiters) {
                plan.addUnlessOwner(
                    'Job_Application__Share', application.Id, application.OwnerId,
                    recruiterId, 'Edit', RECRUITER_CAUSE
                );
                Candidate__c candidate = candidates.get(application.Candidate__c);
                if (candidate != null) {
                    plan.addUnlessOwner(
                        'Candidate__Share', candidate.Id, candidate.OwnerId,
                        recruiterId, 'Read', RECRUITER_CAUSE
                    );
                }
            }

            plan.addUnlessOwner(
                'Job_Application__Share', application.Id, application.OwnerId,
                hiringManagerId, 'Edit', HIRING_MANAGER_CAUSE
            );
            Candidate__c candidate = candidates.get(application.Candidate__c);
            if (candidate != null) {
                plan.addUnlessOwner(
                    'Candidate__Share', candidate.Id, candidate.OwnerId,
                    hiringManagerId, 'Read', HIRING_MANAGER_CAUSE
                );
            }
        }

        for (interview__c interviewRecord : interviews) {
            Job_Application__c application = applications.get(interviewRecord.Application__c);
            Set<Id> recruiters = applicationRecruiters.get(interviewRecord.Application__c);
            if (recruiters != null) {
                for (Id recruiterId : recruiters) {
                    plan.addUnlessOwner(
                        'interview__Share', interviewRecord.Id, interviewRecord.OwnerId,
                        recruiterId, 'Edit', RECRUITER_CAUSE
                    );
                }
            }

            Id hiringManagerId = applicationHiringManagers.get(interviewRecord.Application__c);
            plan.addUnlessOwner(
                'interview__Share', interviewRecord.Id, interviewRecord.OwnerId,
                hiringManagerId, 'Read', HIRING_MANAGER_CAUSE
            );
            plan.addUnlessOwner(
                'interview__Share', interviewRecord.Id, interviewRecord.OwnerId,
                interviewRecord.Primary_Interviewer__c, 'Read', INTERVIEWER_CAUSE
            );

            if (application != null && interviewRecord.Primary_Interviewer__c != null) {
                plan.addUnlessOwner(
                    'Job_Application__Share', application.Id, application.OwnerId,
                    interviewRecord.Primary_Interviewer__c, 'Read', INTERVIEWER_CAUSE
                );
                Candidate__c candidate = candidates.get(application.Candidate__c);
                if (candidate != null) {
                    plan.addUnlessOwner(
                        'Candidate__Share', candidate.Id, candidate.OwnerId,
                        interviewRecord.Primary_Interviewer__c, 'Read', INTERVIEWER_CAUSE
                    );
                }
            }
        }

        for (Offer__c offerRecord : offers) {
            Set<Id> recruiters = applicationRecruiters.get(offerRecord.Application__c);
            if (recruiters == null) {
                continue;
            }
            for (Id recruiterId : recruiters) {
                plan.addUnlessOwner(
                    'Offer__Share', offerRecord.Id, offerRecord.OwnerId,
                    recruiterId, 'Edit', RECRUITER_CAUSE
                );
            }
        }

        Id successionGroupId = groupIds.get(SUCCESSION_GROUP);
        if (successionGroupId != null) {
            for (Critical_Position__c criticalPosition : [
                SELECT Id FROM Critical_Position__c
            ]) {
                plan.add(
                    'Critical_Position__Share', criticalPosition.Id,
                    successionGroupId, 'Read', SUCCESSION_CAUSE
                );
            }
            for (Succession_Nomination__c nomination : [
                SELECT Id FROM Succession_Nomination__c
            ]) {
                plan.add(
                    'Succession_Nomination__Share', nomination.Id,
                    successionGroupId, 'Edit', SUCCESSION_CAUSE
                );
            }
        }

        plan.reconcile();
    }

    private static void registerManagedCauses(SharePlan plan) {
        plan.manage('Job_Requisition__Share', new Set<String>{
            TEAM_CAUSE, RECRUITER_CAUSE, HIRING_MANAGER_CAUSE
        });
        plan.manage('Job_Opening__Share', new Set<String>{
            TEAM_CAUSE, RECRUITER_CAUSE, HIRING_MANAGER_CAUSE
        });
        plan.manage('Job_Application__Share', new Set<String>{
            RECRUITER_CAUSE, HIRING_MANAGER_CAUSE, INTERVIEWER_CAUSE
        });
        plan.manage('Candidate__Share', new Set<String>{
            RECRUITER_CAUSE, HIRING_MANAGER_CAUSE, INTERVIEWER_CAUSE
        });
        plan.manage('interview__Share', new Set<String>{
            RECRUITER_CAUSE, HIRING_MANAGER_CAUSE, INTERVIEWER_CAUSE
        });
        plan.manage('Offer__Share', new Set<String>{RECRUITER_CAUSE});
        plan.manage('Critical_Position__Share', new Set<String>{SUCCESSION_CAUSE});
        plan.manage('Succession_Nomination__Share', new Set<String>{SUCCESSION_CAUSE});
    }

    private static Map<String, Id> loadGroups() {
        Map<String, Id> result = new Map<String, Id>();
        for (Group publicGroup : [
            SELECT Id, DeveloperName
            FROM Group
            WHERE Type = 'Regular'
            AND DeveloperName IN :new Set<String>{RECRUITER_GROUP, SUCCESSION_GROUP}
        ]) {
            result.put(publicGroup.DeveloperName, publicGroup.Id);
        }
        return result;
    }

    private static void addIfPresent(Set<Id> values, Id candidateValue) {
        if (candidateValue != null) {
            values.add(candidateValue);
        }
    }

    public class RebuildJob implements Queueable {
        public void execute(QueueableContext context) {
            RTPRecordSharingService.rebuildAll();
        }
    }

    private class DesiredShare {
        Id parentId;
        Id granteeId;
        String accessLevel;
        String rowCause;

        DesiredShare(Id parentId, Id granteeId, String accessLevel, String rowCause) {
            this.parentId = parentId;
            this.granteeId = granteeId;
            this.accessLevel = accessLevel;
            this.rowCause = rowCause;
        }
    }

    private class SharePlan {
        private Map<String, Set<String>> causesByShareObject = new Map<String, Set<String>>();
        private Map<String, Map<String, DesiredShare>> desiredByShareObject =
            new Map<String, Map<String, DesiredShare>>();

        void manage(String shareObject, Set<String> rowCauses) {
            causesByShareObject.put(shareObject, rowCauses);
            desiredByShareObject.put(shareObject, new Map<String, DesiredShare>());
        }

        void addUnlessOwner(
            String shareObject,
            Id parentId,
            Id ownerId,
            Id granteeId,
            String accessLevel,
            String rowCause
        ) {
            if (granteeId == null || granteeId == ownerId) {
                return;
            }
            add(shareObject, parentId, granteeId, accessLevel, rowCause);
        }

        void add(
            String shareObject,
            Id parentId,
            Id granteeId,
            String accessLevel,
            String rowCause
        ) {
            if (parentId == null || granteeId == null) {
                return;
            }
            String key = shareKey(parentId, granteeId, rowCause);
            desiredByShareObject.get(shareObject).put(
                key,
                new DesiredShare(parentId, granteeId, accessLevel, rowCause)
            );
        }

        void reconcile() {
            for (String shareObject : causesByShareObject.keySet()) {
                reconcileObject(
                    shareObject,
                    causesByShareObject.get(shareObject),
                    desiredByShareObject.get(shareObject)
                );
            }
        }

        private void reconcileObject(
            String shareObject,
            Set<String> managedCauses,
            Map<String, DesiredShare> desired
        ) {
            List<SObject> existingShares = Database.query(
                'SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause ' +
                'FROM ' + shareObject + ' WHERE RowCause IN :managedCauses'
            );
            Map<String, SObject> existingByKey = new Map<String, SObject>();
            for (SObject existingShare : existingShares) {
                existingByKey.put(
                    shareKey(
                        (Id) existingShare.get('ParentId'),
                        (Id) existingShare.get('UserOrGroupId'),
                        (String) existingShare.get('RowCause')
                    ),
                    existingShare
                );
            }

            List<SObject> sharesToDelete = new List<SObject>();
            List<SObject> sharesToInsert = new List<SObject>();

            for (String existingKey : existingByKey.keySet()) {
                SObject existingShare = existingByKey.get(existingKey);
                DesiredShare desiredShare = desired.get(existingKey);
                if (
                    desiredShare == null ||
                    (String) existingShare.get('AccessLevel') != desiredShare.accessLevel
                ) {
                    sharesToDelete.add(existingShare);
                }
            }

            Schema.SObjectType shareType = Schema.getGlobalDescribe().get(shareObject);
            for (String desiredKey : desired.keySet()) {
                SObject existingShare = existingByKey.get(desiredKey);
                DesiredShare desiredShare = desired.get(desiredKey);
                if (
                    existingShare != null &&
                    (String) existingShare.get('AccessLevel') == desiredShare.accessLevel
                ) {
                    continue;
                }
                SObject newShare = shareType.newSObject();
                newShare.put('ParentId', desiredShare.parentId);
                newShare.put('UserOrGroupId', desiredShare.granteeId);
                newShare.put('AccessLevel', desiredShare.accessLevel);
                newShare.put('RowCause', desiredShare.rowCause);
                sharesToInsert.add(newShare);
            }

            if (!sharesToDelete.isEmpty()) {
                delete sharesToDelete;
            }
            if (!sharesToInsert.isEmpty()) {
                insert sharesToInsert;
            }
        }

        private String shareKey(Id parentId, Id granteeId, String rowCause) {
            return String.valueOf(parentId) + '|' + String.valueOf(granteeId) + '|' + rowCause;
        }
    }
}
