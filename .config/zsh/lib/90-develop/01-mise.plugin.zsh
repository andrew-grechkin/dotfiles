if [[ -z "${MISE_SHELL:-}" && -x "$(command -v mise)" ]]; then
    # alias mx='mise exec --'

    eval "$(mise activate)"
fi
