#!/usr/bin/env bash
###############################################################################
#  The MIT License (MIT)
#
# Copyright 2020 Octavian Ionescu <itavyg.at.gmail.com>
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
##############################################################################

set -euo pipefail

LICENSE_HEADER="The MIT License"
LICENSE_HEADER_OWNER="Octavian Ionescu"
LICENSE_COPYRIGHT_HEADER="Copyright"

find_files() {
  IFS=$'\n\t'
  find . -not \( \
    \( -wholename './vendor' -o -wholename '*testdata*' \) -prune \
  \) \
  \( -name '*.go' -o -name '*.sh' \)
}

check_licensing() {
    local header_check=${1}
    shift
    local header_name=${1}
    shift
    local files_to_check="$@"
    if [ -z "${files_to_check}" ]; then
        files_to_check=$(find_files)
    fi
    failed_files=()
    for f in $files_to_check; do
        if ! grep -qi "$header_check" "$f"; then
          failed_files+=("$f")
        fi
    done
    if (( ${#failed_files[@]} > 0 )); then
      echo "Some source files are missing the $header_name header(s)."
      for f in "${failed_files[@]}"; do
        echo "  $f"
      done
      exit 1
    fi
}

check_licensing "${LICENSE_HEADER}" "license" "$@"
check_licensing "${LICENSE_HEADER_OWNER}" "license" "$@"
check_licensing "${LICENSE_COPYRIGHT_HEADER}" "copyright" "$@"
