# vim: filetype=zsh foldmethod=marker

# => Load lib ---------------------------------------------------------------------------------------------------- {{{1

antigen use oh-my-zsh

# => Default repo bundles ---------------------------------------------------------------------------------------- {{{1

antigen bundle vi-mode
antigen bundle broot
antigen bundle completion
antigen bundle cpanm
antigen bundle fzf
antigen bundle gnupg
antigen bundle grep
antigen bundle linuxbrew
antigen bundle perl
antigen bundle rsync
antigen bundle ssh
antigen bundle sudo
antigen bundle systemd
antigen bundle tmux

# => External bundles -------------------------------------------------------------------------------------------- {{{1

#antigen bundle jimhester/per-directory-history
antigen bundle zsh-users/zsh-autosuggestions                                   # Fish-like auto suggestions
antigen bundle zsh-users/zsh-completions                                       # Extra zsh completions
antigen bundle zsh-users/zsh-syntax-highlighting                               # Syntax highlighting bundle.
antigen bundle MichaelAquilina/zsh-you-should-use

# => Default repo bundles load last ------------------------------------------------------------------------------ {{{1

antigen bundle aliases
antigen bundle arch
antigen bundle autosuggestions-key-bindings
antigen bundle dircycle

# => Load theme -------------------------------------------------------------------------------------------------- {{{1

antigen theme grand
#antigen theme "$XDG_CONFIG_HOME" "zsh/grand"
#antigen theme gnzh

# antigen puts a lot of junk into PATH so save PATH before and restore it after
local savepath=(${path[@]})

antigen apply                                                                  # Tell antigen that you're done

path=(${savepath[@]})
