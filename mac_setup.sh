#!/bin/bash

## Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install core brew packages
brew install vim tmux bat yamllint tig jq

chsh -s /bin/bash
