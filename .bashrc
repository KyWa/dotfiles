# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Features and Global Vars
export EDITOR=vim
export PS1="\[\e[33m\]\W\[\e[m\]> "
set -o vi
export PATH=$PATH:/usr/local/go/bin/
# Aliases
#quality of life for ls and grep
alias ls='ls -Fh'
alias grep='grep --color=auto'
#better process checking
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
#show dirs and force dir creation
alias mkdir='mkdir -pv'
#get pub IP
alias getip='curl http://ipecho.net/plain;echo'
#ssh get rid of annoyances
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Functions
mcd(){
    mkdir $1
    cd $1
}
cls(){
    clear
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kwalker/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/kwalker/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kwalker/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/kwalker/Downloads/google-cloud-sdk/completion.bash.inc'; fi
