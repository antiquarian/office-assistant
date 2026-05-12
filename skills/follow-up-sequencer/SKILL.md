---
name: follow-up-sequencer
description: Tracks proposals/quotes in crm/follow-ups/, sends nudge emails at day 3/7/14 with human approval. Closes sequence on win/loss/dismiss.
---

# Follow-Up Sequencer

You track proposals and quotes in `crm/follow-ups/` and send follow-up emails at Day 3, 7, and 14. All emails require human approval before sending.

## File format

```markdown
# Follow-Up: [Client] - [Subject]

- **Sent:** YYYY-MM-DD
- **Status:** Pending | Sent | Won | Lost | Dismissed
- **Contact:** Full Name (email@example.com)
- **Next action:** YYYY-MM-DD

## Notes

Additional tracking information
```

## What to do

1. When a proposal/quote is sent:
   a. Create a file in `crm/follow-ups/` with the format `[Client] - [Subject].md`
   b. Set status to `Pending` and next action to Day 3
2. On Day 3:
   a. Draft a light check-in email
   b. Show it to the user for approval
   c. If approved, update status to `Sent` and set next action to Day 7
3. On Day 7:
   a. Draft a more direct nudge
   b. Show it to the user for approval
   c. If approved, update status to `Sent` and set next action to Day 14
4. On Day 14:
   a. Draft a final touch
   b. Show it to the user for approval
   c. If approved, update status to `Sent` and flag for special attention
5. When a response is received:
   a. Update the CRM log for the client
   b. If the deal is won/lost, update status accordingly
   c. If manually dismissed, set status to `Dismissed`

## Rules

- Always check for duplicate follow-ups before creating a new one
- Never send an email without explicit human approval
- If no response by Day 14, flag for special attention
- Always update the CRM log when a response is received
- Always close the sequence when status is `Won`, `Lost`, or `Dismissed`

## Examples

**User:** Log that I sent a proposal to Brightfield Media on May 1

**You:**
1. Create `crm/follow-ups/brightfield-media - ai-workflow-proposal.md`
2. Set sent date to 2026-05-01, status to `Pending`, next action to 2026-05-04
3. Confirm the follow-up was created

---

**User:** Send the Day 3 nudge for Brightfield Media

**You:**
1. Read the follow-up file
2. Draft a light check-in email
3. Show it to the user for approval
4. If approved, update status to `Sent` and set next action to Day 7

---

**User:** The client said no to our proposal

**You:**
1. Update the follow-up status to `Lost`
2. Log the response in the CRM
3. Confirm the update