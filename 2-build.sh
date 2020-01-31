#!/bin/bash

# the directory of his script file
dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dir"

# echo $1 in green then $2 in yellow
log() {
    echo -e "\033[1;32m$1: \033[1;33m$2\033[0m"
}

# echo $1 in red then $2 in pink
err() {
    echo -e "\033[1;31m$1: \033[1;35m$2\033[0m"
}

if [[ ! -d "$dir/src" ]]; then
    err 'abort' 'src directory is missing'
    exit 1
fi

# make directories
mkdir --parents build/cache/lib/pkgconfig

log 'docker run' 'lambci/lambda-base-2:build'
docker run \
    --interactive \
    --tty \
    --rm \
    --volume $(pwd):/var/task \
    --env "HOST_USER=$(whoami)" \
    --entrypoint /bin/bash \
    --workdir /var/task/build \
    lambci/lambda-base-2:build \
    ../entrypoint.sh