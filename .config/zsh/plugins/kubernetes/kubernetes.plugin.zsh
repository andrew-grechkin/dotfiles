# vim: foldmethod=marker

# => aliases ----------------------------------------------------------------------------------------------------- {{{1

alias   k='kubectl'
alias kga='kubectl get all'
alias kaf='kubectl apply -f'

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
