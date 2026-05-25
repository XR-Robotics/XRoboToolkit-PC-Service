#!/usr/bin/env bash
# Drive the RoboticsService CMake build with parameters suitable for
# CI (Release build type, externally-provided Qt prefix, no Qt deploy).
#
# Usage:
#   build-roboticsservice.sh <qt_prefix> <build_number>
#
# Environment knobs:
#   CMAKE_GENERATOR  Defaults to "Ninja".
#   JOBS             Parallel build jobs, defaults to nproc.
#
# After the build, RoboticsService/bin/ contains the executable and
# project shared libraries. The Qt deployment step that is normally
# wired into CMakeLists.txt under RelWithDebInfo is intentionally
# skipped here; the deb packaging script stages Qt separately to keep
# the package minimal.

set -euo pipefail

QT_PREFIX="${1:?Qt6 install prefix required}"
BUILD_NUM="${2:?build number required}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
PROJECT_DIR="$ROOT_DIR/RoboticsService"

BUILD_DIR="$PROJECT_DIR/Release"
GENERATOR="${CMAKE_GENERATOR:-Ninja}"
JOBS="${JOBS:-$(nproc)}"

echo "==> Configuring RoboticsService"
echo "    project dir : $PROJECT_DIR"
echo "    build dir   : $BUILD_DIR"
echo "    Qt prefix   : $QT_PREFIX"
echo "    build num   : $BUILD_NUM"
echo "    generator   : $GENERATOR"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$PROJECT_DIR/bin"

cmake \
    -S "$PROJECT_DIR" \
    -B "$BUILD_DIR" \
    -G "$GENERATOR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$QT_PREFIX" \
    -DBUILD_LIB_PATH="$QT_PREFIX" \
    -DAUTO_BUILD_NUM="$BUILD_NUM"

echo "==> Building (jobs=$JOBS)"
cmake --build "$BUILD_DIR" --parallel "$JOBS"

echo "==> Build outputs in $PROJECT_DIR/bin:"
ls -lh "$PROJECT_DIR/bin"
