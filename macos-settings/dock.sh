# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Configuring Dock settings..."
run_quiet defaults write com.apple.dock autohide -bool true
run_quiet defaults write com.apple.dock persistent-apps -array
run_quiet killall Dock
