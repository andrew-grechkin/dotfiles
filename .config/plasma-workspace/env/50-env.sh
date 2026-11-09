# [[ -S "${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
[[ -S "${XDG_RUNTIME_DIR}/ssh-agent.socket" ]] && export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# NOTE: force UI askpass for ssh and allow to keep password in keychain
#export SSH_ASKPASS_REQUIRE="force"

# if [[ -x "/usr/bin/ksshaskpass" ]]; then
#     export SSH_ASKPASS="/usr/bin/ksshaskpass"
# fi
