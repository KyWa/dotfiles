#!/bin/bash
k8s_context(){
    CONTEXT=$(cat ~/.kube/config 2>/dev/null | grep -o 'current-context: [^/]*' | cut -d ' ' -f2)

    if [ -n "$CONTEXT" ];then
        echo "(k8s:${CONTEXT})"
    else
        echo "(k8s:---)"
    fi
}
