#!/bin/sh -x

mkdir -p ~/.cache
mkdir -p ~/.cache/bin
mkdir -p ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/xfce4
mkdir -p ~/.local/share
mkdir -p ~/.local/share/tig
mkdir -p ~/{desktop,documents,downloads,music,pictures,public,templates,videos}

SCRIPT=$(realpath -s "$0")
WORKDIR=$(dirname "$SCRIPT")

ln -s  "$WORKDIR/.gnupg"                                               ~/
ln -s  "$WORKDIR/.ssh"                                                 ~/
ln -sf "$WORKDIR/.pam_environment"                                     ~/
ln -sf "$WORKDIR/.xprofile"                                            ~/
[ -z "$ZDOTDIR" ] && ln -sf "$WORKDIR/.zshenv"                         ~/
[ -z "$MYVIMRC" ] && ln -sf "$WORKDIR/.config/nvim/init.vim"           ~/.vimrc
ln -sf "$WORKDIR/.config/perltidyrc"                                   ~/.perltidyrc

ln -sf "$WORKDIR/.config/alacritty"                                    ~/.config/
ln -sf "$WORKDIR/.config/picom.conf"                                   ~/.config/
ln -sf "$WORKDIR/.config/fontconfig/conf.d"                            ~/.config/fontconfig/
ln -sf "$WORKDIR/.config/git"                                          ~/.config/
ln -sf "$WORKDIR/.config/i3"                                           ~/.config/
ln -sf "$WORKDIR/.config/mpv"                                          ~/.config/
ln -sf "$WORKDIR/.config/mutt"                                         ~/.config/
ln -sf "$WORKDIR/.config/nvim/"*                                       ~/.config/nvim
ln -sf "$WORKDIR/.config/perlcriticrc"                                 ~/.config/
ln -sf "$WORKDIR/.config/rofi"                                         ~/.config/
ln -sf "$WORKDIR/.config/shell"                                        ~/.config/
ln -sf "$WORKDIR/.config/sxhkd"                                        ~/.config/
ln -sf "$WORKDIR/.config/systemd"                                      ~/.config/
ln -sf "$WORKDIR/.config/tigrc"                                        ~/.config/
ln -sf "$WORKDIR/.config/tmux"                                         ~/.config/
ln -sf "$WORKDIR/.config/vifm"                                         ~/.config/
ln -sf "$WORKDIR/.config/user-dirs.dirs"                               ~/.config/
ln -sf "$WORKDIR/.config/yamllint"                                     ~/.config/
ln -sf "$WORKDIR/.config/zathura"                                      ~/.config/
ln -sf "$WORKDIR/.config/zsh"                                          ~/.config/

ln -sf "$WORKDIR/.local/bin"                                           ~/.local/
ln -sf "$WORKDIR/.local/share/vim-dict"                                ~/.local/share/
ln -sf "$WORKDIR/.local/share/vim-plug"                                ~/.local/share/

[ -f "$HOME/.config/npm" ] || cp -r "$WORKDIR/.config/npm"             ~/.config/

chmod -R u=rwX,go-rwx "$WORKDIR/.ssh"

[ -x 'submodules/private/setup.sh' ] && echo 'Execution private/setup' && (exec 'submodules/private/setup.sh')
[ -x 'submodules/secret/setup.sh' ]  && echo 'Execution secret/setup'  && (exec 'submodules/secret/setup.sh')
