#!/usr/bin/env bash

# install-rust.sh - Install or update Rust and common tools
# Improved version with error handling, logging, and tool installation

set -e  # Exit immediately if a command exits with a non-zero status

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

# Define default tools to install (can be overridden by environment variable)
DEFAULT_TOOLS="cargo-edit cargo-update cargo-watch dioxus-cli"
RUST_TOOLS=${RUST_TOOLS:-$DEFAULT_TOOLS}

# Define default components to install via rustup
DEFAULT_COMPONENTS="clippy rustfmt"
RUST_COMPONENTS=${RUST_COMPONENTS:-$DEFAULT_COMPONENTS}



# Install Rust using rustup
install_rust() {
    run_with_logging "Installing Rust" sh -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # Make sure cargo is in the PATH for the current session
    source "$HOME/.cargo/env"
}

# Update Rust if already installed
update_rust() {
    run_with_logging "Updating Rust" rustup update
    if [ $? -ne 0 ]; then
        exit 1
    fi
}

# Install specified Rust tools
install_tools() {
    if [ -z "$RUST_TOOLS" ]; then
        return 0
    fi

    log "Installing Rust tools..."
    for tool in $RUST_TOOLS; do
        if cargo install --list | grep -q "$tool"; then
            # If cargo-update is installed, use it to update the tool
            if [ "$tool" != "cargo-update" ] && command_exists cargo-install-update; then
                run_with_logging "Updating $tool" cargo install-update "$tool" || log "Warning: Failed to update $tool"
            fi
        else
            run_with_logging "Installing $tool" cargo install "$tool" || log "Warning: Failed to install $tool"
        fi
    done
}

# Install specified Rust components via rustup
install_components() {
    if [ -z "$RUST_COMPONENTS" ]; then
        return 0
    fi

    log "Installing Rust components..."
    for component in $RUST_COMPONENTS; do
        if ! rustup component list | grep -q "$component[^-].*installed"; then
            run_with_logging "Installing $component" rustup component add "$component" || log "Warning: Failed to install $component"
        fi
    done
}

main() {
    if command_exists rustup; then
        log "Rust is already installed"

        # Check if rustc is installed and working
        if command_exists rustc; then
            update_rust
        else
            log "Rustup is installed but rustc is not working. Reinstalling Rust..."
            install_rust
        fi
    else
        log "Installing Rust..."
        install_rust
    fi

    # Install common tools
    install_tools

    # Install rustup components
    install_components

    log "Rust setup completed"
}

# Run the main function
main
