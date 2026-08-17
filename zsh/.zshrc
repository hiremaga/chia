# ============================================================================
# Modern Zsh Configuration (No Oh My Zsh)
# ============================================================================

# ----------------------------------------------------------------------------
# Helper Functions
# ----------------------------------------------------------------------------

# Warn when expected tools are missing
warn_missing() {
    local tool="$1"
    local message="$2"
    echo "⚠️  Warning: $tool not found - $message" >&2
}

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# History options
setopt APPEND_HISTORY           # Append to history file
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_IGNORE_DUPS         # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS     # Delete old duplicates
setopt HIST_FIND_NO_DUPS        # Don't display duplicates in search
setopt HIST_IGNORE_SPACE        # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks
setopt HIST_VERIFY              # Show command with history expansion before running

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
bindkey -e  # Emacs-style key bindings

# Note: Up/Down arrow history search is provided by atuin, initialized at the
# end of this file. It replaced zsh-history-substring-search, which bound the
# same keys and would have fought with it.

# ----------------------------------------------------------------------------
# Completion System
# ----------------------------------------------------------------------------
# Add Homebrew's site-functions to fpath to enable completions.
# This must be done before compinit.
if command -v brew &> /dev/null; then
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu-style completion
zstyle ':completion:*' menu select

# ----------------------------------------------------------------------------
# Plugin Loading (via Homebrew)
# ----------------------------------------------------------------------------

# Syntax highlighting (must be loaded before autosuggestions)
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    warn_missing "zsh-syntax-highlighting" "Add to Brewfile and run chia.sh"
fi

# Autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    warn_missing "zsh-autosuggestions" "Add to Brewfile and run chia.sh"
fi

# ----------------------------------------------------------------------------
# Tool Integrations
# ----------------------------------------------------------------------------

# chruby - Ruby version management
# Sourced directly as it provides core version-switching functionality, not just completions.
if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
else
    warn_missing "chruby" "Add chruby to Brewfile and run chia.sh"
fi

# nvm - Node version management
# nvm is sourced directly to provide its core version-switching functionality.
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
    # It also uses a bash-style completion script that must be sourced manually.
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
else
    warn_missing "nvm" "Add nvm to Brewfile and run chia.sh"
fi

# direnv - Directory-specific environment variables
# `direnv hook zsh` is required to integrate with the shell prompt; it's not just for completions.
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
else
    warn_missing "direnv" "Add direnv to Brewfile and run chia.sh"
fi

# FZF - Fuzzy finder
# eval is used here to set up fzf's key bindings (e.g., Ctrl+R) and completions.
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
else
    warn_missing "fzf" "Add fzf to Brewfile and run chia.sh"
fi

# worktrunk (wt) - Git worktree management
# Shell integration enables `wt` to change directories and provides completions.
if command -v wt &> /dev/null; then
    eval "$(wt config shell init zsh)"
else
    warn_missing "wt" "Add worktrunk to Brewfile and run chia.sh"
fi

# atuin - Shell history in a searchable SQLite database
# Order matters, so this block must stay put:
#   * after fzf, because both bind Ctrl-R and the last one to bind it wins.
#     fzf keeps Ctrl-T (files) and Alt-C (cd); atuin takes Ctrl-R.
#   * after zsh-autosuggestions, because atuin prepends itself to
#     ZSH_AUTOSUGGEST_STRATEGY so suggestions are drawn from its database
#     rather than ~/.zsh_history.
# Binds Ctrl-R (global search), Up arrow (scoped to the current directory via
# filter_mode_shell_up_key_binding), and `?` at the start of a line for
# Atuin AI natural-language search.
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
else
    warn_missing "atuin" "Add atuin to Brewfile and run chia.sh"
fi

# ----------------------------------------------------------------------------
# Modern Aliases (using eza instead of ls)
# ----------------------------------------------------------------------------

# Use eza if available (modern ls replacement)
if command -v eza &> /dev/null; then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias lt='eza --tree'
    alias l='eza -lah'
else
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# Alias nproc to show number of logical CPUs on macOS (Linux compatibility)
alias nproc="sysctl -n hw.logicalcpu"

# ----------------------------------------------------------------------------
# Starship Prompt
# ----------------------------------------------------------------------------
# `starship init zsh` generates the shell prompt and must be evaluated.
# Initialize Starship prompt (must be at the end)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    warn_missing "starship" "Add starship to Brewfile and run chia.sh"
fi
