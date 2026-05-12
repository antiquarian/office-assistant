# Decisions

## 2026-05-04 — Product is a delivery toolkit, not a standalone software product

- **Context:** The project needed a clear commercial frame.
- **Decision:** Position it as an internal delivery toolkit that Scott installs and configures as part of an engagement.
- **Why:** This keeps the offer grounded in advisory/delivery work rather than pretending OHA is selling shrink-wrapped software.
- **Impact:** OpenClaw branding stays visible, and the implementation prioritises repeatable deployment and handoff over productisation theater.

## 2026-05-04 — Local-first model strategy with cloud fallback

- **Context:** The target environment may be modest Linux hardware, but the assistant still needs stronger reasoning fallback when local models struggle.
- **Decision:** Default to local Ollama models, optimise prompts and skills for small models, and allow client-provided cloud fallback only when needed.
- **Why:** This keeps cost and hardware expectations sane while preserving capability.
- **Impact:** Skills and workspace files must be explicit, concise, and testable against `qwen2.5:7b-instruct`.

## 2026-05-07 — Use Project Smarts files for durable build continuity

- **Context:** Overnight and cross-agent build work can lose context or drift after compaction.
- **Decision:** Track active tasks, handoff state, and notable watchouts in `.project-smarts/` for this project.
- **Why:** Monkey and future sessions need a fast, durable resume path that does not depend on chat history alone.
- **Impact:** Resume work from `.project-smarts/handoff.md` and `.project-smarts/tasks.md` before making large changes.

## 2026-05-08 — Treat Monkey's overnight failure as a tool-calling/runtime issue, not primarily a pathing issue

- **Context:** Multiple Monkey cron reruns appeared to `write` files in scheduler summaries but produced no artifacts or logs on disk.
- **Decision:** Diagnose `qwen2.5-coder:32b` tool execution as the primary fault line before doing more prompt/path cleanup.
- **Why:** Runtime trajectories show `qwen2.5-coder:32b` sessions emitting JSON-like pseudo-tool calls as plain assistant text with `toolMetas: []` and zero tool lifecycle events, while known-good `qwen3:32b` cron runs execute real tools.
- **Impact:** Do not trust cron summaries alone for `qwen2.5-coder:32b` runs. Use a known-good tool-capable model for detached build orchestration until the coder-model tool integration is fixed.

## 2026-05-11 — Bundle built skills and templates inside the repo

- **Context:** The project docs claimed the build was largely complete, but the repo still depended on Scott's live workspace for key skills, templates, and demo setup.
- **Decision:** Copy the built skills into `skills/` inside the repo, add missing workspace templates, and update demo/testing paths to reference the repo bundle first.
- **Why:** A deliverable toolkit has to stand on its own. If the repo only works on Scott's machine, it is not actually packaged.
- **Impact:** The repo is now the canonical source for the bundled skills and demo setup. Remaining work shifts to validation, installer, and packaging rather than artifact recovery.

## 2026-05-11 — Ship a pragmatic first installer before chasing perfect low-spec local-model support

- **Context:** The repo reached self-contained status, but still lacked `install.sh`, and 7B validation exposed local-model reliability issues that are real but orthogonal to basic packaging.
- **Decision:** Build a first installer now that handles workspace scaffolding, unattended onboarding, demo passthrough, safe copy rules, model recommendation, and optional service setup, then revisit local-model choices later.
- **Why:** Packaging and install flow are independent product gaps. Waiting for the perfect local-model answer would stall the rest of the deliverable.
- **Impact:** `install.sh` becomes part of the real deliverable now, while the low-spec/local-model question stays visible as a later validation/watchout item rather than blocking packaging work.
