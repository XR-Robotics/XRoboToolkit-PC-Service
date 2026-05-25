#!/usr/bin/env bash
# Launcher for the headless XRoboToolkit PC Service.
# All Qt and project runtime dependencies are bundled under this directory.

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export LD_LIBRARY_PATH="$DIR:$DIR/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export QT_PLUGIN_PATH="$DIR/plugins${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"

cd "$DIR"
exec ./RoboticsServiceProcess "$@"
