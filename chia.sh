#!/bin/bash -ex


# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Table stakes
if [[ $(xcode-select -p) != '/Applications/Xcode.app/Contents/Developer' ]]; then
  echo 'Please install XCode from the app store before running this script'
  echo 'A full XCode install is required for Flutter, hyperkit etc. Command-line tools is insufficient.'
  exit 1
fi

softwareupdate -a -i true

if ! which brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# First run?
if [ ! -d ~/workspace/chia ]; then
  mkdir -p ~/workspace
  pushd ~/workspace
    git clone https://github.com/hiremaga/chia.git --recurse-submodules
  popd
fi

pushd ~/workspace/chia
  brew bundle cleanup -f
  brew bundle install

  echo 'installing dotfiles...'
  stow -t $HOME dotfiles
  source $HOME/.zprofile
  echo 'installed dotfiles.'

  echo 'installing settings...'
  source macos-settings/00-everything.sh
  echo 'installed settings.'

  echo 'installing tools...'
  source macos-tools/00-everything.sh
  echo 'installing tools.'
popd
