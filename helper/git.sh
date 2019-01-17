#!/usr/bin/env bash

# git wrappers

git-push() {
    _msg="$@"
    git add .
    git commit -m "$_msg"
    git push
}

git-ssh-create() {
    KEY_FILE=github
    read -p 'git.username=' KEY_NAME
    read -p 'git.email=' KEY_EMAIL

    	ssh-keygen -t rsa -b 4096 -C "$KEY_EMAIL" -f $KEY_FILE
    eval "$(ssh-agent -s)"
    mv "$KEY_FILE" "$KEY_FILE.pub" ~/.ssh
    ssh-add ~/.ssh/$KEY_FILE
    xclip -sel clip < ~/.ssh/$KEY_FILE.pub
    echo "$KEY_FILE public key in clipboard."
    echo 'https://github.com/settings/ssh/new'
}

git-ssh-test() {
    ssh -T git@github.com
}

git-ssh-login() {
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github
    git-ssh-test
}
