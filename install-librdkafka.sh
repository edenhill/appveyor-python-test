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

# Copy the librdkafka build with least dependencies to librdkafka.so
cp -v runtimes/linux-x64/native/{debian9-,}librdkafka.so

