#!/bin/bash

## Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install core brew packages
brew install bash vim tmux bat yamllint tig jq ansible openjdk openssl libxml2

## Set Bash as primary shell (will require sudo password)
sudo echo "/usr/local/bin/bash" >> /etc/shells
chsh -s /usr/local/bin/bash

## Set JDK symlink for java usage (will require sudo password)
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
