#!/bin/bash

ramdisk_path="/home/i/ramdisk"
ramdisk_mnt="/mnt/ramdisk"
ramdisk_size='4G'

ramdisk-create() {
    _name="$*"
    sudo mkdir /mnt/$_name
    sudo mount -p -t tmpfs -o rw,size=$ramdisk_size $_name /mnt/$_name
}

