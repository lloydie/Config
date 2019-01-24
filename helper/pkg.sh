#!/bin/bash

PKG_PATH="$HOME/pkg"

pkg-add() {
    PKG_NAME="$*"
    if [ -d "$PKG_PATH/$PKG_NAME" ]; then 
        echo 'pkg exists'
    else
        read -p "about=" PKG_ABOUT
        read -p "website=" PKG_URL
        read -p "git=" PKG_SRC
    fi
    mkdir -p $PKG_PATH/$PKG_NAME/{cfg,bin,src,etc,rel}
}

pkg-index() {

    for i in bin cfg src rel doc; do
        for pkg in $(ls pool); do
            ln -s $PKG_PATH/$pkg/$i $PKG_PATH/$i/$pkg
        done
    done
}

pkg-build() {
    make clean
    ./configure
    make
}
