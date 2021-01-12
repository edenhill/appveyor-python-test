#!/bin/bash

set -ex

DEST="$1"

cd "$DEST"

curl -L -o lrk.zip https://www.nuget.org/api/v2/package/librdkafka.redist/1.6.0-RC1

unzip lrk.zip

dir
