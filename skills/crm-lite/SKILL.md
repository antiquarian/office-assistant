---
name: crm-lite
description: Manage a markdown CRM for clients, vendors, and projects. Handle: create, log interaction, view record, check stale contacts, duplicate prevention. All file paths relative to workspace.
---

# CRM Lite

You manage a simple markdown-based CRM. All files are in the workspace. You read and write markdown files to track clients, vendors, and projects.

## File locations

- Clients: `crm/clients/SLUG.md` where SLUG is the company name lowercased with hyphens (e.g. "Acme Corp" → `crm/clients/acme-corp.md`)
- Vendors: `crm/vendors/SLUG.md`
- Projects: `crm/projects/SLUG.md`

## File format — client or vendor

```markdown
# Company Name

- **Contact:** Full Name (email@example.com)
- **Status:** Active | Prospect | Inactive
- **Since:** YYYY-MM-DD
- **Last Contact:** YYYY-MM-DD

## Notes

Free text notes about the relationship.

## Interaction Log

- YYYY-MM-DD: Brief description of what happened
```

## File format — project

```markdown
# Project Name

- **Client:** Client Name
- **Status:** Active | On Hold | Complete
- **Start:** YYYY-MM-DD
- **Last Updated:** YYYY-MM-DD

## Description

What this project is about.

## Open Items

- Item one
- Item two

## Log

- YYYY-MM-DD: What happened
```

## Commands you handle

### Create a new client
When asked to create a client, vendor, or project:
1. Check if the file already exists. If it does, say so and ask before overwriting.
2. Create the file at the correct path using today's date for Since and Last Contact.
3. Confirm what was created.

### Log an interaction
When asked to log a call, meeting, email, or any interaction:
1. Find the correct file.
2. Append a new line to the Interaction Log section: `- YYYY-MM-DD: Description`
3. Update the Last Contact date in the header.
4. Confirm the update.

### View a record
When asked to show or view a client, vendor, or project:
1. Read the file.
2. Display the full content clearly.

### Check stale contacts
When asked who you haven't spoken to recently or to check stale contacts:
1. Read all files in crm/clients/ and crm/vendors/.
2. Find records where Last Contact is older than the requested threshold (default: 14 days).
3. List them with the last contact date.

### Update status
When asked to update the status of a client, vendor, or project:
1. Find the file.
2. Update the Status line.
3. Confirm the change.

## Rules

- Never delete a file unless explicitly asked to delete it.
- Never create a duplicate — always check first.
- Always use today's date when logging. Do not guess or invent dates.
- Always confirm what action you took.
- If you cannot find a file, say so clearly rather than inventing content.

## Examples

**User:** Create a new client: Brightfield Media, contact Tom Chen, tom@brightfield.com, status Active

**You:** Create the file `crm/clients/brightfield-media.md` with the correct format and confirm: "Created client record for Brightfield Media."

---

**User:** Log that I called Brightfield Media today and we agreed on a June 1 start date

**You:** Append `- 2026-05-05: Call — agreed on June 1 start date` to the Interaction Log in `crm/clients/brightfield-media.md`, update Last Contact to today, and confirm.

---

**User:** Who haven't I spoken to in the last 2 weeks?

**You:** Read all client and vendor files, compare Last Contact dates to today, list anyone with Last Contact older than 14 days.
