# Phase 3 Batch Deployment and Validation

## Purpose

Phase 3 metadata is stored and validated in six dependency-ordered batches. A later batch must not be deployed until the preceding batch passes its check-only deployment.

## Source inventory

The metadata retrieved from `TalentDev` on 2026-10-14 contains:

- 33 custom objects
- 444 custom fields
- 146 validation rules
- 12 Phase 3 flows
- 4 global value sets
- Candidate and Skill matching rules
- Candidate and Skill duplicate rules
- The résumé AI service and its mocked Apex tests

## Batch manifests

| Batch | Scope | Manifest |
| --- | --- | --- |
| A | Department, Position, Skill, Candidate, Employee, identity controls | `manifest/batch-a-foundation.xml` |
| B | Requisition through Job Application | `manifest/batch-b-recruitment.xml` |
| C | Interview, evaluation, offer, onboarding | `manifest/batch-c-selection-onboarding.xml` |
| D | Résumé parsing, matching, consent, AI, integration logging | `manifest/batch-d-ai-matching.xml` |
| E | Employee skills, certification, performance, development | `manifest/batch-e-talent.xml` |
| F | Critical positions, nominations, readiness | `manifest/batch-f-succession.xml` |

## Repeatable validation

Run every gate in order:

```powershell
.\scripts\validate-phase3-batches.ps1 -TargetOrg TalentDev
```

The script stops at the first failed batch. Batch A runs `CandidateIdentityGuardTest`, Batch D runs all five `ResumeAiServiceTest` methods, and the Batch A and B functional checks use savepoints and rollbacks so they do not leave synthetic records in the org.

## Validation evidence

| Batch | Result | Deployment ID | Extra verification |
| --- | --- | --- | --- |
| A | Passed | `0AfgK00000WRREcSAP` | 74/74 components; 1/1 identity test; rollback data check passed |
| B | Passed | `0AfgK00000WRSvRSAX` | 151/151 components; rollback recruitment-chain check passed |
| C | Passed | `0AfgK00000WRSyfSAH` | 114/114 components |
| D | Passed | `0AfgK00000WRT57SAH` | 134/134 components; 5/5 mocked callout tests passed |
| E | Passed | `0AfgK00000WRTDBSA5` | 132/132 components |
| F | Passed | `0AfgK00000WQkG7SAL` | 65/65 components |

The Candidate Contact integrity guard was deployed separately after the functional check exposed that Salesforce Lookup fields cannot be marked unique. Deployment `0AfgK00000WRRRWSA5` passed 3/3 components and 1/1 test.

## Important org-specific findings

- The Interview object API name in the existing org is `interview__c` with a lowercase `i`. The Batch C manifest uses the actual API name.
- `Calculate_Interview_Overall_Score` is retrieved in Draft status. Its metadata validates, but it will not execute until deliberately activated in a later business-logic phase.
- `Candidate__c.Contact__c` cannot use Salesforce's Unique field attribute because it is a Lookup. `CandidateIdentityGuardTrigger` enforces the required one-Contact/one-Candidate rule in bulk-safe Apex.
- Shared picklists `Employment_Type`, `Job_Level`, `Skill_Proficiency`, and `Work_Mode` are introduced in Batch B and must be deployed before dependent later batches.

## Deployment command

After a batch passes validation, deploy that same manifest without `--dry-run`. For example:

```powershell
.\tools\sf.ps1 project deploy start --target-org TalentDev --manifest manifest\batch-b-recruitment.xml --test-level NoTestRun --wait 30
```

Use only synthetic data for post-deployment checks. Do not commit credentials, tokens, résumé content, or real candidate and employee data.
