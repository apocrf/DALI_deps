#!/bin/bash -xe

# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export ROOT_DIR=$(pwd)
export SCRIPT_DIR=$(cd $(dirname $0) && pwd)
export HOST_INSTALL_PREFIX=${HOST_INSTALL_PREFIX:-/usr/local}
export INSTALL_PREFIX=${INSTALL_PREFIX:-$HOST_INSTALL_PREFIX}
export CC_COMP=${CC_COMP:-gcc}
export CXX_COMP=${CXX_COMP:-g++}
export WITH_FFMPEG=${WITH_FFMPEG:-1}
export OPENCV_TOOLCHAIN_FILE=${OPENCV_TOOLCHAIN_FILE:-"linux/gnu.toolchain.cmake"}
export CMAKE_TARGET_ARCH=${CMAKE_TARGET_ARCH:-$(uname -m)}
export CLEANUP=${CLEANUP:-0}
echo ${INSTALL_PREFIX}
echo ${CC_COMP}
echo ${CXX_COMP}
echo ${CMAKE_TARGET_ARCH}
echo ${BUILD_ARCH_OPTION}
echo ${HOST_ARCH_OPTION}
echo ${SYSROOT_ARG}
echo ${WITH_FFMPEG}
echo ${EXTRA_PROTOBUF_FLAGS}
echo ${OPENCV_TOOLCHAIN_FILE}
echo ${EXTRA_FLAC_FLAGS}
echo ${EXTRA_LIBSND_FLAGS}
echo ${CLEANUP}

if [ "$CLEANUP" -eq 1 ]; then
    git clean -fdx
    git submodule init
    git submodule update --init --recursive
    git submodule foreach 'git clean -fdx'
    git submodule foreach 'git checkout --force'
fi

PACKAGE_LIST=(
    "zlib"
    "protobuf"
    "lmdb"
    "libjpeg-turbo"
    "zstd"
    "openjpeg"
    "libtiff"
    "opencv"
    "ffmpeg"
    "libflac"
    "libogg"
    "libvorbis" # Install after libogg
    "libopus"
    "libsnd"
    "libtar"
    "cfitsio"
    "aws-sdk-cpp"
)

for PACKAGE in "${PACKAGE_LIST[@]}"; do
    ${SCRIPT_DIR}/build_${PACKAGE}.sh
done
