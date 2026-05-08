# PROJECT: Pre-Built Office Assistant

**Owner:** Scott Johnson — Open Horizon Advisors  
**Status:** 🟡 Spec under review  
**Created:** 2026-05-04  
**Last updated:** 2026-05-04

---

## Quick Reference

- **Spec:** `SPEC.md` — full requirements, architecture, skills, installer design
- **Target:** Solo/very small business on Linux, Google Workspace
- **Platform:** OpenClaw + Ollama (local) + cloud API fallback
- **Deployment:** Bash installer script

---

## Current Phase

**Phase 1: Spec & Design** (current)

- [x] Discovery conversation
- [x] Spec draft written
- [ ] Scott reviews and approves spec
- [ ] Open questions resolved (pricing, support model, demo mode, branding)

---

## Build Phases (post-spec approval)

| Phase | Work | Status |
|---|---|---|
| 1 | Spec + design | ✅ Complete |
| 2 | `crm-lite` skill | 🔴 Not started |
| 3 | `document-assistant` skill | 🔴 Not started |
| 4 | Workspace template files (7B-optimized) | 🔴 Not started |
| 5 | **Demo mode** — mock data, demo workspace, sales-ready | 🔴 Not started |
| 6 | `meeting-intelligence` skill (transcript/audio → action items) | 🔴 Not started |
| 7 | `meeting-prep` skill | 🔴 Not started |
| 8 | `follow-up-sequencer` skill | 🔴 Not started |
| 9 | `email-assistant` skill | 🔴 Not started |
| 10 | `calendar-assistant` skill | 🔴 Not started |
| 11 | Installer script (`install.sh`) | 🔴 Not started |
| 12 | End-to-end testing (clean machine, min spec) | 🔴 Not started |
| 13 | Package + document | 🔴 Not started |

**Note:** Demo mode (phase 5) unblocks sales before Gmail/Calendar integrations are done.

---

## Engagement Model

- **Pricing:** Setup fee per client engagement + optional yearly maintenance retainer
- **Support:** Self-serve post-handoff; extensions are billable engagements
- **Branding:** OpenClaw stays visible — no white-labeling
- **Installer operator:** Scott (not the client)
