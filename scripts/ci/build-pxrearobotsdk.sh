#!/usr/bin/env bash
# Build the client-side PXREARobotSDK shared library.
#
# Usage:
#   build-pxrearobotsdk.sh [build_number]
#
# Unlike RoboticsServiceProcess this module has its own CMake project
# (RoboticsService/PXREARobotSDK/CMakeLists.txt) and is not part of the
# main add_subdirectory chain, so it has to be configured & built
# separately. It does not depend on Qt; it only links against the
# bundled static gRPC stack that we either ship in
# Redistributable/linux/grpc/ (amd64) or build & stage from source via
# scripts/ci/build-grpc.sh (arm64). The same prerequisites that
# build-roboticsservice.sh satisfies are therefore enough here.
#
# Final products land at:
#   RoboticsService/SDK/<linux|linux_aarch64>/64/libPXREARobotSDK.so
#   RoboticsService/SDK/include/PXREARobotSDK.h
# as wired into PXREARobotSDK/CMakeLists.txt's POST_BUILD copies.

set -euo pipefail

BUILD_NUM="${1:-0}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SDK_SRC="$ROOT_DIR/RoboticsService/PXREARobotSDK"

BUILD_DIR="$SDK_SRC/build-ci"
GENERATOR="${CMAKE_GENERATOR:-Ninja}"
JOBS="${JOBS:-$(nproc)}"

echo "==> Configuring PXREARobotSDK"
echo "    src dir   : $SDK_SRC"
echo "    build dir : $BUILD_DIR"
echo "    generator : $GENERATOR"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cmake \
    -S "$SDK_SRC" \
    -B "$BUILD_DIR" \
    -G "$GENERATOR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DAUTO_BUILD_NUM="$BUILD_NUM"

echo "==> Building PXREARobotSDK (jobs=$JOBS)"
cmake --build "$BUILD_DIR" --parallel "$JOBS"

# The CMakeLists.txt has a POST_BUILD that copies the .so and header
# into RoboticsService/SDK/<arch>/64 and RoboticsService/SDK/include.
# Print where it landed to make CI output easy to follow.
echo "==> PXREARobotSDK install tree:"
find "$ROOT_DIR/RoboticsService/SDK" -type f \
    \( -name 'libPXREARobotSDK.so' -o -name 'PXREARobotSDK.h' \) \
    -print | sed 's/^/  /' || true
