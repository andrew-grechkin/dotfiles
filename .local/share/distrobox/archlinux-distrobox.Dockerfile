# vim: filetype=dockerfile

FROM docker.io/library/archlinux:base-devel

LABEL                                                                 \
    com.github.containers.toolbox="true"                              \
    name="archlinux-distrobox"                                        \
    summary="Base image for creating Arch Linux Distrobox containers" \
    usage="This image is meant to be used with the distrobox command" \
    version="base-devel"

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
RUN pacman -Syu --needed --noconfirm \
    base                             \
    base-devel                       \
    flatpak-xdg-utils                \
    man-db                           \
    man-pages                        \
    nss-mdns                         \
    plocate                          \
    reflector                        \
    sudo                             \
    vim                              \
    xorg-xauth                       \
    && yes | pacman -Scc             \
    && sed -i 's|.*\(en_US\.UTF-8\)|\1|' /etc/locale.gen \
    && locale-gen

ENV LC_ALL=en_US.UTF-8
