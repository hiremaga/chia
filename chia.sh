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
