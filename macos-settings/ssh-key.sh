# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

if [ -f ~/.ssh/id_rsa ]; then
    log "SSH key already exists"
else
    run_with_logging "Generating SSH key" ssh-keygen -t rsa -N '' || log "Warning: Failed to generate SSH key"
fi
