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
