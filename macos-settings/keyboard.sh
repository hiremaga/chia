# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Configuring keyboard settings..."
# Disable press-and-hold for keys in favor of key repeat
run_quiet defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
run_quiet defaults write NSGlobalDomain KeyRepeat -int 1
run_quiet defaults write NSGlobalDomain InitialKeyRepeat -int 10
