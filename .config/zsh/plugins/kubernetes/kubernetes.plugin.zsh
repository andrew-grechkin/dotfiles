# vim: foldmethod=marker
# https://kubernetes.io/docs/reference/kubectl/cheatsheet/

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias   k='kubectl'
alias kga='kubectl get all'
alias kgp='kubectl get pods'
alias kaf='kubectl apply -f'
alias kevents='kubectl get events --sort-by=.metadata.creationTimestamp'

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

function kabort() {
	kubectl --cluster "$(kubectl-management-cluster)" patch -p '{"spec":{"targetStep":0}}' --type="merge" "release.shipper.booking.com/$1"
}

function ksync() {
	kubectl --cluster "$(kubectl-management-cluster)" patch -p '{"spec":{"targetStep":1}}' --type="merge" "release.shipper.booking.com/$1"
}

function kfinish() {
	kubectl --cluster "$(kubectl-management-cluster)" patch -p '{"spec":{"targetStep":2}}' --type="merge" "release.shipper.booking.com/$1"
}

function kgetimages() {
	kubectl get pod -l app="$1" -o json | jq '.items[].spec.containers[] | select(.name | contains("app")) | .image'
}
