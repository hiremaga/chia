
#!/bin/bash -ex

echo "CHIA: Installing Xcode Command Line Tools if it isn't already installed"
xcode-select --install || true

echo "CHIA: Updating OS X"
softwareupdate -a -i true

echo "CHIA: Installing Homebrew if it isn't already installed"
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
