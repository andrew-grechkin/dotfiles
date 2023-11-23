# vim: filetype=zsh foldmethod=marker

# => exports ------------------------------------------------------------------------------------------------------ {{{1

export BUILDKIT_PROGRESS="plain"
export DOCKER_BUILDKIT=0

if [[ -d "${XDG_CONFIG_HOME}/docker" ]]; then
	export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
fi

if [[ -x "$(command which -- podman 2>/dev/null)" ]] && [[ -S "${XDG_RUNTIME_DIR}/podman/podman.sock" ]]; then
	export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
fi

# => main --------------------------------------------------------------------------------------------------------- {{{1
