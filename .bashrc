#!/usr/bin/env bash

# Source Other Scripts
if [ -f /etc/bashrc ];then
    . /etc/bashrc
fi
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f "~/.git-completion.bash" ]; then
    . ~/.git-completion.bash
fi
source ~/.k8sprompt.sh

# Set Options
set -o vi
shopt -s cdspell
complete -d cd
type compopt &> /dev/null && compopt -o bashdefault cd
umask 002

# General Vars
export PS1='\[\e[33m\]\W\[\e[m\]\[\e[36m\] $(k8s_context)\[\e[m\] > '
export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/wsl/lib:/snap/bin:/usr/local/go/bin/:~/bin:~/.local/bin
export BASH_SILENCE_DEPRECATION_WARNING=1
export TERM='xterm-256color'
export EDITOR='vim'
export IFS=`echo -en "\n\b"`
export WORKDOCS="$HOME/engagements"

# Aliases
## QoL and Handy
alias grep='grep --color=auto'
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias mkdir='mkdir -pv'
alias getip='curl http://ipecho.net/plain;echo'
alias cls='clear'
alias ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias scp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

if [ -x "$(command -v bat)" ];then
  alias cat='bat'
elif [ -x "$(command -v batcat)" ];then
  alias cat='batcat'
fi

## Ansible
alias ap="ansible-playbook --vault-password-file=~/.vault-pass"
alias avv="ansible-vault view --vault-password-file=~/.vault-pass"

## Containers
### Set runtime
if [ -f /mnt/c/Users/unixi/AppData/Local/Programs/Podman/podman.exe ];then
  alias podman="/mnt/c/Users/unixi/AppData/Local/Programs/Podman/podman.exe"
fi
alias dps='podman ps -a'

## Kubernetes/OpenShift
### Set client
if [ -x "$(command -v kubectl)" ] && [ ! -x "$(command -v oc)" ];then
  alias oc='kubectl'
  alias kp='kubectl config set-context --current --namespace'
fi

alias oca='oc apply -f'
alias oga='oc get all'
alias oyam='oc get -o yaml'
alias ojay='oc get -o json'
alias occlean='oc delete po --field-selector=status.phase=Succeeded'
alias evicted='oc delete po --field-selector=status.phase=Failed'

## Git
alias gs='git status'
alias gp='git pull'

## OS Specific Checks
if [[ `uname` != "Darwin" ]];then
  alias ls='ls -Fh --color=auto'
else
  alias ls='ls -FhG'
  alias python="/usr/bin/python3"
fi

alias macfixperm=`xattr -d com.apple.quarantine`

# Functions
## QoL and Handy
mcd(){
  mkdir $1
  cd $1
}

ext(){
  # Get all files in a dir and list their extensions (if present)
  find . -type f | perl -ne 'print $1 if m/\.([^.\/]+)$/' | sort -u
}

viewcert(){
  # Views a PEM file for ease of understanding
  openssl crl2pkcs7 -nocrl -certfile $1 | openssl pkcs7 -print_certs -text -noout | less
}

getcert(){
  # Grabs a certificate from a server
  openssl s_client -showcerts -servername $1 -connect $1:443 </dev/null 2>/dev/null | openssl x509 -text > $1.pem
}

makegif(){
  # Makes use of the asciinema project to generate a gif from an asciicast
  # TODO - Haven't used this in a while and need to see how this was done
  podman run --rm -v $PWD:/data asciinema/asciicast2gif -s .75 $1.cast $1.gif
}

macdns(){
  sudo killall -HUP mDNSResponder
}

## Kubernetes/OpenShift
ocga(){
  # Get all objects in a namespace by first getting all api objects that can be gathered
  for i in $(oc api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    oc -n ${1} get --ignore-not-found ${i}
  done
}

clean-olm(){
  # Cleans up all of the OLM Pods/Jobs to "start fresh" when dealing with Operator issues
  oc delete -n openshift-marketplace `oc get job -n openshift-marketplace -o name`
  oc delete -n openshift-marketplace `oc get pod -n openshift-marketplace -o name`
  oc delete -n openshift-operator-lifecycle-manager `oc get pod -n openshift-operator-lifecycle-manager -o name`
}

clean-rs(){
  # Cleans up old/stale ReplicaSets
  for i in `oc get rs -o json | jq -r '.items[] | select(.spec.replicas == 0) .metadata.name'`;do
    oc delete rs $i
  done
}

## Notes
engnotes(){
  NUMBER=$(date | awk '{print $2 " " $3}')
  cd $WORKDOCS
  git add -A .
  git commit -m "$NUMBER notes"
#  git push
  cd $OLDPWD
}

## Development
venv(){
  python3 -m venv $1
  source $1/bin/activate
  if [[ -f "./requirements.txt" ]];then
    python3 -m pip install -r requirements.txt
  fi
}
