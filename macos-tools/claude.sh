#!/usr/bin/env bash

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

set -e

# Check if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    handle_error "Claude CLI not found. Cannot configure Claude."
fi

# MCP Servers
log "Configuring MCP servers..."

if claude mcp list 2>/dev/null | grep -q "chrome-devtools"; then
    log "Chrome DevTools MCP server already configured - skipping"
else
    run_with_logging "Adding Chrome DevTools MCP server" \
        claude mcp add chrome-devtools --scope user npx chrome-devtools-mcp@latest
fi

# Plugins
log "Configuring Claude plugins..."

configure_plugin() {
    local marketplace="$1"
    local plugin="$2"
    local marketplace_name="${marketplace##*/}"

    if ! claude plugin marketplace list 2>/dev/null | grep -q "$marketplace_name"; then
        run_with_logging "Adding marketplace $marketplace_name" \
            claude plugin marketplace add "$marketplace"
    fi

    if claude plugin list 2>/dev/null | grep -q "^  ❯ ${plugin}@"; then
        run_with_logging "Updating plugin $plugin" \
            claude plugin update "${plugin}@${marketplace_name}"
    else
        run_with_logging "Installing plugin $plugin" \
            claude plugin install "$plugin"
    fi
}

configure_plugin "obra/superpowers-marketplace"                    "superpowers"
configure_plugin "obra/superpowers-marketplace"                    "superpowers-chrome"
configure_plugin "obra/superpowers-marketplace"                    "superpowers-developing-for-claude-code"
configure_plugin "obra/superpowers-marketplace"                    "elements-of-style"
configure_plugin "EveryInc/compound-engineering-plugin"            "compound-engineering"
