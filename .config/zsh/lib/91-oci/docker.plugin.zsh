# vim: filetype=zsh foldmethod=marker

# => exports ------------------------------------------------------------------------------------------------------ {{{1

export BUILDKIT_PROGRESS="plain"
# export DOCKER_BUILDKIT=0

if [[ -x "$(command -v docker)" ]] && [[ -S "/run/docker.sock" ]]; then
	export DOCKER_HOST="unix:///run/docker.sock"
fi

# => alias -------------------------------------------------------------------------------------------------------- {{{1

alias co='docker-compose'

# => main --------------------------------------------------------------------------------------------------------- {{{1
