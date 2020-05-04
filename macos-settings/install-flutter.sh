if [ ! -d ~/workspace/flutter ]; then
    pushd ~/workspace
        wget https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_v1.12.13+hotfix.9-stable.zip
        unzip flutter_macos_v1.12.13+hotfix.9-stable.zip
        rm flutter_macos_v1.12.13+hotfix.9-stable.zip
    popd
fi
