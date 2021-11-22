if [ -r ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ ! -f /etc/os-release ];then
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
fi

check_kubectl=$(which kubectl)
if [ -x $check_kubectl ];then
    source <(kubectl completion bash)
fi
