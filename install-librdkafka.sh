#!/bin/bash

set -ex

DEST="$1"

if [[ -f $DEST/build/native/include/librdkafka/rdkafka.h ]]; then
    echo "Already installed in $DEST"
    exit 0
fi

mkdir -p "$DEST"
cd "$DEST"

curl -L -o lrk.zip https://www.nuget.org/api/v2/package/librdkafka.redist/${LIBRDKAFKA_VERSION}

unzip lrk.zip


if which ldd ; then
    # Linux

    # Copy the librdkafka build with least dependencies to librdkafka.so
    cp -v runtimes/linux-x64/native/{centos6-,}librdkafka.so
    ldd runtimes/linux-x64/native/librdkafka.so

elif which otool ; then
    # MacOS X

    # Change the library's self-referencing name from
    # /Users/travis/.....somelocation/librdkafka.1.dylib to its local path.
    install_name_tool -id $PWD/runtimes/osx-x64/native/librdkafka.dylib runtimes/osx-x64/native/librdkafka.dylib

    otool -L runtimes/osx-x64/native/librdkafka.dylib
fi


