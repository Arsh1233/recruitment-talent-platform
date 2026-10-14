# Phase 3 synthetic data

These files document the fictional reference and transaction records loaded into `TalentDev` for schema verification. All candidate email addresses use the reserved `example.invalid` domain.

The canonical, idempotent loader is [`scripts/apex/load-phase3-synthetic-data.apex`](../../scripts/apex/load-phase3-synthetic-data.apex). The CSV files are reviewable source artifacts keyed by stable synthetic codes; they intentionally omit Salesforce record IDs.

No real resumes, personal data, credentials, access tokens, or provider responses are included.
