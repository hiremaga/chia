# Migration Guide: Oh My Zsh → Modern Zsh Setup

This guide helps you migrate from the old Oh My Zsh-based setup to the new lightweight configuration.

## 🎯 What Changed

### Removed
- ❌ Oh My Zsh framework and all its overhead
- ❌ Git submodule for dotfiles
- ❌ `.zprofile` (consolidated into `.zshenv`)
- ❌ `dotfiles/` directory structure

### Added
- ✅ Starship prompt (replaces robbyrussell theme)
- ✅ Modular directory structure (`zsh/`, `git/`)
- ✅ Modern CLI tools (eza, fzf)
- ✅ Homebrew-managed Zsh plugins
- ✅ Native Zsh configuration with better performance
- ✅ JetBrains Mono font

## 📋 Pre-Migration Checklist

Before migrating, backup your current configuration:

```bash
# Backup existing dotfiles
cp ~/.zshrc ~/.zshrc.backup
cp ~/.zprofile ~/.zprofile.backup
cp ~/.zshenv ~/.zshenv.backup 2>/dev/null || true
cp ~/.gitconfig ~/.gitconfig.backup

# Note your current Oh My Zsh plugins
grep "^plugins=" ~/.zshrc
```

## 🔄 Migration Steps

### Step 1: Update Repository

```bash
cd ~/workspace/chia
git pull origin main
```

### Step 2: Remove Old Oh My Zsh Installation

```bash
# Unstow old dotfiles
stow -D -t $HOME dotfiles

# Optionally remove Oh My Zsh (after confirming new setup works)
# rm -rf ~/.oh-my-zsh
```

### Step 3: Install New Packages

```bash
# Install new Homebrew packages
brew bundle install

# This installs:
# - starship (prompt)
# - fzf (fuzzy finder)
# - eza (modern ls)
# - zsh-autosuggestions
# - zsh-syntax-highlighting
# - zsh-history-substring-search
# - font-jetbrains-mono
```

### Step 4: Deploy New Configuration

```bash
cd ~/workspace/chia

# Install new modular dotfiles
stow -t $HOME zsh
stow -t $HOME git

# Verify symlinks were created
ls -la ~ | grep -E '\.zshrc|\.zshenv|\.gitconfig'
```

### Step 5: Start New Shell

```bash
# Start a new shell to load the new configuration
exec zsh

# Verify Starship is active (you should see the new prompt)
echo $STARSHIP_SHELL  # Should output: zsh
```

### Step 6: Set Up FZF Key Bindings

```bash
# Run FZF installation (one-time setup)
$(brew --prefix)/opt/fzf/install

# This enables:
# - Ctrl+R: command history search
# - Ctrl+T: file finder
# - Alt+C: directory navigation
```

## 🧪 Testing Your New Setup

### Test 1: Verify Starship Prompt
```bash
# You should see a colorful, modern prompt
# Try navigating to a git repository to see git status in prompt
cd ~/workspace/chia
```

### Test 2: Test Autosuggestions
```bash
# Start typing a previous command - you should see gray suggestions
# Press → (right arrow) to accept
ls
```

### Test 3: Test Syntax Highlighting
```bash
# Valid commands should be highlighted in green
ls
# Invalid commands should be highlighted in red
lsssss
```

### Test 4: Test History Substring Search
```bash
# Type part of a previous command and press ↑
# Example: type "git" and press up arrow
git
```

### Test 5: Test Modern Aliases
```bash
# Test eza (modern ls)
ls        # Should show colorful output
ll        # Detailed list
la        # All files including hidden
lt        # Tree view

# Test FZF (after setup)
# Press Ctrl+R and start typing to search history
```

### Test 6: Test Tool Integrations
```bash
# Verify chruby works
chruby

# Verify nvm works
nvm list

# Verify direnv works
cd /tmp && echo "export TEST_VAR=hello" > .envrc && direnv allow
```

### Test 7: Test Git Configuration
```bash
# Test git aliases
git st      # Should run 'git status'
git lol     # Should show colorful git log with graph
```

## 🐛 Common Issues and Solutions

### Issue: Starship Not Showing

**Symptom**: Still seeing old prompt style

**Solution**:
```bash
# Check if starship is installed
which starship

# If not found, install it
brew install starship

# Verify it's in your .zshrc
grep starship ~/.zshrc

# Start a fresh shell
exec zsh
```

### Issue: Plugins Not Working

**Symptom**: No syntax highlighting or autosuggestions

**Solution**:
```bash
# Check if plugins are installed
brew list | grep zsh

# If missing, install them
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search

# Verify paths in .zshrc
grep -A2 "Plugin Loading" ~/.zshrc

# Start a fresh shell
exec zsh
```

### Issue: Command Not Found Errors

**Symptom**: Commands like `eza` or `fzf` not found

**Solution**:
```bash
# Verify Homebrew environment is loaded
echo $PATH | grep homebrew

# If /opt/homebrew/bin is missing, source your .zshenv
source ~/.zshenv

# Install missing tools
brew install eza fzf
```

### Issue: Slow Shell Startup

**Symptom**: Shell takes a long time to start

**Solution**:
```bash
# Profile your shell startup
zsh -i -c exit  # Should be under 0.2 seconds

# If slow, check what's taking time
# Add this to top of .zshrc temporarily:
zmodload zsh/zprof

# Then at the bottom:
zprof

# Start new shell and check output
```

### Issue: FZF Key Bindings Not Working

**Symptom**: Ctrl+R doesn't fuzzy search

**Solution**:
```bash
# Run FZF installation
$(brew --prefix)/opt/fzf/install

# Or manually source it
echo 'source <(fzf --zsh)' >> ~/.zshrc
exec zsh
```

## 🎨 Customization

### Change Starship Theme

```bash
# Create starship config
mkdir -p ~/.config
starship preset nerd-font-symbols > ~/.config/starship.toml

# Or use other presets:
starship preset gruvbox-rainbow
starship preset pastel-powerline
starship preset tokyo-night

# Edit manually
vim ~/.config/starship.toml
```

### Add Custom Aliases

Edit `~/workspace/chia/zsh/.zshrc` and add your aliases:

```bash
# Custom aliases
alias myalias='echo "Hello World"'
```

Then restow:
```bash
cd ~/workspace/chia
stow -R -t $HOME zsh
source ~/.zshrc
```

### Adjust History Settings

Edit `~/workspace/chia/zsh/.zshrc`:

```bash
# Increase history size
HISTSIZE=50000
SAVEHIST=50000
```

## 📊 Performance Comparison

| Metric | Oh My Zsh | Modern Setup | Improvement |
|--------|-----------|--------------|-------------|
| Shell startup | ~200ms | ~100ms | **2x faster** |
| Plugin loading | Framework-based | Direct sourcing | **Simpler** |
| Maintenance | Git submodule | Homebrew packages | **Easier** |
| Customization | Theme files | Starship config | **More flexible** |

## ✅ Post-Migration Checklist

- [ ] New prompt (Starship) is showing
- [ ] Command autosuggestions work (type a command)
- [ ] Syntax highlighting works (valid commands in green)
- [ ] History search works (type text, press ↑)
- [ ] Modern aliases work (`ls`, `ll`, `la`)
- [ ] FZF works (Ctrl+R for history search)
- [ ] Git aliases work (`git st`, `git lol`)
- [ ] Language tools work (chruby, nvm, direnv)
- [ ] No error messages on shell startup

## 🔙 Rollback Procedure

If you need to rollback to Oh My Zsh:

```bash
# Unstow new configuration
cd ~/workspace/chia
stow -D -t $HOME zsh
stow -D -t $HOME git

# Restore backups
cp ~/.zshrc.backup ~/.zshrc
cp ~/.zprofile.backup ~/.zprofile
cp ~/.gitconfig.backup ~/.gitconfig

# Reinstall Oh My Zsh if removed
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Start new shell
exec zsh
```

## 🎉 Enjoy Your Modern Shell!

You now have a fast, modern, maintainable shell configuration. Key improvements:

- **Faster**: No framework overhead
- **Cleaner**: Native Zsh with targeted plugins
- **Modern**: Latest tools and best practices
- **Maintainable**: Simple structure, easy to understand
- **Extensible**: Easy to add new tools and configurations

Happy hacking! 🚀
