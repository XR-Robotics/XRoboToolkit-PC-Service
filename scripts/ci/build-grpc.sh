#!/usr/bin/env bash
# Build gRPC (with all of its bundled dependencies: abseil, protobuf,
# re2, c-ares, zlib, BoringSSL) statically with -fPIC and install it
# into a layout compatible with the RoboticsService CMake project.
#
# Usage:
#   build-grpc.sh <grpc_version> <install_prefix>
#
#     <grpc_version>    git tag of grpc/grpc, e.g. v1.66.2.
#     <install_prefix>  destination directory. After installation it
#                       will contain include/ and lib/ subdirectories
#                       suitable to drop into
#                       RoboticsService/Redistributable/linux_aarch64/grpc/.
#
# The .a files are built with -fPIC so they can be linked into the
# project shared libraries (libPXREAGRPCServer.so etc.).

set -euo pipefail

GRPC_VERSION="${1:?grpc version required, e.g. v1.66.2}"
PREFIX="${2:?install prefix required}"

JOBS="${JOBS:-$(nproc)}"
WORKDIR="${WORKDIR:-/tmp/grpc-build}"

echo "==> Building gRPC ${GRPC_VERSION}"
echo "    install prefix: ${PREFIX}"
echo "    work dir      : ${WORKDIR}"
echo "    parallel jobs : ${JOBS}"

rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

git clone --recursive --shallow-submodules --depth 1 \
    --branch "$GRPC_VERSION" \
    https://github.com/grpc/grpc.git grpc

cd grpc
mkdir -p build
cd build

cmake \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DgRPC_INSTALL=ON \
    -DgRPC_BUILD_TESTS=OFF \
    -DgRPC_BUILD_CSHARP_EXT=OFF \
    -DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
    -DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
    -DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
    -DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
    -DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
    -DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
    -DgRPC_SSL_PROVIDER=module \
    -DgRPC_ZLIB_PROVIDER=module \
    -DgRPC_CARES_PROVIDER=module \
    -DgRPC_RE2_PROVIDER=module \
    -DgRPC_PROTOBUF_PROVIDER=module \
    -DgRPC_ABSL_PROVIDER=module \
    ..

cmake --build . --parallel "$JOBS"
cmake --install .

# ---------------------------------------------------------------------------
# Post-install: merge upb sub-archives into a single libupb.a
# ---------------------------------------------------------------------------
# Starting with gRPC 1.55, upb is installed as several smaller archives
# (libupb_base_lib.a, libupb_mem_lib.a, libupb_message_lib.a, ...). The
# RoboticsService CMake project still expects the legacy monolithic
# libupb.a (matching the committed amd64 set in
# Redistributable/linux/grpc/lib/libupb.a). Merge them so we provide the
# same on-disk layout.
LIB_DIR="$PREFIX/lib"
if [ ! -f "$LIB_DIR/libupb.a" ] && ls "$LIB_DIR"/libupb*.a >/dev/null 2>&1; then
    echo "==> Merging split upb archives into libupb.a"
    MERGE_TMP="$(mktemp -d)"
    pushd "$MERGE_TMP" >/dev/null
    for a in "$LIB_DIR"/libupb*.a; do
        echo "    extracting $(basename "$a")"
        ar x "$a"
    done
    ar rcs "$LIB_DIR/libupb.a" ./*.o
    popd >/dev/null
    rm -rf "$MERGE_TMP"
    # Remove the split archives so the linker does not pick them up twice.
    find "$LIB_DIR" -maxdepth 1 -name 'libupb_*.a' -delete
fi

# ---------------------------------------------------------------------------
# Sanity check: every archive the project's CMakeLists references for the
# aarch64 build must exist in the install tree. Missing files are
# reported but do not fail the script so that the next build step can
# surface a more readable error.
# ---------------------------------------------------------------------------
EXPECTED_LIBS=(
    libgrpc++.a libgrpc.a libgpr.a libgrpc_unsecure.a libgrpc++_unsecure.a
    libgrpc_authorization_provider.a libgrpc++_alts.a libgrpc++_error_details.a
    libgrpc_plugin_support.a libgrpcpp_channelz.a libgrpc++_reflection.a
    libprotobuf.a libprotobuf-lite.a libprotoc.a
    libssl.a libcrypto.a libz.a libcares.a libre2.a
    libupb.a libutf8_range.a libutf8_validity.a libaddress_sorting.a
    libabsl_base.a libabsl_strings.a libabsl_synchronization.a
    libabsl_vlog_config_internal.a libabsl_log_internal_proto.a
)
missing=()
for lib in "${EXPECTED_LIBS[@]}"; do
    [ -f "$LIB_DIR/$lib" ] || missing+=("$lib")
done
if [ "${#missing[@]}" -gt 0 ]; then
    echo "WARN: ${#missing[@]} expected archives are missing from $LIB_DIR:" >&2
    printf '  %s\n' "${missing[@]}" >&2
fi

echo "==> gRPC installation tree:"
find "$PREFIX" -maxdepth 3 -type d | sed 's/^/  /'
echo "==> Total static libraries installed: $(find "$LIB_DIR" -maxdepth 1 -name '*.a' | wc -l)"
echo "==> Done."
