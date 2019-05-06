#!/bin/bash

# Check for existing Bashrc
if [[ -f $HOME/.bashrc ]];then
        mv $HOME/.bashrc $HOME/.bashrc.bak
fi
# Check for existing Vimrc
if [[ -f $HOME/.vimrc ]];then
        mv $HOME/.vimrc $HOME/.vimrc.bak
fi
# Check for existing Ansiblecfg
if [[ -f $HOME/.ansible.cfg ]];then
        mv $HOME/.ansiblecfg $HOME/.ansiblecfg.bak
fi

# dotfiles and vim
ln -sv ~/dotfiles/.vimrc ~
ln -sv ~/dotfiles/.vim ~
ln -sv ~/dotfiles/.bashrc ~

# ansible configs
ln -sv ~/dotfiles/.ansible.cfg ~

# tell yourself your done
echo "All done"
