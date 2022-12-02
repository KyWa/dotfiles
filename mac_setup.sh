#!/bin/bash

## Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install core brew packages
brew install bash vim tmux bat yamllint tig jq ansible openjdk openssl libxml2 asciinema npm kubernetes-cli

## Install oVirt-SDK
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
pip3 install --global-option=build_ext --global-option="-I/usr/local/Cellar/libxml2/2.9.12/include/libxml2" ovirt-engine-sdk-python
pip3 uninstall pycurl
pip3 install pycurl --global-option="--with-openssl"

chsh -s /opt/homebrew/bin/bash

## Set JDK symlink for java usage (will require sudo password)
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

## Set python/pip symlink for python usage (will require sudo password)
sudo ln -s /opt/homebrew/bin/python3 /opt/homebrew/bin/python 
sudo ln -s /opt/homebrewl/bin/pip3 /opt/homebrew/bin/pip
