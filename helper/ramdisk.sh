#!/bin/bash

ramdisk_mnt="/home/i/ramdisk"
ramdisk_path=""
ramdisk_size='4G'

sudo mount -t tmpfs -o rw,size=$ramdisk_size ramdisk $ramdisk_path
rsync -av $ramdisk_path $ramdisk_mnt
