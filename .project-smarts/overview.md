# Project Overview

- **Project:** Pre-Built Office Assistant
- **Status:** active
- **Current Objective:** Finish the remaining v1 skills and keep the build state durable across sessions and agents.
- **Active Phase:** implementation
- **Owner:** Scott

## Constraints

- Optimise for OpenClaw + Ollama on Linux with Google Workspace integrations first.
- Write skills clearly enough for `qwen2.5:7b-instruct` to follow reliably.
- Keep OpenClaw branding visible; this is a delivery toolkit, not a white-label product.
- Do not send email or make calendar changes without the defined approval guardrails.

## Important Paths

- `projects/pre-built-office-assistant/SPEC.md`
- `projects/pre-built-office-assistant/PROJECT.md`
- `projects/pre-built-office-assistant/BUILD-NOTES.md`
- `projects/pre-built-office-assistant/TESTING.md`
- `skills/crm-lite/SKILL.md`
- `skills/document-assistant/SKILL.md`
- `skills/email-assistant/`
- `skills/calendar-assistant/`

## Architecture / Notes

- Product scope and quality bar live in `SPEC.md`.
- `PROJECT.md` is partially stale: it still shows only phase 1 as complete, while `BUILD-NOTES.md` confirms additional skills were built after that file was last updated.
- The next scheduled coding push is Monkey's overnight build for `email-assistant` and `calendar-assistant`.
