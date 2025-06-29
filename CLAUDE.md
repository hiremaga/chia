# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is "chia" - a macOS developer workstation setup tool that seeds a healthy development environment. It's a collection of bash scripts that automate the installation and configuration of development tools, dotfiles, and macOS settings.

## Architecture

### Core Components

- `chia.sh` - Main entry point script that orchestrates the entire setup process
- `common/utils.sh` - Shared utility functions for logging, error handling, and command execution
- `Brewfile` - Homebrew package definitions for applications and CLI tools
- `dotfiles/` - Personal configuration files managed via GNU Stow
- `macos-settings/` - Scripts for configuring macOS system preferences
- `macos-tools/` - Scripts for installing development tools (Node.js, Ruby, Rust, etc.)

### Script Architecture

All scripts follow a common pattern using the shared utilities:
- Smart logging with verbose mode support (`CHIA_VERBOSE=true`)
- Consistent error handling with `handle_error()`
- Command execution wrappers (`run_with_logging`, `run_quiet`, `run_with_progress`)
- Automatic cleanup and sudo keep-alive management

## Development Commands

### Running the Setup

First time setup (remotely):
```bash
curl https://raw.githubusercontent.com/hiremaga/chia/master/chia.sh | bash
```

Subsequent runs (locally):
```bash
cd ~/workspace/chia
bash chia.sh
```

Verbose mode for debugging:
```bash
CHIA_VERBOSE=true bash chia.sh
```

### Homebrew Management

The setup uses a `Brewfile` for package management:
```bash
# Install packages defined in Brewfile
brew bundle install

# Clean up old packages not in Brewfile
brew bundle cleanup -f
```

### Dotfiles Management

Dotfiles are managed using GNU Stow:
```bash
# Install dotfiles to home directory
stow -t $HOME dotfiles

# Remove dotfiles
stow -D -t $HOME dotfiles
```

## Key Design Patterns

### Logging System
The utility functions provide a sophisticated logging system:
- Normal mode: Clean status messages ("Installing X - completed")
- Verbose mode: Full command output in real-time
- Error handling: Always shows full output on failure
- Progress indicators: Spinner for long-running operations

### Error Handling
- All scripts use `set -e` for fail-fast behavior
- Custom `handle_error()` function provides consistent error reporting
- Temporary files are automatically cleaned up
- Sudo keep-alive prevents repeated password prompts

### Modular Design
- Settings and tools are split into separate script categories
- Each category has a `00-everything.sh` orchestrator script
- Individual scripts can be run independently for targeted updates

## Working with Scripts

When modifying scripts in this repository:
- Always source `common/utils.sh` for consistent behavior
- Use `run_with_logging` for commands that should show progress
- Use `run_quiet` for commands where output is not useful
- Test both normal and verbose modes
- Ensure proper error handling with meaningful messages

## Dependencies

### System Requirements
- macOS (tested on Apple Silicon and Intel)
- Xcode (full installation, not just command line tools)
- Administrative privileges

### Installed Tools
The setup installs comprehensive development tooling including:
- Homebrew package manager
- Multiple programming languages (Go, Python, Ruby, Rust, Node.js)
- Development environments (VS Code, Zed, Docker)
- CLI utilities (gh, jq, tree, tmux, etc.)
- macOS applications (Rectangle, Slack, Spotify, etc.)