# .bashrc
if [ -f /etc/bashrc ];then
    . /etc/bashrc
fi

umask 002
set -o vi
shopt -s cdspell
complete -d cd

# Add current k8s context to PS1
source ~/.k8sprompt.sh
export PS1='\[\e[33m\]\W\[\e[m\]\[\e[36m\] $(k8s_context)\[\e[m\] > '

export PATH=$PATH:/usr/local/go/bin/:/home/kwalker/bin/:/Users/kylewalker/bin
export TERM="xterm-256color"
export GOPATH=$HOME/Working/golibs
export GOPATH=$GOPATH:$HOME/Working/gocode
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

if [ -f /mnt/c/Users ];then
    alias docker="sudo docker"
fi

if [ -f /etc/redhat-release ];then
    alias docker="podman"
fi

# quality of life things
alias grep='grep --color=auto'

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
alias aenv='docker run -it -v `PWD`:/work -v ~/.ssh:/root/.ssh quay.io/kywa/ansible-env:latest /bin/bash'
alias genv='docker run -it -v `PWD`:/work quay.io/kywa/go-env:latest /bin/bash'
alias code='docker run -d -p 8080:8080 -e PASSWORD="CHANGEME" --name vscode -v /home/kwalker/.ssh/:/home/coder/.ssh -v ${PWD}:/home/coder quay.io/kywa/kcode:v3.11-ubi'
alias dps='docker ps -a'

# Kubernetes/OpenShift
alias kg='kubectl get'
alias kp='kubectl config set-context --current --namespace'
alias oca='oc apply -f'
alias oga='oc get all'

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

viewcert() {
    openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -text -noout | less
}

makegif() {
  cd $HOME/Pictures/mineOps
  docker run --rm -v $PWD:/data asciinema/asciicast2gif -s .75 $1.cast $1.gif
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
  isk8s=$(docker ps | grep k8s | grep -v CONTAINER)
  if [[ -z $isk8s ]];then
    docker stop $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
    docker rm $(docker ps -a | grep -v CONTAINER | awk '{print $1}')
  fi
}

# Notes
engnotes() {
    NUMBER=$(date | awk '{print $2 " " $3}')
    cd ~/engagements
    git add XOM/
    git commit -m "$NUMBER notes"
    git push
    cd ~
}
