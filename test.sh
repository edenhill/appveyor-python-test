#!/bin/bash
#

set -x

project_dir="$1"
package="$2"

dir "$package"

unzip -l "$package"

python ${project_dir}/sample.py

exit $?
