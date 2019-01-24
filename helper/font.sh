#!/bin/sh

PATH_FONTS=/usr/share/fonts

font-install() {
	_FONT="$*"
	sudo cp -v "$_FONT" "$PATH_FONTS"
}
