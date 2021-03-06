#!/bin/bash -ex


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Table stakes
xcode-select --install || true
softwareupdate -a -i true
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# First run?
if [ ! -d ~/workspace/chia ]; then
  mkdir -p ~/workspace
  pushd ~/workspace
    git clone https://github.com/hiremaga/chia.git
  popd
fi

pushd ~/workspace/chia
  brew bundle cleanup -f
  brew bundle install

  echo 'installing dotfiles...'
  stow -t $HOME dotfiles
  echo 'installed dotfiles.'

  echo 'installing settings...'
  source macos-settings/00-everything.sh
  echo 'installed settings.'

  echo 'installing tools...'
  source macos-tools/00-everything.sh
  echo 'installing tools.'
popd
