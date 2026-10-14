# Phase 3 data integrity test report

## Result

- Org alias: `TalentDev`
- Execution date: 2026-10-14
- Result: **17 passed, 0 failed, 1 pending**
- Test method: rollback-safe anonymous Apex; test mutations were rolled back
- Persistent data: synthetic records only
- Final batch validation: A through F passed in dependency order

Final validation deployment IDs:

| Batch | Deployment ID |
|---|---|
| A — Foundation | `0AfgK00000WRaPxSAL` |
| B — Recruitment | `0AfgK00000WRJ90SAH` |
| C — Selection and onboarding | `0AfgK00000WRRpiSAH` |
| D — AI and matching | `0AfgK00000WRHFGSA5` |
| E — Talent | `0AfgK00000WRaszSAD` |
| F — Succession | `0AfgK00000WRMhzSAH` |

## Loaded synthetic data

| Record type | Count |
|---|---:|
| Departments | 3 |
| Positions | 9 |
| Skills | 22 |
| Candidates | 3 |
| Job requisitions | 2 |
| Job openings | 2 |
| Job applications | 3 |
| Employees | 2 |
| Performance cycles | 1 |
| Critical positions | 1 |

The loader also created linked selection, onboarding, matching, review, development, and succession records needed to exercise the end-to-end relationship chains.

## Integrity checks

| Check | Result |
|---|---|
| Synthetic reference counts | Pass |
| Required fields | Pass |
| Negative candidate experience rejected | Pass |
| Invalid employment dates rejected | Pass |
| Duplicate Candidate-to-Contact identity rejected | Pass |
| Duplicate active application rejected | Pass |
| Candidate → Application → Interview → Offer → Employee | Pass |
| Employee → Review → Development Plan | Pass |
| Employee → Succession Nomination → Readiness Assessment | Pass |
| Application → Match Result → Criterion Results | Pass |
| Onboarding rollups | Pass |
| Performance goal-weight rollup | Pass |
| Latest succession assessment fields | Pass |
| Match-result rollups | Pass |
| Inactive skill rejected for a new job requirement | Pass |
| Reporting relationship traversal | Pass |
| Historical application deletion protection | Pass |
| External candidate record isolation | Pending Phase 4 |

## Corrections made during testing

1. Added `Job_Skill_Requirement__c.Active_Skill_Required` so inactive skills cannot be selected for new or changed job requirements.
2. Corrected `Maintain Latest Succession Readiness` so it filters for non-superseded assessments and retains the latest readiness value instead of clearing it.

## Deferred security check

External-candidate isolation cannot be executed responsibly until Phase 4 creates at least two external users and configures sharing sets/rules. The data model is ready, but this security test must remain pending rather than being simulated with administrator access.

## Repeat commands

```powershell
.\tools\sf.ps1 apex run --target-org TalentDev --file scripts/apex/load-phase3-synthetic-data.apex
.\tools\sf.ps1 apex run --target-org TalentDev --file scripts/apex/test-phase3-data-integrity.apex
```

The loader is safe to rerun. The integrity suite establishes a savepoint and rolls back all temporary test records.
