autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

export PATH="$PATH:$HOME/workspace/flutter/bin"
export PATH="/usr/local/opt/node@14/bin:$PATH"

alias nproc="sysctl -n hw.logicalcpu"

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
