#!/bin/bash

## Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install core brew packages
brew install bash vim tmux bat yamllint tig jq ansible openjdk openssl libxml2 asciinema npm kubernetes-cli

## Install oVirt-SDK
export CPPFLAGS="-I/usr/local/opt/openssl@3/include"
export LDFLAGS="-L/usr/local/opt/openssl@3/lib"
pip3 install --global-option=build_ext --global-option="-I/usr/local/Cellar/libxml2/2.9.12/include/libxml2" ovirt-engi
ne-sdk-python
pip3 uninstall pycurl
pip3 install pycurl --global-option="--with-openssl"

## Set Bash as primary shell (will require sudo password)
sudo echo "/usr/local/bin/bash" >> /etc/shells
chsh -s /usr/local/bin/bash

## Set JDK symlink for java usage (will require sudo password)
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
