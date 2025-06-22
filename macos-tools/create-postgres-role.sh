# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

if ! run_quiet psql -U postgres -c '\q'; then
    run_with_logging "Creating postgres superuser" createuser -s postgres || log "Warning: Failed to create postgres superuser"
else
    log "PostgreSQL superuser already exists"
fi
