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

# History substring search (requires zsh-history-substring-search from Homebrew)
if [ -f /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
    bindkey '^[[A' history-substring-search-up      # Up arrow
    bindkey '^[[B' history-substring-search-down    # Down arrow
else
    warn_missing "zsh-history-substring-search" "Add to Brewfile and run chia.sh"
fi

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

# Added by Antigravity
export PATH="/Users/hiremaga/.antigravity/antigravity/bin:$PATH"
