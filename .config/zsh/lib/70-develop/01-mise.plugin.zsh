if [[ -z "${MISE_SHELL:-}" && ! "$PATH" =~ mise\/installs ]] && (( $+commands[mise] )); then
    eval "$(mise activate)"
fi
