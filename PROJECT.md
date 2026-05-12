# PROJECT: Pre-Built Office Assistant

**Owner:** Scott Johnson — Open Horizon Advisors
**Status:** 🟡 Active — core skills are bundled, `install.sh` exists and smoke-tested, and end-to-end testing/packaging remain
**Created:** 2026-05-04
**Last updated:** 2026-05-11

---

## Quick Reference

- **Spec:** `SPEC.md` — full requirements, architecture, skills, installer design
- **Target:** Solo / very small business on Linux with Google Workspace
- **Platform:** OpenClaw + Ollama (local) + optional cloud fallback
- **Deployment:** Installer-driven delivery toolkit, not a standalone software product

---

## Current Phase

**Phase 5: Installer + validation**

### Completed skills
- [x] `crm-lite`
- [x] `document-assistant`
- [x] `meeting-intelligence`
- [x] `meeting-prep`
- [x] `follow-up-sequencer`
- [x] `email-assistant`
- [x] `calendar-assistant`

### Completed supporting work
- [x] Demo mode assets and demo workspace
- [x] Durable project continuity via `.project-smarts/`
- [x] Core built skills copied into `skills/` in the repo

---

## Build Phases (post-spec approval)

| Phase | Work | Status |
|---|---|---|
| 1 | Spec + design | ✅ Complete |
| 2 | Core skills | ✅ Complete |
| 3 | Workspace template files (7B-optimized) | 🟡 In progress |
| 4 | Demo mode — mock data, demo workspace, sales-ready | ✅ Complete |
| 5 | Installer script (`install.sh`) | 🟡 First working pass complete; needs container proof + polish |
| 6 | End-to-end testing (clean machine, min spec) | 🔴 Not started |
| 7 | Package + document | 🔴 Not started |

---

## Engagement Model

- **Pricing:** Setup fee per client engagement + optional yearly maintenance retainer
- **Support:** Self-serve post-handoff; extensions are billable engagements
- **Branding:** OpenClaw stays visible — no white-labeling
- **Installer operator:** Scott, not the client

---

## Immediate Next Steps

1. Refresh or finish the 7B-optimised workspace template files.
2. Run the newly wired Docker installer smoke test on a machine with Docker or Podman.
3. Run end-to-end validation on a clean machine or equivalent test workspace.
4. Package and document the deliverable.
5. Revisit local model options before final low-spec positioning.

---

## Watchouts

- The spec is still marked draft; any business-model or packaging changes should be resolved explicitly before calling the project finished.
- Detached build orchestration should avoid `qwen2.5-coder:32b` for now; it produced pseudo-tool output without real tool execution in prior runs.
- `qwen2.5:7b-instruct` is still below the quality bar on the new email/calendar snapshot tests; revisit local model options later.
- The Docker smoke lane is wired to the real installer, but it still needs an actual container run on a machine with Docker or Podman.
- Some docs and test assets still need cleanup so the repo tells one consistent story end-to-end.
