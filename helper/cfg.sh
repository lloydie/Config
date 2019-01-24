#!/usr/bin/env bash

cfg-bash-update() {
	find ~/cfg/bash/{bashrc,alias}/ -type f -executable | sort | xargs -L1 cat > ~/.bashrc
	find ~/cfg/helper/ -type f -executable | xargs -L1 cat >> ~/.bashrc
	. ~/.bashrc
}

cfg-bash-history-backup() {
    date >> ~/log/bash_history
    history >> ~/log/bash_history
    history -c
}

cfg-tmux-update() {
	find ~/cfg/tmux/tmux.conf/* -type f -executable | sort | xargs cat > ~/.tmux.conf
	tmux source ~/.tmux.conf
}

cfg-tmux-tpm-setup() {
    rm -r ~/.tmux/plugins/tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

cfg-vim-update() {
	find ~/cfg/vim/vimrc -type f -executable | sort | xargs -L 1 cat > ~/.vimrc
	find ~/cfg/vim/plugin -type f -executable | sort | xargs -L 1 cat >> ~/.vimrc
}

cfg-vim-plugin-update() {
    vim +PluginInstall +PluginUpdate +q +q
}

cfg-vim-plugin-setup() {
    if [ -d ~/.vim/bundle ]; then
	echo 'bundle dir exists.'
	read -p "delete ? "
	if [ "$REPLY" == 'y' ]; then
	    rm -r ~/.vim/bundle/*
	else
	    exit
	fi
    fi
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

