#!/bin/bash

set -x

function login_item {
    if [ ! -d "$1" ]; then
        echo "Error: Application not found at $1"
        return 1
    fi
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$1\", hidden:false}" >/dev/null 2>&1
}

echo "Adding login items..."
login_item "/Applications/Google Drive.app"
login_item "/Applications/Flycut.app"
login_item "/Applications/Rectangle.app"
echo "Done."
