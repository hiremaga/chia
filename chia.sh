#!/bin/bash -e

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to handle errors
handle_error() {
    log "Error: $1"
    exit 1
}

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
log "Closing System Preferences..."
osascript -e 'tell application "System Preferences" to quit' || true

# Ask for the administrator password upfront
log "Requesting sudo access..."
sudo -v || handle_error "Failed to get sudo access"

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Table stakes
if [[ $(xcode-select -p) != '/Applications/Xcode.app/Contents/Developer' ]]; then
    handle_error "Please install XCode from the app store before running this script. A full XCode install is required for Flutter, hyperkit etc. Command-line tools is insufficient."
fi

log "Checking for system updates..."
softwareupdate -a -i true || log "Warning: System update check failed"

if ! which brew; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# First run?
if [ ! -d ~/workspace/chia ]; then
    log "Setting up workspace..."
    mkdir -p ~/workspace
    pushd ~/workspace
        git clone https://github.com/hiremaga/chia.git --recurse-submodules || handle_error "Failed to clone repository"
    popd
fi

pushd ~/workspace/chia
    log "Cleaning up old Homebrew packages..."
    brew bundle cleanup -f || log "Warning: Homebrew cleanup failed"

    log "Installing Homebrew packages..."
    if [[ $(arch) == 'arm64' ]]; then
        arch -arm64 brew bundle install || handle_error "Failed to install Homebrew packages"
    else
        brew bundle install || handle_error "Failed to install Homebrew packages"
    fi

    log "Installing dotfiles..."
    stow -t $HOME dotfiles || handle_error "Failed to install dotfiles"
    source $HOME/.zprofile || log "Warning: Failed to source .zprofile"
    log "Installed dotfiles."

    log "Installing settings..."
    source macos-settings/00-everything.sh || handle_error "Failed to install settings"
    log "Installed settings."

    log "Installing tools..."
    source macos-tools/00-everything.sh || handle_error "Failed to install tools"
    log "Installed tools."
popd

log "Setup completed successfully!"
