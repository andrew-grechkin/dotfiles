# Dotfiles

This repository contains my personal dotfiles for configuring a Linux environment. It's a collection of configuration files, scripts, and settings that I use to customize my development and desktop experience.

## Structure

The repository is organized as follows:

*   **`.config/`**: Contains configuration files for various applications that follow the XDG Base Directory Specification.
*   **`.local/`**: Contains local user-specific files, including scripts in `.local/script`.
*   **`.gnupg/`**: Configuration for GnuPG.
*   **`.ssh/`**: Configuration for SSH.
*   **`hooks/`**: Git hooks that are automatically installed and used in this repository.
*   **`submodules/`**: Git submodules.
*   **`.bashrc`, `.zshenv`, `.zshrc`, etc.**: Shell configuration files.
*   **`setup`**: A script to help set up the dotfiles.

## Software Covered

This repository includes configurations for a wide range of software, including but not to:

*   **Window Manager**: `bspwm`
*   **Shell**: `zsh`, `bash`, `tmux`
*   **Editors**: `neovim`, `vim`
*   **Development Tools**: `git`, `docker`, `npm`, `perl`, `python`
*   **Terminal Utilities**: `eza`, `fd`, `fzf`, `htop`, `ripgrep`
*   **And many more...**

## Screenshots

Here are some screenshots of the tools in action:

### Docker images TUI

To discover, pull, push inspect images and run containers

![Docker TUI](doc/docker-tui.png)

### Pacman TUI

This help discover and manage packages on Arch linux

![Pacman TUI](doc/pacman-tui.png)

## Installation

To use these dotfiles, you can clone this repository and then symlink the desired configuration files to your home directory.

For example, to symlink the `.bashrc` file:

```bash
ln -s /path/to/dotfiles/.bashrc ~/.bashrc
```

The `setup` script in the root of the repository can be used to automate this process.

## License

This project is licensed under the terms of the LICENSE file.
