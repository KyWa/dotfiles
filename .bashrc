# .bashrc

umask 002
set -o vi
bind 'set completion-ignore-case on'
shopt -s cdspell
complete -d cd

export PS1="\[\e[33m\]\W\[\e[m\]> "
export PATH=$PATH:/usr/local/go/bin/:/home/kwalker/bin/:/Users/kylewalker/bin
export TERM="xterm-256color"
export GOPATH=$HOME
export EDITOR="vim"
export IFS=`echo -en "\n\b"`


# Aliases
#quality of life for ls and grep
if [ -f /etc/os-release ];then
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
alias scp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Functions
mcd(){
    mkdir $1
    cd $1
}
cls(){
    clear
}
