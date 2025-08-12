# Dotfiles Repository - Agent Configuration

## Architecture & Structure

- **Type**: Personal dotfiles management system for Linux
- **Setup**: Run `./setup` to symlink configs to home directory
- **Structure**:
    - `.config/` - Application configurations (nvim, git, tmux, etc.)
    - `.local/script/` - Custom shell scripts and utilities
    - `.local/share/` - Shared data, templates, and skeleton files
    - `.local/t/` - Test files and modules
    - `submodules/` - Git submodules for private/secret configs

## Commands

- **Setup**: `./setup` - Initialize and symlink all dotfiles
- **Test**: Run tests in `.local/t/` directory (Perl modules)
- **Lint**: Various linters configured per tool (eslint, yamllint, etc.)

## Code Style & Conventions

- **Indentation**: 4 spaces (tabs for Makefiles)
- **Line length**: 120 characters max
- **Encoding**: UTF-8, LF line endings
- **Naming**: kebab-case for scripts, snake_case for functions
- **Shell**: Bash with strict mode (`set -Eeuo pipefail`)
- **Lua**: Neovim config style, dot notation for options
- **Git**: Conventional commits, rebase workflow
- **Perl**: Use perlimports for auto-organizing imports
