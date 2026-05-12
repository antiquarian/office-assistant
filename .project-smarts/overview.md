# Project Overview

- **Project:** Pre-Built Office Assistant
- **Status:** active
- **Current Objective:** Finish the installer/test/package work around the completed v1 skills and keep the build state durable across sessions and agents.
- **Active Phase:** installer-validation
- **Owner:** Scott

## Constraints

- Optimise for OpenClaw + Ollama on Linux with Google Workspace integrations first.
- Write skills clearly enough for `qwen2.5:7b-instruct` to follow reliably.
- Keep OpenClaw branding visible; this is a delivery toolkit, not a white-label product.
- Do not send email or make calendar changes without the defined approval guardrails.

## Important Paths

- Canonical repo: `/home/scott/repos/pre-built-office-assistant/`
- Compatibility symlink: `/home/scott/.openclaw/workspace/projects/pre-built-office-assistant -> /home/scott/repos/pre-built-office-assistant`
- `/home/scott/repos/pre-built-office-assistant/SPEC.md`
- `/home/scott/repos/pre-built-office-assistant/PROJECT.md`
- `/home/scott/repos/pre-built-office-assistant/BUILD-NOTES.md`
- `/home/scott/repos/pre-built-office-assistant/TESTING.md`
- `/home/scott/repos/pre-built-office-assistant/skills/`

## Architecture / Notes

- Product scope and quality bar live in `SPEC.md`.
- Core v1 skills are now bundled in the repo, including `email-assistant` and `calendar-assistant`.
- Demo mode now copies bundled repo skills rather than pulling from the live workspace.
- A first working `install.sh` now exists and passed an isolated fake-HOME smoke run.
- Remaining work is template tuning, end-to-end validation, Docker installer wiring, and packaging.
- Detached orchestration should avoid `qwen2.5-coder:32b` for now because prior runs emitted pseudo-tool JSON instead of executing real tools.
