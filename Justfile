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
export SCONS_CACHE := "/app/.scons_cache"

export IMAGE_NAME := "just-fedora-app"

export ANDROID_SDK_ROOT := "/root/sdk"
export ANDROID_NDK_VERSION := "23.2.8568313"
export cmdlinetools := "commandlinetools-linux-11076708_latest.zip"
export JAVA_HOME := "/jdk"

run_just_docker:
    docker run -it -v $WORLD_PWD:/app --platform linux/x86_64 fedora:39 /bin/bash -c "dnf install just -y && cd /app && just prepare_workspace install_packages fetch_sdks setup_rust setup_emscripten prepare_workspace build-all"

prepare_workspace:
    mkdir -p /app
    cd /app

install_packages:
    sudo dnf install -y xz gcc gcc-c++ zlib-devel libmpc-devel mpfr-devel gmp-devel clang just parallel scons mold pkgconfig libX11-devel libXcursor-devel libXrandr-devel libXinerama-devel libXi-devel wayland-devel mesa-libGL-devel mesa-libGLU-devel alsa-lib-devel pulseaudio-libs-devel libudev-devel libstdc++-static libatomic-static cmake ccache patch libxml2-devel openssl openssl-devel git unzip

fetch_sdks:
    #!/usr/bin/env bash
    cd /app
    just prepare_workspace
    curl -o llvm-mingw.tar.xz -L https://github.com/mstorsjo/llvm-mingw/releases/download/20240917/llvm-mingw-20240917-ucrt-ubuntu-20.04-x86_64.tar.xz
    tar -xf llvm-mingw.tar.xz -C /
    rm -rf llvm-mingw.tar.xz

    just prepare_workspace
    curl --fail --location --silent --show-error "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%2B9/OpenJDK17U-jdk_$(uname -m | sed -e s/86_//g)_linux_hotspot_17.0.11_9.tar.gz" --output /tmp/jdk.tar.gz
    mkdir -p {{JAVA_HOME}}
    tar -xf /tmp/jdk.tar.gz -C {{JAVA_HOME}} --strip 1
    rm -rf /tmp/jdk.tar.gz

    just prepare_workspace
    mkdir -p {{ANDROID_SDK_ROOT}}
    cd {{ANDROID_SDK_ROOT}}
    pwd
    curl -LO https://dl.google.com/android/repository/{{cmdlinetools}}
    unzip -o {{cmdlinetools}}
    rm {{cmdlinetools}}
    yes | {{ANDROID_SDK_ROOT}}/cmdline-tools/bin/sdkmanager --sdk_root={{ANDROID_SDK_ROOT}} --licenses
    {{ANDROID_SDK_ROOT}}/cmdline-tools/bin/sdkmanager --sdk_root={{ANDROID_SDK_ROOT}} "ndk;{{ANDROID_NDK_VERSION}}" 'cmdline-tools;latest' 'build-tools;34.0.0' 'platforms;android-34' 'cmake;3.22.1'

    just prepare_workspace
    curl -O https://download.blender.org/release/Blender4.1/blender-4.1.1-linux-x64.tar.xz
    tar -xf blender-4.1.1-linux-x64.tar.xz -C /opt/
    rm blender-4.1.1-linux-x64.tar.xz
    ln -s /opt/blender-4.1.1-linux-x64/blender /usr/local/bin/blender

setup_rust:
    #!/usr/bin/env bash
    cd /app
    just prepare_workspace
    mkdir -p /opt/cargo /opt/rust
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly --no-modify-path
    . "$HOME/.cargo/env"
    rustup default nightly
    rustup target add aarch64-linux-android x86_64-linux-android x86_64-unknown-linux-gnu aarch64-apple-ios x86_64-apple-ios x86_64-apple-darwin aarch64-apple-darwin x86_64-pc-windows-gnu x86_64-pc-windows-msvc wasm32-wasi

setup_emscripten:
    #!/usr/bin/env bash
    cd /app
    just prepare_workspace
    git clone https://github.com/emscripten-core/emsdk.git /emsdk
    /emsdk/emsdk install 3.1.67
    /emsdk/emsdk activate 3.1.67
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

run-editor:
    @just build-all
    @just {{ EDITOR_TYPE_COMMAND }}

build-osxcross:
    #!/usr/bin/env bash
    git clone https://github.com/tpoechtrager/osxcross.git /osxcross
    curl -o /osxcross/tarballs/MacOSX15.0.sdk.tar.xz -L https://github.com/V-Sekai/world/releases/download/v0.0.1/MacOSX15.0.sdk.tar.xz
    ls -l /osxcross/tarballs/
    cd /osxcross && UNATTENDED=1 ./build.sh && ./build_compiler_rt.sh

build-all:
    #!/usr/bin/env bash
    export PATH=/llvm-mingw-20240917-ucrt-ubuntu-20.04-x86_64/bin:$PATH
    export OSXCROSS_ROOT=/osxcross
    export ANDROID_SDK_ROOT="/root/sdk"
    source "/emsdk/emsdk_env.sh"
    parallel --ungroup --jobs 1 '
        platform={1}
        target={2}
        cd godot
        case "$platform" in
            windows)
                EXTRA_FLAGS=use_mingw=yes use_llvm=yes linkflags='-Wl,-pdb=' ccflags='-g \-gcodeview'
                ;;
            macos)
                @just build-osxcross
                EXTRA_FLAGS="osxcross_sdk=darwin24 vulkan=no arch=arm64 linker=mold"
                ;;
            web)
                EXTRA_FLAGS="threads=yes lto=none dlink_enabled=yes builtin_glslang=yes builtin_openxr=yes module_raycast_enabled=no module_speech_enabled=no javascript_eval=no"
                ;;
        esac        
        scons platform=$platform \
            cc="ccache clang" \
            cxx="ccache clang++" \
            use_thinlto=yes \
            werror=no \
            compiledb=yes \
            generate_bundle=yes \
            precision=double \
            target=$target \
            test=yes \
            debug_symbol=yes \
            $EXTRA_FLAGS
        case "$platform" in
            android)
                if [ "$target" = "editor" ]; then
                    cd platform/android/java
                    ./gradlew generateGodotEditor
                    ./gradlew generateGodotHorizonOSEditor
                    cd ../../..
                    ls -l bin/android_editor_builds/
                elif [ "$target" = "template_release" ] || [ "$target" = "template_debug" ]; then
                    cd platform/android/java
                    ./gradlew generateGodotTemplates
                    cd ../../..
                    ls -l bin/
                fi
                ;;
            web)
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
                ;;            
        esac
    ' ::: android web macos linux windows \
    ::: editor # template_release template_debug
