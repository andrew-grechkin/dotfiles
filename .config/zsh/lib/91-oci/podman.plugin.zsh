# vim: filetype=zsh foldmethod=marker

# => exports ------------------------------------------------------------------------------------------------------ {{{1

if [[ -x "$(command -v podman)" || -x "$(command -v docker)" ]] && [[ -z "$DOCKER_HOST" ]] && [[ -S "${XDG_RUNTIME_DIR}/podman/podman.sock" ]]; then
	export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
fi

# => main --------------------------------------------------------------------------------------------------------- {{{1
