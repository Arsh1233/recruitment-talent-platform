# Recruitment and Talent Management Platform

## Phase 1 — Functional Process Specification

| Document field    | Value                                                                                                  |
| ----------------- | ------------------------------------------------------------------------------------------------------ |
| Document purpose  | Define and freeze the business processes before solution design or development                         |
| Business context  | IT company                                                                                             |
| Platform          | Salesforce with an external candidate portal and an internal Lightning application                     |
| Delivery approach | Phase-based; no deadline assumptions                                                                   |
| Status            | Phase 1 complete — approved baseline for academic prototype design                                     |
| Version           | 1.1                                                                                                    |
| Owner             | Project team                                                                                           |
| Approvers         | Project team for academic prototype; named organizational owners remain required before production use |

> **Phase boundary:** This document defines business behaviour only. Phase 1 does not authorize the creation of Salesforce objects, fields, Flows, Apex, Lightning Web Components, integrations, or AI prompts. Technical design begins only after this specification is internally consistent and signed off.

---

## 1. Purpose and completion criteria

Phase 1 establishes a single, testable definition of how recruitment and talent management will operate. For every process, this specification identifies:

- the initiating event and responsible actors;
- required information and preconditions;
- the normal flow and permitted status transitions;
- validations, approvals, exceptions, and manual fallbacks;
- notifications and audit evidence;
- access restrictions and AI boundaries; and
- the output passed to the next process.

For the academic prototype, Phase 1 is complete when:

1. all **Must** requirements are accepted or explicitly deferred;
2. every unresolved production decision in Section 21 has a safe prototype posture and a named owner role;
3. the project team accepts the flows, rules, statuses, and exceptions as the implementation baseline;
4. access, retention, consent, and AI rules use the restrictive interim posture defined in this document;
5. acceptance scenarios are approved as the baseline for later testing; and
6. the academic-prototype authorization in Section 23 is recorded.

Named business, legal, privacy, and security approval is still mandatory before using the solution with real candidates, employees, production credentials, or production personal data.

## 2. Guiding principles

1. **Human accountability:** AI and scoring assist people; they do not make final hiring, rejection, performance, or succession decisions.
2. **Explainability:** Recommendations and scores must show the factors and data used.
3. **Least privilege:** A user sees only the information needed for their role and assigned records.
4. **Candidate transparency:** Candidates receive clear statuses and safe error messages, but not confidential assessments.
5. **Verified evidence:** AI-extracted résumé data affects matching only after candidate verification.
6. **Auditability:** Material decisions, overrides, approvals, and status changes retain actor, time, reason, and prior value.
7. **Controlled reference data:** Shared catalogues are reused across recruitment and talent processes.
8. **Recoverability:** Integration or AI failure must not prevent an authorized user from completing the process manually.
9. **Privacy by design:** Only necessary data is collected, shared, retained, and sent to external services.
10. **Configuration before customization:** Undecided policies remain configurable until formally approved.

---

## 3. Scope

### 3.1 In scope

1. Job requisition and approval
2. Job-opening publication
3. Candidate registration and profile management
4. Candidate application and withdrawal
5. Résumé upload, AI parsing, correction, and verification
6. Explainable candidate matching
7. Recruiter screening and talent-pool handling
8. Interview scheduling, scorecards, and evaluation
9. Hiring decision
10. Offer approval, issue, and candidate response
11. Employee conversion and onboarding
12. Employee skills and certifications
13. Performance management
14. Development plans
15. Succession planning
16. Candidate and employee chatbots
17. Reports, dashboards, notifications, escalations, and audit history

### 3.2 Out of scope

- Payroll calculation or salary payment
- Attendance, leave, and expense management
- Biometric systems
- Full learning-management delivery
- Video-interview analysis, emotion recognition, or personality prediction
- Automated background verification
- Automatic rejection based only on AI or a match score
- Employee termination management

### 3.3 Mandatory solution capabilities for later phases

- Apex
- Lightning Web Components
- External integrations
- AI capabilities
- Salesforce CLI development in Antigravity

These capabilities are constraints for solution design, not permission to build during Phase 1.

### 3.4 Primary acceptance journey

```text
Hiring manager creates requisition
→ HR approves requisition
→ Recruiter publishes vacancy
→ Candidate registers and uploads résumé
→ AI extracts data
→ Candidate corrects and verifies extracted data
→ Candidate submits application
→ System calculates an explainable match score
→ Recruiter screens candidate
→ Interviews are scheduled and evaluated
→ Hiring decision is recorded
→ Offer is approved and issued
→ Candidate accepts offer
→ Employee and onboarding records are created
→ Employee skills are maintained
→ Performance review is completed
→ Employee is evaluated for a critical position
→ Succession nomination is approved
```

---

## 4. Actors and responsibilities

| Actor                | Core responsibilities                                                                                                                                                                    | Explicit restrictions                                                                                          |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Candidate            | Register; maintain own profile; upload and verify résumé data; browse jobs; apply/withdraw; view public status; manage interviews and offers; complete onboarding; use candidate chatbot | Cannot view other candidates, internal comments, score configuration, employee performance, or succession data |
| Hiring manager       | Create requisitions; define requirements; review assigned applicants; participate in decisions; assess direct reports; nominate successors                                               | Cannot approve their own exceptional request alone or access unrelated employees/candidates                    |
| HR approver          | Approve/return/reject requisitions; review ranges; approve exceptional offers; oversee compliance and employee processes                                                                 | Must provide reasons for returns/rejections; access is limited to authorized business scope                    |
| Recruiter            | Manage assigned openings; screen applications; view match explanations; coordinate interviews; initiate decisions/offers/onboarding                                                      | Cannot use protected characteristics or allow a score to make the decision                                     |
| Interviewer          | View assigned interview context; attend; submit own scorecard and recommendation                                                                                                         | Cannot see other scores before submitting; cannot view unrelated candidate data                                |
| Employee             | Maintain own talent profile; self-assess; view goals/final reviews/development actions; use employee chatbot                                                                             | Cannot edit manager ratings or see confidential succession information unless policy explicitly allows it      |
| Reporting manager    | Set goals; assess performance; validate skills; create development actions; nominate successors                                                                                          | Restricted to their reporting structure and delegated cases                                                    |
| Succession committee | Review critical roles and nominations; compare readiness; approve/reject decisions                                                                                                       | Cannot rely on system recommendation alone; conflicts of interest must be disclosed                            |
| System administrator | Manage configuration, access, catalogues, integration monitoring, and failed-process recovery                                                                                            | Not a normal business approver; elevated access must be logged and periodically reviewed                       |

### 4.1 High-level RACI

Legend: **R** Responsible, **A** Accountable, **C** Consulted, **I** Informed.

| Process                       | Candidate/Employee      | Hiring/Reporting Manager | Recruiter | HR          | Interviewer/Committee | Admin |
| ----------------------------- | ----------------------- | ------------------------ | --------- | ----------- | --------------------- | ----- |
| Requisition                   | I                       | R                        | C         | A           | —                     | I     |
| Job opening                   | I                       | C                        | R/A       | C           | —                     | I     |
| Candidate profile/application | R/A                     | I                        | C         | I           | —                     | I     |
| Résumé parsing verification   | R/A                     | —                        | C         | I           | —                     | I     |
| Matching and screening        | I                       | C                        | R/A       | C           | —                     | I     |
| Interviews                    | C                       | C                        | R/A       | I           | R                     | I     |
| Hiring decision               | I                       | A                        | R         | C           | C                     | I     |
| Offer                         | R for response          | C                        | R         | A           | —                     | I     |
| Onboarding                    | R for assigned tasks    | R for manager tasks      | C         | A           | —                     | I     |
| Skills/certifications         | R                       | A for validation         | —         | C           | —                     | I     |
| Performance/development       | R                       | A/R                      | —         | A for cycle | C if calibration      | I     |
| Succession                    | I unless policy permits | R                        | —         | A           | A/R committee         | I     |

---

## 5. Shared reference information

### 5.1 Controlled organizational values

- Departments and teams
- Office locations
- Work modes: On-site, Hybrid, Remote
- Employment types: Full-time, Part-time, Contract, Internship
- Job levels: Intern, Junior, Mid-level, Senior, Lead, Manager
- Priority: Low, Normal, High, Critical

Business owners must control additions, inactivation, and effective dates. Historical records retain the value that applied when the transaction occurred.

### 5.2 Skill catalogue

Each skill has a name, category, description, active state, related technologies, and optional normalized name. Suggested categories include programming language, framework, cloud, database, DevOps, testing, security, business analysis, project management, communication, and leadership.

Proficiency scale:

| Level | Label     | Meaning                                     |
| ----: | --------- | ------------------------------------------- |
|     1 | Awareness | Recognizes concepts and terminology         |
|     2 | Beginner  | Performs basic work with guidance           |
|     3 | Working   | Works independently in common situations    |
|     4 | Advanced  | Handles complex work and guides others      |
|     5 | Expert    | Defines standards and solves novel problems |

The same catalogue is used for jobs, candidates, employees, development, and succession.

### 5.3 Standard reason catalogue

- Missing mandatory qualification
- Insufficient relevant experience
- Missing mandatory skills
- Required location or work authorization unavailable
- Candidate withdrew
- Interview result
- Position closed, cancelled, or on hold
- Duplicate application
- Offer declined or expired
- No response
- Other — explanatory comment required

### 5.4 Notification channels

- Email
- Salesforce in-app notification
- Portal notification
- Calendar invitation only if Decision DEC-008 approves calendar integration

### 5.5 Status-control convention

- Only transitions listed in this document are allowed.
- A status change records actor, timestamp, previous/new status, and reason where required.
- Terminal records remain reportable and cannot silently return to an active state.
- Reopening requires an authorized role, a reason, and an audit entry.
- Candidate-facing labels may be simpler than internal statuses but must never be misleading.

---

## 6. End-to-end process specifications

### 6.1 Job requisition and approval

**Trigger:** A department needs a new, replacement, project, competency, intern, or temporary position.

**Preconditions:** Authorized hiring manager; valid department and HR contact; at least one opening; future target date; responsibilities and minimum requirements defined.

**Required information:** Title, department, hiring manager, location, work mode, employment type, openings, job level, justification, target date, experience range, education, required/optional skills, salary range, new/replacement indicator, and priority.

**Status flow:**

```text
Draft → Submitted → Under Review → Approved → Converted to Job Opening
                     ├→ Changes Requested → Draft
                     └→ Rejected
Draft/Approved → Cancelled
```

**Normal flow:**

1. Hiring manager prepares a draft and selects controlled requirements.
2. The system validates completeness and cross-field rules.
3. Manager submits; the approved version under review becomes read-only to the requester.
4. HR reviews justification, openings, requirements, and compensation.
5. HR approves, requests changes, or rejects with comments where required.
6. Returned requests are edited and resubmitted through the same approval route.
7. Approval records decision, approver, time, comments, and approved values.
8. Recruiter may create a job opening from the approved version.

**Rules:** Salary and experience minimums cannot exceed maximums; openings must be positive; target date cannot be past; a technical role requires at least one mandatory skill; rejection/change request requires comments; material changes after approval require reapproval; duplicate active requisitions warn but do not auto-reject.

**Output:** Approved, versioned requisition ready for conversion.

### 6.2 Job-opening publication

**Status flow:** `Draft → Published ↔ On Hold → Closed`; Draft or Published may become Cancelled.

1. Recruiter creates a draft from an approved requisition.
2. Approved values are copied; recruiter adds public description, deadline, reference, contact, and screening questions.
3. Recruiter previews and publishes.
4. Portal displays only Published openings within their publication window.
5. Applications stop when the deadline passes, positions are filled, or the opening is held/closed/cancelled.
6. Closed records remain available internally for reporting.

**Rules:** Only approved requisitions can create openings; deadline cannot precede publication; filled positions cannot exceed approved openings; changing salary, mandatory skills, experience, location, employment type, or opening count after publication requires controlled review and may require reapproval.

**Output:** Public vacancy connected to an approved requisition version.

### 6.3 Candidate registration and profile

1. Candidate supplies name, unique email, and password.
2. System validates format, checks existing accounts, and completes email verification.
3. Candidate accepts versioned privacy, terms, and résumé-processing notices.
4. System creates an external user and private candidate profile.
5. Candidate maintains contact, location/preferences, experience, education, employment, skills, certifications, links, résumé, availability, and consent preferences.

**Rules:** Candidate accesses only their own data; protected characteristics are not collected for matching; consent version/time is retained; profile updates do not alter submitted application snapshots; suspected duplicates are flagged for authorized review rather than automatically merged.

**Exceptions:** Existing email routes to sign-in/reset; expired verification can be resent; consent withdrawal stops future AI processing and triggers the approved retention process.

### 6.4 Résumé upload, parsing, and verification

**Status flow:** `Queued → Processing → Needs Verification → Verified`; failure: `Processing → Failed → Retry or Manual Entry`.

1. Candidate uploads a supported, size-compliant file.
2. Original file is preserved and a parsing request is logged.
3. Only permitted content is sent to the configured AI service.
4. Returned structured data is schema-validated and stored separately from the original response.
5. Candidate reviews and corrects contact, education, experience, skills, and certifications.
6. Candidate explicitly confirms; verified values become eligible for matching.

**Rules:** AI output is never automatically verified; it cannot submit or reject; candidate corrections do not erase the original response; confidence prompts review only; protected characteristics are ignored; manual entry is always available.

**Failure handling:** Unsupported/password-protected/empty/poor-scan files, timeouts, authentication errors, rate limits, invalid responses, duplicates, or contradictory dates receive a safe message, internal diagnostic record, retry eligibility, and manual fallback.

### 6.5 Application and withdrawal

**Internal status flow:**

```text
Draft → Submitted → Under Screening → Shortlisted → Interview → Selected → Offer → Hired
Draft/Submitted → Withdrawn
Submitted onward → Rejected or Talent Pool
```

1. Candidate selects Apply on an eligible Published opening.
2. System verifies authentication, deadline, consent, and absence of an active duplicate.
3. Candidate reviews profile/résumé data and completes screening and job-specific questions.
4. System validates completeness and shows a final summary.
5. Candidate confirms submission; system records time, source, consent, and an immutable application snapshot.
6. Candidate receives a reference; assigned recruiter is notified.
7. Candidate may withdraw eligible applications after confirmation.

**Rules:** Multiple jobs are allowed, but only one active application per candidate/opening; drafts do not enter matching; internal ratings/comments remain hidden; withdrawal after offer acceptance escalates to HR; candidate-facing statuses use plain language.

### 6.6 Matching and recruiter screening

**Permitted inputs:** Required/optional skills, relevant experience, education eligibility, relevant certifications, and—only after completion—interview results.

**Prohibited inputs:** Age, gender, religion, marital status, photograph, disability, nationality except lawful work-authorization needs, and unrelated personal data.

**Provisional configurable weights:**

| Factor              | Default | Policy                                                     |
| ------------------- | ------: | ---------------------------------------------------------- |
| Mandatory skills    |     35% | Configurable and versioned                                 |
| Optional skills     |     15% | Configurable and versioned                                 |
| Relevant experience |     20% | Configurable and versioned                                 |
| Education           |     10% | Configurable and versioned                                 |
| Certifications      |      5% | Configurable and versioned                                 |
| Interview result    |     15% | Excluded and remaining factors normalized before interview |

1. Submission triggers retrieval of the approved job version and verified candidate snapshot.
2. Engine creates criterion-level results and a normalized total.
3. Recruiter sees matched/missing criteria, experience comparison, score, data timestamp, and model/rule version.
4. Recruiter performs human screening and chooses Reject, Talent Pool, Request Information, or Shortlist.
5. Candidate receives the approved communication.

**Rules:** Weights total 100%; no automatic rejection; recruiter override requires reason; recalculation preserves prior results; a missing value is not silently treated as evidence of failure unless the approved rule says so.

### 6.7 Interview management

**Status flow:** `Planned → Scheduled → Candidate Confirmed → Completed → Evaluation Submitted`; Scheduled may become Rescheduled, Cancelled, Candidate No-Show, or Interviewer No-Show.

1. Recruiter creates a round with type, time, timezone, mode/location, interviewers, and scorecard template.
2. System checks conflicts and sends the schedule.
3. Candidate confirms or requests a new time; rescheduling retains history.
4. Interviewers receive minimum necessary candidate context.
5. Each attending interviewer submits an independent scorecard.
6. Submitted evaluations lock; corrections require a controlled reopen.
7. Once mandatory evaluations exist, the system calculates the consolidated result.
8. Recruiter and hiring manager decide additional round, hold, reject, or select.

**Scorecard areas:** Technical knowledge, problem solving, relevant experience, communication, role suitability, cultural contribution, and overall recommendation. Vague personality scoring is prohibited.

**Rules:** No past scheduling; at least one interviewer; only attendees evaluate; peers' scores remain hidden until own submission; rejection uses an approved reason; all comments remain internal.

### 6.8 Hiring decision and offer

**Hiring decision:** Recruiter presents screening/interview evidence; hiring manager records recommendation; authorized recruiter/HR records final selection or rejection with reason.

**Offer status flow:**

```text
Draft → Pending Approval → Approved → Sent → Accepted
          ├→ Changes Requested
          └→ Rejected
Sent → Revision Requested / Declined / Expired / Withdrawn
```

1. Selected application creates an offer draft.
2. Recruiter enters position, salary/currency, joining date, work location/mode, and expiry.
3. System compares terms with approved requisition values.
4. Approved routing is applied; out-of-range salary requires exceptional approval.
5. Approved offer is issued through the portal and, if approved later, as a generated document.
6. Candidate explicitly accepts, declines, or requests clarification/revision.
7. Response, terms version, actor, and timestamp are recorded.
8. Acceptance starts onboarding.

**Rules:** One active offer per application; offer requires Selected state; joining date cannot precede acceptance; expiry follows sent date; candidate cannot edit offer terms; expired offer requires controlled reissue/reactivation.

### 6.9 Onboarding

**Status flow:** `Not Started → In Progress → Completed`; In Progress may become Blocked; active onboarding may be Cancelled with reason.

1. Accepted offer creates a pre-joining employee and onboarding plan.
2. Template tasks are assigned to the new employee, HR, IT, and manager with due dates.
3. New employee supplies approved documents and acknowledgements.
4. HR verifies; IT records account/equipment readiness; manager completes team preparation.
5. Overdue tasks notify and escalate according to the catalogue.
6. HR completes onboarding only after mandatory tasks pass.
7. Employee becomes Active on the approved effective date.

**Example tasks:** Identity and qualification evidence, policy acknowledgement, payroll-information collection (not payroll processing), equipment, corporate account, orientation, manager introduction, and probation-review scheduling.

### 6.10 Employee skills and certifications

- Verified candidate skills may initialize the employee profile, clearly marked by source.
- Employee can add/update self-declared proficiency, experience, and last-used date.
- Manager can confirm values; confirmed values require controlled changes and history.
- Certifications record issuer, dates, proof, verification, and active/expired state.
- Reminders occur before expiry; expired credentials remain historical but do not satisfy active eligibility.
- Comparisons may be made with current roles, internal vacancies, development targets, and critical positions.

### 6.11 Performance management

**Status flow:** `Draft → Goal Setting → Self-Assessment → Manager Review → Finalized → Acknowledged`; optional `Manager Review → Calibration → Finalized` depends on DEC-010.

1. HR creates a cycle and enrolls eligible employees.
2. Employee and manager define measurable goals; authorized party confirms them.
3. Employee updates progress and completes self-assessment during the open window.
4. Manager evaluates goals and approved competencies.
5. Calibration occurs only if enabled.
6. Manager/HR finalizes; employee can view and acknowledge.
7. Identified gaps may create development actions.

**Rules:** Required sections must be complete; employee cannot edit manager ratings; ratings are hidden until finalized; reopening requires authority/reason; historical values are retained; performance may inform but never solely determine succession.

### 6.12 Development planning

1. A skill, performance, career, or succession gap is identified.
2. Employee and manager create an action with target competency, activity, owner, dates, success measure, and evidence.
3. Employee records progress; manager reviews it.
4. Action becomes Completed, Extended, Cancelled, or Replaced with reason.
5. Relevant skill or readiness is reassessed; completion alone does not automatically change proficiency.

The platform tracks development activity but does not deliver full training courses.

### 6.13 Succession planning

**Status flow:** `Proposed → Under Review → Approved`; Under Review may become Rejected; Approved may become Removed or Reassessment Required.

**Readiness:** Ready now, Ready within one year, Ready within two years, Development required.

1. HR/management defines a critical position and its requirements.
2. Reporting manager nominates an eligible employee and states rationale.
3. System produces an explainable recommendation from approved job-relevant evidence.
4. Committee reviews skills, experience, recent performance, certifications, development, and manager assessment.
5. Committee approves, rejects, or requests development.
6. Decision, readiness, rationale, conflicts, and review date are recorded.
7. Reassessment occurs on schedule or after material change.

**Rules:** Highly restricted access; recommendation is not approval; manager cannot approve their own nomination alone; multiple successors/positions are allowed; history remains auditable; employee visibility is governed by DEC-009.

### 6.14 Chatbots

**Public candidate intents:** Search jobs, explain eligibility/process/documents, approved FAQs, and links to registration/login. No personal data.

**Authenticated candidate intents:** Own applications and stages, interview schedule, missing profile data, withdrawal guidance, recruiter-contact route.

**Employee intents:** Own skills, expiring certifications, goals, development actions, internal vacancies, role skill gaps, and approved HR-policy answers.

**Controlled response flow:** Authenticate where required → identify approved intent → enforce permission in Salesforce → retrieve minimum data → sanitize context → call AI → validate response → display → log outcome → refuse/escalate unsupported or sensitive requests.

**Rules:** AI cannot independently query unrestricted data, promise selection, change a decision, expose comments/configuration, or pretend unavailable information exists. Sensitive actions move to a controlled screen or human. Every external call has timeout, safe failure, and correlation logging.

---

## 7. Approval and control policies

| Control                     | Minimum rule                                                | Decision dependency             |
| --------------------------- | ----------------------------------------------------------- | ------------------------------- |
| Requisition approval        | At least one HR approval; requester cannot be sole approver | DEC-003 sets levels/thresholds  |
| Material requisition change | Reopen approval before republishing                         | Material fields listed in 6.2   |
| Exceptional offer           | Additional approval for salary/terms outside approved range | DEC-003 and compensation policy |
| Evaluation correction       | Authorized reopen with reason; retain original submission   | None                            |
| Final review reopen         | HR-authorized, reason required, full history                | DEC-010 if calibration applies  |
| Succession approval         | Committee decision; nominating manager cannot approve alone | None                            |
| AI configuration change     | Authorized admin plus version/effective date                | DEC-002                         |
| Matching weight change      | Authorized owner; weights total 100%; preserve versions     | Business owner to assign        |

---

## 8. Data-access matrix

Legend: **C** create, **R** read, **U** update, **D** controlled deactivate/cancel; **Own/Assigned** limits the record population. Blank means no business access.

| Information                  | Candidate                   | Hiring manager    | Recruiter          | HR                 | Interviewer        | Employee                    | Reporting manager  | Committee            | Admin               |
| ---------------------------- | --------------------------- | ----------------- | ------------------ | ------------------ | ------------------ | --------------------------- | ------------------ | -------------------- | ------------------- |
| Candidate profile            | CRU Own                     | R Assigned        | RU Assigned        | R Authorized       | R Limited/Assigned | —                           | —                  | —                    | Config/support only |
| Application                  | CRU Own, limited            | R Assigned        | CRU Assigned       | R Authorized       | R Limited          | —                           | —                  | —                    | Config/support only |
| Match explanation            | Candidate-safe summary only | R Assigned        | R Assigned         | R Authorized       | —                  | —                           | —                  | —                    | Config/support only |
| Interview schedule           | R Own                       | R Assigned        | CRU Assigned       | R                  | R Assigned         | —                           | —                  | —                    | Config/support only |
| Interview scorecard          | —                           | R after release   | R after submission | R Authorized       | CRU Own            | —                           | —                  | —                    | Config/support only |
| Offer                        | R/respond Own               | R Assigned        | CRU Assigned       | CRU Authorized     | —                  | —                           | —                  | —                    | Config/support only |
| Onboarding                   | RU Own tasks                | RU Assigned tasks | R                  | CRU                | —                  | RU Own tasks                | RU Assigned tasks  | —                    | Config/support only |
| Employee skill/certification | —                           | —                 | —                  | R Authorized       | —                  | CRU Own                     | RU Direct reports  | R if succession case | Config/support only |
| Performance review           | —                           | —                 | —                  | CRU Authorized     | —                  | RU Own sections/R finalized | CRU Direct reports | R authorized summary | Config/support only |
| Succession nomination        | —                           | —                 | —                  | CRU Restricted     | —                  | Per DEC-009                 | CR Assigned        | CRU Restricted       | Config/support only |
| Configuration/audit          | —                           | —                 | —                  | R authorized audit | —                  | —                           | —                  | —                    | CRU; access logged  |

**Enforcement requirement:** UI hiding is insufficient. Record, field, file, and server-side access must all enforce the same policy in later technical design.

---

## 9. AI governance

1. The approved provider, model, region, contractual terms, and data-use settings must be documented before integration.
2. Only the minimum sanitized content needed for an approved purpose may leave Salesforce.
3. Résumés and personal context may not be used to train a provider model unless expressly approved by Legal/Privacy and the user consent covers it.
4. Protected characteristics and inferred sensitive traits are excluded from matching, ranking, and succession recommendations.
5. AI responses must conform to a validated structure before business use.
6. Prompt, model, rule, and configuration versions must be traceable for material outputs.
7. Candidate verification is required for parsed résumé facts.
8. Human review is required for screening, hiring, offers, performance, and succession decisions.
9. Users must be able to continue through manual entry or human support when AI fails.
10. Logs should retain status, latency, provider, version, correlation ID, and safe diagnostics—not unnecessary full résumés or sensitive prompts.
11. Unsafe, irrelevant, or unsupported chatbot content is refused or routed to a human.
12. AI access is subject to the same Salesforce permissions as the requesting user; the model never receives unrestricted query capability.

---

## 10. Notification and escalation catalogue

| ID      | Trigger                                    | Recipient                                   | Channel                                   | Timing / escalation                                           | Cancel condition                     |
| ------- | ------------------------------------------ | ------------------------------------------- | ----------------------------------------- | ------------------------------------------------------------- | ------------------------------------ |
| NOT-001 | Requisition submitted                      | HR approver, requester                      | In-app/email                              | Immediate; reminder per policy                                | Decision recorded                    |
| NOT-002 | Requisition approved/returned/rejected     | Requester, assigned recruiter when approved | In-app/email                              | Immediate                                                     | Delivered                            |
| NOT-003 | Job published/held/closed                  | Recruiter, hiring manager                   | In-app                                    | Immediate                                                     | Delivered                            |
| NOT-004 | Application submitted                      | Candidate, assigned recruiter               | Portal/email/in-app                       | Immediate                                                     | Delivered                            |
| NOT-005 | Information requested                      | Candidate                                   | Portal/email                              | Immediate; reminder if due date set                           | Response or case closed              |
| NOT-006 | Shortlisted or rejected                    | Candidate                                   | Portal/email                              | After authorized decision                                     | Delivered                            |
| NOT-007 | Interview scheduled/rescheduled/cancelled  | Candidate, interviewers, recruiter          | Portal/email/in-app; calendar if approved | Immediate and reminder before event                           | Event completed/cancelled            |
| NOT-008 | Evaluation overdue                         | Interviewer, then recruiter                 | In-app/email                              | At due time; escalate per policy                              | Evaluation submitted/round cancelled |
| NOT-009 | Offer sent                                 | Candidate, recruiter                        | Portal/email                              | Immediate                                                     | Response/expiry/withdrawal           |
| NOT-010 | Offer nearing expiry                       | Candidate, recruiter                        | Portal/email/in-app                       | Configurable lead time                                        | Response/expiry/withdrawal           |
| NOT-011 | Offer accepted/declined/revision requested | Recruiter, HR, hiring manager               | In-app/email                              | Immediate                                                     | Delivered                            |
| NOT-012 | Onboarding task assigned/overdue           | Task owner; escalation owner when overdue   | Portal/in-app/email                       | On assignment; repeat per policy                              | Task completed/cancelled             |
| NOT-013 | Performance action required                | Employee/manager/HR as applicable           | In-app/email                              | At stage opening; reminders                                   | Action completed/stage closed        |
| NOT-014 | Certification nearing expiry               | Employee, manager                           | In-app/email                              | Configurable intervals                                        | Renewed/inactivated                  |
| NOT-015 | Succession review due                      | Committee/HR                                | In-app/email                              | Before review date; escalate to owner                         | Review completed                     |
| NOT-016 | AI/integration failure                     | User safe message; support/admin alert      | UI plus in-app/email for support          | Immediate for terminal failures; aggregate transient failures | Retry succeeds/manual closure        |

**Content rule:** Email subjects and push previews must not reveal confidential decisions, compensation, performance ratings, or succession information.

---

## 11. Exception catalogue and handling contract

Every exception implementation must define: user message, internal code/status, retry eligibility, responsible owner, notification, audit evidence, and manual fallback.

| ID      | Exception                                      | User-safe outcome                                                          | Owner / fallback                      |
| ------- | ---------------------------------------------- | -------------------------------------------------------------------------- | ------------------------------------- |
| EXC-001 | Duplicate account                              | Direct user to sign-in or reset; disclose no account details beyond policy | Candidate support                     |
| EXC-002 | Duplicate application                          | Prevent second active submission; link to existing application             | Candidate/recruiter review            |
| EXC-003 | Missing/withdrawn consent                      | Stop affected processing and explain required action                       | Privacy/HR retention workflow         |
| EXC-004 | Incomplete profile/application                 | Identify missing fields without losing draft                               | Candidate completes manually          |
| EXC-005 | Unsupported or unreadable résumé               | Explain permitted format/size; preserve no invalid business data           | Retry or manual entry                 |
| EXC-006 | Deadline passed                                | Block submission and show opening status                                   | Recruiter handles exceptional inquiry |
| EXC-007 | Candidate withdrawal/no-show                   | Confirm status and notify responsible recruiter                            | Recruiter follow-up per policy        |
| EXC-008 | Requisition returned/rejected                  | Show reason to requester and permitted next action                         | Edit/resubmit or close                |
| EXC-009 | Opening held/cancelled                         | Stop new applications; preserve current records                            | Recruiter/HR disposition plan         |
| EXC-010 | Interviewer unavailable/reschedule             | Retain old schedule and coordinate replacement/time                        | Recruiter                             |
| EXC-011 | Missing evaluation                             | Prevent round completion and escalate                                      | Recruiter may replace/escalate        |
| EXC-012 | Offer negotiation/expiry                       | Preserve version/history; route for decision/reissue                       | Recruiter/HR                          |
| EXC-013 | AI unavailable/auth/rate limit/timeout         | Safe temporary message; no false result                                    | Retry with limits, then manual path   |
| EXC-014 | Invalid/unsafe AI response                     | Do not display or use unvalidated output                                   | Log safely; retry/manual review       |
| EXC-015 | Chatbot intent unknown/sensitive               | State limitation and offer approved navigation/human contact               | Support/recruiter/HR                  |
| EXC-016 | Manager changes during review                  | Freeze/reassign through HR; retain contributions                           | HR                                    |
| EXC-017 | Employee inactive                              | Stop new active actions; preserve history                                  | HR closes/reassigns                   |
| EXC-018 | Certification expired                          | Mark inactive for eligibility; notify owner                                | Employee renews; verifier rechecks    |
| EXC-019 | Critical position removed/successor ineligible | Trigger reassessment; preserve decision history                            | HR/committee                          |
| EXC-020 | Performance review reopened                    | Record authority/reason and new version                                    | HR-controlled reopen                  |

---

## 12. Audit and history requirements

The system must retain, as applicable:

- record creator, updater, and timestamps;
- previous/new business status and reason;
- approval assignment, decision, actor, date, comments, and delegated authority;
- versioned requisition/job requirements and offer terms;
- consent type, notice version, acceptance/withdrawal time, and source;
- original résumé file, parsing status, provider/model, original structured response, candidate corrections, and verification;
- matching configuration/version, factor results, total score, recalculations, and override reason;
- interview schedule history, attendance, original scorecard, and controlled corrections;
- hiring/rejection reasons and communications;
- onboarding task ownership/status history;
- skill/certification evidence and verification history;
- performance finalization/reopening and acknowledgement;
- succession recommendation, committee decision, conflicts, and reassessment;
- integration correlation ID, outcome, retry count, and safe diagnostic information.

Audit records must follow the approved retention schedule and must not unnecessarily duplicate sensitive files or message content.

---

## 13. Reporting requirements

Minimum reporting capability:

- requisitions by status, department, owner, age, and approval cycle time;
- openings, applications, conversion stages, time in stage, and source;
- screening and interview completion/overdue workload;
- offers by status, exception approval, acceptance rate, and expiry;
- onboarding task progress and blockers;
- skills coverage, gaps, verification, and certification expiry;
- performance-cycle completion and outstanding actions;
- development-action progress;
- critical roles, succession coverage, readiness, and reassessment due;
- AI/integration volume, success/failure, retry, and manual fallback rate;
- access/audit exception monitoring.

Reports must honor the same record and field access as transactional screens. Aggregates must not reveal confidential data to unauthorized viewers.

---

## 14. Requirements traceability matrix

Priority uses **Must**, **Should**, or **Could**. All rows are Phase 1 functional requirements unless marked as a policy decision.

| ID      | Requirement                                                                | Actor/process                | Priority | Acceptance reference |
| ------- | -------------------------------------------------------------------------- | ---------------------------- | -------- | -------------------- |
| REQ-001 | Authorized manager can create and submit a complete requisition            | Hiring manager / Requisition | Must     | AC-01                |
| REQ-002 | System validates salary, experience, openings, dates, and mandatory skills | Requisition                  | Must     | AC-01                |
| REQ-003 | HR can approve, return, or reject with required comments                   | HR / Requisition             | Must     | AC-01                |
| REQ-004 | Material post-approval changes require renewed approval                    | Requisition                  | Must     | AC-01                |
| REQ-005 | Recruiter can create an opening only from an approved requisition          | Opening                      | Must     | AC-01                |
| REQ-006 | Only eligible Published openings accept applications                       | Opening                      | Must     | AC-01, AC-02         |
| REQ-007 | Candidate can register, verify email, and accept versioned notices         | Candidate profile            | Must     | AC-01                |
| REQ-008 | Candidate can access only their own records                                | Security                     | Must     | AC-07                |
| REQ-009 | Submitted applications preserve an immutable evaluation snapshot           | Application                  | Must     | AC-01                |
| REQ-010 | Candidate can upload a supported résumé and retain the original            | Résumé parsing               | Must     | AC-01, AC-03         |
| REQ-011 | AI parsing stores structured draft data separately from verified data      | Résumé parsing               | Must     | AC-03                |
| REQ-012 | Candidate must review/correct/verify AI-extracted data                     | Candidate / Parsing          | Must     | AC-01                |
| REQ-013 | AI failure provides retry and manual-entry fallback                        | Parsing                      | Must     | AC-03                |
| REQ-014 | Candidate can submit one active application per opening                    | Application                  | Must     | AC-01, AC-02         |
| REQ-015 | Candidate can withdraw an eligible application with confirmation           | Application                  | Must     | AC-08                |
| REQ-016 | Candidates see understandable public statuses, not internal comments       | Application                  | Must     | AC-02, AC-07         |
| REQ-017 | Matching uses only approved job-relevant data                              | Matching                     | Must     | AC-01, AC-02         |
| REQ-018 | Match results show criterion explanations and configuration version        | Recruiter / Matching         | Must     | AC-01                |
| REQ-019 | Match score cannot automatically reject a candidate                        | Matching                     | Must     | AC-02                |
| REQ-020 | Recruiter override requires an auditable reason                            | Recruiter / Matching         | Must     | AC-02                |
| REQ-021 | Recalculation preserves previous match results                             | Matching                     | Must     | AC-09                |
| REQ-022 | Recruiter can shortlist, reject, pool, or request information              | Screening                    | Must     | AC-01, AC-02         |
| REQ-023 | Recruiter can schedule/reschedule/cancel interview rounds                  | Interview                    | Must     | AC-04                |
| REQ-024 | Interview scheduling detects conflicts and records timezone/mode           | Interview                    | Should   | AC-04                |
| REQ-025 | Interviewer sees only assigned, minimum necessary information              | Interview / Security         | Must     | AC-07                |
| REQ-026 | Interviewer submits an independent locked scorecard                        | Interviewer                  | Must     | AC-01                |
| REQ-027 | Other interviewers' scores remain hidden until own submission              | Interview                    | Must     | AC-10                |
| REQ-028 | Required evaluations gate completion of a round                            | Interview                    | Must     | AC-01                |
| REQ-029 | Authorized users record a human hiring decision with reason                | Hiring decision              | Must     | AC-01, AC-02         |
| REQ-030 | Offer can be created only for a selected application                       | Offer                        | Must     | AC-01                |
| REQ-031 | Exceptional terms invoke additional approval                               | Offer                        | Must     | AC-05                |
| REQ-032 | Candidate can accept, decline, or request clarification/revision           | Offer                        | Must     | AC-01, AC-05         |
| REQ-033 | Offer response is explicit, version-linked, and timestamped                | Offer                        | Must     | AC-01                |
| REQ-034 | Accepted offer creates pre-joining employee and onboarding plan            | Onboarding                   | Must     | AC-01                |
| REQ-035 | Onboarding creates role-owned tasks with due dates                         | Onboarding                   | Must     | AC-01                |
| REQ-036 | Mandatory tasks gate onboarding completion                                 | Onboarding                   | Must     | AC-11                |
| REQ-037 | Verified candidate skills can initialize employee skills with source       | Skills                       | Should   | AC-01                |
| REQ-038 | Employee can maintain self-declared skills and certifications              | Employee talent              | Must     | AC-12                |
| REQ-039 | Manager/HR can verify skills/certifications with history                   | Employee talent              | Must     | AC-12                |
| REQ-040 | Expired certification does not satisfy active eligibility                  | Certifications               | Must     | AC-12                |
| REQ-041 | HR can create a performance cycle and enroll eligible employees            | Performance                  | Must     | AC-13                |
| REQ-042 | Employee can update goals and complete self-assessment                     | Performance                  | Must     | AC-13                |
| REQ-043 | Manager can assess and finalize when required sections are complete        | Performance                  | Must     | AC-13                |
| REQ-044 | Employee sees finalized review and can acknowledge it                      | Performance                  | Must     | AC-13                |
| REQ-045 | Finalized review reopens only through an audited control                   | Performance                  | Must     | AC-14                |
| REQ-046 | Employee/manager can create and track development actions                  | Development                  | Must     | AC-15                |
| REQ-047 | HR can define a critical position and its requirements                     | Succession                   | Must     | AC-06                |
| REQ-048 | Manager can nominate an eligible employee                                  | Succession                   | Must     | AC-06                |
| REQ-049 | Readiness recommendation is explainable and not self-approving             | Succession                   | Must     | AC-06                |
| REQ-050 | Committee can approve/reject/request development and record rationale      | Succession                   | Must     | AC-06                |
| REQ-051 | Succession data is restricted and historically auditable                   | Security / Succession        | Must     | AC-07                |
| REQ-052 | Public chatbot answers only approved non-personal intents                  | Chatbot                      | Must     | AC-16                |
| REQ-053 | Authenticated chatbot retrieves only the requester's permitted data        | Chatbot / Security           | Must     | AC-07, AC-16         |
| REQ-054 | Chatbot cannot change decisions or expose confidential information         | Chatbot                      | Must     | AC-16                |
| REQ-055 | Unsupported/sensitive intents fail safely or route to a human              | Chatbot                      | Must     | AC-16                |
| REQ-056 | Required business events produce configurable notifications                | All                          | Must     | AC-17                |
| REQ-057 | Confidential details are excluded from subject lines/previews              | Notifications                | Must     | AC-17                |
| REQ-058 | Material decisions and AI/integration outcomes are auditable               | All                          | Must     | AC-18                |
| REQ-059 | Reports enforce transactional access controls                              | Reporting/Security           | Must     | AC-07, AC-19         |
| REQ-060 | Failed AI/integration work supports bounded retry and manual recovery      | Integration                  | Must     | AC-03, AC-20         |

In Phase 2, extend this matrix with solution component, permission set, automation, Apex/LWC, test case, and demonstration step.

---

## 15. Acceptance scenarios

| ID    | Scenario               | Given / When / Then acceptance                                                                                                                                                                                                                                       |
| ----- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AC-01 | Successful hiring      | Given an approved requisition and published opening, when a verified candidate applies, is human-shortlisted, completes interviews, is selected, and accepts an approved offer, then a pre-joining employee and onboarding plan are created with full audit history. |
| AC-02 | Candidate rejection    | Given a submitted application and explainable score, when recruiter review rejects using an approved reason, then the candidate receives the approved message, no AI-only decision occurs, and internal evidence is retained.                                        |
| AC-03 | AI parsing failure     | Given a valid upload, when parsing times out or returns invalid data, then the failure is safely logged, the candidate sees no raw error, and manual entry allows the application to continue.                                                                       |
| AC-04 | Interview rescheduling | Given a scheduled interview, when the candidate requests another time and the recruiter reschedules, then old/new schedules remain in history and all participants receive updated details.                                                                          |
| AC-05 | Exceptional offer      | Given a selected candidate, when salary exceeds the approved range, then standard issue is blocked until additional approval; after approval the candidate can respond to the correct offer version.                                                                 |
| AC-06 | Succession planning    | Given a critical role and eligible nominee, when readiness is calculated and committee-reviewed, then an authorized decision and development needs are recorded without recommendation becoming automatic approval.                                                  |
| AC-07 | Unauthorized access    | Given any user requesting another person's restricted record, when access is evaluated, then it is denied server-side, no data is disclosed, and a security event is logged where policy requires.                                                                   |
| AC-08 | Candidate withdrawal   | Given an eligible active application, when the candidate confirms withdrawal, then status, time, and notification are recorded; an accepted-offer withdrawal escalates to HR.                                                                                        |
| AC-09 | Requirement change     | Given a published role with scored applications, when a material requirement is approved and matching reruns, then both old and new score versions and explanations remain available to authorized users.                                                            |
| AC-10 | Independent scoring    | Given multiple interviewers, when one has not submitted, then they cannot see peers' scores; after their submission and release conditions, consolidated results become available to authorized reviewers.                                                           |
| AC-11 | Blocked onboarding     | Given incomplete mandatory tasks, when HR attempts completion, then completion is blocked and missing tasks are identified; once complete, employee activation proceeds.                                                                                             |
| AC-12 | Certification expiry   | Given a verified certification nearing expiry, when reminder thresholds are reached and expiry passes, then notifications occur and the credential stops satisfying active eligibility while history remains.                                                        |
| AC-13 | Performance cycle      | Given an enrolled employee, when goals, self-assessment, and manager review are completed, then the authorized review can be finalized, viewed, and acknowledged.                                                                                                    |
| AC-14 | Review reopening       | Given a finalized review, when authorized HR reopens it with a reason, then the original is retained and changes are versioned and audited.                                                                                                                          |
| AC-15 | Development action     | Given an identified gap, when employee/manager track an action to completion, then evidence and outcome are recorded and any proficiency/readiness change requires reassessment.                                                                                     |
| AC-16 | Chatbot safety         | Given public, authenticated, unsupported, and sensitive prompts, when chatbot policy runs, then it returns only permitted data, admits limitations, and redirects/refuses safely.                                                                                    |
| AC-17 | Notification privacy   | Given each catalogue event, when a notification is generated, then the right recipient/channel/template is used and confidential details do not appear in subject lines or previews.                                                                                 |
| AC-18 | Audit reconstruction   | Given a completed hiring and talent journey, when an auditor inspects it, then they can reconstruct versions, actors, approvals, decisions, overrides, AI use, and status changes.                                                                                   |
| AC-19 | Reporting security     | Given two users with different scopes, when they open the same report, then each sees only records/fields permitted by their transactional access.                                                                                                                   |
| AC-20 | Integration recovery   | Given a transient and then terminal provider failure, when bounded retries are exhausted, then duplication is prevented, support is notified, and an authorized manual fallback is available.                                                                        |

---

## 16. Non-functional business expectations

These are business-level expectations to quantify during technical design:

- Accessibility: Portal and Lightning experiences should target WCAG 2.1 AA.
- Localization: User-facing text, dates, times, currency, and timezone must be localizable.
- Performance: Interactive actions require agreed response targets; long AI work must show progress and complete asynchronously where appropriate.
- Reliability: Repeated external calls must not create duplicate applications, decisions, offers, employees, or tasks.
- Observability: Authorized support can identify failed step, correlation ID, retry state, and responsible owner without reading unnecessary sensitive content.
- Data quality: Controlled values, duplicate detection, mandatory fields, effective dates, and versioning protect cross-module consistency.
- Security: Authentication, authorization, encryption, file access, session policy, and audit monitoring follow organizational and Salesforce standards.
- Retention: Record/file/log retention and deletion follow DEC-006 and applicable law/policy.

---

## 17. Glossary

| Term                  | Definition                                                                                         |
| --------------------- | -------------------------------------------------------------------------------------------------- |
| Application snapshot  | Immutable copy of candidate/job data used when the application was submitted or evaluated          |
| Candidate             | External person considering or applying for a vacancy                                              |
| Critical position     | Role for which succession coverage is actively managed                                             |
| Explainable score     | Score accompanied by factors, values, weights, version, and reasoned contribution                  |
| Job opening / vacancy | Candidate-facing opportunity created from an approved requisition                                  |
| Material change       | Change to an approved value that may affect budget, eligibility, fairness, or candidate evaluation |
| Requisition           | Internal, approved request to hire one or more people                                              |
| Talent pool           | Consented group of unsuccessful or prospective candidates retained for future roles                |
| Verified résumé data  | AI-extracted or manually entered résumé information explicitly confirmed by the candidate          |
| Readiness             | Committee-approved estimate of when an employee could assume a critical role                       |

---

## 18. Process hand-offs

| From            | Handoff condition              | Data passed                                                   | To                     |
| --------------- | ------------------------------ | ------------------------------------------------------------- | ---------------------- |
| Requisition     | Approved                       | Approved requirements/version, openings, range, owner         | Job opening            |
| Job opening     | Published                      | Public description, questions, deadline, requirements version | Application            |
| Résumé parsing  | Verified                       | Candidate-confirmed structured data and source                | Application/matching   |
| Application     | Submitted                      | Immutable snapshot, answers, consent, job version             | Matching/screening     |
| Screening       | Shortlisted                    | Screening decision and reason                                 | Interview              |
| Interview       | Required evaluations submitted | Scorecards and consolidated result                            | Hiring decision        |
| Hiring decision | Selected                       | Candidate, application, approved role                         | Offer                  |
| Offer           | Accepted                       | Accepted terms/version and dates                              | Onboarding             |
| Onboarding      | Completed/effective            | Employee identity, role, manager, verified skills             | Talent/performance     |
| Performance     | Finalized                      | Approved outcomes and identified gaps                         | Development/succession |
| Development     | Reviewed                       | Progress/evidence and reassessment result                     | Skills/succession      |

---

## 19. Phase 1 deliverables checklist

- [x] Project boundary and primary journey
- [x] Actor definitions and high-level RACI
- [x] Shared reference-data rules
- [x] Process catalogue and hand-offs
- [x] Status-transition definitions
- [x] Business and validation rules
- [x] Approval controls
- [x] Data-access matrix
- [x] AI governance rules
- [x] Notification and escalation catalogue
- [x] Exception catalogue and fallback contract
- [x] Audit and reporting requirements
- [x] Requirements traceability baseline
- [x] Acceptance scenarios
- [x] Glossary
- [x] Safe prototype postures adopted for unresolved production decisions
- [x] Accountable owner roles identified
- [x] Academic-prototype authorization recorded
- [ ] Named organizational owners assigned before production use
- [ ] Formal business, legal, privacy, and security sign-off before production use

---

## 20. Exit gate to Phase 2

Phase 2 implementation for the academic prototype may begin when all of the following are true:

- unresolved production decisions use the safe interim posture in Section 21 and do not change the core lifecycle;
- every process has an accountable owner role;
- status transitions and candidate-facing labels are accepted as the prototype baseline;
- approval routes remain configurable, with at least one independent HR approval and additional approval for exceptional offers;
- no real personal data or production AI credentials are used before retention, consent, provider, and privacy policies receive organizational approval;
- the restrictive access matrix is the prototype baseline;
- the traceability and acceptance baselines are accepted; and
- academic-prototype authorization is recorded.

These conditions authorize design and development only. They do not authorize production deployment or processing of real applicant or employee data.

After the gate, Phase 2 may define the Salesforce org strategy, Antigravity/Salesforce CLI setup, source control, data model, permission model, automation allocation, Apex/LWC boundaries, integrations, and an AI proof of concept.

---

## 21. Deferred production-decision register

No item below may be silently assumed for production. The stated posture is adopted for the academic prototype until the responsible organizational owner records a final decision.

| ID      | Decision required                                             | Owner                             | Safe interim posture                                                               | Downstream impact                   | Status                                                 |
| ------- | ------------------------------------------------------------- | --------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------- | ------------------------------------------------------ |
| DEC-001 | Salesforce org/Experience Cloud type and licensing            | Technical lead / Sponsor          | Keep portal and internal requirements product-neutral                              | Identity, portal, limits, licensing | Phase 2 selection required                             |
| DEC-002 | AI provider, model, region, data-use terms, and failover      | Security/Privacy / Technical lead | Provider abstraction; synthetic data only until approved                           | Integration, consent, logging, cost | Phase 2 selection required                             |
| DEC-003 | Requisition/offer approval levels and thresholds              | HR / Finance                      | At least one independent HR approval; exceptional offers require added approval    | Approval routing                    | Prototype default adopted; production decision pending |
| DEC-004 | Interview round types, defaults, and mandatory scorecards     | Talent Acquisition                | Configurable templates; no hard-coded count                                        | Scheduling, evaluation              | Prototype default adopted; production decision pending |
| DEC-005 | Salary currency and multi-currency need                       | HR / Finance                      | Store currency explicitly; do not infer                                            | Requisition, offer, reporting       | Prototype default adopted; production decision pending |
| DEC-006 | Candidate/application/résumé/chat/audit retention periods     | Privacy/Legal                     | Do not permanently delete or over-retain until policy is approved; restrict access | Storage, deletion, consent          | Prototype default adopted; production decision pending |
| DEC-007 | Talent-pool participation and consent                         | Talent Acquisition / Privacy      | No pooling without explicit consent and withdrawal mechanism                       | Screening, retention                | Prototype default adopted; production decision pending |
| DEC-008 | External calendar provider/integration                        | IT / Talent Acquisition           | Email/portal schedule remains authoritative                                        | Interview invitations               | Prototype default adopted; production decision pending |
| DEC-009 | Whether employees can see succession nominations              | HR / Privacy                      | Keep nominations confidential                                                      | Access and chatbot                  | Prototype default adopted; production decision pending |
| DEC-010 | Whether performance calibration is required                   | HR                                | Keep stage configurable and disabled until approved                                | Workflow, access                    | Prototype default adopted; production decision pending |
| DEC-011 | Offer document generation/e-signature versus portal response  | HR / Legal                        | Portal display and explicit response only; preserve version                        | Documents, integration              | Prototype default adopted; production decision pending |
| DEC-012 | Supported résumé formats and size limit                       | Security / Talent Acquisition     | Use configurable allowlist/limit; publish before launch                            | Upload UX, parsing                  | Prototype default adopted; production decision pending |
| DEC-013 | Candidate-facing status labels and rejection-message policy   | Talent Acquisition / Legal        | Use neutral plain-language templates                                               | Portal, notifications               | Prototype default adopted; production decision pending |
| DEC-014 | Notification reminder intervals and escalation hierarchy      | Each process owner                | Configurable; no repeated external messages without policy                         | Automation                          | Prototype default adopted; production decision pending |
| DEC-015 | Matching weights, eligibility gates, and governance owner     | Talent Acquisition / HR           | Current table is provisional; never auto-reject                                    | Matching and audit                  | Prototype default adopted; production decision pending |
| DEC-016 | Work authorization data and jurisdiction rules                | Legal / HR                        | Collect only where legally necessary                                               | Profile, screening                  | Prototype default adopted; production decision pending |
| DEC-017 | Onboarding mandatory tasks by employee type/location          | HR / IT                           | Use configurable templates                                                         | Onboarding completion               | Prototype default adopted; production decision pending |
| DEC-018 | Performance rating scale, cycle cadence, and reopen authority | HR                                | Configurable; no production cycle until defined                                    | Reviews, reporting                  | Prototype default adopted; production decision pending |

### Decision record template

For each decision, record: selected option, rationale, owner, approvers, decision date, effective date, affected requirements/processes, and whether re-sign-off is required.

---

## 22. Change control after sign-off

1. Submit a change request referencing affected process and requirement IDs.
2. Describe reason, user impact, data/access impact, AI/privacy impact, and acceptance changes.
3. Process owner and Security/Privacy review where applicable.
4. Approved changes receive a new document version and effective date.
5. Traceability, scenarios, and later technical/test artefacts are updated together.
6. Emergency changes are still documented retrospectively within the approved governance window.

---

## 23. Sign-off record

Signing confirms agreement with the defined business processes and authorizes Phase 2 design. It does not approve a specific technical implementation.

| Role                     | Name | Decision         | Date | Comments |
| ------------------------ | ---- | ---------------- | ---- | -------- |
| Business sponsor         |      | Approve / Reject |      |          |
| HR process owner         |      | Approve / Reject |      |          |
| Talent Acquisition owner |      | Approve / Reject |      |          |
| Talent Management owner  |      | Approve / Reject |      |          |
| Security/Privacy owner   |      | Approve / Reject |      |          |
| Technical lead           |      | Approve / Reject |      |          |

### Academic-prototype authorization

| Authorizing group | Decision                                         | Date       | Conditions                                                                                                                     |
| ----------------- | ------------------------------------------------ | ---------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Project team      | Approved to begin Phase 2 design and development | 2026-09-28 | Synthetic demonstration data only; restrictive interim controls apply; no production use without named organizational approval |

---

## Appendix A — Review workshop checklist

Use this order to complete Phase 1 efficiently:

1. Confirm scope and primary journey.
2. Assign process owners and approve the RACI.
3. Resolve identity, consent, retention, and access decisions.
4. Walk every status transition and exception.
5. Approve requisition/offer routes and material-change policy.
6. Approve matching inputs, weights, and prohibited data.
7. Approve interview templates and decision authority.
8. Approve onboarding, performance, development, and succession policies.
9. Approve chatbot intents, refusals, and escalation paths.
10. Approve notification timing and privacy rules.
11. Review every Must requirement against the acceptance scenarios.
12. Resolve or formally defer remaining decisions, then sign.

## Appendix B — Definition of ready for a Phase 2 requirement

A requirement is ready for design when it has:

- a unique ID and accountable owner;
- an unambiguous actor and authorized record scope;
- preconditions, trigger, normal outcome, and failure outcome;
- required information and validation rules;
- permitted status transitions;
- approval/notification/audit requirements;
- privacy and AI constraints where relevant;
- at least one acceptance scenario; and
- no unresolved decision that would materially change its implementation.
