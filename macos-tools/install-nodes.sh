#!/bin/bash

set +x

mkdir -p ~/.nvm

# shellcheck disable=SC1091
source "${NVM_HOMEBREW}"/nvm.sh
nvm install 14 # For Rails 6 
nvm install 15 # For everything else including Phoenix
nvm alias default 15

set -x
