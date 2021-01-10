# vim: foldmethod=marker

# => ------------------------------------------------------------------------------------------------------------- {{{1

# The next line updates PATH for Yandex Cloud CLI.
if [ -f "$HOME/.local/share/yandex-cloud/path.bash.inc" ]; then
	source "$HOME/.local/share/yandex-cloud/path.bash.inc"
fi

# The next line enables shell command completion for yc.
if [ -f "$HOME/.local/share/yandex-cloud/completion.zsh.inc" ]; then
	source "$HOME/.local/share/yandex-cloud/completion.zsh.inc"
fi
