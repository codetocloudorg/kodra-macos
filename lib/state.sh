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
