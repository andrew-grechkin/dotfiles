# System clipboard integration
# Based on https://github.com/robbyrussell/oh-my-zsh
#
# This file has support for doing system clipboard copy and paste operations
# from the command line in a generic cross-platform fashion.
#
# On OS X and Windows, the main system clipboard or "pasteboard" is used. On other
# Unix-like OSes, this considers the X Windows CLIPBOARD selection to be the
# "system clipboard", and the X Windows `xclip` command must be installed.

# clipcopy - Copy data to clipboard
#
# Usage:
#  <command> | clipcopy      - copies stdin to clipboard
#  clipcopy <file> <file>... - copies file's contents to clipboard
function clipcopy() {
	emulate -L zsh
	if [[ $OSTYPE == darwin* ]]; then
		cat "${@[@]}" | pbcopy
	elif [[ $OSTYPE == cygwin* ]]; then
		cat "${@[@]}" > /dev/clipboard
	else
		if (( $+commands[xclip] )); then
			cat "${@[@]}" | xclip -i -sel p -f | xclip -i -sel c
		elif (( $+commands[xsel] )); then
			cat "${@[@]}" | xsel --clipboard --input
		else
			print "clipcopy: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
			return 1
		fi
	fi
}

# clippaste - "Paste" data from clipboard to stdout
#
# Usage:
#   clippaste                - writes clipboard's contents to stdout
#   clippaste | <command>    - pastes contents and pipes it to another process
#   clippaste > <file>       - paste contents to a file
function clippaste() {
	emulate -L zsh
	if [[ $OSTYPE == darwin* ]]; then
		pbpaste
	elif [[ $OSTYPE == cygwin* ]]; then
		cat /dev/clipboard
	else
		if (( $+commands[xclip] )); then
			xclip -o -sel c
		elif (( $+commands[xsel] )); then
			xsel --clipboard --output
		else
			print "clipcopy: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
			return 1
		fi
	fi
}
