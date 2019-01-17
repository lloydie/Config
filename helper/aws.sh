aws-setup() {
    sudo apt install python3-pip
    sudo -H pip3 install awscli --upgrade --user
    aws --version
}
