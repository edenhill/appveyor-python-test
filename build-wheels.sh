#!/bin/bash
#
#
# Build wheels (on Linux or OSX) using cibuildwheel.
#


# Skip PyPy, old Python3 versions, and x86 builds.
export CIBW_SKIP="pp* cp35-* *i686"
export CIBW_TEST_COMMAND="python {project}/test.py"


librdkafka_version=$1
wheeldir=$2

if [[ -z $wheeldir ]]; then
    echo "Usage: $0 <librdkafka-nuget-version> <wheeldir>"
    exit 1
fi

set -ex

[[ -d $wheeldir ]] || mkdir -p "$wheeldir"


osname=$(uname -s)
case $osname in
    Linux)
        os=linux
        # Needed by setup.py to find librdkafka
        lib_dir=dest/runtimes/linux-x64/native
        export CIBW_ENVIRONMENT="INCLUDE_DIRS=dest/build/native/include LIB_DIRS=$lib_dir LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PWD/$lib_dir"
        ;;
    Darwin)
        os=macos
        lib_dir=dest/runtimes/osx-x64/native
        ;;
    *)
        echo "$0: May only be used on Linux or OSX"
        exit 1
        ;;
esac



function install_librdkafka {
    local ver=$1
    local dest=$2   # dest directory

    set -ex

    if [[ -f $dest/build/native/include/librdkafka/rdkafka.h ]]; then
        echo "$0: librdkafka already installed in $dest"
        return
    fi

    mkdir -p "$dest"
    pushd "$dest"

    echo "Installing librdkafka $ver to $dest"
    curl -L -o lrk.zip https://www.nuget.org/api/v2/package/librdkafka.redist/${ver}

    unzip lrk.zip

    if [[ $os == linux ]]; then
        # Copy the librdkafka build with least dependencies to librdkafka.so
        cp -v runtimes/linux-x64/native/{centos6-,}librdkafka.so
        ldd runtimes/linux-x64/native/librdkafka.so

    elif [[ $os == macos ]]; then
        # MacOS X

        # Change the library's self-referencing name from
        # /Users/travis/.....somelocation/librdkafka.1.dylib to its local path.
        install_name_tool -id $PWD/runtimes/osx-x64/native/librdkafka.dylib runtimes/osx-x64/native/librdkafka.dylib

        otool -L runtimes/osx-x64/native/librdkafka.dylib
    fi

    popd
}



install_librdkafka $librdkafka_version dest

python3 -m pip install cibuildwheel==1.7.4

if [[ -z $TRAVIS ]]; then
    cibw_args="--platform $os"
fi

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/$lib_dir python3 -m cibuildwheel --output-dir $wheeldir $cibw_args

ls $wheeldir

for f in $wheeldir/*whl ; do
    echo $f
    unzip -l $f
done

