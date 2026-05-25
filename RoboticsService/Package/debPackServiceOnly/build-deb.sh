#!/usr/bin/env bash
# Assemble a minimal "service-only" .deb package containing just
# RoboticsServiceProcess plus its required Qt 6 runtime.
#
# Usage:
#   build-deb.sh <arch> <version> <build_bin_dir> <qt_install_dir> <output_dir>
#
#     <arch>             Debian architecture, e.g. amd64 or arm64.
#     <version>          Full version string, e.g. 1.0.0.42.
#     <build_bin_dir>    Path to RoboticsService/bin/ produced by the build.
#     <qt_install_dir>   Root of the Qt 6 prefix used for the build.
#     <output_dir>       Directory where the produced .deb will be written.
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

case "$ARCH" in
    amd64) REDIST_DIR="$ROOT_DIR/Redistributable/linux"         ;;
    arm64) REDIST_DIR="$ROOT_DIR/Redistributable/linux_aarch64" ;;
    *)
        echo "ERROR: unsupported arch '$ARCH'" >&2
        exit 1
        ;;
esac

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

echo "==> Installing launcher and maintainer scripts"
install -m 0755 "$SCRIPT_DIR/runService.sh" "$APP_DIR/runService.sh"

sed -e "s/@ARCH@/$ARCH/g" -e "s/@VERSION@/$VERSION/g" \
    "$SCRIPT_DIR/control.in" > "$DEBIAN_DIR/control"

install -m 0755 "$SCRIPT_DIR/postinst" "$DEBIAN_DIR/postinst"
install -m 0755 "$SCRIPT_DIR/prerm"    "$DEBIAN_DIR/prerm"
install -m 0755 "$SCRIPT_DIR/postrm"   "$DEBIAN_DIR/postrm"

echo "==> Stripping ELF binaries to reduce package size"
# Best-effort: strip is platform-specific in cross builds; ignore failures.
find "$APP_DIR" -type f \( -name '*.so' -o -name '*.so.*' \
    -o -name 'RoboticsServiceProcess' \) -print0 \
    | xargs -0 -r -n1 strip --strip-unneeded 2>/dev/null || true

mkdir -p "$OUT_DIR"
PACKAGE_NAME="xrobotoolkit-pc-service_${VERSION}_${ARCH}.deb"
echo "==> Building $PACKAGE_NAME"
dpkg-deb --root-owner-group -b "$STAGING" "$OUT_DIR/$PACKAGE_NAME"

echo "==> Done: $OUT_DIR/$PACKAGE_NAME"
ls -lh "$OUT_DIR/$PACKAGE_NAME"
