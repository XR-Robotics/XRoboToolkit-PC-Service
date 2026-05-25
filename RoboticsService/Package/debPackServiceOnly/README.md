# Service-only Debian packaging

This directory produces a minimal `.deb` containing only the headless
`RoboticsServiceProcess` and the Qt 6 runtime libraries it requires.
No GUI demos, no Unity binaries, no Qt QML / platforms plugins.

The resulting package installs to `/opt/apps/xrobotoolkit-pc-service/` and
exposes `runService.sh` as the entry point.

## Build inputs

`build-deb.sh` consumes:

* a finished CMake build under `RoboticsService/bin/` (with at least
  `RoboticsServiceProcess`, `libBusiness.so`, `libCommonUtils.so`,
  `libDeviceConnectionManager.so`, `libPXREAGRPCServer.so`),
* a Qt 6 prefix (e.g. `/opt/Qt/6.7.3/gcc_64`) providing `lib/` and
  `plugins/` directories.

It then stages the runtime, generates `DEBIAN/control` from `control.in`,
strips ELF binaries, and produces:

```
xrobotoolkit-pc-service_<version>_<arch>.deb
```

## Manual invocation

```bash
./build-deb.sh amd64 1.0.0.42 \
    /path/to/RoboticsService/bin \
    /opt/Qt/6.7.3/gcc_64 \
    /tmp/out
```

## Continuous integration

The companion workflow `.github/workflows/build-deb-ubuntu2004.yml`
calls this script after building the project inside an `ubuntu:20.04`
container to guarantee a glibc 2.31 target. The workflow produces both
`amd64` and `arm64` artifacts.

## Runtime contents

```
/opt/apps/xrobotoolkit-pc-service/
├── RoboticsServiceProcess              # main service binary
├── libBusiness.so
├── libCommonUtils.so
├── libDeviceConnectionManager.so
├── libPXREAGRPCServer.so
├── libssl.so, libssl.so.3
├── libcrypto.so, libcrypto.so.3
├── runService.sh                       # entry point (sets LD_LIBRARY_PATH etc.)
├── setting.ini                         # default configuration
├── lib/                                # Qt 6 + ICU shared libraries
└── plugins/                            # Qt plugins (tls, networkinformation, sqldrivers)
```
