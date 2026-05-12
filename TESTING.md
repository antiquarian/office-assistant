# TESTING.md — Pre-Built Office Assistant

Testing runbook for skills, installer, and end-to-end validation.

---

## Quick reference

| What | Command / Method | Notes |
|---|---|---|
| Skill tests (automated) | Overnight build runs these via isolated sessions | See BUILD-NOTES.md for results |
| Skill tests (manual) | See Section 2 below | Run anytime against workspace-test |
| Installer test (Docker) | `docker build -f Dockerfile.test -t boa-test . && docker run --rm boa-test` | Stub only until install.sh exists |
| Systemd test | Fresh Ubuntu VM, full install | See Section 4 |
| Min-spec test | 8GB RAM / no GPU machine | See Section 5 |

---

## 1. Test environment setup

### Skill testing workspace
Create an isolated workspace for testing skills without touching Scott's real workspace:

```bash
mkdir -p ~/.openclaw/workspace-test
mkdir -p ~/.openclaw/workspace-test/skills
cp -r ./skills/crm-lite ~/.openclaw/workspace-test/skills/
cp -r ./skills/document-assistant ~/.openclaw/workspace-test/skills/
cp -r ./skills/email-assistant ~/.openclaw/workspace-test/skills/
cp -r ./skills/calendar-assistant ~/.openclaw/workspace-test/skills/
# etc. for each skill being tested
```

Run the commands above from the repo root: `/home/scott/repos/pre-built-office-assistant/`.

Then open the OpenClaw Control UI and switch workspace to `~/.openclaw/workspace-test/`
(or configure a second OpenClaw instance with `--workspace ~/.openclaw/workspace-test`).

### Demo workspace
The demo workspace (`~/.openclaw/workspace-demo/`) is set up by `demo/setup-demo.sh`.
Run it before demo testing, tear down with `demo/teardown-demo.sh`.

```bash
bash demo/setup-demo.sh
# ... run demo tests ...
bash demo/teardown-demo.sh
```

---

## 2. Skill test cases

Run these manually in the OpenClaw Control UI against `ollama/qwen2.5:7b-instruct`.
Mark results in the table below.

### 2.1 crm-lite

| # | Test prompt | Expected result | Pass? |
|---|---|---|---|
| 1 | "Create a new client: Brightfield Media, contact Tom Chen, tom@brightfield.com, status Active" | File created at `crm/clients/brightfield-media.md` with correct format | |
| 2 | "Log that I called Brightfield Media today — we agreed on a kickoff call next Tuesday" | Interaction appended to `brightfield-media.md` with today's date | |
| 3 | "What clients haven't I spoken to in the last 2 weeks?" | Lists contacts with `Last Contact` older than 14 days | |
| 4 | "Show me the Brightfield Media record" | Displays full markdown file content | |
| 5 | "Create a new client: Brightfield Media" (duplicate) | Asks to confirm; does not create a second file | |
| 6 | "Create a new vendor: Office Depot, billing@officedepot.com" | File created at `crm/vendors/office-depot.md` | |

### 2.2 document-assistant

| # | Test prompt | Expected result | Pass? |
|---|---|---|---|
| 1 | "Draft a proposal for Brightfield Media for a 3-month AI workflow engagement at $5,000/month" | Fills `proposal.md` template; saves to `documents/drafts/` | |
| 2 | "Draft a follow-up email to Tom Chen after our call today" | Uses `follow-up-email.md` template; appropriate tone | |
| 3 | "Draft meeting notes for today's Brightfield kickoff call" | Uses `meeting-notes.md` template | |
| 4 | "Draft a scope of work for the Brightfield engagement" | Uses `scope-of-work.md` template | |
| 5 | "Draft a status report for the Brightfield project — week 2 of 12, on track" | Uses `status-report.md` template | |

### 2.3 meeting-intelligence

| # | Test prompt | Expected result | Pass? |
|---|---|---|---|
| 1 | Paste a 10-sentence fake meeting transcript → "Process this transcript" | Returns: summary, decisions, action items, open questions | |
| 2 | Transcript mentions client "Brightfield Media" → "Process and log to CRM" | Offers to append key items to `crm/clients/brightfield-media.md` | |
| 3 | "Process this transcript and add action items to my task list" | Appends items to `tasks/today.md` | |

### 2.4 meeting-prep

| # | Test prompt | Expected result | Pass? |
|---|---|---|---|
| 1 | "Prep me for my meeting with Brightfield Media" | Returns brief with CRM notes + recent interactions | |
| 2 | "Prep me for my meeting with someone not in the CRM" | Graceful response; offers to create a CRM entry | |

### 2.5 follow-up-sequencer

| # | Test prompt | Expected result | Pass? |
|---|---|---|---|
| 1 | "I sent a proposal to Brightfield Media today — track it" | Creates follow-up record in `crm/follow-ups/` | |
| 2 | "What proposals are still pending?" | Lists open follow-up records | |
| 3 | "Draft a day-3 follow-up to Brightfield Media" | Produces a light check-in email draft | |
| 4 | "Brightfield signed — close the Brightfield follow-up" | Marks record as won; closes sequence | |

---

## 3. Demo mode test

After running `setup-demo.sh`, verify the following in the demo workspace:

```
[ ] SOUL.md present with persona "Alex"
[ ] USER.md present for "Jordan Lee"
[ ] crm/clients/ contains 3 client files
[ ] crm/vendors/ contains 2 vendor files
[ ] crm/projects/ contains 2 project files
[ ] calendar-snapshot.md present with 3-5 events
[ ] inbox-snapshot.md present with 4-6 emails
[ ] All 4 skills accessible
```

Then run the 5 demo scenarios from `DEMO-GUIDE.md` and confirm each produces a realistic, clean output.

---

## 4. Installer test (Docker)

**Prerequisites:** Docker installed on dev machine.

```bash
cd /path/to/pre-built-office-assistant
docker build -f Dockerfile.test -t boa-installer-test .
docker run --rm boa-installer-test
```

**Expected behavior:**
1. Run `bash install.sh --no-service --skip-google --unattended --skip-model-pull`
2. Assert OpenClaw installed and responds to `openclaw --version`
3. Assert workspace directory created with template files and bundled skills
4. Assert document templates were deployed
5. Exit 0 on all pass, exit 1 on any failure

**Current note:** this Docker lane is now wired to the real installer, but still needs an actual `docker build` / `docker run` proof on a machine with Docker available.

---

## 5. Systemd service test (VM)

**Environment:** Fresh Ubuntu 22.04 minimal install in a VM.

```bash
# On the VM:
bash install.sh --skip-google --unattended

# Verify service registered and running:
systemctl --user status openclaw-gateway.service

# Reboot and confirm auto-start:
sudo reboot
# After reboot:
systemctl --user status openclaw-gateway.service

# Confirm UI accessible:
curl http://localhost:18789
```

---

## 6. Min-spec end-to-end test

**Target hardware:** 8GB RAM, no GPU, Ubuntu 22.04, CPU-only Ollama.

**Steps:**
1. Run full installer on a clean machine
2. Pull `qwen2.5:7b-instruct` (CPU inference)
3. Open Control UI
4. Run the 5 demo scenarios
5. Measure and record:
   - Time to first token on a typical query
   - Time to complete a document draft
   - Peak RAM usage (watch with `htop`)
   - Any OOM or crash events

**Acceptable thresholds:**
- First token: < 60 seconds
- Full document draft: < 3 minutes
- No OOM with browser + Ollama + OpenClaw running simultaneously

---

## 7. Test results log

Update this section after each test run.

| Date | Tester | Surface | Result | Notes |
|---|---|---|---|---|
| — | — | — | — | First build not yet complete |
