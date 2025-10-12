# Chia - Modern macOS Developer Workstation Setup

A lightweight, fast shell setup tool that seeds a healthy macOS development environment. Modern configuration without framework overhead.

## 🚀 Quick Start

### First Time Setup (Remote)

```bash
curl https://raw.githubusercontent.com/hiremaga/chia/master/chia.sh | bash
```

### Local Updates

```bash
cd ~/workspace/chia
bash chia.sh
```

### Verbose Mode (Debugging)

```bash
CHIA_VERBOSE=true bash chia.sh
```

## ✨ Features

### Modern Shell Configuration
- **No Oh My Zsh**: Native Zsh with modern tools
- **Starship Prompt**: Fast, customizable cross-shell prompt
- **Smart Plugins**: Homebrew-managed zsh plugins
  - autosuggestions
  - syntax-highlighting
  - history-substring-search

### Modern CLI Tools
- **eza**: Modern `ls` replacement with colors and icons
- **fzf**: Fuzzy finder for files, history, and more
- **direnv**: Directory-specific environment variables
- **starship**: Beautiful, minimal prompt

### Developer Tools
- Multiple language runtimes (Go, Python, Ruby, Node.js, Rust)
- Version managers (chruby, nvm)
- Git with enhanced configuration
- Modern terminal (Ghostty)
- Development IDEs (VS Code, Zed)

### macOS Applications
- Rectangle (window management)
- Docker
- Slack, Discord
- Spotify
- Chrome
- And more...

## 📁 Structure

```
chia/
├── chia.sh              # Main setup script
├── Brewfile             # Package definitions
├── common/
│   └── utils.sh         # Shared utilities
├── zsh/
│   ├── .zshrc           # Shell configuration
│   └── .zshenv          # Environment variables
├── git/
│   └── .gitconfig       # Git configuration
├── macos-settings/      # System preferences
└── macos-tools/         # Tool installers
```

## 🔧 Configuration Files

### Zsh Configuration

**`.zshenv`** (Environment & PATH)
- Homebrew setup
- Language runtime paths (Go, Python, Rust)
- Editor preferences

**`.zshrc`** (Interactive Shell)
- History configuration (10,000 entries, deduplication)
- Key bindings (Emacs-style)
- Plugin loading (syntax highlighting, autosuggestions)
- Tool integrations (fzf, direnv, chruby, nvm)
- Modern aliases (eza-based)
- Starship prompt initialization

### Git Configuration

**`.gitconfig`**
- Useful aliases (`st`, `ci`, `co`, `lol`)
- Enhanced `git lol` with colors and relative dates
- SSH push URLs for GitHub
- LFS support

## 🛠️ Manual Customization

### Homebrew Packages

Edit `Brewfile` to add/remove packages:

```ruby
# Add a new CLI tool
brew 'ripgrep'

# Add a new application
cask 'iterm2'
```

Then run:
```bash
brew bundle install
brew bundle cleanup -f  # Remove packages not in Brewfile
```

### Zsh Configuration

Edit configuration files:
```bash
vim ~/workspace/chia/zsh/.zshrc    # Shell behavior
vim ~/workspace/chia/zsh/.zshenv   # Environment variables
```

Apply changes:
```bash
cd ~/workspace/chia
stow -R -t $HOME zsh  # Restow to update symlinks
source ~/.zshrc       # Reload configuration
```

### Starship Prompt

Customize the prompt:
```bash
mkdir -p ~/.config
starship preset nerd-font-symbols > ~/.config/starship.toml
# Edit ~/.config/starship.toml to customize
```

## 🔄 Migration from Oh My Zsh

This setup replaces Oh My Zsh with native Zsh + modern tools:

| Oh My Zsh | Modern Replacement |
|-----------|-------------------|
| robbyrussell theme | Starship prompt |
| git plugin | Native git completion |
| chruby plugin | Homebrew chruby + sourcing |
| nvm plugin | Homebrew nvm + sourcing |
| history-substring-search | Homebrew package + bindkeys |
| rust plugin | Native cargo (not needed) |
| gcloud plugin | Direct gcloud CLI |

### Benefits
- **Faster startup**: No framework overhead (~50-100ms faster)
- **Simpler**: Direct configuration, easy to understand
- **Modern**: Latest tools and best practices
- **Maintainable**: No git submodules, cleaner structure

## 📦 System Requirements

- macOS (Apple Silicon or Intel)
- Xcode (full installation, not just command line tools)
- Administrative privileges

## 🐛 Troubleshooting

### Plugins Not Working

Check if Homebrew packages are installed:
```bash
brew list | grep zsh
```

Should show:
- zsh-autosuggestions
- zsh-syntax-highlighting
- zsh-history-substring-search

### Starship Not Showing

Verify installation:
```bash
which starship
starship --version
```

### Path Issues

Check your PATH in order:
```bash
echo $PATH | tr ':' '\n'
```

Homebrew should be early in the path (`/opt/homebrew/bin`).

## 📚 Additional Resources

- [Starship Documentation](https://starship.rs/)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Homebrew Documentation](https://docs.brew.sh/)

## 🤝 Contributing

This is a personal configuration repository, but feel free to fork and adapt to your needs!

## 📝 License

MIT License - Use freely for your own workstation setup
