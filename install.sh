#!/bin/bash


# dotfiles and vim
ln -sv ~/dotfiles/.vimrc ~
ln -sv ~/dotfiles/.vim ~
ln -sv ~/dotfiles/.bashrc ~

# ansible configs
ln -sv ~/dotfiles/.ansible.cfg ~

# tell yourself your done
echo "Scripts in place, proceed to working"
