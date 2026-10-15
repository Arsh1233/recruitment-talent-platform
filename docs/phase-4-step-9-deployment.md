# Phase 4 Step 9 — Apex and Lightning Security Deployment

## Status

Deployed to `TalentDev` on 2026-10-15.

- Validation deployment ID: `0AfgK00000WaM7dSAF`
- Primary deployment ID: `0AfgK00000WZzuESAT`
- Final controller cleanup deployment ID: `0AfgK00000WaEreSAF`
- Primary deployment components: 9
- Primary deployment tests: 5 passed, 0 failed
- Final cleanup tests: 4 passed, 0 failed
- Result: Succeeded

## Implemented controls

### Authenticated candidate context

`RTPCandidateContext` derives the candidate only from the current Salesforce
user's `ContactId`. Portal methods do not accept a Candidate ID or Contact ID as
proof of identity.

`RTPPortalCandidateController`:

- is declared `with sharing`;
- uses user-mode queries for candidate and application data;
- filters application requests by both the untrusted application ID and the
  authenticated candidate ID;
- returns explicit DTOs rather than Salesforce records;
- converts internal failures into controlled candidate-safe messages; and
- never returns match details, recruiter notes, integration data, or raw AI
  content.

### Public job listings

`RTPPortalJobController`:

- is declared `with sharing`;
- verifies object and public-field read access;
- returns only an explicit public job-card DTO;
- selects only openings whose publication flag and status both indicate
  `Published`;
- excludes openings after their application deadline; and
- does not return internal status, recruiter ownership, requirements versions,
  or other internal fields to the browser.

The controller reads publication-control fields internally but exposes only the
approved public values. `Work_Mode__c` is included only when that field exists
and is readable in the running org.

### Interview evaluation gateway

`RTPInterviewEvaluationService` is the only documented `without sharing`
exception for portal-facing functionality. The exception is required because
Interview Evaluation is master-detail to Interview and direct child CRUD would
allow an interviewer to see sibling evaluations inherited through the parent.

The service compensates with narrower controls:

- requires custom permission `RTP_Submit_Interview_Evaluation`;
- confirms user-mode access to the Interview record;
- confirms the current user is the assigned primary interviewer;
- derives `Interviewer__c` from `UserInfo.getUserId()`;
- filters every evaluation read/update by that same user;
- accepts and copies only an explicit field allowlist;
- locks submitted evaluations unless reopened; and
- returns controlled errors instead of raw platform details.

The custom permission and Apex class are granted by
`RTP_Interviewer_Access`. Candidate portal users receive access only to the two
candidate-safe controllers.

### Lightning boundary

The repository currently contains no candidate-facing LWC that performs record
operations. `environmentHealth` displays static health text only and contains
no IDs, data queries, credentials, or secrets. Future candidate LWCs must use
the secured controllers above or Lightning Data Service and must not treat
client-provided record IDs as authorization.

## Test evidence

The deployment tests verify:

1. Candidate A can retrieve only Candidate A's application.
2. Candidate A cannot retrieve Candidate B's application by supplying its ID.
3. Only published, non-expired jobs appear in the public listing.
4. The public job DTO omits internal status, recruiter, and requirements data.
5. Missing candidate identity returns a controlled message.
6. Unexpected job-listing failures return a controlled message.
7. An interviewer can create and retrieve only their own evaluation.
8. A different authorized interviewer cannot edit that evaluation.
9. A user without the custom permission cannot use the evaluation gateway.

Coverage recorded by the completed deployments:

| Apex class | Coverage |
| --- | ---: |
| `RTPCandidateContext` | 86.7% |
| `RTPInterviewEvaluationService` | 86.3% |
| `RTPPortalCandidateController` | 91.9% |
| `RTPPortalJobController` | 95.7% |

Post-deployment Tooling API checks confirmed all four production classes and
the Step 9 test class are active at API version 67. Permission metadata checks
confirmed the candidate permission set has both candidate-safe Apex classes and
the interviewer permission set has the evaluation service and custom
permission.

## Operational note

No secrets were added to Apex, Lightning, permission sets, test data, or logs.
All test identities and business records use fictional data. The security
classes are deployed, but they are not assigned to real users by this step.
