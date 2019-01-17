function print_ansi_colors() {
	a=1
	for i in {0..255} ; do
		printf "\x1b[38;5;%sm%3d\e[0m " "$i" "$i"
		printf "\x1b[48;5;   \e[0m " "$i"
		let "a+=1"

		if [ "$a" -gt 8 ]; then
			printf "\n"
			a=1
		fi
	done
	printf "\n"
}
