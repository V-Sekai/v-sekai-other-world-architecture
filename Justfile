export RUST_LOG := "log"
export MVSQLITE_DATA_PLANE := "http://192.168.0.39:7000"
export OPERATING_SYSTEM := os()
export EDITOR_TYPE_COMMAND := "run-editor-$OPERATING_SYSTEM"
export PROJECT_PATH := "" # Can be empty

export BUILD_COUNT := "001"
export DOCKER_GOCDA_AGENT_CENTOS_8_GROUPS_GIT := "abcdefgh"  # Example hash
export GODOT_GROUPS_EDITOR_PIPELINE_DEPENDENCY := "dependency_name"

export LABEL_TEMPLATE := "docker-gocd-agent-centos-8-groups_${DOCKER_GOCDA_AGENT_CENTOS_8_GROUPS_GIT:0:8}.$BUILD_COUNT"
export GROUPS_LABEL_TEMPLATE := "groups-4.3.$GODOT_GROUPS_EDITOR_PIPELINE_DEPENDENCY.$BUILD_COUNT"
export GODOT_STATUS := "groups-4.3"
export GIT_URL_DOCKER := "https://github.com/V-Sekai/docker-groups.git"
export GIT_URL_VSEKAI := "https://github.com/V-Sekai/v-sekai-game.git"
export WORLD_PWD := invocation_directory()
export SCONS_CACHE := ".scons_cache"

export IMAGE_NAME := "just-fedora-app"

export ANDROID_SDK_ROOT := WORLD_PWD + "/sdk"
export ANDROID_NDK_VERSION := "23.2.8568313"
export cmdlinetools := "commandlinetools-linux-11076708_latest.zip"
export JAVA_HOME := "/jdk"

# To use. Run `lima`.

run:
    just install_packages fetch_sdks setup_rust setup_emscripten build-all

install_packages:
    sudo dnf install -y vulkan xz gcc gcc-c++ zlib-devel libmpc-devel mpfr-devel gmp-devel clang just parallel scons mold pkgconfig libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel libXi-devel wayland-devel mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel pulseaudio-libs-devel libudev-devel libstdc++-static libatomic-static cmake ccache patch libxml2-devel openssl openssl-devel git unzip

fetch_llvm_mingw:
    #!/usr/bin/env bash
    cd $WORLD_PWD
    curl -o /tmp/llvm-mingw.tar.xz -L https://github.com/mstorsjo/llvm-mingw/releases/download/20240917/llvm-mingw-20240917-ucrt-ubuntu-20.04-x86_64.tar.xz
    sudo tar -xf /tmp/llvm-mingw.tar.xz -C /
    rm -rf /tmp/llvm-mingw.tar.xz

fetch_openjdk:
    curl --fail --location --silent --show-error "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_$(uname -m | sed -e s/86_//g)_linux_hotspot_17.0.11_9.tar.gz" --output /tmp/jdk.tar.gz
    sudo mkdir -p {{JAVA_HOME}}
    sudo tar -xf /tmp/jdk.tar.gz -C {{JAVA_HOME}} --strip 1
    rm -rf /tmp/jdk.tar.gz

fetch_vulkan_sdk:
    curl -L "https://github.com/godotengine/moltenvk-osxcross/releases/download/vulkan-sdk-1.3.283.0-2/MoltenVK-all.tar" -o /tmp/vulkan-sdk.zip
    sudo mkdir -p /opt/vulkan_sdk
    sudo tar -xf /tmp/vulkan-sdk.zip -C /opt/vulkan_sdk/
    rm /tmp/vulkan-sdk.zip

setup_android_sdk:
    #!/usr/bin/env bash
    mkdir -p {{ANDROID_SDK_ROOT}}
    curl -LO https://dl.google.com/android/repository/{{cmdlinetools}} -o {{WORLD_PWD}}/{{cmdlinetools}}
    cd {{WORLD_PWD}} && unzip -o {{WORLD_PWD}}/{{cmdlinetools}}
    rm {{WORLD_PWD}}/{{cmdlinetools}}
    yes | {{WORLD_PWD}}/cmdline-tools/bin/sdkmanager --sdk_root={{ANDROID_SDK_ROOT}} --licenses
    yes | {{WORLD_PWD}}/cmdline-tools/bin/sdkmanager --sdk_root={{ANDROID_SDK_ROOT}} "ndk;{{ANDROID_NDK_VERSION}}" 'cmdline-tools;latest' 'build-tools;34.0.0' 'platforms;android-34' 'cmake;3.22.1'

fetch_sdks:
    just setup_android_sdk
    just fetch_vulkan_sdk
    just fetch_llvm_mingw
    just fetch_openjdk
    just build-osxcross
    
setup_rust:
    #!/usr/bin/env bash
    cd $WORLD_PWD
    sudo mkdir -p /opt/cargo /opt/rust
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly --no-modify-path
    . "$HOME/.cargo/env"
    rustup default nightly
    rustup target add aarch64-linux-android x86_64-linux-android x86_64-unknown-linux-gnu aarch64-apple-ios x86_64-apple-ios x86_64-apple-darwin aarch64-apple-darwin x86_64-pc-windows-gnu x86_64-pc-windows-msvc wasm32-wasi

setup_emscripten:
    #!/usr/bin/env bash
    cd $WORLD_PWD
    sudo git clone https://github.com/emscripten-core/emsdk.git /emsdk
    sudo /emsdk/emsdk install 3.1.67
    sudo /emsdk/emsdk activate 3.1.67
    source "/emsdk/emsdk_env.sh"
    echo 'source "/emsdk/emsdk_env.sh"' >> $HOME/.bashrc

list_files:
    ls export_windows
    ls export_linuxbsd

deploy_game:
    echo "Deploying game binaries..."

copy_binaries:
    cp templates/windows_release_x86_64.exe export_windows/v_sekai_windows.exe
    cp templates/linux_release.x86_64 export_linuxbsd/v_sekai_linuxbsd

prepare_exports:
    rm -rf export_windows export_linuxbsd
    mkdir export_windows export_linuxbsd

generate_build_constants:
    echo "## AUTOGENERATED BY BUILD" > v/addons/vsk_version/build_constants.gd
    echo "" >> v/addons/vsk_version/build_constants.gd
    echo "const BUILD_LABEL = \"$GROUPS_LABEL_TEMPLATE\"" >> v/addons/vsk_version/build_constants.gd
    echo "const BUILD_DATE_STR = \"$(shell date --utc --iso=seconds)\"" >> v/addons/vsk_version/build_constants.gd
    echo "const BUILD_UNIX_TIME = $(shell date +%s)" >> v/addons/vsk_version/build_constants.gd

clone_repo_vsekai:
    if [ ! -d "v" ]; then \
        git clone $GIT_URL_VSEKAI v; \
    else \
        git -C v pull origin main; \
    fi

deploy_osxcross:
    #!/usr/bin/env bash
    git clone https://github.com/tpoechtrager/osxcross.git || true
    cd osxcross
    ./tools/gen_sdk_package.sh 

clone_repo:
    if [ ! -d "g" ]; then \
        git clone $GIT_URL_DOCKER g; \
    else \
        git -C g pull origin master; \
    fi

# !!! Use aarch64-apple-darwin24-* instead of arm64-* when dealing with Automake !!!
# !!! CC=aarch64-apple-darwin24-clang ./configure --host=aarch64-apple-darwin24 !!!
# !!! CC="aarch64-apple-darwin24-clang -arch arm64e" ./configure --host=aarch64-apple-darwin24 !!!

build-osxcross:
    #!/usr/bin/env bash
    sudo git clone https://github.com/tpoechtrager/osxcross.git /osxcross
    sudo curl -o /osxcross/tarballs/MacOSX15.0.sdk.tar.xz -L https://github.com/V-Sekai/world/releases/download/v0.0.1/MacOSX15.0.sdk.tar.xz
    sudo chown -R $(whoami):$(whoami) /osxcross
    ls -l /osxcross/tarballs/
    cd /osxcross && UNATTENDED=1 ./build.sh && ./build_compiler_rt.sh

install-lazygit:
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install lazygit -y

build-all:
    #!/usr/bin/env -S parallel --jobs 1 just build-platform-target {1} {2} ::: macos windows linux android ::: editor template_release template_debug

build-platform-target platform target:
    #!/usr/bin/env bash
    cd $WORLD_PWD
    export PATH=/llvm-mingw-20240917-ucrt-ubuntu-20.04-x86_64/bin:$PATH
    export PATH=/osxcross/target/bin/:$PATH
    export OSXCROSS_ROOT=/osxcross
    source "/emsdk/emsdk_env.sh"
    cd godot
    case "{{platform}}" in \
        macos)
            EXTRA_FLAGS="vulkan_sdk_path=/opt/vulkan_sdk/MoltenVK/MoltenVK/static/MoltenVK.xcframework osxcross_sdk=darwin24 vulkan=yes arch=arm64" \
            ;; \
        *) \
            EXTRA_FLAGS="use_llvm=yes use_mingw=yes" \
            ;; \
    esac
    scons platform={{platform}} \
          werror=no \
          compiledb=yes \
          precision=double \
          target={{target}} \
          test=yes \
          debug_symbol=yes \
          $EXTRA_FLAGS
    just handle-special-cases {{platform}} {{target}}

handle-special-cases platform target:
    #!/usr/bin/env bash
    case "{{platform}}" in \
        android) \ 
            just handle-android {{target}} \
            ;; \
        web) \
            just handle-web \
            ;; \
    esac

handle-android target:
    #!/usr/bin/env bash
    if [ "{{target}}" = "editor" ]; then
        cd platform/android/java
        ./gradlew generateGodotEditor
        ./gradlew generateGodotHorizonOSEditor
        cd ../../..
        ls -l bin/android_editor_builds/
    elif [ "{{target}}" = "template_release" ] || [ "{{target}}" = "template_debug" ]; then
        cd platform/android/java
        ./gradlew generateGodotTemplates
        cd ../../..
        ls -l bin/
    fi

handle-web:
    #!/usr/bin/env bash
    cd bin
    files_to_delete=(
        "*.wasm"
        "*.js"
        "*.html"
        "*.worker.js"
        "*.engine.js"
        "*.service.worker.js"
        "*.wrapped.js"
    )
    for file_pattern in "${files_to_delete[@]}"; do
        echo "Deleting files: $file_pattern"
        rm -f $file_pattern
    done
    if [ -d ".web_zip" ]; then
        echo "Deleting directory: .web_zip"
        rm -rf .web_zip
    fi
    cd ..
    ls -l bin/
