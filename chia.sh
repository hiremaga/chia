#!/bin/bash -ex

xcode-select --install || true
softwareupdate -a -i true
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

if [ ! -d ~/workspace/chia ]; then
  mkdir -p ~/workspace
  pushd ~/workspace
    git clone https://github.com/hiremaga/chia.git
  popd
fi

pushd ~/workspace/chia
  source macos-settings/00-everything.sh
  brew bundle
popd
