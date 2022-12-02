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
# Check for existing bash_profile
if [[ -f $HOME/.bash_profile ]];then
    mv $HOME/.bash_profile $HOME/.bash_profile.bak
fi
# Check for existing k8s Prompt
if [[ -f $HOME/.tmux.conf ]];then
    mv $HOME/.k8sprompt.sh $HOME/.k8sprompt.sh.bak
fi

## Check and setup for Mac OS
os=`uname`
if [[ ${os} == Darwin ]];then
    ./mac_setup.sh
fi

# Create symlinks to ~/dotfiles
ln -sv ~/dotfiles/.vimrc ~
ln -sv ~/dotfiles/.vim ~
ln -sv ~/dotfiles/.bashrc ~
ln -sv ~/dotfiles/.bash_profile ~
ln -sv ~/dotfiles/.tmux.conf ~
ln -sv ~/dotfiles/.k8sprompt.sh ~
ln -sv ~/dotfiles/.ansible.cfg ~

# Get Git Bash Completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Add KyWa repositories
# Also assumes you pulled this repo with an ssh key
echo "Would you like to add KyWa repositories?: y/n"
read repo_install

case $repo_install in
    [yY][eE][sS][|[yY])
        mkdir -p ~/Working/kywa
        cd ~/Working/kywa
        git clone git@github.com:kywa/kywa.git
        git clone git@github.com:kywa/kywa-lab
        git clone git@github.com:kywa/kywa-ahoy.git
        git clone git@github.com:kywa/mineops.git
        git clone git@github.com:kywa/kywa-kube-dd
        git clone git@github.com:kywa/kywa-argo
        git clone git@github.com:kywa/dockerbuilds
        git clone git@github.com:kywa/kywa-website
        git clone git@github.com:kywa/yamlzone
        git clone git@github.com:kywa/kywa-learn
        echo "Repos cloned and all done!"
        ;;
    [nN][oO]|[nN])
        echo "All done!"
        exit
        ;;
esac

source ~/.bash_profile
