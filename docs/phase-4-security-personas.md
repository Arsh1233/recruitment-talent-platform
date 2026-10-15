# Phase 4 security personas

## Scope

This document is the approved persona baseline for Phase 4. It defines intended access but does not yet grant object, field, or record access. Functional permission sets, sharing controls, site membership, and test-user assignments are implemented in later Phase 4 steps.

## Verified org context

Verified in `TalentDev` on 2026-10-14:

- `Recruitment and Talent Portal` exists with status `UnderConstruction` and URL prefix `careersvforcesite`.
- `Customer Community` has 5 licenses and 0 are used.
- `Salesforce Integration` has 1 license and 0 are used.
- Salesforce Platform licenses are available for internal least-privilege test personas.

## Access-control model

- Profiles provide the minimum login and application baseline.
- Permission sets provide small, reusable capabilities.
- Permission set groups represent internal human personas.
- Roles, groups, queues, sharing rules, sharing sets, and restriction rules control record visibility.
- Field-level security controls confidential and highly restricted fields.
- Permission sets only add access. They must not be used to compensate for an over-permissive profile.

## Persona inventory

| Persona | Metadata representation | Record scope | Key exclusions |
|---|---|---|---|
| System Administrator | Existing administrator profile | All | Not used for normal business testing |
| HR Administrator | `Talent_HR_Administrator` group | HR and recruitment | Setup; succession without separate authorization |
| Recruiter | `Talent_Recruiter_Persona` group | Assigned/shared recruitment | Performance and succession |
| Hiring Manager | `Talent_Hiring_Manager` group | Assigned requisitions and related records | Unrelated applications; parsing changes; compensation edits |
| Interviewer | `Talent_Interviewer_Persona` group | Assigned interviews; own evaluations | Offers; other evaluations; application-status changes |
| Employee | `Talent_Employee` group | Own employee graph | Succession |
| Talent Manager / Succession Committee | `Talent_Succession_Committee` group | Authorized succession population | Unrelated recruitment data |
| Candidate Portal User | `Talent_Candidate_Portal` permission set | Own candidate graph; published jobs | Internal evaluations, matching details, employee/succession and audit records |
| Integration User | `Talent_AI_Integration` permission set | Approved integration operations | Setup, broad data access, salary, performance and succession |

## Reusable functional permission-set structure

The following permission-set foundations were created in Step 2. Object, field, Apex, Flow, and application permissions will be added in later Phase 4 steps:

| API name | Capability |
|---|---|
| `RTP_Recruiter_Access` | Recruitment operations |
| `RTP_Hiring_Manager_Access` | Assigned requisitions and applications |
| `RTP_Interviewer_Access` | Assigned interviews and evaluations |
| `RTP_HR_Admin_Access` | Employee and talent administration |
| `RTP_Employee_Self_Service` | Employee self-service |
| `RTP_Succession_Access` | Critical positions, nominations and readiness |
| `RTP_Candidate_Portal_Access` | Candidate portal operations |
| `RTP_AI_Integration_Access` | AI and integration execution |
| `RTP_Audit_Read_Access` | Read-only audit access |

`RTP_Succession_Access` remains a separately reviewed assignment. It is not included in `RTP_HR_Talent_Team` or the recruiter group.

## Sensitive-access separations

These capabilities require dedicated permission sets and explicit approval:

- Succession nominations, committee comments and readiness decisions
- Offered salary and compensation fields
- Confidential performance comments
- Named Credential principal access
- Integration-log administration
- Candidate data export
- Résumé parsing-result correction
- Delete access for historical records

## Candidate ownership model

Candidate isolation will use the following identity chain:

```text
External User.ContactId
        → Candidate__c.Contact__c
        → candidate-owned child records
```

Object permissions do not provide isolation. Sharing sets or equivalent external-user sharing controls must enforce this chain before the site is published.

## Planned security test identities

Use fictional `example.invalid` identities for one HR administrator, recruiter, hiring manager, interviewer, employee, succession committee member, integration user, Candidate A, and Candidate B. Candidate A must never be able to query, open, update, or infer Candidate B's records.

No test users are created in Step 1 because their profiles, sharing model, site membership, and functional permission sets are not yet complete.

The `_Persona` suffix distinguishes the two new groups from the pre-existing `Talent_Recruiter` and `Talent_Interviewer` permission sets. Existing security metadata was preserved and was not overwritten.

## Step 1 completion criteria

- Nine personas are documented.
- Six internal persona permission-set groups exist in source and `TalentDev`.
- Candidate and integration foundations are bound to the correct licenses.
- Allowed scope and explicit exclusions are documented.
- Succession access is separated from general HR access.
- Candidate and integration licenses remain unconsumed.
- No permission assignments or real user access were changed.
