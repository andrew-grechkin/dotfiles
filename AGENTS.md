# Dotfiles Repository - Agent Guidelines

This document provides instructions for agentic coding agents operating in this repository

## 1. Core Philosophy, Language & Database Selection Tree

I optimize for tools that remain stable, compose cleanly, and reduce long-term maintenance burden.
This often means choosing mature, proven solutions over trendy ones - not because I oppose progress,
but because I've learned which kinds of complexity pay for themselves and which don't.

### On Modern Tools & Complexity

This repository embraces modern tooling where it solves problems without introducing disproportionate complexity:

- **APIs & HTTP**: Fully embraced. The JSON-first approach makes CLI tools and REST APIs interchangeable - the same data contract works via pipes or HTTP. API responses in JSON can be piped to local CLI tools for processing and back. Local vs remote execution becomes a deployment choice, not an architectural rewrite. This enables seamless composition: `http-echo -r | json2yaml | colored-yaml`. In this architecture, `jq` acts as the universal glue under the hood - transforming, filtering, and adapting JSON between any combination of local tools and remote APIs. (Example: [gemini-api])
- **Docker/Containers**: Use when isolation or/and reproducibility requirements applied. Many tasks don't need containers when proper dependency management exists. (Example: [oc])
- **Languages**: Selected not due to novelty, but evaluated on stability, portability, and maintenance burden

**The principle**: Choose tools that compose well and remain stable over time. This isn't anti-progress, it's anti-fragility.

### Language Hierarchy

When deciding how to implement a solution, strictly adhere to the following language hierarchy and tooling philosophy:

- **Bash**: Use primarily as a glue language to connect processes, manage files, and execute system commands. (Example: [cred])
- **Just (`justfile`)**: The "glue of glues." Use `just` as the primary orchestrator. A highly encouraged pattern is combining multiple Bash and/or Perl scripts into unified tasks within a `justfile`. **Note**: Tasks grouped in a `justfile` MUST share a common purpose or domain. Avoid creating a single, monolithic `justfile` as a dumping ground for unrelated scripts. (Example: [menu-pacman])
- **Perl**: The absolute standard for textual data processing. It provides the power of modern scripting with the guarantee of minimal dependency, backward-compatible execution on almost any Unix machine. (Example: [json2yaml]). **CRITICAL**: Always prefer Perl over `awk` and `sed` one-liners because Perl ensures consistent, cross-platform portability without the GNU vs. BSD compatibility issues
- **Python**: Avoided due to dependency management complexity. `virtualenvs`, version drift, and packaging fragility introduce maintenance burden that outweighs benefits when Perl provides equivalent functionality with minimal dependency overhead. If Python is genuinely required (e.g., ML/data science libraries with no alternatives), contain it strictly and document the justification
- **Compiled Languages** (e.g., Rust, Go, C++): Use _only_ if absolutely necessary. They must provide a clear, undoubtful, and significant benefit (such as a massive performance requirement) that cannot be met by Bash or Perl. (Example: [colored-md])

## 2. Build, Lint Commands

### Setup & Build

- **Initial Setup**: `./setup`

### Linting

Various linters are configured and enforced via git hooks:

- **Bash**: `shellcheck` and `shellharden`
- **Lua**: `lua-format -c .config/luaformatter/config.yaml <file>`
- **Perl**: `perlcritic <file>` (uses [perlcriticrc])
- **YAML**: `yamllint -s <file>`

## 3. Code Style Guidelines

### General Standards

Always respect configuration described in: [.editorconfig]

### Data & Configuration Formats

- **Tabular Data (Human-Readable)**: 2-dimensional data (tables) intended to be shown to people MUST be in **TSV** (Tab-Separated Values) format. **CSV is strictly forbidden**. Reasoning: TSV can be natively and safely processed by standard Unix tools (`column`, `cut`, `sort`) without worrying about the quoted-delimiter edge cases that break CSVs in the terminal.
- **Machine Data (Bounded)**: Data intended for machine processing MUST be structured as an **array of hashes** (objects) in **JSON** format. If the data is strictly a single entity by definition, a **single hash** (object) is perfectly fine without an array wrapper
- **Machine Data (Unbounded/Streaming)**: If data doesn't have a strict size limit or is being streamed, it MUST be formatted as a **JSON stream of hashes** (`JSONL` format)
- **Configuration Files**: Configuration files that are supposed to be edited by people MUST be in **YAML** format. **TOML** should be avoided in favor of YAML unless the file is already TOML

### Databases & Storage

- **Simplicity First**: Most of the time, simple file-based formats (JSON, JSONL, TSV) should be enough
- **SQLite**: If JSON is insufficient due to constraints regarding size, speed, or complex querying requirements, **SQLite** MUST be selected. Also for in-memory non-distributed cache
- **PostgreSQL**: For anything larger that does not fit into SQLite or requires distribution (distributed data, pub/sub, in-memory cache, timeseries), **PostgreSQL** MUST be used

### Shell Scripts (Bash)

- **Strict Mode**: Always start with `#!/usr/bin/env -S bash -Eeuo pipefail`
- **Naming**: Use `kebab-case` for script and for function names
- **Variable Scope**: Use `local` for all variables inside functions
- **Variables**: Always use quotes around all variable expansions: `"$VARIABLE"`
- **TUI Architecture**: Any script that implements a Text User Interface (TUI) MUST follow the Model-View-Controller (MVC) pattern. The model can be defined within the `justfile` itself (Example: [menu-pacman]) or extracted into a separate script depending on complexity (Example: [gitlab-api])
- **Arguments & Help**: Use the `argc` bash helper to leverage declarative benefits if a script takes more than 1 positional argument or requires any flags or arguments. (Example: [git-credential-pass-cache])

### Perl

- **Version**: Target Perl v5.42+
- **Naming**: Use `PascalCase` for package names/modules. Use `snake_case` for variable and function names
- **Boilerplate**: (Example: [json2yaml])
    ```perl
    use v5.42;
    use experimental qw(class declared_refs defer refaliasing);
    ```
- **Testing**: Use `Test2::V0` and `Test2::Tools::Spec`
- **Formatting**: Follow [perltidyrc] (Perl Best Practices with minor adjustments)
- **Regular Expressions**: Complex regexes are powerful when written well. Always use the `/x` modifier to allow whitespace and comments, and use named capture groups or `(?(DEFINE))` for readability. Avoid dense, unreadable one-liners. (Example: `$match_ext` in [gather-files])
- **Critic**: Adhere to [perlcriticrc] (severity 1)
    - Avoid `Readonly`, use `constant`
    - Prefer builtin `try` or `eval` over `Try::Tiny`
    - Prefer `YAML::XS` over `YAML` or `YAML::Tiny`
    - Prefer `Mojolicious` module for http

### Lua (Neovim)

- **Style**: Standard Neovim Lua style
- **Naming**: `snake_case` for variables and functions
- **Tables**: Use dot notation for options when possible (e.g., `vim.opt.number = true`)
- **Quotes**: Prefer single quotes `'` over double quotes `"` unless interpolation or escaping is needed
- **Formatting**: Use `lua-format` with [luaformatter]

### Git Workflow & Commits

- **Conventional Commits**: Use `feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`
- Create commits or any other changes to git only if asked to do so explicitly

## 4. Tool-specific Guidelines

### Neovim Configuration

- The configuration is split into `lua/config/` (core options) and `lua/plugins/` (lazy.nvim setup)
- Plugin files are numbered (e.g., `00-colorscheme.lua`, `20-lsp.lua`) to control load order
- Custom snippets are located in `.config/nvim/snippets/`

## 5. Project Structure

- `.config/`: Application-specific configurations
- `.local/scripts/`: Primary location for custom utility scripts
- `.local/lib/`: Libraries used by scripts (Perl modules, etc.)
- `hooks/`: Git hooks (managed by the repo, not standard `.git/hooks`)
- `submodules/`:
    - `private/`: Private configurations
    - `secret/`: Encrypted/sensitive data

## 6. Error Handling

- **Bash**: Use `trap` for cleanup on error/exit. Check return codes of critical commands
- **Perl**: Use `warnings qw(FATAL utf8)` to treat warnings as errors where appropriate
- **Logic**: Favor failing fast with clear error messages over silent failures

## 7. Agent Instructions

- **Verification**: Always run the relevant linter after modifying a file
- **Dependencies**: Check `mise` for managing tool versions and dependencies. If a new tool or language runtime is required, it MUST be added via `mise` (e.g., modifying [mise]) rather than global system installation

[.editorconfig]: .editorconfig
[colored-md]: https://github.com/andrew-grechkin/colored-md
[cred]: .local/scripts/tool/cred
[gather-files]: .local/scripts/tool/gather-files
[gemini-api]: .local/scripts/model/gemini-api
[git-credential-pass-cache]: .local/scripts/tool/git-credential-pass-cache
[gitlab-api]: .local/scripts/model/gitlab-api
[json2yaml]: .local/scripts/filter/json2yaml
[luaformatter]: .config/luaformatter/config.yaml
[menu-pacman]: .local/scripts/tui/menu-pacman
[oc]: .local/scripts/tool/oc
[perlcriticrc]: .config/perlcriticrc
[perltidyrc]: .config/perltidyrc
[mise]: .config/mise/config
