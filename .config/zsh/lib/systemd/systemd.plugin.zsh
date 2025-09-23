user_commands=(
	cat
	help
	is-active
	is-enabled
	list-automounts
	list-dependencies
	list-jobs
	list-machines
	list-paths
	list-sockets
	list-timers
	list-unit-files
	list-units
	show
	show-environment
	status
)

sudo_commands=(
	cancel
	disable
	edit
	enable
	daemon-reload
	isolate
	kill
	link
	load
	mask
	preset
	reenable
	reload
	reset-failed
	restart
	set-environment
	start
	stop
	try-restart
	unmask
	unset-environment
)

for c in "${user_commands[@]}"; do alias sc-"$c=systemctl $c"; done
for c in "${sudo_commands[@]}"; do alias sc-"$c=sudo systemctl $c"; done

for c in "${user_commands[@]}"; do alias scu-"$c=systemctl --user $c"; done
for c in "${sudo_commands[@]}"; do alias scu-"$c=systemctl --user $c"; done

unset user_commands
unset sudo_commands

alias    scu-enable-now='scu-enable --now'
alias   scu-disable-now='scu-disable --now'
alias scu-list-services='scu-list-units -t service'
alias      scu-mask-now='scu-mask --now'

alias    sc-enable-now='sc-enable --now'
alias   sc-disable-now='sc-disable --now'
alias sc-list-services='sc-list-units -t service'
alias      sc-mask-now='sc-mask --now'
