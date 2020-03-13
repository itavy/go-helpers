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

set -euo pipefail;

HAVE_TO_GENERATE=${HAVE_TO_GENERATE:-0}
if [[ "$HAVE_TO_GENERATE" == "1" ]]; then
  make generate
fi

gofiles=$(git diff --cached --name-only --diff-filter=ACM | grep '\.go$' || [[ $? == 1 ]])
license_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\(\.go\|\.sh\)$' || [[ $? == 1 ]])


if [ ! -z "$gofiles" ]; then
  unformatted=$(gofmt -l $gofiles)

  if [ ! -z "$unformatted" ]; then
    echo >&2 "Go files must be formatted with gofmt. Please run:"
    for fn in $unformatted; do
      echo >&2 "  gofmt -w $PWD/$fn"
    done
    exit 1
  fi
fi

[ -z "$license_files" ] && exit 0
./scripts/utils/validate_license.sh $license_files
