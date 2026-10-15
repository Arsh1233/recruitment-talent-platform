# Phase 4 Step 3 organization-wide defaults report

## Result

- Target org: `TalentDev`
- Date: 2026-10-14
- Dry-run deployment: `0AfgK00000WRIo4SAH`
- Production deployment: `0AfgK00000WOQeuSAH`
- Deployment status: **Succeeded**
- Packaged components: 447 of 447
- Live OWD verification: **33 passed, 0 failed**
- Phase 3 regression suite: **17 passed, 0 failed, 1 Phase 4 test pending**

Salesforce packaged the unchanged decomposed fields, rules, layouts, and other object children with 21 selected object headers. Nineteen headers required changes; Critical Position and Succession Nomination were already Private/Private. No component failed and the deployment changed only the intended object sharing configuration.

## Final standalone-object defaults

| Object | Internal | External |
|---|---|---|
| `Department__c` | Public Read Only | Private |
| `Position__c` | Public Read Only | Private |
| `Skill__c` | Public Read Only | Public Read Only |
| `Job_Opening__c` | Public Read Only | Private |
| `Candidate__c` | Private | Private |
| `Certification__c` | Private | Private |
| `Job_Requisition__c` | Private | Private |
| `Job_Application__c` | Private | Private |
| `interview__c` | Private | Private |
| `Offer__c` | Private | Private |
| `Onboarding_Plan__c` | Private | Private |
| `Employee__c` | Private | Private |
| `Performance_Cycle__c` | Private | Private |
| `Performance_Review__c` | Private | Private |
| `Development_Plan__c` | Private | Private |
| `Critical_Position__c` | Private | Private |
| `Succession_Nomination__c` | Private | Private |
| `Resume_Parsing_Request__c` | Private | Private |
| `Match_Result__c` | Private | Private |
| `AI_Interaction__c` | Private | Private |
| `Integration_Log__c` | Private | Private |

## Controlled-by-parent objects

The following 12 master-detail children remain Controlled by Parent for both internal and external access:

- `Candidate_Skill__c`
- `Education__c`
- `Employment_Experience__c`
- `Consent_Record__c`
- `Job_Skill_Requirement__c`
- `Interview_Evaluation__c`
- `Onboarding_Task__c`
- `Employee_Skill__c`
- `Performance_Goal__c`
- `Development_Action__c`
- `Readiness_Assessment__c`
- `Match_Criterion_Result__c`

## Published jobs decision

`Job_Opening__c` remains externally Private. External Public Read Only would also expose Draft, On Hold, Closed, and Cancelled openings to any external user with object Read access. A later Phase 4 sharing step must expose only records meeting both conditions:

```text
Status__c = "Published"
Is_Published__c = TRUE
```

## Hierarchy and sharing-engine setting

The CustomObject metadata property `enableSharing` was deliberately retained as `true`. Salesforce requires Allow Sharing, Bulk API, and Streaming API access to remain enabled together for these objects, and later Phase 4 steps require the sharing engine.

The separate **Grant Access Using Hierarchies** policy was not disabled by misusing `enableSharing`. Hierarchy behavior must be reviewed alongside the internal sharing-rule and public-group design so required managerial access is not accidentally removed.

## Verification evidence

- The verifier queried `EntityDefinition.InternalSharingModel` and `ExternalSharingModel` directly from `TalentDev`.
- All 33 target objects matched `data/phase4/owd-model.csv`.
- No pending `BackgroundOperation` record was found after deployment.
- The rollback-safe Phase 3 test suite still passed all executable integrity checks.
- Candidate A versus Candidate B isolation remains pending until external users, sharing sets, and portal membership are created.

## Repeatable commands

```powershell
.\scripts\deploy-phase4-step3-owd.ps1 -TargetOrg TalentDev -DryRun
.\scripts\deploy-phase4-step3-owd.ps1 -TargetOrg TalentDev
.\scripts\verify-phase4-step3-owd.ps1 -TargetOrg TalentDev
```
