#!/usr/bin/env bash
# Copy the minimum subset of Qt 6 runtime (libraries + plugins) needed
# by the headless RoboticsServiceProcess into a staging directory.
#
# Usage: collect-qt-runtime.sh <qt_install_dir> <staging_dir>
#
#   <qt_install_dir>  Root of a Qt 6 prefix (e.g. /opt/Qt/6.7.3/gcc_64).
#                     Must contain ./lib and ./plugins.
#   <staging_dir>     Destination directory; ./lib and ./plugins will be
#                     created inside it.
#
# Only non-GUI Qt modules are copied. No QML, no platforms/, no fonts.

set -euo pipefail

QT_DIR="${1:?qt install dir required}"
DST="${2:?staging dir required}"

if [ ! -d "$QT_DIR/lib" ]; then
    echo "ERROR: $QT_DIR/lib not found" >&2
    exit 1
fi

mkdir -p "$DST/lib" "$DST/plugins"

# Qt6 modules required at runtime by RoboticsServiceProcess and its dependencies.
QT_MODULES=(
    Qt6Core
    Qt6Network
    Qt6DBus
    Qt6Sql
    Qt6Xml
    Qt6Core5Compat
)

copy_versioned_so() {
    local pattern="$1"
    # Resolve all matching shared object files (including symlinks) and copy
    # them while preserving the symlink chain.
    shopt -s nullglob
    local matched=("$QT_DIR/lib/"$pattern*)
    shopt -u nullglob
    if [ "${#matched[@]}" -eq 0 ]; then
        echo "WARN: no files match $pattern in $QT_DIR/lib" >&2
        return
    fi
    cp -a "${matched[@]}" "$DST/lib/"
}

for m in "${QT_MODULES[@]}"; do
    copy_versioned_so "lib${m}.so"
done

# ICU is a hard dependency of Qt6Core for unicode support.
copy_versioned_so "libicui18n.so"
copy_versioned_so "libicuuc.so"
copy_versioned_so "libicudata.so"

# Qt plugins required for networking and TLS. We deliberately skip
# platforms/, imageformats/, etc. since the service is headless.
QT_PLUGIN_DIRS=(
    tls
    networkinformation
    sqldrivers
)
for d in "${QT_PLUGIN_DIRS[@]}"; do
    if [ -d "$QT_DIR/plugins/$d" ]; then
        mkdir -p "$DST/plugins/$d"
        cp -a "$QT_DIR/plugins/$d/." "$DST/plugins/$d/"
    fi
done

echo "Qt runtime collected into $DST"
ls -1 "$DST/lib"   | sed 's/^/  lib\//'
ls -1 "$DST/plugins" | sed 's/^/  plugins\//'
