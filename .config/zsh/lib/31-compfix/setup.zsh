# Based on https://github.com/robbyrussell/oh-my-zsh

# Handle completions insecurities (i.e., completion-dependent directories with
# insecure ownership or permissions) by:
#
# * Human-readably notifying the user of these insecurities.
#
function handle_completion_insecurities() {
    # List of the absolute paths of all unique insecure directories, split on
    # newline from compaudit()'s output resembling:
    #
    #     There are insecure directories:
    #     /usr/share/zsh/site-functions
    #     /usr/share/zsh/5.0.6/functions
    #     /usr/share/zsh
    #     /usr/share/zsh/5.0.6
    #
    # Since the ignorable first line is printed to stderr and thus not captured,
    # stderr is squelched to prevent this output from leaking to the user.
    local -aU insecure_dirs=( "${(f@):-"$(compaudit 2>/dev/null)"}" )

    # If no such directories exist, get us out of here.
    (( ! ${#insecure_dirs} )) && return

    # List ownership and permissions of all insecure directories.
    print "[oh-my-zsh] Insecure completion-dependent directories detected:"
    ls -ld "${(@)insecure_dirs}"

    cat << EOD

[oh-my-zsh] For safety, we will not load completions from these directories until
[oh-my-zsh] you fix their permissions and ownership and restart zsh.
[oh-my-zsh] See the above list for directories with group or other writability.

[oh-my-zsh] To fix your permissions you can do so by disabling
[oh-my-zsh] the write permission of "group" and "others" and making sure that the
[oh-my-zsh] owner of these directories is either root or your current user.
[oh-my-zsh] The following command may help:
[oh-my-zsh]     compaudit | xargs chmod g-w,o-w

[oh-my-zsh] If the above didn't help or you want to skip the verification of
[oh-my-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
[oh-my-zsh] "true" before oh-my-zsh is sourced in your zshrc file.

EOD
}

function compaudit-detect() {
    emulate -L zsh
    setopt EXTENDED_GLOB
    local my_uid=$UID
    local dir parent file
    local -A checked_parents

    echo "=== Scanning \$fpath, parent dirs, and completion entries ==="

    # The leading '-' in the qualifiers makes the tests operate on symlink
    # targets instead of the symlinks themselves (which are always mode 777).
    for dir in "${fpath[@]}"; do
        [[ -d "$dir" ]] || continue

        # 1. Check if the directory itself is group/world writable or owned by someone else
        for item in "$dir"(N-^u0u"$my_uid",-W,-f:g+w:); do
            echo "[OFFENDER] fpath dir: $item"
            ls -ld "$item"
        done

        # 2. Check the immediate parent directory, like compaudit does
        parent="${dir:h}"
        if [[ -n "$parent" && -z "${checked_parents[$parent]}" ]]; then
            checked_parents[$parent]=1
            for item in "$parent"(N-^u0u"$my_uid",-W,-f:g+w:); do
                echo "[OFFENDER] Parent dir: $item"
                ls -ld "$item"
            done
        fi

        # 3. Check all completion entries inside the directory
        for file in "$dir"/*(N-^u0u"$my_uid",-W,-f:g+w:); do
            echo "[OFFENDER] Entry inside fpath: $file"
            ls -ld "$file"
        done
    done
}
