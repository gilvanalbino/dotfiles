#!/bin/bash

cp vimrc $HOME/.vimrc

if [ -z "$1" ];  then

    echo -e "Installing all dependencies"

    if [ ! -d "$HOME/.vim/autoload/plug.vim" ]; then
        echo -e "Installing plugin manager"
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    sudo apt-get install -y ctags npm cscope
    vim -c 'PluginInstall' -c 'qa!'

else
    if [ "$1" == "--vimrc" ]; then
        echo -e "Copying only the vimrc file."
    else
        echo -e "This script copies the vimrc to the correct place and installs all dependencies if necessary."
        echo -e "\nUsage: $0 [--vimrc]"
        echo -e "\noptions:"
        echo -e "\t--vimrc\t\tOnly copies the vimrc file. It does not install any dependencies."
    fi
fi
