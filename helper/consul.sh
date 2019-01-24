socat -v tcp-l:8181,fork exec:"/bin/cat"

nc 127.0.0.1 8181
