# vim: syntax=zsh foldmethod=marker

# => Load oh-my-zsh library -------------------------------------------------------------------------------------- {{{1

antigen use oh-my-zsh

# => Default repo bundles ---------------------------------------------------------------------------------------- {{{1

antigen bundle vi-mode
antigen bundle cpanm
antigen bundle dirpersist
antigen bundle encode64
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

# => Default repo bundles load last ------------------------------------------------------------------------------ {{{1

antigen bundle aliases
antigen bundle autosuggestions-key-bindings
antigen bundle dircycle

# => Load theme -------------------------------------------------------------------------------------------------- {{{1

antigen theme grand
#antigen theme "$XDG_CONFIG_HOME" "zsh/grand"
#antigen theme gnzh

local SAVEPATH=$PATH

antigen apply                                                                  # Tell antigen that you're done

PATH=$SAVEPATH
export PATH
