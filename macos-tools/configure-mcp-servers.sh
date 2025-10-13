#!/usr/bin/env bash

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

set -e

log "Configuring MCP servers..."

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    handle_error "Claude CLI not found. Cannot configure MCP servers."
fi

# Check if chrome-devtools MCP server is already configured
if claude mcp list 2>/dev/null | grep -q "chrome-devtools"; then
    log "Chrome DevTools MCP server already configured - skipping"
else
    run_with_logging "Adding Chrome DevTools MCP server" \
        claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
fi
