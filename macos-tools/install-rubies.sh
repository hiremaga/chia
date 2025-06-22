# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

log "Installing Ruby versions..."
run_with_logging "Installing Ruby 2.7.2" ruby-install ruby 2.7.2 --no-reinstall || log "Warning: Failed to install Ruby 2.7.2"
run_with_logging "Installing Ruby 3.3.4" ruby-install ruby 3.3.4 --no-reinstall || log "Warning: Failed to install Ruby 3.3.4"
