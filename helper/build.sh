#!/bin/bash

build() {
    make clean
    ./configure
    make
}
