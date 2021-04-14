if [ ! -d ~/workspace/jetbrains-ide-prefs ]; then

pushd ~/workspace
    git clone https://github.com/professor/jetbrains-ide-prefs
    pushd jetbrains-ide-prefs
        cli/bin/ide_prefs install --ide=intellij
    popd
popd

fi