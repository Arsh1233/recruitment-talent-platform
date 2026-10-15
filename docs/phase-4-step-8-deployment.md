# Phase 4 Step 8 — Field-Level Security Deployment

## Status

Deployed to `TalentDev` on 2026-10-15.

- Validation deployment ID: `0AfgK00000WaHCnSAN`
- Deployment ID: `0AfgK00000Wa70YSAR`
- Components: 9 permission sets
- Result: Succeeded

## Permission sets secured

- `RTP_Recruiter_Access`
- `RTP_Hiring_Manager_Access`
- `RTP_Interviewer_Access`
- `RTP_HR_Admin_Access`
- `RTP_Employee_Self_Service`
- `RTP_Succession_Access`
- `RTP_Candidate_Portal_Access`
- `RTP_AI_Integration_Access`
- `RTP_Audit_Read_Access`

## Implemented boundaries

### Candidate personal information

- Candidates can maintain their own email, phone, profile, and consent flag.
- Recruiters and HR administrators can access candidate contact information.
- Hiring managers receive only a limited candidate summary.
- Interviewers receive name, location, title, and experience only; email,
  phone, Contact, consent, and resume identifiers are not granted.
- The AI integration can read email and consent but cannot edit them; it does
  not receive phone access.
- Resume file identifiers are limited to recruiter, HR read-only, and AI
  integration access. Candidates and interviewers receive no parsing-request
  access.
- Candidate users can read but no longer directly edit the Candidate lookup on
  Certification; application logic must derive ownership.

The schema contains no date-of-birth, personal-address, work-authorization, or
raw AI response field. None was added during this deployment.

### Compensation

- Recruiters and HR administrators can read and edit requisition salary ranges,
  offered salary, and internal approval comments.
- Hiring managers can read salary ranges and offered salary but cannot edit
  them.
- Candidates can read the final offered salary but cannot edit it and cannot
  read internal approval comments.
- Interviewers, employees, AI integration, and audit readers receive no
  compensation-field access.

### Interviews

- Candidates can read scheduling, mode, meeting link, and public status fields.
- Interviewers receive only scheduling and assessment-relevant candidate
  context.
- Interview scores, recommendations, and comments are not granted to candidates
  or direct interviewer object access. Interviewer submissions continue through
  `RTPInterviewEvaluationService`.
- Recruiters can read evaluations; HR administrators can manage them; hiring
  managers receive read-only overall results and comments.

### Performance and succession

- Employees can edit self-rating, employee comments, and acknowledgement fields.
- Employees can read but cannot edit manager rating, final rating, manager
  comments, and finalization information.
- HR administrators can manage performance ratings and review administration.
- Succession access is isolated in `RTP_Succession_Access`, including vacancy
  risk, approved readiness, committee comments, restricted conflict notes, and
  readiness assessments.
- Recruiter, candidate, interviewer, employee, AI, and audit permission sets do
  not expose succession fields or succession objects.

### Audit

`RTP_Audit_Read_Access` is read-only and exposes safe integration-log,
AI-interaction, and parsing-status metadata. It does not expose candidate PII,
resume file identifiers, credentials, prompts, or provider payloads.

## Verification

Post-deployment queries against `FieldPermissions` confirmed the sensitive
field matrix. A separate `ObjectPermissions` query returned zero entries with
`View All` or `Modify All` enabled across the nine permission sets.

All related permission-set groups report `Updated`:

- `RTP_Recruitment_Team`
- `RTP_HR_Talent_Team`
- `RTP_Candidate_User`
- `RTP_AI_Service_User`

No real persona user is currently assigned to these groups, so no identity was
guessed or granted access during this step. Persona-based UI testing should be
performed after dedicated fictional test users are created.

## Conditional visibility note

Field-level security cannot reveal manager/final review fields only after a
review is released. The permission set supplies read-only field access; record
sharing, review status, and page/component visibility must enforce the release
condition when employee self-service UI is built.

