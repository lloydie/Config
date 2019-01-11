#!/usr/bin/env bash

cfg-bash-update() {
	find ~/.Config/bash/{bashrc,alias}/ -type f -executable | sort | xargs -L1 cat > ~/.bashrc
	find /usr/local/helper -type f -executable | xargs -L1 cat >> ~/.bashrc
	. ~/.bashrc
}

cfg-tmux-update() {
	find ~/.Config/tmux/tmux.conf/* -type f -executable | sort | xargs cat > ~/.tmux.conf
	tmux source ~/.tmux.conf
}

cfg-tmux-tpm-setup() {
	rm -r ~/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

cfg-vim-update() {
	find ~/.Config/vim/vimrc -type f -executable | sort | xargs -L 1 cat > ~/.vimrc
	find ~/.Config/vim/plugin -type f -executable | sort | xargs -L 1 cat >> ~/.vimrc
	cfg-vim-plugin-update
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




cfg-vim-plugin-youcompleteme-setup() {
    cd ~/.vim/bundle/YouCompleteMe || exit
    python3 install.py --all
}

if [ -d ~/.Config ]; then
    echo yes
else
    git clone https://github.com/lloydie/Config.git ~/.Config
fi

