# Dotfiles Repository - Agent Guidelines

This document provides instructions for agentic coding agents operating in this repository.

## 1. Build, Lint Commands

This repository uses a mix of Bash scripts, Perl modules, and Neovim configurations.

### Setup & Build

- **Initial Setup**: `./setup`
    - This script symlinks configurations to the home directory and initializes submodules.

### Linting

Various linters are configured and enforced via git hooks:

- **YAML**: `yamllint -s <file>`
- **Perl**: `perlcritic <file>` (uses `.config/perlcriticrc`)
- **SQL**: `sqlfluff lint <file>` (uses `.config/sqlfluff`)
- **Markdown**: `markdownlint <file>` (uses `.config/markdownlint.yaml`)
- **Git Commits**: `commitlint` (uses `.config/commitlintrc.yaml`)
- **Lua**: `lua-format -c .config/luaformatter/config.yaml <file>`
- **Bash**: `shellcheck` and `shellharden`

## 2. Code Style Guidelines

### General Standards

- **Indentation**: 4 spaces (except Makefiles, which use tabs).
- **Line Length**: Max 120 characters.
- **Encoding**: UTF-8 without BOM.
- **Line Endings**: LF (Unix style).
- **Whitespace**: Trim trailing whitespace; end files with a single newline.

### Shell Scripts (Bash)

- **Strict Mode**: Always start with `#!/usr/bin/env bash` and `set -Eeuo pipefail`.
- **Naming**: Use `kebab-case` for script and for function names.
- **Variable Scope**: Use `local` for all variables inside functions.
- **Path Handling**: Use quotes around all variable expansions: `"$VARIABLE"`.

### Perl

- **Version**: Target Perl v5.40+.
- **Boilerplate**:
    ```perl
    use v5.40;
    use warnings qw(FATAL utf8);
    use experimental qw(class declared_refs defer refaliasing);
    ```
- **Testing**: Use `Test2::V0` and `Test2::Tools::Spec`.
- **Formatting**: Follow `.config/perltidyrc` (Perl Best Practices with minor adjustments).
- **Critic**: Adhere to `.config/perlcriticrc` (severity 1).
    - Avoid `Readonly`, use `constant` or `Const::Fast`.
    - Use `parent` instead of `base`.
    - Use `Path::Tiny` instead of `File::Slurp`.
    - Prefer builtin `try` or `eval` over `Try::Tiny`.
    - Prefer `YAML::XS` over `YAML` or `YAML::Tiny`.

### Lua (Neovim)

- **Style**: Standard Neovim Lua style.
- **Naming**: `snake_case` for variables and functions.
- **Tables**: Use dot notation for options when possible (e.g., `vim.opt.number = true`).
- **Quotes**: Prefer single quotes `'` over double quotes `"` unless interpolation or escaping is needed.
- **Formatting**: Use `lua-format` with `.config/luaformatter/config.yaml`.
    - `indent_width`: 4
    - `column_limit`: 120
    - `align_table_field`: true
    - `double_quote_to_single_quote`: true

### Git Workflow & Commits

- **Conventional Commits**: Use `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`.
- **Hooks**: This repo uses custom hooks in `hooks/`.
    - `pre-commit`: Runs whitespace checks, yamllint, etc.
    - `commit-msg`: Runs commitlint.

### Configuration Files

- **JSON/YAML/Ruby**: 2-space indentation.

## 3. Tool-specific Guidelines

### Just (Task Runner)

- Use `just` for common tasks.

### Neovim Configuration

- The configuration is split into `lua/config/` (core options) and `lua/plugins/` (lazy.nvim setup).
- Plugin files are numbered (e.g., `00-colorscheme.lua`, `20-lsp.lua`) to control load order.
- Custom snippets are located in `.config/nvim/snippets/`.

## 4. Project Structure

- `.config/`: Application-specific configurations.
- `.local/scripts/`: Primary location for custom utility scripts.
- `.local/lib/`: Libraries used by scripts (Perl modules, etc.).
- `hooks/`: Git hooks (managed by the repo, not standard `.git/hooks`).
- `submodules/`:
    - `private/`: Private configurations.
    - `secret/`: Encrypted/sensitive data.

## 5. Error Handling

- **Bash**: Use `trap` for cleanup on error/exit. Check return codes of critical commands.
- **Perl**: Use `warnings qw(FATAL utf8)` to treat warnings as errors where appropriate.
- **Logic**: Favor failing fast with clear error messages over silent failures.

## 6. Agent Instructions

- **Verification**: Always run the relevant linter after modifying a file.
- **Formatting**: Respect `.editorconfig` settings at all times.
- **Dependencies**: Check `mise` or `npm` for managing tool versions and dependencies.
