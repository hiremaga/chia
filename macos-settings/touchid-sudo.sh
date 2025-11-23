# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Configuring Touch ID for sudo..."

# Check if Touch ID hardware is available
if ! bioutil -r -s > /dev/null 2>&1; then
    log "Touch ID hardware not available, skipping setup"
    return 0
fi

# macOS Sequoia 15.0+ uses /etc/pam.d/sudo_local which persists across updates
PAM_TID_LINE="auth       sufficient     pam_tid.so"

if ! grep -q "pam_tid.so" /etc/pam.d/sudo_local 2>/dev/null; then
    run_with_logging "Enabling Touch ID for sudo" \
        bash -c "echo '$PAM_TID_LINE' | sudo tee /etc/pam.d/sudo_local > /dev/null"
else
    log "✓ Touch ID already enabled for sudo"
fi
