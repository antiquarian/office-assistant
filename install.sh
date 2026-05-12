#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
TEMPLATES_DIR="$REPO_ROOT/templates"
SKILLS_DIR="$REPO_ROOT/skills"
DOC_TEMPLATES_DIR="$REPO_ROOT/skills/document-assistant/templates"
DEMO_SETUP_SCRIPT="$REPO_ROOT/demo/setup-demo.sh"
DEMO_TEARDOWN_SCRIPT="$REPO_ROOT/demo/teardown-demo.sh"

WORKSPACE="${HOME}/.openclaw/workspace"
NO_SERVICE=0
SKIP_GOOGLE=0
UNATTENDED=0
SKIP_MODEL_PULL=0
DRY_RUN=0
RUN_DEMO=0
RUN_DEMO_TEARDOWN=0

log() {
  printf '[boa-installer] %s\n' "$*"
}

warn() {
  printf '[boa-installer][warn] %s\n' "$*" >&2
}

die() {
  printf '[boa-installer][error] %s\n' "$*" >&2
  exit 1
}

run_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'
    for arg in "$@"; do
      printf ' %q' "$arg"
    done
    printf '\n'
    return 0
  fi
  "$@"
}

usage() {
  cat <<'EOF'
Pre-Built Office Assistant installer

Usage:
  bash install.sh [options]

Options:
  --workspace DIR       Target OpenClaw workspace (default: ~/.openclaw/workspace)
  --no-service          Skip OpenClaw gateway service install/start
  --skip-google         Skip Google Workspace follow-up notes
  --skip-model-pull     Do not pull the recommended Ollama model
  --unattended          Non-interactive mode where supported
  --demo                Set up the demo workspace and exit
  --demo-teardown       Remove the demo workspace and exit
  --dry-run             Print actions without changing anything
  -h, --help            Show this help

Notes:
- This installer is for Scott/operator use, not end-user self-service.
- It does not overwrite existing workspace files or skill directories.
- OpenClaw and Ollama are detected if already installed.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --workspace)
        [[ $# -ge 2 ]] || die "--workspace requires a path"
        WORKSPACE="$2"
        shift 2
        ;;
      --no-service)
        NO_SERVICE=1
        shift
        ;;
      --skip-google)
        SKIP_GOOGLE=1
        shift
        ;;
      --skip-model-pull)
        SKIP_MODEL_PULL=1
        shift
        ;;
      --unattended)
        UNATTENDED=1
        shift
        ;;
      --demo)
        RUN_DEMO=1
        shift
        ;;
      --demo-teardown)
        RUN_DEMO_TEARDOWN=1
        shift
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unknown option: $1"
        ;;
    esac
  done
}

require_linux() {
  [[ "$(uname -s)" == "Linux" ]] || die "This installer currently supports Linux only."
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

check_prereqs() {
  require_linux
  require_command bash
  require_command curl
  require_command git
}

check_repo_assets() {
  [[ -d "$TEMPLATES_DIR" ]] || die "Missing templates directory: $TEMPLATES_DIR"
  [[ -d "$SKILLS_DIR" ]] || die "Missing skills directory: $SKILLS_DIR"
  [[ -f "$TEMPLATES_DIR/AGENTS.md" ]] || die "Missing required template: $TEMPLATES_DIR/AGENTS.md"
}

ensure_openclaw() {
  if command -v openclaw >/dev/null 2>&1; then
    log "OpenClaw detected: $(openclaw --version | head -n 1)"
    return 0
  fi

  log "OpenClaw not found; installing via official installer"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] curl -fsSL https://openclaw.ai/install-cli.sh | bash"
    return 0
  fi

  curl -fsSL https://openclaw.ai/install-cli.sh | bash
  command -v openclaw >/dev/null 2>&1 || die "OpenClaw install did not put 'openclaw' on PATH"
}

run_openclaw_setup() {
  local args
  if [[ "$UNATTENDED" -eq 1 ]]; then
    args=(onboard --non-interactive --accept-risk --workspace "$WORKSPACE" --auth-choice skip --skip-daemon --skip-health --skip-search --skip-skills --skip-ui --skip-channels --skip-bootstrap)
  else
    args=(setup --workspace "$WORKSPACE")
  fi

  log "Running OpenClaw setup for workspace: $WORKSPACE"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run] openclaw'; for arg in "${args[@]}"; do printf ' %q' "$arg"; done; printf '\n'
    return 0
  fi

  if ! openclaw "${args[@]}"; then
    warn "OpenClaw setup did not complete cleanly. You may need to rerun the appropriate setup/onboard command manually for workspace $WORKSPACE."
  fi
}

ensure_ollama() {
  if command -v ollama >/dev/null 2>&1; then
    log "Ollama detected: $(ollama --version 2>/dev/null | head -n 1 || echo installed)"
    return 0
  fi

  warn "Ollama is not installed. This first installer pass does not attempt a root-level Ollama install automatically."
  warn "Install Ollama separately, then rerun this installer to pull a recommended local model."
}

recommend_model() {
  local mem_kb mem_gb has_gpu
  mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
  mem_gb=$(( mem_kb / 1024 / 1024 ))
  has_gpu=0
  if command -v nvidia-smi >/dev/null 2>&1; then
    has_gpu=1
  fi

  if (( has_gpu == 1 && mem_gb >= 16 )); then
    printf 'qwen2.5:32b\n'
  elif (( mem_gb >= 16 )); then
    printf 'qwen2.5:14b-instruct\n'
  else
    printf 'qwen2.5:7b-instruct\n'
  fi
}

ensure_model() {
  local model
  model="$(recommend_model)"
  log "Recommended local model: $model"

  if ! command -v ollama >/dev/null 2>&1; then
    return 0
  fi

  if [[ "$SKIP_MODEL_PULL" -eq 1 ]]; then
    log "Skipping model pull by request"
    return 0
  fi

  if [[ "$UNATTENDED" -eq 0 ]]; then
    printf 'Pull recommended Ollama model (%s)? [Y/n] ' "$model"
    read -r reply || true
    if [[ -n "${reply:-}" && ! "$reply" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
      log "Skipping model pull"
      return 0
    fi
  fi

  log "Ensuring Ollama model is available: $model"
  run_cmd ollama pull "$model" || warn "Model pull failed for $model. You can run 'ollama pull $model' manually later."
}

safe_copy_file() {
  local src="$1"
  local dst="$2"
  if [[ -e "$dst" ]]; then
    log "Keeping existing file: $dst"
    return 0
  fi
  run_cmd mkdir -p "$(dirname "$dst")"
  run_cmd cp "$src" "$dst"
  log "Installed file: $dst"
}

safe_copy_dir() {
  local src="$1"
  local dst="$2"
  if [[ -e "$dst" ]]; then
    log "Keeping existing directory: $dst"
    return 0
  fi
  run_cmd mkdir -p "$(dirname "$dst")"
  run_cmd cp -R "$src" "$dst"
  log "Installed directory: $dst"
}

scaffold_workspace() {
  log "Scaffolding workspace at $WORKSPACE"
  run_cmd mkdir -p "$WORKSPACE" "$WORKSPACE/skills" "$WORKSPACE/documents/drafts" "$WORKSPACE/documents/templates"

  local name
  for name in AGENTS.md SOUL.md USER.md HEARTBEAT.md MEMORY.md TOOLS.md; do
    safe_copy_file "$TEMPLATES_DIR/$name" "$WORKSPACE/$name"
  done

  local skill_dir skill_name
  shopt -s nullglob
  for skill_dir in "$SKILLS_DIR"/*; do
    skill_name="$(basename "$skill_dir")"
    safe_copy_dir "$skill_dir" "$WORKSPACE/skills/$skill_name"
  done
  shopt -u nullglob

  if [[ -d "$DOC_TEMPLATES_DIR" ]]; then
    local tpl
    shopt -s nullglob
    for tpl in "$DOC_TEMPLATES_DIR"/*.md; do
      safe_copy_file "$tpl" "$WORKSPACE/documents/templates/$(basename "$tpl")"
    done
    shopt -u nullglob
  fi
}

write_next_steps() {
  local notes="$WORKSPACE/INSTALL-NEXT-STEPS.md"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "[dry-run] write $notes"
    return 0
  fi

  cat > "$notes" <<EOF
# Install Next Steps

## Workspace
- Workspace path: $WORKSPACE
- Repo source: $REPO_ROOT

## Recommended follow-up
- Run: openclaw status
- Open the Control UI from your normal OpenClaw workflow
- Confirm the bundled skills appear in $WORKSPACE/skills/
- Revisit local model choice later if the target machine struggles with qwen2.5:7b-instruct

## Google Workspace
EOF

  if [[ "$SKIP_GOOGLE" -eq 1 ]]; then
    cat >> "$notes" <<'EOF'
- Google setup was skipped for this run.
- When ready, configure Gmail/Calendar access and then validate `email-assistant` and `calendar-assistant` in live mode.
EOF
  else
    cat >> "$notes" <<'EOF'
- Finish Google Workspace setup for Gmail + Calendar.
- Preferred path in this project is gws-sa service-account setup with the required scopes and account details.
EOF
  fi

  cat >> "$notes" <<'EOF'

## Validation
- Snapshot/demo tests proved the bundled repo skills work on a stronger model control.
- Local-model options may need another pass before final packaging.
EOF
}

setup_service() {
  if [[ "$NO_SERVICE" -eq 1 ]]; then
    log "Skipping gateway service install/start by request"
    return 0
  fi

  log "Installing and starting OpenClaw gateway service"
  run_cmd openclaw gateway install
  run_cmd openclaw gateway start
}

verify_workspace_scaffold() {
  local required_files=(
    "$WORKSPACE/AGENTS.md"
    "$WORKSPACE/SOUL.md"
    "$WORKSPACE/USER.md"
    "$WORKSPACE/HEARTBEAT.md"
    "$WORKSPACE/MEMORY.md"
    "$WORKSPACE/TOOLS.md"
    "$WORKSPACE/INSTALL-NEXT-STEPS.md"
    "$WORKSPACE/documents/templates/proposal.md"
  )

  local path
  for path in "${required_files[@]}"; do
    [[ -e "$path" ]] || die "Final verification failed; missing expected path: $path"
  done

  [[ -d "$WORKSPACE/skills/email-assistant" ]] || die "Final verification failed; missing email-assistant skill"
  [[ -d "$WORKSPACE/skills/calendar-assistant" ]] || die "Final verification failed; missing calendar-assistant skill"

  log "Workspace scaffold verified"
}

final_check() {
  log "Final check"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ "$NO_SERVICE" -eq 1 ]]; then
      echo "[dry-run] verify workspace scaffold at $WORKSPACE"
    else
      echo "[dry-run] openclaw gateway status"
      echo "[dry-run] openclaw status"
    fi
    return 0
  fi

  if [[ "$NO_SERVICE" -eq 1 ]]; then
    verify_workspace_scaffold
    return 0
  fi

  openclaw gateway status || warn "Gateway status check reported an issue"
  openclaw status || warn "OpenClaw status reported an issue"
}

run_demo_mode() {
  [[ -x "$DEMO_SETUP_SCRIPT" ]] || die "Demo setup script not found: $DEMO_SETUP_SCRIPT"
  run_cmd bash "$DEMO_SETUP_SCRIPT"
}

run_demo_teardown() {
  [[ -x "$DEMO_TEARDOWN_SCRIPT" ]] || die "Demo teardown script not found: $DEMO_TEARDOWN_SCRIPT"
  run_cmd bash "$DEMO_TEARDOWN_SCRIPT"
}

main() {
  parse_args "$@"

  if [[ "$RUN_DEMO" -eq 1 && "$RUN_DEMO_TEARDOWN" -eq 1 ]]; then
    die "Use only one of --demo or --demo-teardown"
  fi

  if [[ "$RUN_DEMO" -eq 1 ]]; then
    run_demo_mode
    exit 0
  fi

  if [[ "$RUN_DEMO_TEARDOWN" -eq 1 ]]; then
    run_demo_teardown
    exit 0
  fi

  check_prereqs
  check_repo_assets
  ensure_openclaw
  run_openclaw_setup
  ensure_ollama
  ensure_model
  scaffold_workspace
  write_next_steps
  setup_service
  final_check

  log "Install pass complete"
  log "Workspace: $WORKSPACE"
  log "Next: review $WORKSPACE/INSTALL-NEXT-STEPS.md"
}

main "$@"
