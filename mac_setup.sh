#!/bin/bash

## Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install core brew packages
brew install bash vim tmux bat yamllint tig jq

## Set Bash as primary shell (will require sudo password)
sudo echo "/usr/local/bin/bash" >> /etc/shells
chsh -s /usr/local/bin/bash
