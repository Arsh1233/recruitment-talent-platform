# AI-Enabled Recruitment and Talent Management System

Salesforce major project for an IT company. The solution provides an Experience Cloud candidate portal and an internal Lightning application covering recruitment, onboarding, employee skills, performance, and succession planning.

## Confirmed scope

- Job requisitions, approval, vacancies, and candidate applications
- Résumé upload, AI-assisted parsing, and candidate verification
- Explainable rule-based candidate matching
- Recruiter screening, interviews, offers, and onboarding
- Employee skills, certifications, goals, reviews, and development plans
- Critical positions and succession nominations
- Candidate and employee chatbot experiences
- Security, audit history, reports, dashboards, and failure recovery

The signed academic-prototype business baseline is stored in `docs/Phase-1-Functional-Process-Specification.md`.

## Technology

- Salesforce Platform and Experience Cloud
- Lightning Web Components, SLDS, JavaScript, HTML, and CSS
- Apex, SOQL/SOSL, Queueable Apex, and scheduled processing
- Salesforce Flow and approval automation
- Salesforce Files
- REST/JSON integrations through Named and External Credentials
- Provider-neutral AI integration
- Salesforce DX, Salesforce CLI, Git, Jest, ESLint, and Prettier

## Local development

The project is designed for Antigravity on Windows. A project-local Salesforce CLI is used so development does not depend on a machine-wide CLI installation.

```powershell
.\tools\sf.ps1 --version
.\tools\sf.ps1 org login web --alias TalentDev
.\tools\sf.ps1 project deploy start --target-org TalentDev
```

The current machine's global npm launcher is misconfigured. Use the project wrapper until the machine installation is repaired:

```powershell
.\tools\npm.ps1 --version
.\tools\npm.ps1 install
```

## Environment policy

- Use synthetic demonstration data only.
- Do not commit secrets, access tokens, résumés, or candidate/employee personal data.
- Keep AI provider code behind a provider-neutral service interface.
- Human users remain responsible for hiring, rejection, performance, and succession decisions.
- Production deployment requires separate organizational, legal, privacy, and security approval.

## Current phase

Phase 1 is complete for academic-prototype design. Phase 2 environment setup is in progress; see `docs/phase-2-environment-status.md`.
