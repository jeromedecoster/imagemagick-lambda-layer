#!/bin/bash

# the directory of his script file
dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dir"

# make directories
mkdir --parents zip src

# echo $1 in green then $2 in yellow
log() {
    echo -e "\033[1;32m$1: \033[1;33m$2\033[0m"
}

# download $2 into ./zip/$1
# then extract $2 into ./src/$1
download() {
    local tarfile="${2##*/}"
    mkdir --parents "zip/$1"
    cd "zip/$1"

    # download if not already done
    if [[ ! -f "$tarfile" ]]; then
        log 'download' "$1/$tarfile"
        curl --location --remote-name "$2"
    else
        log 'skip download' "$1/$tarfile"
    fi

    # extract if not already done
    if [[ ! -d "$dir/src/$1" ]]; then
        log 'extract' "$1/$tarfile"
        tar --extract --file *.tar.*

        # mv and rename the extracted directory into ../src
        local extracted=$(find . -maxdepth 1 -mindepth 1 -type d -printf '%f')
        mv --force "$extracted" "$dir/src/$1"
    else
        log 'skip extract' "$1/$tarfile"
    fi

    cd "$dir"
}


# imagemagick
download imagemagick https://github.com/ImageMagick/ImageMagick/archive/7.0.9-20.tar.gz
# libbz2
download libbz2 http://prdownloads.sourceforge.net/bzip2/bzip2-1.0.6.tar.gz
# libjpg
download libjpg http://ijg.org/files/jpegsrc.v9d.tar.gz
# libopenjp2
download libopenjp2 https://github.com/uclouvain/openjpeg/archive/v2.3.1.tar.gz
# libpng
download libpng http://prdownloads.sourceforge.net/libpng/libpng-1.6.37.tar.xz
# libtiff
download libtiff http://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz
# libwebp
download libwebp https://github.com/webmproject/libwebp/archive/v1.1.0.tar.gz

log 'docker pull' 'lambci/lambda-base-2:build'
docker pull lambci/lambda-base-2:build
