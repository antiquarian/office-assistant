# SPEC: Pre-Built Office Assistant - v1

**Owner:** Scott Johnson - Open Horizon Advisors
**Status:** 🟡 Spec draft - under review
**Created:** 2026-05-04
**Last updated:** 2026-05-04

---

## 1. What Is This?

An internal delivery toolkit that makes OHA engagements faster, more consistent, and more repeatable.

When a prospect says "I want an AI office assistant," Scott runs this installer, configures it for their specific setup, and hands it over as a delivered engagement. The client doesn't buy software - they buy Scott's expertise. This toolkit is how Scott delivers it reliably every time without rebuilding from scratch.

**What the client gets:** A working AI office assistant - built on OpenClaw, named whatever they like, connected to their Google Workspace - that handles email, calendar, document drafting, and lightweight CRM. It behaves like a smart, proactive EA, not a chatbot they have to manage.

**What Scott gets:** A repeatable, installer-driven deployment process. Show up, run the script, configure, hand off, invoice.

**OpenClaw branding stays visible.** We're not white-labeling. The pitch is: *"We set up an AI assistant for you, powered by OpenClaw."*

---

## 2. Target User

- **Primary:** Solo entrepreneur or very small business (1-3 people)
- **Technical level:** Comfortable with a Linux box; not a developer
- **Machine profile:** Linux desktop or small-form-factor box (e.g., Clawbox equivalent); may lack GPU; internet connected
- **Workspace:** Google Workspace (Gmail + Google Calendar) to start

**Out of scope - v1:**
- Multi-user / team mode
- Windows or macOS install
- Microsoft 365 / Outlook / Exchange
- Fastmail or other providers

---

## 3. Product Architecture

```
┌─────────────────────────────────────────────┐
│              Client Machine (Linux)          │
│                                              │
│  OpenClaw Gateway                            │
│  └── Workspace (configured by client)        │
│      ├── SOUL.md       ← persona             │
│      ├── USER.md       ← about the user      │
│      ├── AGENTS.md     ← behavior rules      │
│      ├── MEMORY.md     ← long-term memory    │
│      ├── HEARTBEAT.md  ← proactive tasks     │
│      ├── TOOLS.md      ← local notes         │
│      ├── crm/          ← lightweight CRM     │
│      ├── tasks/        ← daily task files    │
│      └── skills/       ← pre-built skills    │
│          ├── email-assistant/                │
│          ├── calendar-assistant/             │
│          ├── document-assistant/             │
│          └── crm-lite/                       │
│                                              │
│  Ollama (local inference)                    │
│  └── Primary model: qwen2.5:7b-instruct      │
│      Fallback: cloud API (client's key)      │
│                                              │
│  gws-sa (Google Workspace integration)       │
│  └── Gmail + Google Calendar                 │
└─────────────────────────────────────────────┘
```

---

## 4. Model Strategy

### Primary: Local (Ollama)
- **Default model:** `qwen2.5:7b-instruct`
  - Runs on CPU with 8GB RAM; adequate for routine tasks
  - Fast enough for email drafts, short summaries, task management
- **Upgraded local:** `qwen2.5:14b-instruct` if client has 16GB+ RAM or a GPU
- Installer detects available hardware and recommends the appropriate model

### Fallback: Cloud API
- **Recommended:** OpenAI `gpt-4o-mini` (cheap, fast, capable)
- **Alternative:** Anthropic Claude Haiku
- Client provides their own API key during setup - OHA does not hold or manage API keys
- Cloud is used for: complex reasoning, long-context tasks, anything the local model handles poorly
- Routing rule in AGENTS.md: local by default, cloud for tasks requiring extended context or high capability

### Prompt Optimization
- All workspace files (SOUL.md, AGENTS.md, HEARTBEAT.md, skill SKILL.md files) must be written for smaller models
- Directives must be explicit, unambiguous, and short - no implicit assumptions
- Skills must include worked examples in their SKILL.md where it helps the model
- Test suite: every skill tested against qwen2.5:7b-instruct before shipping

---

## 5. Features - v1 Scope

### 5.1 Email Assistant (Gmail)
**What it does:**
- Reads and triages inbox - surfaces urgent/important messages
- Drafts replies in the user's voice
- Sends emails on request (with user approval by default; "auto-send" mode optional)
- Summarizes threads
- Tracks unanswered messages and surfaces them in heartbeat

**Heartbeat behavior:**
- Checks inbox 2-3 times per day
- Alerts user to urgent/time-sensitive messages
- Composes daily email summary if enabled

**Skill:** `email-assistant/SKILL.md`

---

### 5.2 Calendar Assistant (Google Calendar)
**What it does:**
- Shows upcoming events on request
- Creates and updates events
- Reminds user of upcoming events (via heartbeat)
- Suggests scheduling based on availability
- Blocks focus time on request

**Guardrails (default):**
- Ask before inviting external attendees
- Ask before cancelling or moving confirmed meetings
- Never double-book without asking

**Skill:** `calendar-assistant/SKILL.md`

---

### 5.3 Document Assistant
**What it does:**
- Drafts common business documents from templates:
  - Proposals
  - Scope of work / engagement letters
  - Follow-up emails
  - Meeting notes / summaries
  - Status reports
  - Simple invoices (text format)
- Saves drafts to `documents/drafts/`
- Tracks document versions

**Template system:**
- Templates live in `documents/templates/`
- Each template is a markdown file with `{{placeholder}}` slots
- User can add their own templates; assistant learns from them

**Skill:** `document-assistant/SKILL.md`

---

### 5.4 CRM Lite
**What it does:**
- Maintains structured markdown files for clients, vendors, and projects
- Answers questions: "What's the status of the Acme project?" / "When did I last talk to Rich?"
- Logs interactions when asked: "Log that I called Acme today and we agreed on a start date of June 1"
- Surfaces stale relationships in heartbeat: "You haven't followed up with Acme in 3 weeks"
- Tracks project status and open items

**Data structure:**
```
crm/
├── clients/
│   └── acme-corp.md         ← one file per client
├── vendors/
│   └── stripe.md
├── projects/
│   └── acme-ai-rollout.md
└── INDEX.md                 ← auto-maintained index
```

**Client file format:**
```markdown
# Acme Corp
- **Contact:** Jane Smith (jane@acme.com)
- **Status:** Active client
- **Since:** 2026-03-15
- **Last contact:** 2026-05-01

## Notes
...

## Interaction Log
- 2026-05-01: Call - agreed on June 1 start date
- 2026-04-15: Proposal sent
```

**Skill:** `crm-lite/SKILL.md`

---

### 5.5 Meeting Prep
**What it does:**
- Triggered automatically 15-30 minutes before a calendar event, or on demand: "Prep me for my 2pm with Acme"
- Pulls together into a single brief:
  - CRM notes and interaction log for the contact/company
  - Recent email threads with them (last 7 days)
  - Open project items tied to them
  - Any notes from previous meetings
- Saves brief to `documents/meeting-prep/YYYY-MM-DD-[meeting-name].md`
- Optionally surfaces the brief via heartbeat before the meeting

**Skill:** `meeting-prep/SKILL.md`

---

### 5.6 Follow-Up Sequencer
**What it does:**
- Tracks proposals, quotes, and pending follow-ups in `crm/follow-ups/`
- When a proposal is sent, logs it with a sent date and status: `pending`
- Cron job checks daily for follow-ups due:
  - Day 3: draft a light check-in
  - Day 7: draft a more direct nudge
  - Day 14: draft a final touch and flag for Scott's attention
- Scott approves and sends; nothing goes out automatically
- Updates CRM log when a response is received
- Closes the sequence when deal won, lost, or manually dismissed

**Follow-up file format:**
```markdown
# Follow-Up: Acme Solutions - AI Workflow Proposal
- **Sent:** 2026-05-01
- **Status:** Pending - Day 7 nudge due
- **Contact:** Jane Smith (jane@acme.com)
- **Next action:** 2026-05-08
```

**Skill:** `follow-up-sequencer/SKILL.md`

---

### 5.7 Meeting Intelligence
**What it does:**
- Accepts input in two forms:
  1. **Audio recording** - transcribed via OpenAI Whisper API (existing skill in toolkit)
  2. **Text transcript** - pasted directly into the chat
- Processes the transcript into:
  - **Summary** - 2-4 sentence overview of what was discussed
  - **Decisions made** - bulleted list of anything agreed or decided
  - **Action items** - each with owner and deadline if mentioned
  - **Open questions** - anything unresolved that needs follow-up
- Saves structured output to `documents/meetings/YYYY-MM-DD-[meeting-name].md`
- Optionally logs key items to the relevant CRM entry if a client/project is identified
- On request: turns action items into task entries in `tasks/today.md`

**Transcription pipeline:**
- Audio file (`.mp3`, `.m4a`, `.wav`) → Whisper API → raw transcript → intelligence processing
- Requires `OPENAI_API_KEY` in config (Whisper is cloud-only; no local transcription in v1)
- Transcript-only mode works fully local with qwen2.5:7b-instruct

**Skill:** `meeting-intelligence/SKILL.md`

---

## 6. Workspace Template Files

The installer deploys a set of template files into `~/.openclaw/workspace/`. The client fills in their specifics. Templates must work well with small models.

### 6.1 SOUL.md template
- Generic professional assistant persona
- Client fills in: name, voice/style preferences, tone
- Includes: behavior guidance optimized for 7B models (explicit, directive, no implicit assumptions)

### 6.2 USER.md template
- Client fills in: their name, company, timezone, pronouns, preferences
- Pre-populated with sensible defaults

### 6.3 AGENTS.md
- Core behavior rules - heavily commented so client understands each section
- Includes:
  - Session startup sequence
  - Memory management
  - External action guardrails
  - Heartbeat behavior
  - Model routing rules (local vs cloud)

### 6.4 HEARTBEAT.md
- Pre-configured heartbeat tasks:
  - Email triage check (configurable frequency)
  - Calendar reminder (24h and 2h lead times)
  - CRM stale contact check (weekly)
  - Daily task carry-forward
- Client enables/disables sections by commenting them out

### 6.5 MEMORY.md
- Empty template with section headers
- Pre-populated by the assistant after first interaction

### 6.6 TOOLS.md
- Template with sections for: SSH hosts, cameras, devices, voice preferences
- Client fills in as they discover needs

---

## 7. Installer Script

### Philosophy
**Scott runs this installer - not the client.** The installer needs to be fast, clean, and reliable for a practitioner deploying on behalf of a client. It doesn't need to be bulletproof for a non-technical end user running it blind.

OpenClaw already has its own configuration process (model selection, API keys, gateway setup, assistant name). We run that first and let it do its job. Our installer then reads what OpenClaw configured and only asks for what it doesn't already know. No duplication, no conflicting prompts.

### What it does (in order):
1. **Checks prerequisites** - Linux, bash, curl, node/nvm
2. **Installs OpenClaw** (or detects existing install and updates if needed)
3. **Runs OpenClaw's own setup/config flow** - `openclaw setup` or equivalent; handles model selection, API keys, assistant name, gateway config
4. **Reads OpenClaw config** - parses what OpenClaw stored (assistant name, model, API provider, etc.) so we don't ask again
5. **Installs Ollama** (or detects existing install)
6. **Hardware detection** - RAM, GPU presence → recommends appropriate local model; cross-checks against model already configured in OpenClaw
7. **Model download** - pulls recommended Ollama model if not already present
8. **Google Workspace setup** - walks through gws-sa service account setup (or OAuth for simpler deployments); outputs a working config
9. **Workspace scaffold** - deploys template workspace files to `~/.openclaw/workspace/`; skips files that already exist (never overwrites user-modified files)
10. **OHA configuration wizard** - asks only for what OpenClaw doesn't cover:
    - Google account email address
    - Google Calendar ID
    - Which skills to enable (email / calendar / documents / CRM)
    - OHA-specific preferences (heartbeat frequency, email auto-send on/off)
11. **Systemd service** - installs and starts OpenClaw gateway as a user service (if not already running)
12. **Final check** - runs `openclaw status` and confirms everything is green
13. **First-run message** - prints instructions for opening the Control UI and getting started

### Design rules:
- Idempotent - safe to re-run (upgrades rather than breaks)
- Never overwrites user-modified workspace files; skips with a notice
- Interactive by default; `--unattended` flag for scripted deploys
- No root required (user-space install throughout)
- Rollback notes printed if any step fails
- Single file: `install.sh` - no dependencies beyond bash + curl
- OpenClaw's config is the source of truth for model and API settings; our config only extends it

---

## 8. Skills to Build

### v1 Skills

| Skill | Status | Notes |
|---|---|---|
| `email-assistant` | 🔴 Not started | Gmail via gws-sa; inbox triage + draft/send |
| `calendar-assistant` | 🔴 Not started | Google Calendar via gws-sa; view/create/remind |
| `document-assistant` | 🔴 Not started | Template engine + draft management |
| `crm-lite` | 🔴 Not started | Markdown CRM; read/write/search/log |
| `meeting-prep` | 🔴 Not started | Pre-meeting brief: CRM notes + email threads + project status |
| `follow-up-sequencer` | 🔴 Not started | Track sent proposals; draft nudge emails at day 3/7/14 |
| `meeting-intelligence` | 🔴 Not started | Audio recordings or text transcripts → summary + action items + CRM log |

### v2 Skills (backlog)

| Skill | Notes |
|---|---|
| `client-onboarding` | One-prompt new client setup: CRM + welcome email + project file + reminders |
| `weekly-summary` | Auto Friday brief: clients touched, proposals out, projects, stale relationships |
| `subscription-tracker` | Markdown log of business subscriptions; renewal reminders at 30 days |
| `expense-logger` | Quick-log expenses by text; monthly CSV summary for bookkeeper |
| `contact-research` | Pre-meeting research brief on a new contact (lighter briefing package) |

All skills must:
- Have a clear SKILL.md that works with 7B models
- Include worked examples
- Define guardrails explicitly
- Be testable independently

---

## 9. Hardware Requirements

| Config | RAM | GPU | Local Model | Notes |
|---|---|---|---|---|
| Minimum | 8 GB | None | qwen2.5:7b-instruct | CPU inference; slower but functional |
| Recommended | 16 GB | None | qwen2.5:14b-instruct | Noticeably better output quality |
| Preferred | 16 GB+ | Any CUDA GPU | qwen2.5:14b or 32b | Fast, high quality |

- OS: Ubuntu 22.04+ or Debian 12+ (other distros likely work, not tested)
- Disk: 10-20 GB for models + workspace
- Internet: Required for cloud API fallback and Google Workspace

---

## 10. v1 Scope Boundaries

### In scope - v1
- Single user
- Linux only
- Google Workspace (Gmail + Google Calendar)
- Four core skills (email, calendar, document, CRM)
- Bash installer
- Local + cloud hybrid model strategy
- Markdown CRM

### Explicitly out of scope - v1
- Team / multi-user mode
- Windows / macOS
- Microsoft 365 / Outlook
- Fastmail or other email providers
- CRM integrations (HubSpot, Salesforce, etc.)
- Mobile client
- Billing / license management
- White-labeling beyond persona naming

### Future (v2+)
- Team mode (shared memory, role-based behavior)
- Microsoft 365 integration path
- CRM sync to common APIs
- Marketplace of additional skills
- Managed hosting option ("Clawbox as a service")

---

## 11. Engagement Model

### Pricing
- **Setup fee:** Fixed fee per engagement. Scott installs, configures, and hands off. Google Workspace setup is included in that fee (it requires Scott's involvement anyway).
- **Yearly maintenance (optional):** Scott reviews, updates, and tunes the assistant annually as a retainer line item. Client decides if they want it. Not a subscription product.
- **Extensions:** If a client wants new capabilities added later, that's a new engagement - billed accordingly.

### Support model
- **Self-serve day-to-day:** The client uses the assistant on their own after handoff. No ongoing support obligation from OHA unless they're on the maintenance retainer.
- **No packaged support product:** This is not a SaaS offering. There is no support portal, ticketing system, or SLA. Going back in to help is a billable engagement.

### Branding
- OpenClaw name stays visible. The pitch: *"We set up an AI assistant for you, powered by OpenClaw."*
- No white-labeling. No OHA-branded wrapper around OpenClaw.

### Open questions (resolved)
| # | Question | Decision |
|---|---|---|
| 1 | Pricing model | Hybrid: setup fee + optional yearly maintenance retainer |
| 2 | Post-install support | Self-serve; extensions are billable engagements |
| 3 | Demo mode | Yes - high priority; critical sales tool for Scott |
| 4 | OpenClaw branding | Keep it visible |

---

## 12. Demo Mode

Demo mode is a **sales tool for Scott** - not for the client. It lets Scott spin up a fully working, realistic assistant in ~10 minutes during or ahead of a prospect conversation.

### What it does:
- Triggered by `install.sh --demo` flag
- Deploys a pre-configured workspace with a named demo assistant (e.g., "Alex") and a fictional solo business owner (e.g., "Jordan Lee, owner of Greenleaf Consulting")
- Populates mock CRM data: 3-5 clients, 2-3 vendors, 2 active projects
- Populates a mock inbox summary and upcoming calendar events (static, not live - no real API calls needed)
- Enables all four skills
- Skips Google Workspace setup (no real credentials needed)
- Uses cloud API if available; falls back to local model gracefully

### Demo scenarios pre-scripted:
1. "What's on my calendar this week?" - shows upcoming mock events
2. "Draft a follow-up email to Acme after our meeting yesterday" - produces a realistic draft
3. "What's the status of the Greenleaf website project?" - reads mock CRM file
4. "Log that I called Riverside Supply today and they confirmed the order" - writes to mock CRM
5. "Draft a simple proposal for a new client" - uses document template

### Persona customization (future)
The demo persona (Jordan Lee / Greenleaf Consulting) is the default. In a future iteration, Scott can swap in a prospect-specific persona before a sales meeting - same mock data structure, different name and business type. A small library of persona packs (contractor, medical office, law firm, etc.) would make the demo feel bespoke and meaningfully improve close rates.

### Design rules:
- Demo mode must be runnable on Scott's own machine without affecting his real workspace
- Uses a separate workspace directory: `~/.openclaw/workspace-demo/`
- Teardown: `install.sh --demo-teardown` removes the demo workspace cleanly
- No real data, no real API calls to Google

---

## 13. Build Order

1. Finalize spec — **Scott review + approval** ✅
2. Build `crm-lite` skill
3. Build `document-assistant` skill (templates + drafting)
4. Write workspace template files (SOUL.md, AGENTS.md, HEARTBEAT.md, USER.md, TOOLS.md) — optimized for 7B models
5. **Build demo mode** — mock data, demo workspace, runnable for sales demos *(unblocks sales)*
6. Build `meeting-intelligence` skill (transcript + audio → action items)
7. Build `meeting-prep` skill
8. Build `follow-up-sequencer` skill
9. Build `email-assistant` skill (Gmail integration)
10. Build `calendar-assistant` skill (Google Calendar integration)
11. Write installer script (`install.sh`)
12. End-to-end test on a clean machine (minimum-spec hardware)
13. Package and document

---

## 14. Testing Strategy

### Two distinct test surfaces

| Surface | What it tests | Method |
|---|---|---|
| Skills + workspace files | CRM reads/writes, doc drafts, model prompt compliance | Isolated OpenClaw sessions, separate workspace dir |
| Installer script | Clean-OS install, dependency detection, config flow | Docker container (Ubuntu 22.04) |
| Systemd service | Service registration + auto-start | VM or bare-metal second machine |
| Min-spec end-to-end | Full product on 8GB RAM / no GPU | Real hardware or constrained VM |

---

### Skill testing

**Environment:** `~/.openclaw/workspace-test/` on the dev machine, separate from the real workspace.

**Method:** For each skill, spawn an isolated OpenClaw session with model `ollama/qwen2.5:7b-instruct`, supply the SKILL.md as context, run the test scenarios, and verify output.

**Pass criteria per skill:**
- Correct file created/modified in the right location
- Content follows the specified format
- No hallucinated paths, dates, or contact details
- Guardrails respected (no delete without asking, no duplicate creation, etc.)
- Response is coherent on the 7B model without requiring a cloud fallback

**Skill test cases (minimum per skill):**

`crm-lite`:
- Create a new client → verify file created at correct path with correct format
- Log an interaction → verify appended correctly
- Query stale contacts → verify correct output based on dates
- Query a client record → verify correct data returned
- Attempt duplicate creation → verify it catches and asks

`document-assistant`:
- Draft a proposal from template → verify all `{{placeholder}}` slots filled
- Save draft → verify file at correct path
- Draft a follow-up email → verify tone and content are appropriate

`meeting-intelligence`:
- Paste a raw transcript → verify summary + action items + decisions extracted
- Paste a transcript mentioning a client → verify CRM log offer
- Submit audio file path → verify Whisper transcription triggers

`meeting-prep`:
- Request prep for a named contact → verify brief pulls CRM + email + project data
- Request prep for unknown contact → verify graceful handling

`follow-up-sequencer`:
- Log a sent proposal → verify follow-up record created
- Simulate day 3 check → verify nudge draft produced
- Mark as won → verify sequence closed

---

### Installer testing (Docker)

**Image:** `ubuntu:22.04` (standard; no systemd)

**Installer flags for Docker:**
- `--no-service` — skips systemd service registration (not available in standard Docker)
- `--skip-google` — skips Google Workspace OAuth/service-account setup (no browser in container)
- `--unattended` — non-interactive mode with defaults

**What Docker tests cover:**
- Prerequisite detection (curl, node, nvm)
- OpenClaw install/update
- Ollama install detection (mock or skip)
- Hardware detection logic
- Workspace scaffold (template file deployment)
- Config wizard in unattended mode

**What Docker does NOT test:**
- Systemd service registration
- Google Workspace OAuth flow
- Actual model inference
- GPU detection

**Docker test run (target command):**
```bash
docker build -f Dockerfile.test -t boa-installer-test .
docker run --rm boa-installer-test
```

See `Dockerfile.test` in this directory.

---

### Systemd + end-to-end testing

**For systemd:** Run the full installer on a real VM (Ubuntu 22.04 minimal install) or a separate physical machine. Verify the service starts, survives a reboot, and is reachable at `http://localhost:18789`.

**For min-spec end-to-end:** Target 8GB RAM, no GPU, `qwen2.5:7b-instruct` on CPU. Measure:
- Time to first response (acceptable: <60 seconds for a typical query)
- Time to generate a document draft (acceptable: <3 minutes)
- Memory usage under load (must not OOM with browser + Ollama + OpenClaw running)

---

### Test runbook
See `TESTING.md` in this directory for step-by-step test execution instructions.

---

## 15. Notes

- This product is essentially a productized version of what Scott has built with Grainne. The difference is it must work reliably with a smaller model and a less technical operator.
- The biggest risk is prompt quality on 7B models - every skill and workspace file needs explicit, unambiguous instructions. Assume the model will not infer anything.
- The second-biggest risk is the installer - it needs to handle the full range of Linux setups without breaking. Test on fresh Ubuntu and Debian VMs.
