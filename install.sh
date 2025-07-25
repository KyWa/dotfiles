#!/usr/bin/env bash

# Backup existing shell files and then link to this repository
FILES=".ansible.cfg .bash_profile .bashrc .k8sprompt.sh .tmux.conf .vim .vimrc"

for f in $FILES;do
  if [[ -f $HOME/$f ]];then
    mv $HOME/$f $HOME/$f.bak
    ln -sv $PWD/$f $HOME/$f
  fi
done

# Check and setup for Mac OS
if [[ `uname` == "Darwin" ]];then
  echo "Would you like to setup a Mac OS?: y/n"
  read mac_install

  case $mac_install in
    [yY][eE][sS][|[yY])
      ./mac_setup.sh
      ;;
    [nN][oO]|[nN])
      echo "Moving on. Don't forget to run ./mac_setup.sh at a later time"
      ;;
  esac
fi

# Get Git Bash Completion
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.git-completion.bash

# Add KyWa repositories
echo "Would you like to add KyWa repositories?: y/n"
read repo_install

case $repo_install in
  [yY][eE][sS][|[yY])
    mkdir -p $HOME/Working/kywa
    cd $HOME/Working/kywa
    git clone git@github.com:KyWa/KyWa.git kywa
    git clone git@github.com:KyWa/kywa-lab.git kywa-lab
    git clone git@github.com:KyWa/kywa-learn.git kywa-learn
    echo "Repos cloned and all done!"
    ;;
  [nN][oO]|[nN])
    echo "All done!"
    exit
    ;;
esac
