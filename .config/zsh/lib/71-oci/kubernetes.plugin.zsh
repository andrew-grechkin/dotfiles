# vim: filetype=zsh foldmethod=marker

# https://kubernetes.io/docs/reference/kubectl/cheatsheet/

alias   k='kubectl'
alias kga='kubectl get all'
alias kgp='kubectl get pods'
alias kaf='kubectl apply -f'
alias kevents='kubectl get events --sort-by=.metadata.creationTimestamp'

function kgetimages() {
    kubectl get pod -l app="$1" -o json | jq '.items[].spec.containers[] | select(.name | contains("app")) | .image'
}
