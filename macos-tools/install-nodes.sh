set +x

mkdir -p ~/.nvm

source ${NVM_HOMEBREW}/nvm.sh
nvm install 22 # For everything else including Phoenix
nvm alias default 22

set -x
