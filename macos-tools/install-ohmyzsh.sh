# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/utils.sh"

if [ ! -d "$HOME/.oh-my-zsh/.git" ]; then
    run_with_logging "Installing Oh My Zsh" git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh || log "Warning: Failed to install Oh My Zsh"
else
    log "Oh My Zsh already installed"
fi
