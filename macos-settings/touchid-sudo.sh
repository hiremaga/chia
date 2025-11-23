# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Configuring Touch ID for sudo..."

# Check if Touch ID hardware is available
if ! bioutil -r -s > /dev/null 2>&1; then
    log "Touch ID hardware not available, skipping setup"
    return 0
fi

# Modern macOS (Sonoma 14.0+) uses /etc/pam.d/sudo_local which persists across updates
# Older macOS versions require modifying /etc/pam.d/sudo directly
PAM_TID_LINE="auth       sufficient     pam_tid.so"

if [[ -f /etc/pam.d/sudo_local ]]; then
    # Modern approach - use sudo_local (persists across OS updates)
    if ! grep -q "pam_tid.so" /etc/pam.d/sudo_local 2>/dev/null; then
        log "Enabling Touch ID via /etc/pam.d/sudo_local..."
        echo "$PAM_TID_LINE" | sudo tee /etc/pam.d/sudo_local > /dev/null
        log "✓ Touch ID enabled for sudo (will persist across updates)"
    else
        log "✓ Touch ID already enabled via /etc/pam.d/sudo_local"
    fi
else
    # Legacy approach - modify /etc/pam.d/sudo directly
    if ! grep -q "pam_tid.so" /etc/pam.d/sudo 2>/dev/null; then
        log "Enabling Touch ID via /etc/pam.d/sudo..."
        # Create a backup
        sudo cp /etc/pam.d/sudo /etc/pam.d/sudo.backup
        # Add pam_tid.so as the first auth line
        sudo sed -i '' '1a\
'"$PAM_TID_LINE"'
' /etc/pam.d/sudo
        log "✓ Touch ID enabled for sudo"
        log "⚠ Note: This may be reset by macOS updates. Consider upgrading to macOS Sonoma or later."
    else
        log "✓ Touch ID already enabled via /etc/pam.d/sudo"
    fi
fi

log "You can now use Touch ID instead of typing your password for sudo commands!"
