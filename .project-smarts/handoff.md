# Handoff

## 2026-05-08 15:58 America/Chicago

### Done
- Confirmed the real overnight failure mode was detached `qwen2.5-coder:32b` tool-calling, not just bad paths.
- Completed the remaining `email-assistant` and `calendar-assistant` skill files with a workaround run on `qwen3:32b`.
- Performed a cleanup pass on both new skills so they are more concrete, more testable, and more aligned with the project quality bar.
- Rewrote both `tests.json` files to match the skill-tester schema and include smoke + guardrail coverage.
- Corrected `PROJECT.md`, `BUILD-NOTES.md`, and project-smarts state so the project status reflects reality.
- Ran a robust-model control on 2026-05-11 using a fresh repo-local temp workspace and `anthropic/claude-sonnet-4-6`.
- Confirmed representative controls pass on Sonnet:
  - email snapshot triage returned the expected top unread items from `inbox-snapshot.md`
  - calendar focus-time request wrote `documents/drafts/calendar-request-focus-time.md` with the correct draft shape
- Confirmed the remaining QA issue is specifically with smaller/local model reliability (`qwen2.5:7b-instruct`), not the repo-local test harness.
- Created a first working `install.sh` with support for unattended runs, workspace scaffolding, demo passthrough, safe non-overwriting file copies, local model recommendation, optional model pull, and optional gateway service install/start.
- Polished `install.sh` so unattended onboarding skips bootstrap file creation, repo assets are validated up front, and `--no-service` runs verify the scaffold directly instead of ending with noisy gateway-status failures.
- Ran `install.sh` successfully in an isolated fake-HOME smoke test with `--no-service --skip-google --unattended --skip-model-pull` after the polish pass.

### Next
- Refresh or finish the 7B-optimised workspace template files.
- Run end-to-end validation on a clean machine or equivalent test workspace.
- Run the newly wired Docker installer smoke test on a machine with Docker (or Podman) available.
- Package and document the deliverable.
- Revisit local model options later before calling the product ready for low-spec installs.

### Watchouts
- `qwen2.5-coder:32b` is not trustworthy for detached tool-heavy build runs in this environment yet.
- `qwen2.5:7b-instruct` still behaves below the quality bar on the email/calendar snapshot tests even after tightening the skill instructions.
- A stronger model (`anthropic/claude-sonnet-4-6`) passes representative repo-local controls, so the harness and repo packaging look sound.
- The first installer pass is real, and `Dockerfile.test` is now wired to it, but this host lacks Docker/Podman so the container lane still needs an actual build/run proof elsewhere.
- The spec still says draft, so packaging/positioning changes should be resolved explicitly before final release.
- Live Gmail / Calendar actions still need real validation beyond snapshot/demo coverage.
- The repo is now substantially self-contained, but the real quality bar still depends on validation, installer work, and doc consistency.

### Useful Paths
- `/home/scott/repos/pre-built-office-assistant/SPEC.md`
- `/home/scott/repos/pre-built-office-assistant/PROJECT.md`
- `/home/scott/repos/pre-built-office-assistant/BUILD-NOTES.md`
- `/home/scott/repos/pre-built-office-assistant/TESTING.md`
- `/home/scott/repos/pre-built-office-assistant/skills/email-assistant/SKILL.md`
- `/home/scott/repos/pre-built-office-assistant/skills/email-assistant/tests.json`
- `/home/scott/repos/pre-built-office-assistant/skills/calendar-assistant/SKILL.md`
- `/home/scott/repos/pre-built-office-assistant/skills/calendar-assistant/tests.json`

### Suggested Resume
- Start with the Docker installer smoke run on a machine that actually has Docker or Podman.
- Then move to end-to-end validation and packaging.
- If detached automation is needed, use `qwen3:32b` or another known-good tool-capable model rather than `qwen2.5-coder:32b`.
