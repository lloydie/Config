#!/usr/bin/env bash

function _filename() {
	_file="$*"
	printf '%s' "${_file%.*}"
}

function _fileext() {
	_file="$*"
	printf '%s' "${_file#*.}"
}
