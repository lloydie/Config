#!/usr/bin/env bash

if [ -d ~/.Config ]; then
    echo yes
else
    echo no
fi

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
}

cfg-vim-vundle-update() {
    vim +PluginInstall +q +q
}

cfg-vim-vundle-install() {
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}



setup() {
    ln -s "$CFG_PATH/vim/vim" "$HOME/.vim"
    cd ~/.vim/bundle/YouCompleteMe || exit
    python3 install.py --all
}
