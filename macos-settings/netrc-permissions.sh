# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

# Fix .netrc permissions for security
# CocoaPods and other tools require 0600 permissions because .netrc can contain credentials
if [ -f ~/.netrc ]; then
    current_perms=$(stat -f "%OLp" ~/.netrc)
    if [ "$current_perms" != "600" ]; then
        run_with_logging "Setting secure permissions on ~/.netrc (0600)" chmod 0600 ~/.netrc
    else
        log "~/.netrc already has secure permissions (0600)"
    fi
else
    log "~/.netrc does not exist, skipping"
fi
