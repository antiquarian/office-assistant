# BUILD-NOTES.md - Pre-Built Office Assistant

## 2026-05-08

### What was completed

- Built the remaining v1 skills:
  - `skills/email-assistant/SKILL.md`
  - `skills/email-assistant/tests.json`
  - `skills/calendar-assistant/SKILL.md`
  - `skills/calendar-assistant/tests.json`
- Ran a quality pass on both new skills so they match the existing project style better.
- Corrected `PROJECT.md` so phase status is aligned with the real project state.

### Notes on the two new skills

#### email-assistant
- Uses live Gmail when available.
- Falls back to `inbox-snapshot.md` and `email-threads/SLUG.md` in demo/test workspaces.
- Saves drafts to `documents/drafts/email-reply-SLUG.md`.
- Keeps sending approval-gated and never claims a send succeeded unless it actually did.

#### calendar-assistant
- Uses live Google Calendar when available.
- Falls back to `calendar-snapshot.md` in demo/test workspaces.
- Saves write-action drafts to `documents/drafts/calendar-request-SLUG.md` when running in snapshot/test mode or when approval is still required.
- Keeps external invites, moves, cancels, and double-booking behind explicit approval.

### Testing posture

- Both skills now have schema-shaped `tests.json` files for the skill tester.
- Tests cover smoke paths plus guardrails.
- Still worth running the automated/manual test pass against `ollama/qwen2.5:7b-instruct` before calling this project truly ready.

### Important watchout

Detached runs that relied on `qwen2.5-coder:32b` were misleading: the model emitted pseudo-tool JSON as plain text and the runtime did not execute those tools. Use `qwen3:32b` or another known-good tool-capable model for detached build orchestration until that integration issue is fixed.

### Remaining work

- Refresh or finish the 7B-optimised workspace template files.
- Build `install.sh`.
- Run end-to-end testing on a clean machine or equivalent test workspace.
- Package and document the deliverable.

## 2026-05-11

### Repo self-containment pass

- Copied the built v1 skills into `skills/` inside the repo so the project no longer depends on Scott's main workspace for those artifacts.
- Added bundled `MEMORY.md` and `TOOLS.md` templates to close an obvious workspace-template gap.
- Updated `demo/setup-demo.sh` so it copies bundled repo skills rather than reaching into the live workspace.
- Extended the demo setup to include `email-assistant` and `calendar-assistant`, which the demo scenarios already assume are present.
- Corrected `TESTING.md` demo/setup paths and manual skill-copy examples so they reference the repo bundle.
- Updated the v1 skill status table in `SPEC.md` so it reflects reality instead of claiming the built skills are still not started.

### Installer first pass

- Created `install.sh` with:
  - OpenClaw detection/install path
  - unattended onboarding path using `openclaw onboard --non-interactive --accept-risk --auth-choice skip`
  - workspace scaffolding for templates, bundled skills, and document templates
  - safe non-overwriting copy behavior
  - Ollama detection plus recommended-model logic
  - optional model pull
  - optional gateway service install/start
  - demo passthrough flags (`--demo`, `--demo-teardown`)
- Verified the script with `bash -n` and `--help`.
- Ran a fake-HOME smoke test successfully with `--no-service --skip-google --unattended --skip-model-pull`.
- Replaced the `Dockerfile.test` placeholder harness with a real installer smoke lane that runs `install.sh --no-service --skip-google --unattended --skip-model-pull` and asserts the scaffolded workspace files.
- Current validation gap: this host does not have Docker or Podman installed, so the container lane is wired but not yet executed here.
- Polished `install.sh` to use `--skip-bootstrap` during unattended onboarding, verify repo assets up front, and do direct scaffold verification in `--no-service` runs instead of noisy gateway-status checks.
- Re-ran the isolated fake-HOME smoke test successfully after the polish pass.
