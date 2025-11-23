#!/bin/bash -e

# Disable debug mode that might be inherited
set +x

# Determine if this is a first run (bootstrap mode)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOTSTRAP_MODE=false

if [[ ! -f "$SCRIPT_DIR/common/utils.sh" ]]; then
    BOOTSTRAP_MODE=true

    # Barebones bootstrap utilities - only what's needed before utils.sh exists
    log() {
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
    }

    handle_error() {
        log "Error: $1"
        exit 1
    }

    command_exists() {
        command -v "$1" >/dev/null 2>&1
    }

    run_with_logging() {
        local description="$1"
        shift
        log "$description"
        "$@" 2>&1 || handle_error "Failed: $description"
    }

    log ""
    log "========================================="
    log "Welcome to Chia - macOS Developer Setup"
    log "========================================="
    log ""
    log "This script will set up your Mac for development by:"
    log "  • Installing Xcode (if not already installed)"
    log "  • Setting up SSH keys for GitHub"
    log "  • Installing Homebrew and essential tools"
    log "  • Configuring your shell environment"
    log "  • Installing development tools and applications"
    log ""
else
    # Normal mode - source the full utilities
    source "$SCRIPT_DIR/common/utils.sh"

    # Show usage tip if not in verbose mode
    if ! is_verbose; then
        print_verbose_usage
    fi
fi

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
log "Closing System Preferences..."
osascript -e 'tell application "System Preferences" to quit' || true

# Ask for the administrator password upfront
log "Requesting sudo access..."
sudo -v || handle_error "Failed to get sudo access"
# Keep-alive: update existing sudo time stamp until the script has finished
while true; do
    sudo -n true
    sleep 30
    kill -0 "$$" || exit
done 2>/dev/null &

# Store the PID of the background keep-alive process
SUDO_KEEPALIVE_PID=$!

# Trap to clean up the background process
trap 'kill $SUDO_KEEPALIVE_PID 2>/dev/null || true' EXIT

# ==========================================
# XCODE SETUP
# ==========================================
log ""
log "Checking Xcode installation..."

if ! command_exists xcode-select; then
    handle_error "xcode-select not found. This is unexpected on macOS."
fi

# Check if Xcode is properly installed
XCODE_PATH=$(xcode-select -p 2>/dev/null || echo "")

if [[ "$XCODE_PATH" != "/Applications/Xcode.app/Contents/Developer" ]]; then
    log ""
    log "========================================="
    log "XCODE INSTALLATION REQUIRED"
    log "========================================="
    log ""
    log "A full Xcode installation is required (not just Command Line Tools)."
    log "This is needed for Flutter, hyperkit, and other development tools."
    log ""
    log "Please follow these steps:"
    log ""
    log "  1. Open the App Store application"
    log "  2. Search for 'Xcode'"
    log "  3. Click 'Get' or 'Install' (this may take 30-60 minutes)"
    log "  4. After installation, open Xcode once to accept the license"
    log "  5. When Xcode opens, you may close it"
    log ""
    log "After Xcode is installed and opened once, run this script again:"
    log "  curl https://raw.githubusercontent.com/hiremaga/chia/master/chia.sh | bash"
    log ""
    exit 0
fi

log "✓ Xcode is properly installed at: $XCODE_PATH"

# Accept Xcode license if not already accepted
if ! sudo xcodebuild -license check 2>/dev/null; then
    log ""
    log "Xcode license needs to be accepted..."
    sudo xcodebuild -license accept || handle_error "Failed to accept Xcode license"
fi

# ==========================================
# SSH KEY SETUP
# ==========================================
log ""
log "Checking SSH key configuration..."

SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
SSH_PUB_KEY_PATH="$SSH_KEY_PATH.pub"

if [[ ! -f "$SSH_KEY_PATH" ]]; then
    log ""
    log "========================================="
    log "SSH KEY GENERATION"
    log "========================================="
    log ""
    log "No SSH key found. An SSH key is needed to:"
    log "  • Clone repositories from GitHub"
    log "  • Push code changes"
    log "  • Authenticate with remote servers"
    log ""

    read -p "Would you like to generate an SSH key now? [Y/n]: " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        log ""
        read -p "Enter your email address for the SSH key: " email

        if [[ -z "$email" ]]; then
            handle_error "Email address is required for SSH key generation"
        fi

        log "Generating SSH key..."
        ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY_PATH" -N "" || handle_error "Failed to generate SSH key"

        log ""
        log "✓ SSH key generated successfully!"
        log ""
        log "========================================="
        log "ADD SSH KEY TO GITHUB"
        log "========================================="
        log ""
        log "Your public SSH key is:"
        log ""
        cat "$SSH_PUB_KEY_PATH"
        log ""
        log "To add this key to GitHub:"
        log ""
        log "  1. Copy the key above (it's also in your clipboard)"
        log "  2. Go to: https://github.com/settings/ssh/new"
        log "  3. Paste the key and give it a title (e.g., 'My MacBook')"
        log "  4. Click 'Add SSH key'"
        log ""

        # Copy to clipboard if possible
        if command_exists pbcopy; then
            cat "$SSH_PUB_KEY_PATH" | pbcopy
            log "(Key copied to clipboard)"
            log ""
        fi

        # Start ssh-agent and add key
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add "$SSH_KEY_PATH" 2>/dev/null || true

        read -p "Press Enter when you've added the key to GitHub to continue..."
        echo
    else
        log ""
        log "Skipping SSH key generation."
        log "Note: You may encounter issues cloning the chia repository."
        log ""
    fi
elif [[ -f "$SSH_PUB_KEY_PATH" ]]; then
    log "✓ SSH key found at: $SSH_KEY_PATH"

    # Ensure ssh-agent is running and key is added
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add "$SSH_KEY_PATH" 2>/dev/null || true
else
    log "⚠ SSH private key exists but public key is missing"
    log "You may need to regenerate your SSH key pair"
fi

# ==========================================
# SYSTEM SETUP
# ==========================================
log ""
log "Starting system setup..."

run_with_logging "Checking for system updates" softwareupdate -l || log "No system updates available"

if ! command_exists brew; then
    run_with_logging "Installing Homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# First run? Clone the repository
if [ ! -d ~/workspace/chia ]; then
    log ""
    log "Setting up workspace..."
    mkdir -p ~/workspace
    pushd ~/workspace > /dev/null
        # Try SSH first, fall back to HTTPS if it fails
        if ! git clone git@github.com:hiremaga/chia.git --recurse-submodules 2>/dev/null; then
            log "SSH clone failed, trying HTTPS..."
            git clone https://github.com/hiremaga/chia.git --recurse-submodules || handle_error "Failed to clone repository"
        fi
    popd > /dev/null

    # If we were in bootstrap mode, re-exec from the cloned location
    if [[ "$BOOTSTRAP_MODE" == "true" ]]; then
        log ""
        log "Repository cloned successfully!"
        log "Re-running from cloned location..."
        log ""
        exec bash ~/workspace/chia/chia.sh
    fi
fi

pushd ~/workspace/chia > /dev/null
    run_with_logging "Cleaning up old Homebrew packages" brew bundle cleanup -f || log "Warning: Homebrew cleanup failed"

    if [[ $(arch) == 'arm64' ]]; then
        run_with_logging "Installing Homebrew packages" arch -arm64 brew bundle install || handle_error "Failed to install Homebrew packages"
    else
        run_with_logging "Installing Homebrew packages" brew bundle install || handle_error "Failed to install Homebrew packages"
    fi

    # Install modern dotfiles with Stow
    log "Installing dotfiles..."
    run_with_logging "Installing zsh configuration" stow -t $HOME zsh || handle_error "Failed to install zsh configuration"
    run_with_logging "Installing git configuration" stow -t $HOME git || handle_error "Failed to install git configuration"
    run_with_logging "Installing ruby configuration" stow -t $HOME ruby || handle_error "Failed to install ruby configuration"

    # Source the new environment
    run_quiet source $HOME/.zshenv || true

    log "Configuring macOS settings..."
    set +x; source macos-settings/00-everything.sh || handle_error "Failed to install settings"

    log "Installing development tools..."
    set +x; source macos-tools/00-everything.sh || handle_error "Failed to install tools"
popd > /dev/null

log "Setup completed successfully!"

# Cleanup any temporary files
cleanup_temp_files
