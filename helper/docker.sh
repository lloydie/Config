#!/bin/bash

cfg-docker-uninstall() {
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo rm /etc/docker -rf
    sudo rm /var/docker -rf
    sudo rm /home/i/.docker -rf
}

cfg-docker-machine-install() {
    base=https://github.com/docker/machine/releases/download/v0.16.0 &&
    curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
    sudo install /tmp/docker-machine /usr/local/bin/docker-machine
    echo 'getting boot2docker v18.06.1-ce'
    wget https://github.com/boot2docker/boot2docker/releases/download/v18.06.1-ce/boot2docker.iso -O ~/.docker/machine/cache/boot2docker-18.06.1-ce.iso
}

cfg-docker-machine-install-bash-completions() {
    base=https://raw.githubusercontent.com/docker/machine/v0.16.0
    for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
    do
    sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
    done
}

cfg-docker-install() {

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
    apt-cache policy docker-ce
    sudo apt install docker-ce

    sudo systemctl enable docker
    docker container run hello-world

    sudo systemctl enable docker

}

cfg-docker-user() {
    sudo groupadd docker
    sudo usermod -aG docker $(whoami)
    echo '$ su - ${USER} # next login'

}

docker-image-rm-all() {
    docker images -q | xargs sudo docker image rm
}

docker-machine-env() {
    eval $(sudo docker-machine env $1)
}

docker-image-build() {

    PKG_TAG="lloydie/${PWD##*/}"

    PKG_INSTALLED=$(docker image ls | grep -c "$PKG_TAG")

    if [ "$PKG_INSTALLED" == '1' ]; then
	read -p "$PKG_TAG - installed: Delete ?" 
	if [ "$REPLY" == 'y' ]; then
	    docker image rm $PKG_TAG
	else
	    exit
	fi
    fi

    docker image rm $PKG_TAG
    docker build --tag="$PKG_TAG:latest" .
}


docker-machine-create() {


    PKG_NAME="${PWD##*/}"
    export VIRTUALBOX_BOOT2DOCKER_URL=file://$HOME/.docker/machine/cache/boot2docker-18.06.1-ce.iso

    read NODES

    docker-machine create --driver virtualbox "$PKG_NAME.manager"
    docker-machine ssh "$PKG_NAME.manager" "mkdir ./data"

    IP_MANAGER=$(docker-machine ip "$PKG_NAME.manager")
    SWARM_TOKEN=$(docker-machine ssh "$PKG_NAME.manager" "docker swarm init --advertise-addr $IP_MANAGER" | awk '/--token/ {print $5}')

    for ((n=1; n=NODES; n++)); do
	docker-machine create --driver virtualbox "$PKG_NAME.worker.$n"
	docker-machine ssh "$PKG_NAME.worker.$n" "docker swarm join --token $SWARM_TOKEN $IP_MANAGER:2377"
    done

    docker-machine env "$PKG_NAME.manager"
    eval $(docker-machine env "$PKG_NAME.manager")

    docker stack deploy -c docker-compose.yml "$PKG_NAME"
}

docker-machine-rm-all() {
    for i in $(docker-machine ls -q); do
	docker-machine rm -y $i
    done
}

docker-images-rm-all() {
    docker images -q | xargs -L 1 docker image rm --force
}

docker-info() {
    clear; echo -e "Container";docker ps;echo -e "\nImage"; docker images;echo -e "\nMachine"; docker-machine ls
}

#!/usr/bin/env bash

# TODO confirm dockerd running
docker-ca-create() {
    HOST=localhost

    # CA private and public key
    # "Common Name" == hostname
    openssl genrsa -aes256 -out ca-key.pem 4096
    openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

    # Server key 
    openssl genrsa -out server-key.pem 4096

    # CSR: certificate signing request
    openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

    # sign public key with CA
    echo subjectAltName = DNS:$HOST,IP:10.10.10.20,IP:127.0.0.1 >> extfile.cnf

    # dockerd setup
    echo extendedKeyUsage = serverAuth >> extfile.cnf

    # Generate signed certificate
    openssl x509 -req \
	-days 365 \
	-sha256 \
	-in server.csr \
	-CA ca.pem \
	-CAkey ca-key.pem \
	-CAcreateserial \
	-out server-cert.pem \
	-extfile extfile.cnf

    # CA, client key.
    openssl genrsa -out key.pem 4096

    # CA, sign client key
    openssl req -subj '/CN=client' -new -key key.pem -out client.csr

    echo extendedKeyUsage = clientAuth > extfile-client.cnf

    # Generate signed certificate
    openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem \
      -CAcreateserial -out cert.pem -extfile extfile-client.cnf

    # Cleanup
    rm -v client.csr server.csr extfile.cnf extfile-client.cnf

    chmod -v 0444 ca-key.pem key.pem server-key.pem

    # Dockerd accept CA
    dockerd --tlsverify --tlscacert=ca.pem --tlscert=server-cert.pem --tlskey=server-key.pem \
      -H=0.0.0.0:2376

    # Run on client machine
    docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem \
      -H=$HOST:2376 version

    mkdir -pv ~/.docker
    cp -v {ca,cert,key}.pem ~/.docker
    export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1

    docker ps
}
