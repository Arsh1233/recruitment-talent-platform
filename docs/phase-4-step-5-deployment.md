# Phase 4 Step 5 candidate Sharing Set report

## Result

- Target org: `TalentDev`
- Org ID: `00DgK00000akf0DUAQ`
- Date: 2026-10-15
- Sharing Set: `RTP_Candidate_Record_Access`
- Profile: `Customer Community User`
- Dry-run deployment: `0AfgK00000WVYarSAH`
- Production deployment: `0AfgK00000WUlyMSAT`
- Post-deployment retrieval: `09SgK00000bVDTWUA4`
- Deployment status: **Succeeded**
- Live metadata verification: **Passed**

## Access mappings

| Object | User field | Target field | Access |
|---|---|---|---|
| `Candidate__c` | `Contact` | `Contact__c` | Edit |
| `Job_Application__c` | `Contact` | `Portal_Contact__c` | Edit |
| `interview__c` | `Contact` | `Portal_Contact__c` | Read |
| `Offer__c` | `Contact` | `Portal_Contact__c` | Edit |
| `Certification__c` | `Contact` | `Portal_Contact__c` | Edit |

The deployed component was retrieved from Salesforce after deployment. Salesforce normalized the standard profile name to `customer community user`; the five mappings and access levels were preserved exactly.

## Inherited candidate children

These objects were deliberately omitted from direct mappings because their Candidate relationship is Master-Detail:

- `Candidate_Skill__c`
- `Education__c`
- `Employment_Experience__c`
- `Consent_Record__c`

They inherit record-level access from `Candidate__c`. Object and field permissions must still be granted separately through the candidate permission set.

## Confidential exclusions

The Sharing Set contains no mapping for:

- `Interview_Evaluation__c`
- `Match_Result__c`
- `Match_Criterion_Result__c`
- `AI_Interaction__c`
- `Integration_Log__c`
- Employee, performance, development, or succession objects

Recruiter-only fields on shared records remain subject to field-level security.

## Runtime-test status

The org currently has zero Experience Cloud users. The Sharing Set configuration is deployed and verified, but two-candidate runtime isolation cannot be executed until two synthetic candidate users are created, added to the Recruitment and Talent Portal, and assigned the candidate permission set. User provisioning and candidate CRUD/FLS are separate security steps and were not added implicitly here.

The site remains `UnderConstruction`; publishing was not required for this metadata deployment.
