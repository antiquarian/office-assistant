# Demo Guide — Pre-Built Office Assistant

**Persona:** Jordan Lee, Owner — Greenleaf Consulting  
**Setup:** Run `bash demo/setup-demo.sh` then point OpenClaw at `~/.openclaw/workspace-demo/`  
**Teardown:** Run `bash demo/teardown-demo.sh`

---

## Before the demo

1. Run `bash demo/setup-demo.sh`
2. Open OpenClaw and switch workspace to `~/.openclaw/workspace-demo/`
3. Confirm the assistant greets you as "Alex" and references Jordan / Greenleaf Consulting
4. Have the 5 scenarios below ready to run in order

---

## Scenario 1 — Calendar awareness

**Prompt:**
> What's on my calendar this week?

**Expected output:**
Alex lists the 5 events from `calendar-snapshot.md` — Monday Acme call, Tuesday Riverside demo prep, Wednesday Northgate follow-up + standup, Thursday vendor review.

**Talking point:** *"Every morning, Alex has already pulled your calendar and knows what's coming. No digging through apps."*

---

## Scenario 2 — Email-driven action

**Prompt:**
> Diana Chen from Northgate sent me some questions about the proposal. Draft a follow-up email that acknowledges her questions and proposes a call this week.

**Expected output:**
Alex drafts a warm, professional follow-up to Diana referencing Northgate Partners, acknowledges the questions, and proposes a time to connect. Saves to `documents/drafts/`.

**Talking point:** *"Alex read the inbox snapshot, knows who Diana is and the context, and drafts the email. Jordan reviews and sends — one click."*

---

## Scenario 3 — CRM lookup

**Prompt:**
> What's the status of the Acme RFP Automation project?

**Expected output:**
Alex reads `crm/projects/acme-rfp-automation.md` and summarizes: Phase 2 active, answer library content due May 10, stakeholder demo due May 20, status report due May 15. Open items listed.

**Talking point:** *"Every project has a living record. Jordan doesn't have to remember everything — Alex holds the context."*

---

## Scenario 4 — CRM logging

**Prompt:**
> Log that I called Riverside Group today and Marcus confirmed the dashboard demo for May 8 at 10 AM.

**Expected output:**
Alex appends to `crm/clients/riverside-group.md` Interaction Log: `- 2026-05-05: Call — Marcus confirmed dashboard demo for May 8 at 10 AM`. Updates Last Contact date. Confirms the update.

**Talking point:** *"One sentence. The CRM is updated. No portal, no form, no copy-paste."*

---

## Scenario 5 — Document drafting

**Prompt:**
> Draft a status report for the Acme RFP Automation project. Week 10 of 12. Status: on track. Completed this week: answer library content received from Sarah's team. In progress: draft generation system build. Next week: stakeholder demo on May 22. No blockers.

**Expected output:**
Alex reads `skills/document-assistant/templates/status-report.md`, fills in all fields with the provided details, saves to `documents/drafts/status-report-acme-rfp-automation-2026-05-05.md`, and displays the finished document.

**Talking point:** *"A professional status report in 15 seconds. Jordan edits if needed, sends. That's the pitch — less admin, more client work."*

---

## Closing the demo

After the 5 scenarios:

> *"What you just saw — calendar awareness, email drafting, CRM updates, project tracking, document generation — is all running locally on this machine. No cloud subscription for the AI. Your data doesn't leave your office. And this is just the starting point — we can add email integration, meeting intelligence, automated follow-ups, and more."*

---

## Troubleshooting

**Alex doesn't know Jordan's name:** Check that `USER.md` is in the workspace-demo root and the session restarted after setup.

**CRM files not found:** Confirm `setup-demo.sh` ran successfully and `crm/` directory exists in workspace-demo.

**Wrong persona:** Confirm the session is pointing at `workspace-demo`, not the main workspace.
