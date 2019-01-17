function _time() {
	/usr/bin/time -f %E "$*"
}
alias time="_time"
