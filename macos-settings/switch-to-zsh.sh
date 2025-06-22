# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

if [[ $(dscl . -read ~/ UserShell) =~ zsh ]]; then
    log "Shell is already zsh"
else
    run_with_logging "Switching to zsh shell" chsh -s /bin/zsh || log "Warning: Failed to switch to zsh"
fi
