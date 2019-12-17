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
        mv $HOME/.ansible.cfg $HOME/.ansible.cfg.bak
fi
# Check for existing TMUX Config
if [[ -f $HOME/.tmux.conf ]];then
        mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
fi


# dotfiles and vim
ln -sv ~/dotfiles/.vimrc ~
ln -sv ~/dotfiles/.vim ~
if [[ $SHELL = "/bin/zsh" ]];then
    ln -sv ~/dotfiles/.bashrc ~/.zshrc
else
    ln -sv ~/dotfiles/.bashrc ~
fi
ln -sv ~/dotfiles/.tmux.conf ~

# ansible configs
ln -sv ~/dotfiles/.ansible.cfg ~

# tell yourself your done
echo "All done"
