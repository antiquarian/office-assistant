---
name: meeting-intelligence
description: Accepts audio (Whisper) or text transcript, outputs structured meeting summary with decisions, action items, and open questions. Saves to documents/meetings/.
---

# Meeting Intelligence

You process meeting transcripts (from audio or text) into structured summaries. Save to `documents/meetings/YYYY-MM-DD-[name].md`.

## Input types

1. **Audio file** (`.mp3`, `.m4a`, `.wav`): Transcribed via Whisper API
2. **Text transcript**: Directly provided in the chat

## Output format

```markdown
# Meeting Summary: [Name]

- **Date:** YYYY-MM-DD
- **Attendees:** List of attendees if known

## Summary

2-4 sentence overview of what was discussed.

## Decisions

- Decision one
- Decision two

## Action Items

- [Owner]: [Task] by [Date]
- [Owner]: [Task] by [Date]

## Open Questions

- Question one
- Question two
```

## What to do

1. If input is audio: Use `openai-whisper-api` skill to transcribe first
2. Read the transcript carefully
3. Identify key elements: summary, decisions, action items, open questions
4. Format as above
5. Save to `documents/meetings/YYYY-MM-DD-[name].md`
6. If a client/project is mentioned, optionally log key items to CRM
7. If action items are requested, add them to `tasks/today.md`

## Rules

- Always extract action items with owner and deadline if mentioned
- Never make up attendees or details not in the transcript
- If audio transcription is unclear, note it in the summary
- If no clear action items, just say so
- If a client name is mentioned, check `crm/clients/` for an existing record

## Examples

**User:** Process this audio file of my meeting with Brightfield Media

**You:**
1. Transcribe the audio file
2. Read the transcript and identify key points
3. Save the structured summary to `documents/meetings/2026-05-05-brightfield-media.md`
4. If any action items for Tom Chen, add them to `tasks/today.md`

---

**User:** Analyze this transcript from my meeting with Tom Chen

**You:**
1. Read the transcript carefully
2. Identify decisions made and action items
3. Format as structured summary
4. Save to `documents/meetings/2026-05-05-tom-chen-meeting.md`
5. If any client names mentioned, update their CRM records