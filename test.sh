#!/bin/bash
#

set -ex

project_dir="$1"
package="$2"

echo "projdir $1, package $2"
dir "$package"

unzip -l "$package"

python ${project_dir}/sample.py

exit 1
