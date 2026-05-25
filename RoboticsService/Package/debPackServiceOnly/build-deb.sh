#!/usr/bin/env bash
# Assemble a minimal "service-only" .deb package containing just
# RoboticsServiceProcess plus its required Qt 6 runtime.
#
# Usage:
#   build-deb.sh <arch> <version> <build_bin_dir> <qt_install_dir> \
#                <output_dir> [distro_tag]
#
#     <arch>             Debian architecture, e.g. amd64 or arm64.
#     <version>          Full version string, e.g. 1.0.0.42.
#     <build_bin_dir>    Path to RoboticsService/bin/ produced by the build.
#     <qt_install_dir>   Root of the Qt 6 prefix used for the build.
#     <output_dir>       Directory where the produced .deb will be written.
#     [distro_tag]       Optional distro suffix (e.g. ubuntu20.04). When set,
#                        the produced filename becomes
#                        xrobotoolkit-pc-service_<version>_<distro_tag>_<arch>.deb
#                        so packages targeting different distros can coexist.
#
# Environment knobs:
#     LIBC_MIN     Minimum libc6 version stamped into Depends (default 2.31).
#     STDCPP_MIN   Minimum libstdc++6 version stamped into Depends (default 9).
#                  Override these per target distro so apt does not let users
#                  install a binary that requires symbols newer than their
#                  installed glibc / libstdc++.
#
# The script does not run the C++ build itself; it consumes whatever the
# CMake build has put into <build_bin_dir> and packages the service-only
# subset.

set -euo pipefail

ARCH="${1:?arch required}"
VERSION="${2:?version required}"
BIN_DIR="${3:?build bin dir required}"
QT_DIR="${4:?qt install dir required}"
OUT_DIR="${5:?output dir required}"
DISTRO_TAG="${6:-}"

LIBC_MIN="${LIBC_MIN:-2.31}"
STDCPP_MIN="${STDCPP_MIN:-9}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

case "$ARCH" in
    amd64)
        REDIST_DIR="$ROOT_DIR/Redistributable/linux"
        SDK_LIB_DIR="$ROOT_DIR/SDK/linux/64"
        ;;
    arm64)
        REDIST_DIR="$ROOT_DIR/Redistributable/linux_aarch64"
        SDK_LIB_DIR="$ROOT_DIR/SDK/linux_aarch64/64"
        ;;
    *)
        echo "ERROR: unsupported arch '$ARCH'" >&2
        exit 1
        ;;
esac
SDK_INC_DIR="$ROOT_DIR/SDK/include"

if [ ! -f "$BIN_DIR/RoboticsServiceProcess" ]; then
    echo "ERROR: $BIN_DIR/RoboticsServiceProcess not found" >&2
    exit 1
fi

STAGING="$SCRIPT_DIR/build/package_${ARCH}"
APP_DIR="$STAGING/opt/apps/xrobotoolkit-pc-service"
DEBIAN_DIR="$STAGING/DEBIAN"

echo "==> Cleaning staging dir $STAGING"
rm -rf "$STAGING"
mkdir -p "$APP_DIR" "$DEBIAN_DIR"

echo "==> Copying main executable and project shared libraries"
install -m 0755 "$BIN_DIR/RoboticsServiceProcess" "$APP_DIR/"

for so in libBusiness.so libCommonUtils.so \
          libDeviceConnectionManager.so libPXREAGRPCServer.so; do
    if [ ! -f "$BIN_DIR/$so" ]; then
        echo "ERROR: $BIN_DIR/$so missing" >&2
        exit 1
    fi
    install -m 0644 "$BIN_DIR/$so" "$APP_DIR/"
done

echo "==> Copying OpenSSL runtime"
for so in libssl.so libssl.so.3 libcrypto.so libcrypto.so.3; do
    if [ -e "$REDIST_DIR/openssl/$so" ]; then
        cp -a "$REDIST_DIR/openssl/$so" "$APP_DIR/"
    fi
done

echo "==> Copying default setting.ini"
if [ -f "$REDIST_DIR/setting.ini" ]; then
    install -m 0644 "$REDIST_DIR/setting.ini" "$APP_DIR/"
fi

echo "==> Collecting Qt6 runtime from $QT_DIR"
"$SCRIPT_DIR/collect-qt-runtime.sh" "$QT_DIR" "$APP_DIR"

echo "==> Installing client SDK (PXREARobotSDK)"
# Lay the SDK out in a stable, self-contained tree so consumers can
# point their build systems at one of:
#   /opt/apps/xrobotoolkit-pc-service/sdk/lib/libPXREARobotSDK.so
#   /opt/apps/xrobotoolkit-pc-service/sdk/include/PXREARobotSDK.h
SDK_OUT_LIB="$APP_DIR/sdk/lib"
SDK_OUT_INC="$APP_DIR/sdk/include"
mkdir -p "$SDK_OUT_LIB" "$SDK_OUT_INC"

if [ -f "$SDK_LIB_DIR/libPXREARobotSDK.so" ]; then
    install -m 0644 "$SDK_LIB_DIR/libPXREARobotSDK.so" "$SDK_OUT_LIB/"
else
    echo "ERROR: $SDK_LIB_DIR/libPXREARobotSDK.so not found." >&2
    echo "       Did scripts/ci/build-pxrearobotsdk.sh run before this?" >&2
    exit 1
fi

if [ -f "$SDK_INC_DIR/PXREARobotSDK.h" ]; then
    install -m 0644 "$SDK_INC_DIR/PXREARobotSDK.h" "$SDK_OUT_INC/"
else
    echo "ERROR: $SDK_INC_DIR/PXREARobotSDK.h not found." >&2
    exit 1
fi

echo "==> Installing launcher and maintainer scripts"
install -m 0755 "$SCRIPT_DIR/runService.sh" "$APP_DIR/runService.sh"

sed -e "s/@ARCH@/$ARCH/g" \
    -e "s/@VERSION@/$VERSION/g" \
    -e "s/@LIBC_MIN@/$LIBC_MIN/g" \
    -e "s/@STDCPP_MIN@/$STDCPP_MIN/g" \
    "$SCRIPT_DIR/control.in" > "$DEBIAN_DIR/control"

install -m 0755 "$SCRIPT_DIR/postinst" "$DEBIAN_DIR/postinst"
install -m 0755 "$SCRIPT_DIR/prerm"    "$DEBIAN_DIR/prerm"
install -m 0755 "$SCRIPT_DIR/postrm"   "$DEBIAN_DIR/postrm"

echo "==> Setting RPATH on the main binary and project libraries"
# Without this, running ./RoboticsServiceProcess directly fails with
# "libBusiness.so: cannot open shared object file" because the dynamic
# linker doesn't know to look in the install directory. With RPATH set
# to $ORIGIN:$ORIGIN/lib, the process finds:
#   - sibling project libs (libBusiness.so, libCommonUtils.so, ...)
#     in $ORIGIN (= /opt/apps/xrobotoolkit-pc-service)
#   - Qt6 and ICU libs in $ORIGIN/lib
# runService.sh is kept as a convenience wrapper but is no longer
# strictly required.
if ! command -v patchelf >/dev/null 2>&1; then
    echo "ERROR: patchelf not installed; install it via apt-get install patchelf" >&2
    exit 1
fi
RPATH='$ORIGIN:$ORIGIN/lib'
patchelf --force-rpath --set-rpath "$RPATH" "$APP_DIR/RoboticsServiceProcess"
for so in libBusiness.so libCommonUtils.so \
          libDeviceConnectionManager.so libPXREAGRPCServer.so; do
    patchelf --force-rpath --set-rpath "$RPATH" "$APP_DIR/$so"
done
# Also normalise Qt's own libs to $ORIGIN so the chain keeps working
# regardless of what aqtinstall baked in.
for so in "$APP_DIR/lib"/libQt6*.so.*.*.* "$APP_DIR/lib"/libicu*.so.*.*; do
    [ -f "$so" ] && patchelf --force-rpath --set-rpath '$ORIGIN' "$so" || true
done

echo "==> Stripping ELF binaries to reduce package size"
# Best-effort: strip is platform-specific in cross builds; ignore failures.
find "$APP_DIR" -type f \( -name '*.so' -o -name '*.so.*' \
    -o -name 'RoboticsServiceProcess' \) -print0 \
    | xargs -0 -r -n1 strip --strip-unneeded 2>/dev/null || true

mkdir -p "$OUT_DIR"
if [ -n "$DISTRO_TAG" ]; then
    PACKAGE_NAME="xrobotoolkit-pc-service_${VERSION}_${DISTRO_TAG}_${ARCH}.deb"
else
    PACKAGE_NAME="xrobotoolkit-pc-service_${VERSION}_${ARCH}.deb"
fi
echo "==> Building $PACKAGE_NAME"
dpkg-deb --root-owner-group -b "$STAGING" "$OUT_DIR/$PACKAGE_NAME"

echo "==> Done: $OUT_DIR/$PACKAGE_NAME"
ls -lh "$OUT_DIR/$PACKAGE_NAME"
