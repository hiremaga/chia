# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Installing Node.js versions..."

mkdir -p ~/.nvm

source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
run_with_logging "Installing Node.js 22" nvm install 22 || log "Warning: Failed to install Node.js 22"
run_with_logging "Setting Node.js 22 as default" nvm alias default 22 || log "Warning: Failed to set default Node.js version"
