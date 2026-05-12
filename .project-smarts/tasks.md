# Tasks

## Active

- [ ] TMP-013 Build or refresh 7B-optimised workspace template files
- [ ] QA-016 Run end-to-end test pass on a clean machine or equivalent test workspace
- [ ] PKG-017 Package and document the deliverable
- [ ] TEST-021 Replace the Docker installer stub with a real installer smoke test when the container path is verified

## Pending

- [ ] SPEC-001 Resolve any remaining spec/business-model questions if the draft status is meant to close

## Blocked

- [ ] QA-015 `qwen2.5:7b-instruct` failed the new email/calendar snapshot tests even after prompt tightening; robust-model control passed, so revisit local-model options later
- [ ] RUNTIME-018 Detached tool-heavy builds should not rely on `qwen2.5-coder:32b` until the tool-calling mismatch is fixed

## Done

- [x] SKILL-002 Build `crm-lite`
- [x] SKILL-003 Build `document-assistant`
- [x] DEMO-005 Build demo mode assets and demo workspace
- [x] SKILL-006 Build `meeting-intelligence`
- [x] SKILL-007 Build `meeting-prep`
- [x] SKILL-008 Build `follow-up-sequencer`
- [x] DIAG-013 Determine why Monkey was exiting before producing `email-assistant` / `calendar-assistant` artifacts
- [x] SKILL-009 Build `skills/email-assistant/SKILL.md` and `skills/email-assistant/tests.json`
- [x] SKILL-010 Build `skills/calendar-assistant/SKILL.md` and `skills/calendar-assistant/tests.json`
- [x] DOC-011 Update `BUILD-NOTES.md` after the rerun and quality pass
- [x] DOC-012 Update `PROJECT.md` so completed phases reflect reality
- [x] AUD-019 Audit repo self-containment and identify packaging gaps
- [x] PKG-018 Make the repo self-contained so it no longer depends on Scott's main workspace for built skills and templates
- [x] PKG-014 Create `install.sh`
