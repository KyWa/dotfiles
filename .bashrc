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
if [[ -f /mnt/c/Users ]];then
    export DOCKER_HOST="tcp://localhost:2375"
fi
# Aliases
#quality of life for ls and grep
if [[ -f /etc/os-release ]];then
    # if on main system add in color
    alias ls='ls -Fh --color=auto'
else
    # if on macbook don't (throws errors)    
    alias ls='ls -FhG'
fi
alias grep='grep --color=auto'
#better process checking
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
#show dirs and force dir creation
alias mkdir='mkdir -pv'
#get pub IP
alias getip='curl http://ipecho.net/plain;echo'
#ssh get rid of annoyances
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias kubectl='kubectl.exe'
alias work='cd /mnt/c/Users/kwalker/Working/'

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
