function myip() {
    curl ipinfo.io/ip
}

net-ports-listen() {
    sudo netstat -ltpe
}

net-route() {
    sudo netstat -r
}


