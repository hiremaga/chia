#!/bin/bash

if [ ! -d ~/workspace/jetbrains-ide-prefs ]; then

pushd ~/workspace || exit
    git clone https://github.com/professor/jetbrains-ide-prefs
    pushd jetbrains-ide-prefs || exit
        cli/bin/ide_prefs install --ide=intellij
    popd || exit
popd || exit

fi
