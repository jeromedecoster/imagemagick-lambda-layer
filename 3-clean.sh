#!/bin/bash

# the directory of his script file
dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dir"


rm --force --recursive build src imagemagick.zip

# remove all the zip directory if the first argument is `all` or `--all`
if [[ ${1##*-} == 'all' ]]; then
    rm --force --recursive zip
fi