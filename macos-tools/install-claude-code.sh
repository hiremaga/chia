#!/usr/bin/env bash

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

set -eo pipefail # without `pipefail`, a failed `curl` could be
                 # masked by `bash` successfully processing empty input.
install_claude_code() {
    curl -fsSL https://claude.ai/install.sh | bash
}

# Install Claude Code CLI if not already installed
if [[ ! -x "$HOME/.local/bin/claude" ]]; then
    run_with_logging "Installing Claude Code CLI" install_claude_code
else
    log "Claude Code already installed - skipping"
fi

# MCP Servers
log "Configuring MCP servers..."

if claude mcp list 2>/dev/null | grep -q "chrome-devtools"; then
    log "Chrome DevTools MCP server already configured - skipping"
else
    run_with_logging "Adding Chrome DevTools MCP server" \
        claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
fi
