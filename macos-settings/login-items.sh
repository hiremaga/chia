#!/bin/bash

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

function login_item {
    if [ ! -d "$1" ]; then
        log "Warning: Application not found at $1"
        return 1
    fi
    run_quiet osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$1\", hidden:false}"
}

log "Configuring login items..."
login_item "/Applications/Google Drive.app"
login_item "/Applications/Flycut.app"
login_item "/Applications/Rectangle.app"
