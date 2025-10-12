# ============================================================================
# Modern Zsh Configuration (No Oh My Zsh)
# ============================================================================

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
fi

# ----------------------------------------------------------------------------
# Completion System
# ----------------------------------------------------------------------------
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
fi

# Autosuggestions
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ----------------------------------------------------------------------------
# Tool Integrations
# ----------------------------------------------------------------------------

# chruby - Ruby version management
if [ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

# nvm - Node version management
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
fi
if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
    source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

# direnv - Directory-specific environment variables
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# FZF - Fuzzy finder
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
elif command -v fzf &> /dev/null; then
    # Set up fzf key bindings and completion if installed via Homebrew
    eval "$(fzf --zsh)"
fi

# GitHub CLI completion
if command -v gh &> /dev/null; then
    eval "$(gh completion -s zsh)"
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
# Initialize Starship prompt (must be at the end)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi
