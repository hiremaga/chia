# Automatically hide and show Dock.
sudo defaults write /Library/Preferences/com.apple.dock autohide -bool YES

# Automatically hide and show Dock.
defaults write com.apple.dock autohide -bool true

killall Dock &> /dev/null