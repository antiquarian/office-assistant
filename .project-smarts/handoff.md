# Handoff

## 2026-05-08 09:20 America/Chicago

### Done
- Verified the overnight Monkey assignment was still the two remaining skills: `email-assistant` and `calendar-assistant`.
- Confirmed the expected output files still do not exist under `skills/email-assistant/` or `skills/calendar-assistant/`.
- Patched the debug guidance to use on-disk logging at `projects/pre-built-office-assistant/run-logs/monkey-email-calendar-debug.md` with delivery disabled for reruns.
- Triggered a rerun and checked the workspace afterward.

### Next
- Inspect the Monkey job definition/runtime config and run a minimal reproducible diagnostic that should perform multiple file tool actions.
- Verify whether Monkey's agent workspace isolation is the real blocker: Monkey's home workspace is `/home/scott/.openclaw/workspace-monkey`, which does not contain the `projects/pre-built-office-assistant/` tree.
- If the job prompt uses relative paths, rewrite it to use absolute paths in `/home/scott/.openclaw/workspace/...` or otherwise mount/share the target project into Monkey's workspace before rerunning.
- Once the worker pathing/runtime is stable, rerun the build for `email-assistant` and `calendar-assistant`, then update `BUILD-NOTES.md` and `PROJECT.md`.

### Watchouts
- `PROJECT.md` is stale relative to later build progress; do not trust it as the sole status source.
- The prior cron announcement fail-closed path masked the first failure, but the rerun still produced no skill artifacts and no debug log file, so delivery was not the only problem.
- Monkey's configured workspace is `/home/scott/.openclaw/workspace-monkey`, and a quick filesystem check shows that workspace currently contains only the bootstrap files, not the Office Assistant project tree.
- Current leading suspicion: the build brief relied on relative project paths that make sense in the main workspace but not in Monkey's isolated workspace; model/tool-loop instability is still possible, but path isolation now looks like the cleaner first explanation.
- Keep the new skills explicit and 7B-friendly; vague instructions will backfire on the target runtime.

### Useful Paths
- `projects/pre-built-office-assistant/SPEC.md`
- `projects/pre-built-office-assistant/PROJECT.md`
- `projects/pre-built-office-assistant/BUILD-NOTES.md`
- `projects/pre-built-office-assistant/.project-smarts/tasks.md`
- `projects/pre-built-office-assistant/run-logs/`
- `skills/crm-lite/SKILL.md`
- `skills/document-assistant/SKILL.md`

### Suggested Resume
- Read `.project-smarts/handoff.md` then `.project-smarts/tasks.md`.
- Validate Monkey's agent/runtime configuration before blaming the Office Assistant prompt.
- Use a tiny multi-tool diagnostic first; if that also dies after one action, fix Monkey before reattempting the real build.
