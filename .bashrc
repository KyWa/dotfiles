# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Features and Global Vars
umask 002
set -o vi
export EDITOR=vim
export PS1="\[\e[33m\]\W\[\e[m\]> "
export PATH=$PATH:/usr/local/go/bin/
#Windows Docker fix
export DOCKER_HOST="tcp://localhost:2375"
# Aliases
#quality of life for ls and grep
alias ls='ls -Fh --color=auto'
alias grep='grep --color=auto'
#better process checking
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
#show dirs and force dir creation
alias mkdir='mkdir -pv'
#get pub IP
alias getip='curl http://ipecho.net/plain;echo'
#ssh get rid of annoyances
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
<<<<<<< HEAD
alias kubectl='kubectl.exe'
=======
alias work='cd /mnt/c/Users/kwalker/Working/'
>>>>>>> 276ccb8c66b9ff6d436b58a99c106876c293605e

# Functions
mcd(){
    mkdir $1
    cd $1
}
cls(){
    clear
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/kwalker/google-cloud-sdk/path.bash.inc' ]; then . '/home/kwalker/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/kwalker/google-cloud-sdk/completion.bash.inc' ]; then . '/home/kwalker/google-cloud-sdk/completion.bash.inc'; fi
