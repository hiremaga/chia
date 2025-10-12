# ============================================================================
# Zsh Environment Configuration
# ============================================================================
# This file is sourced for all shells (login, interactive, and non-interactive)
# Use it for environment variables and PATH setup

# ----------------------------------------------------------------------------
# Homebrew Setup
# ----------------------------------------------------------------------------
# Set up Homebrew environment variables so the 'brew' command and installed
# packages are available in this shell. This is especially important for
# Apple Silicon Macs where Homebrew is installed in /opt/homebrew.
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ----------------------------------------------------------------------------
# PATH Configuration
# ----------------------------------------------------------------------------

# Go workspace and binaries
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Python user-local binaries (pipx)
export PATH=$PATH:$HOME/.local/bin

# Rust/Cargo binaries
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH=$HOME/.cargo/bin:$PATH
fi

# ----------------------------------------------------------------------------
# Tool-Specific Environment Variables
# ----------------------------------------------------------------------------

# Preferred editor
export EDITOR='vim'
export VISUAL='vim'

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
