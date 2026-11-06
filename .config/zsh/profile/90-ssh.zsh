# vim: filetype=zsh foldmethod=marker
# shellcheck shell=bash

# => SSH agent check and start ------------------------------------------------------------------------------------ {{{1

#SSH_AGENTS=(
#   "${XDG_RUNTIME_DIR}/keyring/ssh"           # Gnome keyring agent
#   "${XDG_RUNTIME_DIR}/S.ssh-agent"           # OpenSSH agent
#   "${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh" # Gnupg ssh agent
#)
#
#function _is_ssh_auth_sock_ok() {
#   [[ -n "$SSH_AUTH_SOCK" ]] && [[ -S "$SSH_AUTH_SOCK" ]]
#}
#
#function _try_existing_ssh_auth_sock_term() {
#   test -S "$AGENT" && export SSH_AUTH_SOCK="${SSH_AGENTS[1]}" && return 0
#   return 2
#}
#
#function _try_existing_ssh_auth_sock() {
#   for AGENT in "${SSH_AGENTS[@]}"; do
#       test -S "$AGENT" && export SSH_AUTH_SOCK="$AGENT" && return 0
#   done
#   return 2
#}
#
#function _check_gpg_agent() {
#   source-file "$XDG_CACHE_HOME/gpg-agent.rc" && _check_auth_sock
#}
#
#function _check_ssh_agent() {
#   source-file "$XDG_CACHE_HOME/ssh-agent.rc" && _check_auth_sock && [[ -n "$SSH_AGENT_PID" && -e "/proc/$SSH_AGENT_PID" ]]
#}
#
#function _start_ssh_agent() {
#   local SSHAGENT='/usr/bin/ssh-agent'
#   local SSHAGENTARGS=(-s)
#
#   if [[ -x "$SSHAGENT" ]]; then
#       # eval `$SSHAGENT $SSHAGENTARGS`
#       # trap "kill $SSH_AGENT_PID" 0
#       # shellcheck disable=2091
#       $("$SSHAGENT" "${SSHAGENTARGS[@]}" >"$XDG_CACHE_HOME/ssh-agent.rc")
#       source-file "$XDG_CACHE_HOME/ssh-agent.rc"
#   fi
#
#   # add ssh keys if empty
#   # RESULT=$(ssh-add -l 2>/dev/null | grep '.ssh/id_')
#   # if [[ "0" = "${#RESULT}" ]]; then
#   # ssh-add
#   # fi
#}
#
#if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_CONNECTION" ]] || [[ -n "$SSH_TTY" ]]; then
#### for remote sessions
#   _is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock_term || echo 'No SSH_AUTH_SOCK found'
#else
#### for local sessions
#   ### check and reuse existing running ssh agent
#   _is_ssh_auth_sock_ok || _try_existing_ssh_auth_sock
#
#   ### start ssh-agent if it's not runnig
#   #_check_auth_sock || _check_gpg_agent || _check_ssh_agent || _start_ssh_agent
#
#   ### SSH make common link to auth socket link
#   #if [[ -z "$TMUX" ]]; then
#   #   if [[ -n "$SSH_AUTH_SOCK" ]]; then
#   #       ln -sf "$SSH_AUTH_SOCK" "$HOME/.cache/SSH_AUTH_SOCK"
#   ##      export SSH_AUTH_SOCK_ORIG=$SSH_AUTH_SOCK
#   #   fi
#   #else
#   #   export SSH_AUTH_SOCK="$HOME/.cache/SSH_AUTH_SOCK"
#   #fi
#fi

# NOTE: for interactive SSH sessions
if [[ -o interactive && -n "${SHELL:-}" && -z "${TMUX:-}" ]]; then
    # NOTE: best effort to implement environment.d for ssh sessions
    if [[ -z "${ENVIRONMENT_D_LOADED:-}" && -d "$XDG_CONFIG_HOME/environment.d" ]]; then
        export ENVIRONMENT_D_LOADED=1

        # echo environment before environment.d parsed && env | sort
        for __init_conf in "$XDG_CONFIG_HOME/environment.d"/*.conf(-.N); do
            [[ "${_init_conf:t}" =~ zsh.conf$ ]] && continue
            # read all variables from a file
            source "$__init_conf" && __init_conf_files+=("$__init_conf")
        done

        if [[ -n "${__init_conf_files[*]}" ]]; then
            # export them
            __init_vars=("${(f)$(perl -lnE '/^[[:space:]]*([_[:alpha:]][_[:alnum:]]+?)=.+/ and print $1' "${__init_conf_files[@]}")}")
            export "${__init_vars[@]}"
        fi

        unset __init_conf __init_conf_files __init_vars
    fi

    if __init_umask=$(grep -m1 "^$USER:" /etc/passwd 2>/dev/null | grep -Pom1 'umask=\K\d+' 2>/dev/null); then
        umask "$__init_umask"
        unset __init_umask
    fi
fi
