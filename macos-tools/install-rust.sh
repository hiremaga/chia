#!/usr/bin/env bash

# install-rust.sh - Install or update Rust and common tools
# Improved version with error handling, logging, and tool installation

set -e  # Exit immediately if a command exits with a non-zero status

# Define color codes for logging
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define default tools to install (can be overridden by environment variable)
DEFAULT_TOOLS="cargo-edit cargo-update cargo-watch"
RUST_TOOLS=${RUST_TOOLS:-$DEFAULT_TOOLS}

# Define default components to install via rustup
DEFAULT_COMPONENTS="clippy rustfmt"
RUST_COMPONENTS=${RUST_COMPONENTS:-$DEFAULT_COMPONENTS}

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Rust using rustup
install_rust() {
    log_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [ $? -ne 0 ]; then
        log_error "Failed to install Rust"
        exit 1
    fi
    log_info "Rust installed successfully"
    
    # Make sure cargo is in the PATH for the current session
    source "$HOME/.cargo/env"
}

# Update Rust if already installed
update_rust() {
    log_info "Updating Rust..."
    rustup update
    if [ $? -ne 0 ]; then
        log_error "Failed to update Rust"
        exit 1
    fi
    log_info "Rust updated successfully"
}

# Install specified Rust tools
install_tools() {
    if [ -z "$RUST_TOOLS" ]; then
        log_info "No tools specified for installation"
        return 0
    fi
    
    log_info "Installing Rust tools: $RUST_TOOLS"
    for tool in $RUST_TOOLS; do
        if cargo install --list | grep -q "$tool"; then
            log_info "$tool is already installed, checking for updates..."
            # If cargo-update is installed, use it to update the tool
            if [ "$tool" != "cargo-update" ] && command_exists cargo-install-update; then
                cargo install-update "$tool"
            fi
        else
            log_info "Installing $tool..."
            cargo install "$tool"
            if [ $? -ne 0 ]; then
                log_warn "Failed to install $tool, continuing with other tools"
            else
                log_info "$tool installed successfully"
            fi
        fi
    done
}

# Install specified Rust components via rustup
install_components() {
    if [ -z "$RUST_COMPONENTS" ]; then
        log_info "No components specified for installation"
        return 0
    fi
    
    log_info "Installing Rust components: $RUST_COMPONENTS"
    for component in $RUST_COMPONENTS; do
        if rustup component list | grep -q "$component[^-].*installed"; then
            log_info "$component is already installed"
        else
            log_info "Installing $component..."
            rustup component add "$component"
            if [ $? -ne 0 ]; then
                log_warn "Failed to install $component, continuing with other components"
            else
                log_info "$component installed successfully"
            fi
        fi
    done
}

main() {
    log_info "Starting Rust installation/update process..."
    
    if command_exists rustup; then
        log_info "Rustup is already installed"
        
        # Check if rustc is installed and working
        if command_exists rustc; then
            current_version=$(rustc --version | cut -d' ' -f2)
            log_info "Current Rust version: $current_version"
            update_rust
        else
            log_warn "Rustup is installed but rustc is not working. Reinstalling Rust..."
            install_rust
        fi
    else
        log_info "Rustup not found, installing Rust..."
        install_rust
    fi
    
    # Install common tools
    install_tools
    
    # Install rustup components
    install_components
    
    log_info "Rust setup completed successfully!"
}

# Run the main function
main