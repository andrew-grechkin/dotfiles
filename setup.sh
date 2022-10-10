#!/usr/bin/env bash

echo 'Executing setup'

mkdir -p ~/.cache/bin
mkdir -p ~/.config/fontconfig
mkdir -p ~/.local/{bin,lib}
mkdir -p ~/.local/share
mkdir -p ~/{desktop,documents,downloads,music,pictures,public,templates,videos}

SCRIPT=$(realpath -s "$0")
WORKDIR=$(dirname "$SCRIPT")

ln -sr  "$WORKDIR/.gnupg"                                               ~/ 2>/dev/null
ln -sr  "$WORKDIR/.ssh"                                                 ~/ 2>/dev/null
ln -srf "$WORKDIR/.pam_environment"                                     ~/
ln -srf "$WORKDIR/.xprofile"                                            ~/
[[ -z "$ZDOTDIR" ]] && ln -srf "$WORKDIR/.zshenv"                       ~/
ln -srf "$WORKDIR/.config/perlcriticrc"                                 ~/.perlcriticrc
ln -srf "$WORKDIR/.config/perltidyrc"                                   ~/.perltidyrc

ln -srf "$WORKDIR/.config/alacritty"                                    ~/.config/
ln -srf "$WORKDIR/.config/autorandr"                                    ~/.config/
ln -srf "$WORKDIR/.config/black"                                        ~/.config/
ln -srf "$WORKDIR/.config/bspwm"                                        ~/.config/
ln -srf "$WORKDIR/.config/containers"                                   ~/.config/
ln -srf "$WORKDIR/.config/fontconfig/conf.d"                            ~/.config/fontconfig/
ln -srf "$WORKDIR/.config/git"                                          ~/.config/
ln -srf "$WORKDIR/.config/luaformatter"                                 ~/.config/
ln -srf "$WORKDIR/.config/mpv"                                          ~/.config/
ln -srf "$WORKDIR/.config/mutt"                                         ~/.config/
ln -srf "$WORKDIR/.config/nvim"                                         ~/.config/
ln -srf "$WORKDIR/.config/perlcriticrc"                                 ~/.config/
ln -srf "$WORKDIR/.config/picom.conf"                                   ~/.config/
ln -srf "$WORKDIR/.config/pylintrc"                                     ~/.config/
ln -srf "$WORKDIR/.config/rofi"                                         ~/.config/
ln -srf "$WORKDIR/.config/ripgreprc"                                    ~/.config/
ln -srf "$WORKDIR/.config/shell"                                        ~/.config/
ln -srf "$WORKDIR/.config/sxhkd"                                        ~/.config/
ln -srf "$WORKDIR/.config/systemd"                                      ~/.config/
ln -srf "$WORKDIR/.config/tmux"                                         ~/.config/
ln -srf "$WORKDIR/.config/vifm"                                         ~/.config/
ln -srf "$WORKDIR/.config/user-dirs.dirs"                               ~/.config/
ln -srf "$WORKDIR/.config/yamllint"                                     ~/.config/
ln -srf "$WORKDIR/.config/wireplumber"                                  ~/.config/
ln -srf "$WORKDIR/.config/zathura"                                      ~/.config/
ln -srf "$WORKDIR/.config/zsh"                                          ~/.config/

ln -srf "$WORKDIR/.local/lib/perl5"                                     ~/.local/lib/
ln -srf "$WORKDIR/.local/script"                                        ~/.local/
ln -srf "$WORKDIR/.local/share/vim-dict"                                ~/.local/share/
ln -srf "$WORKDIR/.local/share/vim-plug"                                ~/.local/share/
ln -srf "$WORKDIR/.local/share/wiki"                                    ~/.local/share/

[[ -f "$HOME/.config/npm" ]] || command cp -rf "$WORKDIR/.config/npm"          ~/.config/
                                command cp -rf "$WORKDIR/.config/kdedefaults"  ~/.config/

chmod -R u=rwX,go-rwx "$WORKDIR/.ssh"

[[ -x 'submodules/private/setup.sh' ]] && echo 'Executing private/setup' && (exec 'submodules/private/setup.sh')
[[ -x 'submodules/secret/setup.sh' ]]  && echo 'Executing secret/setup'  && (exec 'submodules/secret/setup.sh')
