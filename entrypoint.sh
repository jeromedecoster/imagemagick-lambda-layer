# the directory of his script file
dir="$(cd "$(dirname "$0")"; pwd)"
cd "$dir"


CACHE=/var/task/build/cache

CONFIGURE="PKG_CONFIG_PATH=$CACHE/lib/pkgconfig \
    ./configure \
    CPPFLAGS=-I$CACHE/include \
    LDFLAGS=-L$CACHE/lib \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --prefix=$CACHE"


# log $1 in green then $2 in yellow
log() {
    echo -e "\033[1;32m$1: \033[1;33m$2\033[0m"
}


# build `libjpg` if not already done
if [[ ! -f "$CACHE/lib/libjpeg.a" ]]; then
    log 'build' 'libjpg plugin'
    cd /var/task/src/libjpg

    eval "$CONFIGURE"

    make
    make install
else
    log 'skip build' 'libjpg plugin'
fi


# build `libpng` if not already done
if [[ ! -f "$CACHE/lib/libpng.a" ]]; then
    log 'build' 'libpng plugin'
    cd /var/task/src/libpng

    eval "$CONFIGURE"

    make
    make install
else
    log 'skip build' 'libpng plugin'
fi


# build `libtiff` if not already done
if [[ ! -f "$CACHE/lib/libtiff.a" ]]; then
    log 'build' 'libtiff plugin'
    cd /var/task/src/libtiff

    eval "$CONFIGURE"

    make
    make install
else
    log 'skip build' 'libtiff plugin'
fi


# build `libbz2` if not already done
if [[ ! -f "$CACHE/lib/libbz2.a" ]]; then
    log 'build' 'libbz2 plugin'
    cd /var/task/src/libbz2

    eval "$CONFIGURE"

    make libbz2.a
    make install PREFIX=$CACHE
else
    log 'skip build' 'libbz2 plugin'
fi


# build `libwebp` if not already done
if [[ ! -f "$CACHE/lib/libwebp.a" ]]; then
    log 'build' 'libwebp plugin'
    cd /var/task/src/libwebp

    sh autogen.sh
    eval "$CONFIGURE"

    make
    make install
else
    log 'skip build' 'libwebp plugin'
fi


# build `libopenjp2` if not already done
if [[ ! -f "$CACHE/lib/libopenjp2.a" ]]; then
    log 'build' 'libopenjp2 plugin'
    cd /var/task/src/libopenjp2

    mkdir -p build
    cd build 
    PKG_CONFIG_PATH=$CACHE/lib/pkgconfig cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$CACHE \
        -DBUILD_SHARED_LIBS:bool=off \
        -DBUILD_CODEC:bool=off
    make clean
    make install

else
    log 'skip build' 'libopenjp2 plugin'
fi


# build `imagemagick` if not already done
if [[ ! -f "/var/task/imagemagick.zip" ]]; then
    log 'build' 'imagemagick'
    cd /var/task/src/imagemagick

    PKG_CONFIG_PATH=$CACHE/lib/pkgconfig \
        ./configure \
        CPPFLAGS=-I$CACHE/include \
        LDFLAGS=-L$CACHE/lib \
        --disable-dependency-tracking \
        --disable-shared \
        --enable-static \
        --prefix=/opt/ \
        --enable-delegate-build \
        --without-modules \
        --disable-docs \
        --without-magick-plus-plus \
        --without-perl \
        --without-x \
        --disable-openmp

    make clean
    make all
    make install

    # zip
    cd /opt
    zip /var/task/imagemagick.zip --recurse-paths --symlinks -9 *
else
    log 'skip build' 'imagemagick'
fi


# chown to remove `root` user
useradd $HOST_USER
chown -R $HOST_USER:$HOST_USER \
    /var/task/build \
    /var/task/src \
    /var/task/imagemagick.zip