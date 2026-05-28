#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"

echo "=== ARMSX2 iOS Build Script ==="
echo "Workspace: $WORKSPACE"
echo "Build dir: $BUILD_DIR"

# Copy cpp source tree from app/src/main if not already present
if [ ! -d "$SCRIPT_DIR/cpp" ]; then
    echo "Copying PCSX2 C++ sources from app/src/main/cpp..."
    mkdir -p "$SCRIPT_DIR/cpp"
    cp -a "$WORKSPACE/app/src/main/cpp/." "$SCRIPT_DIR/cpp/"
    echo "C++ sources copied."
fi

# Create build directory
mkdir -p "$BUILD_DIR"

# Determine SDK
SDK="${SDK:-iphonesimulator}"
ARCH="${ARCH:-arm64}"
CONFIGURATION="${CONFIGURATION:-Debug}"

echo "SDK: $SDK"
echo "Architecture: $ARCH"
echo "Configuration: $CONFIGURATION"

# Configure with CMake
cmake -G Xcode \
    -B "$BUILD_DIR" \
    -S "$SCRIPT_DIR" \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_SYSROOT=$(xcrun --sdk $SDK --show-sdk-path) \
    -DCMAKE_OSX_ARCHITECTURES=$ARCH \
    -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO \
    -DCMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH=YES

# Build
xcodebuild \
    -project "$BUILD_DIR/ARMSX2.xcodeproj" \
    -scheme ARMSX2 \
    -configuration $CONFIGURATION \
    -sdk $SDK \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "$BUILD_DIR/DerivedData" \
    build

echo "=== Build complete ==="
echo "Output: $BUILD_DIR/DerivedData/Build/Products/${CONFIGURATION}-${SDK}/ARMSX2.app"
