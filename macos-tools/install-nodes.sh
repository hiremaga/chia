set +x

mkdir -p ~/.nvm

source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
nvm install 22 # For everything else including Phoenix
nvm alias default 22

set -x
