# Phase 4 Step 6 — Internal Sharing Deployment

## Status

Deployed to `TalentDev` on 2026-10-15.

- Deployment ID: `0AfgK00000WJsH8SAL`
- Interview evaluation security deployment: `0AfgK00000WVVmgSAH`
- Automated test: `RTPRecordSharingServiceTest.buildsAndReplacesInternalShares`
- Result: Passed

## Public groups

| Developer name | Include managers | Current membership |
| --- | --- | --- |
| `RTP_All_Recruiters` | No | Users already assigned as recruiters were added |
| `RTP_Succession_Committee` | No | Empty; no user currently has `RTP_Succession_Access` |

The group-member synchronization script adds known assigned recruiters and
users explicitly assigned the succession permission set. It does not guess
committee membership and does not remove manually approved members.

## Implemented access

| Persona | Record | Access |
| --- | --- | --- |
| Recruitment team | Job Requisition | Edit through `RTP_All_Recruiters` |
| Recruitment team | Job Opening | Edit through `RTP_All_Recruiters` |
| Assigned recruiter | Requisition, Opening, Application, Interview, Offer | Edit |
| Assigned recruiter | Candidate summary | Read |
| Hiring manager | Assigned Requisition | Edit |
| Hiring manager | Related Application | Edit |
| Hiring manager | Candidate summary and Interview | Read |
| Primary interviewer | Assigned Interview, Application, Candidate summary | Read |
| Succession committee | Critical Position | Read |
| Succession committee | Succession Nomination | Edit |
| Succession committee | Readiness Assessment | Controlled by the nomination parent |

`Job_Opening__c` is Public Read Only internally, so hiring managers already
receive the required read access. The service intentionally does not add an
Edit share merely to represent that relationship.

## Reassignment and removal

Custom Apex sharing reasons distinguish recruitment-team, recruiter, hiring
manager, interviewer, and succession access. A post-commit rebuild runs after
inserts, updates, deletes, and undeletes on the assignment-sensitive objects.
It removes stale managed shares and creates only the shares justified by the
current assignments.

## Interview evaluation isolation

`Interview_Evaluation__c` is master-detail to `interview__c`. Salesforce child
sharing therefore cannot isolate individual evaluations while also granting
normal direct child access. `RTPInterviewEvaluationService` provides the safe
edit path instead:

- The logged-in user identity is forced into `Interviewer__c`.
- A new evaluation can be created only by the assigned primary interviewer.
- Existing evaluations can be edited only by their own interviewer.
- Submitted evaluations are locked unless reopened by an authorized process.
- `RTP_Interviewer_Access` grants access to this Apex service, not broad direct
  access to all evaluation records.

## Backfill and verification

The existing org records were reconciled with
`scripts/apex/backfillRTPInternalSharing.apex`.

Observed managed shares after backfill:

- 3 Job Requisitions shared Edit with `RTP_All_Recruiters`.
- 1 Critical Position shared Read with `RTP_Succession_Committee`.
- 1 Succession Nomination shared Edit with `RTP_Succession_Committee`.
- Existing direct assignees who own their records did not receive redundant
  share rows because ownership already provides stronger access.

The integration test verifies initial grants, stale-share removal after
recruiter, manager, and interviewer replacement, succession access, absence of
an employee self-share, and rejection of a cross-interviewer evaluation edit.

## Operational scripts

- `scripts/apex/backfillRTPInternalSharing.apex`
- `scripts/apex/syncRTPInternalGroupMembers.apex`

Run the membership synchronization script after assigning
`RTP_Succession_Access` to approved committee users or after introducing new
assigned recruiters.
