function install-zsh-3rdparty() {
	(
		cd "$XDG_DATA_HOME/3rdparty" || exit
		git submodule update --init .
	)
}

function install-distrobox() {
	curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix ~/.local
}

# => proxy -------------------------------------------------------------------------------------------------------- {{{1

function enable-proxy() {
	export all_proxy="http://$PROXY_FDQN:$PROXY_PORT"
	export http_proxy="http://$PROXY_FDQN:$PROXY_PORT"
	export https_proxy="http://$PROXY_FDQN:$PROXY_PORT"
	export no_proxy="localhost,localaddress,127.0.0.1"
}

function disable-proxy() {
	unset all_proxy
	unset http_proxy
	unset https_proxy
	export no_proxy="*"
}

# => docker ------------------------------------------------------------------------------------------------------- {{{1

function dw() {
	image="registry.gitlab.com/andrew-grechkin/dotfiles/scripts"
	name="$(basename "$image")"

	[[ -t 0 && -t 1 ]] && args=(-it) || args=(-i)
	# shellcheck disable=SC2016
	args+=(
		--rm
		-e TERM -e USER -e GITLAB_TOKEN --env-merge 'PATH=${PATH}:/mnt'
		-h "$name"
		-v '.:/mnt:ro'
		"$image"
	)

	command docker run "${args[@]}" "$@"
}

# => environment -------------------------------------------------------------------------------------------------- {{{1

function remove-all-environment() {
	unset "$(env | cut -d= -f1 | grep -v '^PATH$' | grep -v '^HOME$' | grep -v '^PWD$' | grep -v '^USER$' | grep -v '^TERM$')"
}
