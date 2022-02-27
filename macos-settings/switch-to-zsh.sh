#!/bin/bash

[[ $(dscl . -read ~/ UserShell) =~ zsh ]] || chsh -s /bin/zsh