#!/bin/bash

set -e

OPUS_VERSION="opus-1.5.2"
OPUS_SRC_DIR=$(pwd)/$OPUS_VERSION
BUILD_DIR=$(pwd)/build
XCFRAMEWORK_NAME="libopus.xcframework"

IOS_SDK=$(xcrun --sdk iphoneos --show-sdk-path)
SIMULATOR_SDK=$(xcrun --sdk iphonesimulator --show-sdk-path)
MACOS_SDK=$(xcrun --sdk macosx --show-sdk-path)

ARCHS_IOS=("arm64")
ARCHS_SIMULATOR=("x86_64" "arm64")
ARCHS_MACOS=("x86_64" "arm64")

function build_for_arch() {
    local platform=$1
    local arch=$2
    local sdk_path=$3
    local host

    case $arch in
        arm64)
            host="aarch64-apple-darwin"
            ;;
        x86_64)
            host="x86_64-apple-darwin"
            ;;
        *)
            echo "Unsupported arch: $arch"
            exit 1
            ;;
    esac

    echo "🏗️  Building for $platform $arch"

    build_path="$BUILD_DIR/$platform/$arch"
    mkdir -p "$build_path"
    pushd "$OPUS_SRC_DIR"

    make distclean || true

    # ✅ 设置兼容版本
    DEPLOYMENT_TARGET=""
    if [[ "$platform" == "iphoneos" ]]; then
        DEPLOYMENT_TARGET="-mios-version-min=13.0"
    elif [[ "$platform" == "iphonesimulator" ]]; then
        DEPLOYMENT_TARGET="-mios-simulator-version-min=13.0"
    elif [[ "$platform" == "macosx" ]]; then
        DEPLOYMENT_TARGET="-mmacosx-version-min=10.13"
    fi

    ./configure \
        --host=$host \
        --prefix="$build_path" \
        --disable-shared \
        --enable-static \
        CC="$(xcrun --sdk $platform clang -arch $arch)" \
        CFLAGS="-isysroot $sdk_path -arch $arch $DEPLOYMENT_TARGET"

    make -j$(sysctl -n hw.logicalcpu)
    make install

    popd
}


function lipo_merge() {
    local platform=$1
    local output_dir="$BUILD_DIR/universal/$platform"
    mkdir -p "$output_dir/lib"

    libs=()
    for arch in "${@:2}"; do
        libs+=("$BUILD_DIR/$platform/$arch/lib/libopus.a")
    done

    lipo -create "${libs[@]}" -output "$output_dir/lib/libopus.a"
    cp -R "$BUILD_DIR/$platform/${2}/include" "$output_dir/include"
}

echo "🚧 Cleaning build dir..."
rm -rf "$BUILD_DIR" "$XCFRAMEWORK_NAME"

echo "📦 Building libopus for iOS..."
for arch in "${ARCHS_IOS[@]}"; do
    build_for_arch "iphoneos" $arch $IOS_SDK
done

echo "📦 Building libopus for Simulator..."
for arch in "${ARCHS_SIMULATOR[@]}"; do
    build_for_arch "iphonesimulator" $arch $SIMULATOR_SDK
done

echo "📦 Building libopus for macOS..."
for arch in "${ARCHS_MACOS[@]}"; do
    build_for_arch "macosx" $arch $MACOS_SDK
done

echo "📦 Merging libs with lipo..."
lipo_merge "iphoneos" "${ARCHS_IOS[@]}"
lipo_merge "iphonesimulator" "${ARCHS_SIMULATOR[@]}"
lipo_merge "macosx" "${ARCHS_MACOS[@]}"

echo "📦 Creating .xcframework..."
xcodebuild -create-xcframework \
    -library "$BUILD_DIR/universal/iphoneos/lib/libopus.a" \
    -headers "$BUILD_DIR/universal/iphoneos/include" \
    -library "$BUILD_DIR/universal/iphonesimulator/lib/libopus.a" \
    -headers "$BUILD_DIR/universal/iphonesimulator/include" \
    -library "$BUILD_DIR/universal/macosx/lib/libopus.a" \
    -headers "$BUILD_DIR/universal/macosx/include" \
    -output "$XCFRAMEWORK_NAME"

echo "✅ Done! Created $XCFRAMEWORK_NAME"

