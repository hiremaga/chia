
#!/bin/bash -xe

echo
echo      | |   (_)      
echo   ___| |__  _  __ _ 
echo  / __| '_ \| |/ _` |
echo | (__| | | | | (_| |
echo  \___|_| |_|_|\__,_|
echo

echo "CHIA: Installing Xcode Command Line Tools if it isn't already installed"
xcode-select --install || true

echo "CHIA: Updating OS X"
softwareupdate -a -i true

echo "CHIA: Installing Homebrew if it isn't already installed"
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "CHIA: Installing/updating Homebrew taps, formulae and casks"
brew bundle
