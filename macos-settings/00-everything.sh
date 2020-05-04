# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

source macos-settings/dock.sh
source macos-settings/keyboard.sh
source macos-settings/spectacle-shortcuts.sh
source macos-settings/switch-to-zsh.sh
source macos-settings/install-flutter.sh
