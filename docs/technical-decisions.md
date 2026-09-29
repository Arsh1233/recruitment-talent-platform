# Technical Decision Register

| ID      | Decision                                                                            | Status   | Rationale                                                                            |
| ------- | ----------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------ |
| TDR-001 | Use a Salesforce DX source-format project                                           | Accepted | Enables repeatable deployment, testing, and version control                          |
| TDR-002 | Use Antigravity as the primary editor and Salesforce CLI as the execution authority | Accepted | Keeps the workflow IDE-independent                                                   |
| TDR-003 | Keep the AI provider behind an Apex service abstraction                             | Accepted | Avoids coupling résumé parsing and chatbot behavior to one provider                  |
| TDR-004 | Use synthetic data until production governance is approved                          | Accepted | Prevents unapproved processing of candidate and employee information                 |
| TDR-005 | Use a project-local Salesforce CLI for the current workstation                      | Accepted | The global CLI is absent and local installation is reproducible                      |
| TDR-006 | Use the existing `TalentDev` Developer Edition org for prototype development        | Accepted | The org is connected; no Dev Hub is available, so direct metadata deployment is used |
| TDR-007 | Runtime AI provider                                                                 | Pending  | Requires provider, model, region, quota, and data-use evaluation                     |
