#!/usr/env/bash

run() {
	cmd_exec="$*"
	read -r -e -i "$cmd_exec" -p "$ " cmd_exec
	eval "$cmd_exec"
	if [ $? -eq 0 ]; then
		cmd_return='ok'
	else
		cmd_return='fail'
	fi
	printf '$?=%s\n' "$cmd_return"
}

msg()
{
	printf 'Message\n%s'
}	
