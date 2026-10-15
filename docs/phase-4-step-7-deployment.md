# Phase 4 Step 7 — Object Permission Deployment

## Status

Deployed to `TalentDev` on 2026-10-15.

- Validation deployment ID: `0AfgK00000WZywcSAD`
- Production deployment ID: `0AfgK00000WY672SAD`
- AI mock-test deployment ID: `0AfgK00000WZxIwSAL`
- Apex test run ID: `707gK00000zHVOt`
- Test result: 7 tests passed, 0 failed

## Candidate portal access

`RTP_Candidate_Portal_Access` now grants the candidate-facing CRUD model with
field-level allowlists:

| Object | Access |
| --- | --- |
| Candidate | Read, Edit |
| Candidate Skill | Create, Read, Edit, Delete |
| Education | Create, Read, Edit, Delete |
| Employment Experience | Create, Read, Edit, Delete |
| Certification | Create, Read, Edit, Delete |
| Skill | Read |
| Job Opening | Read |
| Job Application | Create, Read, Edit; no Delete |
| Interview | Read |
| Offer | Read, controlled response-field Edit |

The permission set has no `View All` or `Modify All`. It grants no access to
Interview Evaluation, Match Result, employee, performance, succession, AI
audit, or integration-log objects.

Candidate-editable Offer fields are limited to candidate response, revision
request, and decline reason. Internal Offer status and compensation fields are
read-only. Job Application internal screening, matching, and recruiter fields
are not exposed.

`RTP_Candidate_Portal_User` is assigned through the candidate permission set.
The `Candidate_Submitted_Application_Lock` validation rule prevents candidate
users from editing an application after it leaves Draft, except for the
controlled withdrawal transition. Candidates cannot delete applications.

Certification previously required an Employee even though candidates are
allowed to own certifications. `Employee__c` is now optional, and
`Candidate_or_Employee_Required` enforces that every certification has at least
one Candidate or Employee owner.

## Interviewer access

`RTP_Interviewer_Access` grants read-only access to the assigned Interview,
limited Candidate summary fields, and limited Job Application context. It does
not expose candidate email or phone and does not grant Candidate Edit.

Direct Interview Evaluation object access remains intentionally absent because
the object is controlled by its Interview master-detail parent. The previously
deployed `RTPInterviewEvaluationService` is the secure create/edit path for an
interviewer's own evaluation, and the permission set grants access to that
service.

## AI integration access

`RTP_AI_Integration_Access` now grants least-privilege access to:

- Resume Parsing Request: Create, Read, Edit
- AI Interaction: Create, Read, Edit
- Integration Log: Create, Read
- Match Result and Match Criterion Result: Create, Read, Edit
- Candidate: Read, with Edit only on approved parsed profile fields
- Candidate Skill, Education, and Employment Experience: Create, Read, Edit
- Job Application, Job Opening, and Skill: Read

The permission set grants no Delete, `View All`, or `Modify All`. It also grants
execution access to `ResumeAiService`. The service was missing from TalentDev
and was deployed as part of this step.

## Verification

The org's `ObjectPermissions` records were queried after deployment. All 25
expected entries matched the source metadata, and every entry had
`PermissionsViewAllRecords = false` and `PermissionsModifyAllRecords = false`.
Field-permission records were also audited to confirm only the allowlisted
fields are editable.

The following tests passed:

- Five mocked `ResumeAiServiceTest` callout tests
- `RTPRecordSharingServiceTest.buildsAndReplacesInternalShares`
- Existing sharing and interview-evaluation service coverage remained intact

The related permission-set groups report `Updated`, meaning recalculation is
complete.

## Assignment status

No user currently has these three permission sets assigned directly. This was
left unchanged deliberately: candidate, interviewer, and integration access
must be assigned only after the corresponding real test users are identified.
The permission-set groups are ready for those assignments.

