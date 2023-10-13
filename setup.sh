#!/usr/bin/env bash

set -Euo pipefail

echo 'Executing setup'

mkdir -p ~/.cache/bin
mkdir -p ~/.config/fontconfig
mkdir -p ~/.config/environment.d
mkdir -p ~/.local/{bin,lib}
mkdir -p ~/.local/share
mkdir -p ~/{desktop,documents,downloads,music,pictures,public,templates,videos}

SCRIPT=$(realpath -s "$0")
WORKDIR=$(dirname "$SCRIPT")
export PATH="$PATH:$WORKDIR/.local/script"

cd "$WORKDIR" || exit 1

ln -sr  .gnupg                                               ~/ 2>/dev/null
ln -sr  .ssh                                                 ~/ 2>/dev/null
ln -srf .xprofile                                            ~/
ln -srf .zshenv                                              ~/

ln -srf .config/black                                        ~/.config/
ln -srf .config/bspwm                                        ~/.config/
ln -srf .config/chromium-flags.conf                          ~/.config/
ln -srf .config/chromium-flags.conf                          ~/.config/chrome-flags.conf
ln -srf .config/containers                                   ~/.config/
ln -srf .config/environment.d/*                              ~/.config/environment.d/
ln -srf .config/fontconfig/conf.d                            ~/.config/fontconfig/
ln -srf .config/git                                          ~/.config/
ln -srf .config/luaformatter                                 ~/.config/
ln -srf .config/markdownlint.yaml                            ~/.config/
ln -srf .config/mpv                                          ~/.config/
ln -srf .config/mutt                                         ~/.config/
ln -srf .config/nvim                                         ~/.config/
ln -srf .config/perlcriticrc                                 ~/.config/
ln -srf .config/perlcriticrc                                 ~/.perlcriticrc
ln -srf .config/perltidyrc                                   ~/.perltidyrc
ln -srf .config/picom.conf                                   ~/.config/
ln -srf .config/pylintrc                                     ~/.config/
ln -srf .config/ripgreprc                                    ~/.config/
ln -srf .config/shell                                        ~/.config/
ln -srf .config/sqlfluff                                     ~/.config/
ln -srf .config/sxhkd                                        ~/.config/
ln -srf .config/systemd                                      ~/.config/
ln -srf .config/tmux                                         ~/.config/
ln -srf .config/user-dirs.dirs                               ~/.config/
ln -srf .config/vifm                                         ~/.config/
ln -srf .config/wezterm                                      ~/.config/
ln -srf .config/wgetrc                                       ~/.config/
ln -srf .config/wireplumber                                  ~/.config/
ln -srf .config/yamllint                                     ~/.config/
ln -srf .config/yt-dlp                                       ~/.config/
ln -srf .config/zathura                                      ~/.config/
ln -srf .config/zsh                                          ~/.config/

ln -srf .local/lib/perl5                                     ~/.local/lib/
ln -srf .local/script                                        ~/.local/
ln -srf .local/share/vim-dict                                ~/.local/share/
ln -srf .local/share/vim-plug                                ~/.local/share/
ln -srf .local/share/wiki                                    ~/.local/share/

[[ -x "$(command which -- delta 2>/dev/null)" ]] && {
	ln -srfn .config/git/gitconfig.delta                     ~/.config/gitconfig.delta
}

[[ -x "/volume1/local/arch/usr/bin/vim" ]] && {
	ln -srfn .config/vim                                     ~/.vim
}

command                                 cp -rf ".config/Crow Translate" ~/.config/
[[ -f "$HOME/.config/npm" ]] || command cp -rf ".config/npm"            ~/.config/
command                                 cp -rf ".config/kdedefaults"    ~/.config/

chmod -R u=rwX,go-rwx .ssh

[[ -x submodules/private/setup.sh ]] && echo 'Executing private/setup' && (exec submodules/private/setup.sh)
[[ -x submodules/secret/setup.sh ]]  && echo 'Executing secret/setup'  && (exec submodules/secret/setup.sh)
