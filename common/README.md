# Common Utilities

This directory contains shared utilities used by all chia setup scripts.

## Files

- `utils.sh` - Common functions and utilities for logging, error handling, and command execution

## Usage

Source the utilities file in your script:

```bash
# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"
```

## Available Functions

### Logging

- `log "message"` - Log a message with timestamp
- `handle_error "message"` - Log an error and exit

### Command Execution

- `run_with_logging "description" command args...` - Run command with smart logging
  - Shows description and "completed" message in normal mode
  - Shows full output in verbose mode
  - Shows full output only on failure
  
- `run_quiet command args...` - Run command silently, only show output on failure

- `run_with_progress "description" command args...` - Run command with progress spinner
  - Shows spinning progress indicator for long-running commands
  - Falls back to verbose output in verbose mode

### Utilities

- `command_exists command` - Check if a command exists
- `is_verbose` - Check if running in verbose mode
- `print_verbose_usage` - Show tip about verbose mode
- `cleanup_temp_files` - Clean up old temporary files

## Verbose Mode

Set `CHIA_VERBOSE=true` to see detailed output from all commands:

```bash
CHIA_VERBOSE=true ./chia.sh
```

## Smart Logging Behavior

### Normal Mode (default)
- Shows clean status messages: "Installing Homebrew packages - completed"
- Hides command output unless there's an error
- If a command fails, shows the full error output for debugging

### Verbose Mode (`CHIA_VERBOSE=true`)
- Shows all command output in real-time
- Useful for debugging or understanding what's happening

### Example Output

**Normal mode:**
```
[2025-06-21 18:00:28] Installing Homebrew packages - completed
[2025-06-21 18:00:30] Installing dotfiles - completed
[2025-06-21 18:00:30] Configuring Dock settings...
```

**Verbose mode:**
```
[2025-06-21 18:00:28] Installing Homebrew packages
==> Downloading https://homebrew.bintray.com/bottles/...
==> Installing dependencies for package...
[... full command output ...]
[2025-06-21 18:00:30] Installing dotfiles
[... full stow output ...]
```

**Error scenario:**
```
[2025-06-21 18:00:28] Failed: Installing Homebrew packages
[2025-06-21 18:00:28] Command output:
  Error: Package 'nonexistent-package' not found
  Error: Installation failed
```

## Benefits

1. **Clean output by default** - Users see progress without noise
2. **Full debugging info on failure** - Error output is preserved and shown
3. **Verbose mode available** - Developers can see everything when needed
4. **Consistent across all scripts** - Same behavior everywhere
5. **No information loss** - All output is captured, just shown selectively