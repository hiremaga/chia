#!/bin/bash

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

function login_item {
    if [ ! -d "$1" ]; then
        log "Warning: Application not found at $1"
        return 1
    fi

    # Use gtimeout from coreutils to prevent hanging (10 second timeout)
    if ! gtimeout 10 osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$1\", hidden:false}" 2>/dev/null; then
        log "Warning: Could not add login item (may need System Events permissions): $(basename "$1")"
    fi
}

log "Configuring login items..."
log "Note: This may require granting Terminal/iTerm automation permissions in System Settings > Privacy & Security > Automation"

login_item "/Applications/Google Drive.app"
login_item "/Applications/Flycut.app"
login_item "/Applications/Rectangle.app"

log "Login items configuration completed"
