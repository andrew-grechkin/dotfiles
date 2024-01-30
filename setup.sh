#!/usr/bin/env bash

set -Euo pipefail

echo 'Executing setup'

mkdir -p ~/.cache/bin
mkdir -p ~/.config/fontconfig
mkdir -p ~/.config/environment.d
mkdir -p ~/.local/{bin,lib}
mkdir -p ~/.local/share

SCRIPT=$(realpath -s "$0")
WORKDIR=$(dirname "$SCRIPT")
export PATH="$PATH:$WORKDIR/.local/script"

cd "$WORKDIR" || exit 1

chmod -R u=rwX,go-rwxs .ssh

[[ -r "$HOME/.config/user-dirs.dirs" ]] || {
	mkdir -p ~/{desktop,documents,downloads,music,pictures,public,templates,videos}
	command cp -rf ".config/user-dirs.dirs"                  ~/.config/
	command cp -rf ".config/user-dirs.locale"                ~/.config/
}

ln -sr  .gnupg                                               ~/ 2>/dev/null
ln -sr  .ssh                                                 ~/ 2>/dev/null
ln -sr  .xprofile                                            ~/ 2>/dev/null
ln -srf .profile                                             ~/
ln -srf .zshenv                                              ~/

ln -srf .config/chromium-flags.conf                          ~/.config/
ln -srf .config/chromium-flags.conf                          ~/.config/chrome-flags.conf
ln -srf .config/environment.d/*                              ~/.config/environment.d/
ln -srf .config/fontconfig/conf.d                            ~/.config/fontconfig/
ln -srf .config/git                                          ~/.config/
ln -srf .config/mpv                                          ~/.config/
ln -srf .config/picom.conf                                   ~/.config/
ln -srf .config/ripgreprc                                    ~/.config/
ln -srf .config/shell                                        ~/.config/
ln -srf .config/sxhkd                                        ~/.config/
ln -srf .config/systemd                                      ~/.config/
ln -srf .config/tmux                                         ~/.config/
ln -srf .config/vifm                                         ~/.config/
ln -srf .config/vim                                          ~/.config/
ln -srf .config/wezterm                                      ~/.config/
ln -srf .config/wgetrc                                       ~/.config/
ln -srf .config/yt-dlp                                       ~/.config/
ln -srf .config/zsh                                          ~/.config/

ln -srf .local/lib/perl5                                     ~/.local/lib/
ln -srf .local/script                                        ~/.local/
ln -srf .local/share/3rdparty                                ~/.local/share/
ln -srf .local/share/distrobox                               ~/.local/share/

command cp -rf ".config/crow-translate"                      ~/.config/
command cp -rf ".config/htop"                                ~/.config/ 2>/dev/null
command cp -rf ".config/locale.conf"                         ~/.config/ 2>/dev/null

if [[ "$USER" == "agrechkin" ]]; then
	if [[ ! "$(hostname)" =~ ^LL ]]; then
		ln -srf .config/black                                ~/.config/
	fi
	ln -srf .config/bspwm                                    ~/.config/
	ln -srf .config/containers                               ~/.config/
	ln -srf .config/luaformatter                             ~/.config/
	ln -srf .config/markdownlint.yaml                        ~/.config/
	ln -srf .config/nvim                                     ~/.config/
	ln -srf .config/perlcriticrc                             ~/.config/
	ln -srf .config/perlcriticrc                             ~/.perlcriticrc
	ln -srf .config/perlimports                              ~/.config/
	ln -srf .config/perltidyrc                               ~/.perltidyrc
	ln -srf .config/pylintrc                                 ~/.config/
	ln -srf .config/sql-formatter.json                       ~/.config/
	ln -srf .config/sqlfluff                                 ~/.config/
	ln -srf .config/wireplumber                              ~/.config/
	ln -srf .config/yamllint                                 ~/.config/
	ln -srf .config/zathura                                  ~/.config/
	ln -srf .config/zellij                                   ~/.config/
	[[ -f "$HOME/.config/npm" ]] || {
		command cp -rf ".config/npm"                         ~/.config/
	}
	[[ -x "/volume1/local/arch/usr/bin/vim" ]] && {
		ln -srfn .config/vim                                 ~/.vim
	}
	[[ -x "$(command -v delta)" ]] && {
		ln -srfn .config/git/gitconfig.delta                 ~/.config/gitconfig.delta
	}

	ln -srf .local/share/vim-dict                            ~/.local/share/
	ln -srf .local/share/vim-plug                            ~/.local/share/
	ln -srf .local/share/wiki                                ~/.local/share/

	[[ -x submodules/private/setup.sh ]] && {
		echo 'Executing private/setup'
		(exec submodules/private/setup.sh)
	}
	[[ -x submodules/secret/setup.sh ]]  && {
		echo 'Executing secret/setup'
		(exec submodules/secret/setup.sh)
	}
else
	ln -srfn .config/vim                                     ~/.config/nvim
fi

[[ -d "$HOME/.config/kdedefaults" ]] || {
	command cp -rf ".config/kdedefaults"                     ~/.config/
}

exit 0
