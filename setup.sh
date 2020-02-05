#!/bin/sh -x

mkdir -p ~/.cache
mkdir -p ~/.cache/bin
mkdir -p ~/.config
mkdir -p ~/.config/nvim
mkdir -p ~/.config/xfce4
mkdir -p ~/.local/share

SCRIPT=$(realpath -s "$0")
WORKDIR=$(dirname "$SCRIPT")

ln -sf "$WORKDIR/.config/nvim/init.vim"                                ~/.vimrc
ln -sf "$WORKDIR/.config/tmux/config"                                  ~/.tmux.conf
ln -sf "$WORKDIR/.pam_environment"                                     ~/
ln -s  "$WORKDIR/.ssh"                                                 ~/
ln -sf "$WORKDIR/.perlcriticrc"                                        ~/
ln -sf "$WORKDIR/.xprofile"                                            ~/
#ln -sf "$WORKDIR/.zshenv"                                              ~/

ln -sf "$WORKDIR/.config/compton.conf"                                 ~/.config/
ln -sf "$WORKDIR/.config/fontconfig/conf.d"                            ~/.config/fontconfig/
ln -sf "$WORKDIR/.config/git"                                          ~/.config/
ln -sf "$WORKDIR/.config/i3"                                           ~/.config/
ln -sf "$WORKDIR/.config/mpv"                                          ~/.config/
ln -sf "$WORKDIR/.config/shell"                                        ~/.config/
ln -sf "$WORKDIR/.config/npm"                                          ~/.config/
ln -sf "$WORKDIR/.config/nvim/init.vim"                                ~/.config/nvim
ln -sf "$WORKDIR/.config/nvim/plugins.vim"                             ~/.config/nvim
ln -sf "$WORKDIR/.config/perltidyrc"                                   ~/.config/
ln -sf "$WORKDIR/.config/rofi"                                         ~/.config/
ln -sf "$WORKDIR/.config/sxhkd"                                        ~/.config/
ln -sf "$WORKDIR/.config/systemd"                                      ~/.config/
ln -sf "$WORKDIR/.config/tigrc"                                        ~/.config/
ln -sf "$WORKDIR/.config/tmux"                                         ~/.config/
ln -sf "$WORKDIR/.config/vifm"                                         ~/.config/
ln -sf "$WORKDIR/.config/zathura"                                      ~/.config/
ln -sf "$WORKDIR/.config/zsh"                                          ~/.config/

ln -sf "$WORKDIR/.local/bin"                                           ~/.local/

chmod -R u=rwX,go-rwx "$WORKDIR/.ssh"

[ -x 'submodules/private/setup.sh' ] && echo 'Execution private/setup' && (exec 'submodules/private/setup.sh')
[ -x 'submodules/secret/setup.sh' ]  && echo 'Execution secret/setup'  && (exec 'submodules/secret/setup.sh')
