# vim: filetype=zsh foldmethod=marker

export BUILDKIT_PROGRESS="plain"
# export DOCKER_BUILDKIT=0

if (( $+commands[docker] )) && [[ -S "/run/docker.sock" ]]; then
	export DOCKER_HOST="unix:///run/docker.sock"
fi
