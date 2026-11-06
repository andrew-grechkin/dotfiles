# vim: filetype=zsh foldmethod=marker

if [[ -S "${XDG_RUNTIME_DIR}/podman/podman.sock" ]]; then
    if (( $+commands[podman] || $+commands[docker] )); then
       [[ -z "${CONTAINER_HOST:-}" ]] && export CONTAINER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
       [[ -z "${DOCKER_HOST:-}"    ]] && export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
       [[ -z "${DOCKER_SOCK:-}"    ]] && export DOCKER_SOCK="${XDG_RUNTIME_DIR}/podman/podman.sock"
    fi
fi
