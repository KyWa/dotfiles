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
# mac specific checks
if [ -f /etc/os-release ];then
    # if on main system add in color
    alias ls='ls -Fh --color=auto'
else
    # if on macbook don't (throws errors)    
    alias ls='ls -FhG'
    alias python="/usr/local/bin/python"
fi

# quality of life things
alias grep='grep --color=auto'
alias gh='history | grep'

# better process checking
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# show dirs and force dir creation
alias mkdir='mkdir -pv'

# Ansible Aliases
alias ap="ansible-playbook --vault-password-file=~/.vault-pass"
alias avv="ansible-vault view --vault-password-file=~/.vault-pass"

# get pub IP
alias getip='curl http://ipecho.net/plain;echo'

# Docker things
alias aenv='docker run -it -v `PWD`:/work -v ~/.ssh:/root/.ssh quay.io/kywa/ansible-env:2.10 /bin/bash'
alias genv='docker run -it -v `PWD`:/work quay.io/kywa/go-env:1.15 /bin/bash'
alias dps='docker ps -a'

# Kubernetes/OpenShift
alias kg='kubectl get'

# Git quick
alias gs='git status'
alias gp='git pull'
alias gc='git commit'

# Use bat instead of cat
if [ -x "$(command -v bat)" ];then
    alias cat='bat'
fi

# Use bat instead of cat (Debian systems)
if [ -x "$(command -v batcat)" ];then
    alias cat='batcat'
fi

# ssh get rid of annoyances
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Functions
mcd(){
    mkdir $1
    cd $1
}
# clear screen because i"m lazy
cls(){
    clear
}

# Get all files in a dir and list their extensions (if present)
ext(){
find . -type f | perl -ne 'print $1 if m/\.([^.\/]+)$/' | sort -u
}

# Get all objects in a namespace by first getting all api objects that can be gathered
ocga() {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}

# Docker handy cleanup
drm() {
  docker rm $(docker ps -a | grep Exited | grep -v CONTAINER |awk '{print $1}')
}

dclean() {
  docker stop $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
  docker rm $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
}

# Notes
engnotes() {
    NUMBER=$(date | awk '{print $2 " " $3}')
    cd ~/engagements
    git add XOM/Journal.md
    git commit -m "$NUMBER notes"
    git push
    cd ~
}
