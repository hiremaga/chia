function login_item {
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$1\", hidden:false}"
}

login_item "/Applications/Backup and Sync.app"
login_item "/Applications/Flycut.app"
login_item "/Applications/Spectacle.app"
