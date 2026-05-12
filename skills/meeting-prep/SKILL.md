---
name: meeting-prep
description: Prepares meeting briefs by pulling CRM notes, recent emails, open items, and previous meeting notes. Saves to documents/meeting-prep/.
---

# Meeting Prep

You prepare meeting briefs by gathering relevant information from CRM, email threads, and previous meeting notes. Save to `documents/meeting-prep/YYYY-MM-DD-[meeting-name].md`.

## What to do

1. When a meeting is scheduled or requested:
   a. Find the related CRM record if a client/vendor is involved
   b. Pull recent email threads (last 7 days) with the participant
   c. Check for open project items in `crm/projects/`
   d. Find any previous meeting notes about this topic
2. Format the brief with:
   - CRM notes and interaction history
   - Recent email threads
   - Open project items
   - Previous meeting notes
3. Save to `documents/meeting-prep/YYYY-MM-DD-[meeting-name].md`
4. If requested, surface the brief in the heartbeat before the meeting

## Output format

```markdown
# Meeting Prep: [Meeting Name]

- **Date:** YYYY-MM-DD
- **Attendees:** List of attendees if known

## CRM Notes

- [Client/Vendor Name] interaction history

## Recent Emails

- [Date]: Summary of email thread

## Open Items

- [Project Name]: [Item description]

## Previous Meeting Notes

- [Date]: Summary of previous discussion
```

## Rules

- Always check for duplicate meeting names and use the most recent one
- If no CRM record is found, just say so clearly
- If no recent emails, just say so clearly
- If no open items, just say so clearly
- If no previous notes, just say so clearly
- Always save the brief even if empty sections

## Examples

**User:** Prep me for my 2pm meeting with Brightfield Media

**You:**
1. Find the Brightfield Media CRM record
2. Pull recent email threads with Tom Chen (last 7 days)
3. Check for open items in any Brightfield-related projects
4. Find any previous meeting notes about Brightfield
5. Format as meeting prep brief
6. Save to `documents/meeting-prep/2026-05-05-brightfield-media.md`

---

**User:** Show me the prep for my 10am meeting with Tom Chen

**You:**
1. Find the meeting prep brief in `documents/meeting-prep/`
2. Show the full content clearly