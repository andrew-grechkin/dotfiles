# [[ -S "${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"

[[ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# if [[ -x "/usr/bin/ksshaskpass" ]]; then
#     export SSH_ASKPASS="/usr/bin/ksshaskpass"
#     export SSH_ASKPASS_REQUIRE="force"
# fi

[[ -r "$HOME/.config/shell/env" ]] && source "$HOME/.config/shell/env"
