#!/bin/bash -e

# Disable debug mode that might be inherited
set +x

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common/utils.sh"

# Show usage tip if not in verbose mode
if ! is_verbose; then
    print_verbose_usage
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

# Table stakes
if [[ $(xcode-select -p) != '/Applications/Xcode.app/Contents/Developer' ]]; then
    handle_error "Please install XCode from the app store before running this script. A full XCode install is required for Flutter, hyperkit etc. Command-line tools is insufficient."
fi

run_with_logging "Checking for system updates" softwareupdate -l || log "No system updates available"

if ! command_exists brew; then
    run_with_logging "Installing Homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# First run?
if [ ! -d ~/workspace/chia ]; then
    log "Setting up workspace..."
    mkdir -p ~/workspace
    pushd ~/workspace > /dev/null
        git clone https://github.com/hiremaga/chia.git --recurse-submodules || handle_error "Failed to clone repository"
    popd > /dev/null
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
