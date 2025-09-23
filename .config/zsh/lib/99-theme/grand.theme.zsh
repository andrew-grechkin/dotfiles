# grand ZSH theme
# vim: filetype=zsh foldmethod=marker
# url: http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Version-Control-Information
# url: https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
# url: https://timothybasanov.com/2016/04/23/zsh-prompt-and-vcs_info.html
# man zshmisc

autoload -Uz vcs_info
zmodload zsh/system 2>/dev/null

typeset -gA __signal_desc=(
    HUP    'Hangup'
    INT    'Interrupt'
    QUIT   'Quit'
    ILL    'Illegal instruction'
    TRAP   'Trace/breakpoint trap'
    ABRT   'Aborted'
    BUS    'Bus error'
    FPE    'Floating point exception'
    KILL   'Killed'
    USR1   'User defined signal 1'
    SEGV   'Segmentation fault'
    USR2   'User defined signal 2'
    PIPE   'Broken pipe'
    ALRM   'Alarm clock'
    TERM   'Terminated'
    STKFLT 'Stack fault'
    CHLD   'Child exited'
    CONT   'Continued'
    STOP   'Stopped'
    TSTP   'Stopped'
    TTIN   'Background read'
    TTOU   'Background write'
    URG    'Urgent I/O'
    XCPU   'CPU time limit exceeded'
    XFSZ   'File size limit exceeded'
    VTALRM 'Virtual timer expired'
    PROF   'Profiling timer expired'
    WINCH  'Window changed'
    IO     'I/O possible'
    PWR    'Power failure'
    SYS    'Bad system call'
)

setopt PROMPT_SUBST
# NOTE: do not export. Zsh-only prompt parameter, its value is a zsh format string that no other process understands
# export PROMPT_EOL_MARK=...
PROMPT_EOL_MARK='%B%S%F{red}<No newline at end of file>%f%s%b'

function precmd() {
    local last=$?
    __error_text=''
    if (( last != 0 )); then
        local name='' msg=''
        case $last in
            126) name='ENOEXEC'; msg='Command not executable' ;;
            127) name='ENOENT';  msg='Command not found' ;;
            *)
                if (( last > 128 )) && [[ -n "${signals[last-127]}" ]]; then
                    local sig=${signals[last-127]}
                    name="SIG$sig/$((last-128))"
                    msg="${__signal_desc[$sig]:-Killed by signal $sig}"
                elif (( ${+errnos[$last]} )); then
                    name="${errnos[$last]}"
                    syserror -e msg $last 2>/dev/null
                elif (( $+commands[errno] )); then
                    local out=$(errno -- "$last" 2>/dev/null)
                    if [[ -n "$out" ]]; then
                        name="${out%% *}"
                        msg="${out#$name $last }"
                    fi
                fi
                ;;
        esac
        [[ -n "$name" ]] && __error_text="[$name] $msg"
    fi
    vcs_info
}

() {
    typeset -AHg ZSH_THEME
    ZSH_THEME['GIT_PROMPT_PREFIX']='%K{23}%F{231}%B'
    ZSH_THEME['GIT_PROMPT_SUFFIX']='%b%K{36}%F{23}'
    ZSH_THEME['GIT_PROMPT_DIRTY']=''
    ZSH_THEME['GIT_PROMPT_CLEAN']=''
    ZSH_THEME['GIT_PROMPT_AHEAD']='%B%F{cyan}↑'
    ZSH_THEME['GIT_PROMPT_BEHIND']='%B%F{cyan}↓'
    ZSH_THEME['GIT_PROMPT_ADDED']='%B%F{green}+'
    ZSH_THEME['GIT_PROMPT_MODIFIED']='%B%F{yellow}*'
    ZSH_THEME['GIT_PROMPT_DELETED']='%B%F{red}-'
    ZSH_THEME['GIT_PROMPT_RENAMED']='%B%F{yellow}➜'
    ZSH_THEME['GIT_PROMPT_UNMERGED']='%B%F{magenta}?'
    ZSH_THEME['GIT_PROMPT_UNTRACKED']='%B%F{red}+'
    ZSH_THEME['GIT_PROMPT_SHA_BEFORE']='%F{231}%B'
    ZSH_THEME['GIT_PROMPT_SHA_AFTER']='%b%K{black}%F{36}'
    ZSH_THEME['CLOCK']='%K{29}%F{231}%B%T%b%f%k'
    ZSH_THEME['CWD']='%F{cyan}:%f%B%F{12}%~%f%b'

    local nl=$'\n'
    local history='$[HISTCMD-1]'
    local separator='%K{black}%F{29}%f%k'
    local error_body="%K{red}%F{29}%F{231}%B${history} -> %? "'${__error_text}'"%b%K{black}%F{red}%f%k"
    ZSH_THEME['ERROR_LINE']="%(?..${error_body}${nl})"

    ZSH_THEME['history_sign']='$([[ "$HISTFILE" == *tmp ]] && echo " %K{yellow}H%k")'

    # Check if we are root
    ZSH_THEME['USER']='%(!.%F{red}%n%f.%F{green}%n%f)'

    # Check if we are on SSH or not
    [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]] && ZSH_THEME['HOST']='%F{red}%M%f' || ZSH_THEME['HOST']='%F{green}%M%f'

    local left11="${nl}%F{0}#${ZSH_THEME['CLOCK']}${ZSH_THEME['history_sign']}${separator}"
    local left12="${ZSH_THEME['USER']}%F{cyan}@%f${ZSH_THEME['HOST']}${ZSH_THEME['CWD']}"'${vcs_info_msg_0_}'"%b%k%f%{$reset_color%}"
    local left2="%F{0}:%{$reset_color%}%(!.#.$)%b%k%F{0};%f%{$reset_color%}"

    PROMPT="${ZSH_THEME['ERROR_LINE']}$left11 $left12 ${nl}$left2"
    RPROMPT=''
}

zstyle    ':vcs_info:*'                 debug                    false
zstyle    ':vcs_info:*'                 enable                   git
if [[ -n "$HOSTNAME" && "$HOSTNAME" =~ king\.com$ ]]; then
    # this is too slow on a virtual machine in monorepo
    zstyle    ':vcs_info:*'                 check-for-changes        false
    zstyle    ':vcs_info:*'                 check-for-staged-changes false
else
    zstyle    ':vcs_info:*'                 check-for-changes        true
    zstyle    ':vcs_info:*'                 check-for-staged-changes true
    zstyle -e ':vcs_info:git+set-message:*' hooks                    'reply=(${${(k)functions[(I)[+]vi-git-set-message*]}#+vi-})'
fi
zstyle    ':vcs_info:*'                 get-revision             true
zstyle    ':vcs_info:*'                 stagedstr                '%B%F{green}+'
zstyle    ':vcs_info:*'                 unstagedstr              '%B%F{11}*'
zstyle    ':vcs_info:*'                 formats                  ' %K{23}%F{231}%b%K{29}%F{23} %F{233}%i%k%F{29} %u%c%m'
zstyle    ':vcs_info:*'                 actionformats            ' %K{23}%F{231}%b%K{29}%F{23} %F{233}%i%k%F{29} %a %m'
