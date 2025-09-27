if [[ -z "${MISE_SHELL:-}" && ! "$PATH" =~ mise\/installs && -x "$(command -v mise)" ]]; then
    # alias mx='mise exec --'

    eval "$(mise activate)"
fi
