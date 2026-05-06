#!/usr/bin/env bash
#
# Kodra macOS — State Management
#

KODRA_STATE_FILE="${KODRA_STATE_DIR:-$HOME/.local/state/kodra}/state.json"

# Initialize state file if needed
init_state() {
    local dir
    dir="$(dirname "$KODRA_STATE_FILE")"
    mkdir -p "$dir"
    if [[ ! -f "$KODRA_STATE_FILE" ]]; then
        echo '{}' > "$KODRA_STATE_FILE"
    fi
}

# Save a key-value pair to state
save_state() {
    local key="$1"
    local value="$2"
    init_state

    # Use Python for JSON manipulation (always available on macOS)
    python3 -c "
import json, sys
with open('$KODRA_STATE_FILE', 'r') as f:
    data = json.load(f)
data['$key'] = '$value'
with open('$KODRA_STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# Read a value from state
read_state() {
    local key="$1"
    local default="${2:-}"
    init_state

    python3 -c "
import json
with open('$KODRA_STATE_FILE', 'r') as f:
    data = json.load(f)
print(data.get('$key', '$default'))
"
}

# Check if a tool is installed according to state
is_tool_installed() {
    local tool="$1"
    local status
    status="$(read_state "tool.$tool" "not_installed")"
    [[ "$status" == "installed" ]]
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Resume infrastructure
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Mark a step as complete
mark_step_complete() {
    local step="$1"
    save_state "steps.${step}" "complete"
}

# Check if a step is complete
is_step_complete() {
    local step="$1"
    local status
    status="$(read_state "steps.${step}" "pending")"
    [[ "$status" == "complete" ]]
}

# Mark a step as failed with a message
mark_step_failed() {
    local step="$1"
    local msg="${2:-unknown error}"
    save_state "steps.${step}" "failed:${msg}"
}

# List all steps with "failed:" prefix
get_failed_steps() {
    init_state
    python3 -c "
import json
with open('${KODRA_STATE_FILE}', 'r') as f:
    data = json.load(f)
for k, v in data.items():
    if k.startswith('steps.') and isinstance(v, str) and v.startswith('failed:'):
        print(k.replace('steps.', '', 1) + '|' + v)
"
}

# List all steps not marked complete or failed
get_pending_steps() {
    init_state
    python3 -c "
import json
with open('${KODRA_STATE_FILE}', 'r') as f:
    data = json.load(f)
for k, v in data.items():
    if k.startswith('steps.') and v != 'complete' and not (isinstance(v, str) and v.startswith('failed:')):
        print(k.replace('steps.', '', 1))
"
}

# Find first non-complete step
get_resume_point() {
    init_state
    python3 -c "
import json
with open('${KODRA_STATE_FILE}', 'r') as f:
    data = json.load(f)
for k, v in sorted(data.items()):
    if k.startswith('steps.') and v != 'complete':
        print(k.replace('steps.', '', 1))
        break
"
}

# Remove state file entirely
clear_state() {
    if [[ -f "$KODRA_STATE_FILE" ]]; then
        rm -f "$KODRA_STATE_FILE"
    fi
}

# Print summary of steps
show_state_summary() {
    init_state
    python3 -c "
import json
with open('${KODRA_STATE_FILE}', 'r') as f:
    data = json.load(f)
complete = 0
failed = 0
pending = 0
for k, v in data.items():
    if not k.startswith('steps.'):
        continue
    if v == 'complete':
        complete += 1
    elif isinstance(v, str) and v.startswith('failed:'):
        failed += 1
    else:
        pending += 1
total = complete + failed + pending
if total == 0:
    print('No steps recorded')
else:
    print(f'Steps: {complete} complete, {failed} failed, {pending} pending (total: {total})')
"
}

# Get install progress as percentage
get_install_progress() {
    init_state
    python3 -c "
import json
with open('${KODRA_STATE_FILE}', 'r') as f:
    data = json.load(f)
steps = {k: v for k, v in data.items() if k.startswith('steps.')}
total = len(steps)
if total == 0:
    print('0')
else:
    complete = sum(1 for v in steps.values() if v == 'complete')
    print(str(int(complete * 100 / total)))
"
}

# Check if state file exists with pending/failed steps
can_resume() {
    [[ -f "$KODRA_STATE_FILE" ]] || return 1
    local pending
    pending="$(get_pending_steps)"
    local failed
    failed="$(get_failed_steps)"
    [[ -n "$pending" || -n "$failed" ]]
}
