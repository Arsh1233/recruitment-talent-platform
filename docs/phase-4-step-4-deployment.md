# Phase 4 Step 4 candidate-owned relationship report

## Result

- Target org: `TalentDev`
- Org ID: `00DgK00000akf0DUAQ`
- Date: 2026-10-15
- Fields and flows dry run: `0AfgK00000WVLYnSAP`
- Fields and flows deployment: `0AfgK00000WV5c6SAD`
- Administrator permission-set deployment: `0AfgK00000WVOgLSAX`
- Validation-rule dry run: `0AfgK00000WVSbtSAH`
- Validation-rule deployment: `0AfgK00000WVMWUSA5`
- Deployment status: **Succeeded**
- Backfill: **7 succeeded, 0 failed**
- Final identity verification: **0 mismatches on all four objects**
- Caller-supplied Contact override test: **Passed**

## Deployed fields

The system-managed `Portal_Contact__c` Contact lookup was added to:

- `Job_Application__c`
- `interview__c`
- `Offer__c`
- `Certification__c`

The fields are optional in metadata to support safe deployment, but active validation rules enforce the required identity for candidate-facing records. Candidate permission metadata does not expose these fields.

## Active automation

- `RTP_Set_Application_Portal_Contact` derives Contact from `Candidate__c.Contact__c`.
- `RTP_Set_Interview_Portal_Contact` inherits Contact from the related Job Application.
- `RTP_Set_Offer_Portal_Contact` inherits Contact from the related Job Application.
- `RTP_Set_Certification_Portal_Contact` derives Contact from Candidate and clears it for employee-only certifications.

Each flow runs before save on create and update and overwrites any caller-supplied Portal Contact value.

## Integrity controls

Active validation rules require the derived identity to be nonblank and correct for Job Applications, Interviews, and Offers. Candidate Certifications must match their Candidate Contact; employee-only Certifications must keep Portal Contact blank.

`RTP_Portal_Contact_Admin` provides read-only verification access to the four protected fields and is assigned only to the deployment administrator. It does not provide edit permission.

## Existing-data correction

One synthetic Candidate (`CAN-00001`, Test Candidate) had no Contact. A matching synthetic Contact was created under `Synthetic Candidate Portal Account`, linked to the Candidate, and inherited down to its Application and Interview before the validation rules were activated.

## Repeatable checks

```powershell
sf apex run --target-org TalentDev --file scripts/apex/backfill-phase4-step4-portal-contact.apex
sf apex run --target-org TalentDev --file scripts/apex/verify-phase4-step4-portal-contact.apex
sf apex run --target-org TalentDev --file scripts/apex/test-phase4-step4-portal-contact-override.apex
```

The override test uses a savepoint and rolls back its temporary data change.
