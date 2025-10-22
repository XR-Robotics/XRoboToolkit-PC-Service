#!/bin/bash
# Handle arguments
BUILD_NUM="1000"  # Default build number
CLEAN_FLAG=false
OVERSEAS_FLAG=false

# Parse arguments
for arg in "$@"; do
    if [ "$arg" = "--clean" ]; then
        CLEAN_FLAG=true
    elif [ "$arg" = "overseas" ]; then
        OVERSEAS_FLAG=true
    elif [[ "$arg" =~ ^[0-9]+$ ]]; then
        # If argument is a number, use it as build number
        BUILD_NUM="$arg"
    fi
done

echo "Build number: $BUILD_NUM"
if [ "$CLEAN_FLAG" = true ]; then
    echo "Clean flag: enabled"
fi
if [ "$OVERSEAS_FLAG" = true ]; then
    echo "Overseas flag: enabled"
fi

echo "set qt gcc compile env parameter for ARM64 architecture..."
################################################################################
################################################################################
# Set the path to your Qt installation for ARM64 architecture

QT_GCC_ARM64=/home/orin_pico/Qt/6.7.3/gcc_arm64
export QT6_TOOLS=/home/orin_pico/Qt/Tools

export PATH=/home/orin_pico/Qt/6.7.3/gcc_arm64/bin:$PATH
export PATH=/home/orin_pico/Qt/6.7.3/gcc_arm64/include:$PATH
export PATH=/home/orin_pico/Qt/Tools/QtCreator/bin:$PATH
export PATH=/home/orin_pico/Qt/Tools/CMake/bin:$PATH
################################################################################
################################################################################

echo "set qt gcc compile env parameter finished."
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd $DIR

PROJECT_DIR=$DIR
RELEASE_DIR=$DIR/RelWithDebInfo

# Create directories if they don't exist (but don't delete if they do)
BinDir="$DIR/bin"
if [ ! -d "$BinDir" ]; then
    mkdir bin
fi

# Create lib directory for Qt libraries
LibDir="$DIR/bin/lib"
if [ ! -d "$LibDir" ]; then
    mkdir -p "$LibDir"
fi

if [ ! -d "$RELEASE_DIR" ]; then
    mkdir RelWithDebInfo
fi

# Check Qt version
echo "Using Qt 6.7.3 from $QT_GCC_ARM64"
if [ -f "$QT_GCC_ARM64/lib/libQt6Core.so.6.7.3" ]; then
    echo "Found Qt 6.7.3 libraries"
else
    echo "Warning: Qt 6.7.3 libraries not found at $QT_GCC_ARM64"
fi

# Only configure if CMakeCache.txt doesn't exist or --clean flag is provided
if [ ! -f "$RELEASE_DIR/CMakeCache.txt" ] || [ "$CLEAN_FLAG" = true ]; then
    echo "Running CMake configuration..."

    # If --clean flag is provided, remove directories and recreate them
    if [ "$CLEAN_FLAG" = true ]; then
        echo "Cleaning build directories..."
        rm -rf bin
        mkdir bin
        mkdir -p bin/lib
        rm -rf RelWithDebInfo
        mkdir RelWithDebInfo
    fi

    if [ "$OVERSEAS_FLAG" = true ]; then
        cmake -S $PROJECT_DIR -B $RELEASE_DIR -DBUILD_LIB_PATH:STRING=$QT_GCC_ARM64 -DAUTO_BUILD_NUM:STRING=$BUILD_NUM -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_PREFIX_PATH:PATH=$QT_GCC_ARM64 -DAUTO_BUILD_OVERSEA=ON
    else
        cmake -S $PROJECT_DIR -B $RELEASE_DIR -DBUILD_LIB_PATH:STRING=$QT_GCC_ARM64 -DAUTO_BUILD_NUM:STRING=$BUILD_NUM -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo -DCMAKE_PREFIX_PATH:PATH=$QT_GCC_ARM64
    fi
fi

# Always build
echo "Building..."
cmake --build $RELEASE_DIR --target all

echo "Build completed."
