# [Pipelines](https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Simple-Commands-_0026-Pipelines)

## [Redirection](https://zsh.sourceforge.io/Doc/Release/Redirection.html)

* Pipe STDIN from file
    ```bash
    clipcopy < path/to/file
    ```
* Pipe STDIN from heredoc (type end-word for stop reading)
    ```bash
    clipcopy <<'END'
    ```
* Pipe STDIN from heredoc and strip leading tabs
    ```bash
    clipcopy <<-'END'
    ```
* Pipe STDIN from heredoc with parameters expansion
    ```bash
    clipcopy <<END
    ```
* Pipe STDIN from string
    ```bash
    clipcopy <<<'arbitrary string'
    ```
* Pipe STDERR to file
    ```bash
    clippaste 2>/dev/null
    ```
* Pipe all output to file
    ```bash
    clippaste &>/dev/null
    ```
* Explicitly write to output stream
    ```bash
    echo 'to Standard Output' >&1
    echo 'to Standard Error' >&2
    ```

## [Process substitution](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Process-Substitution)

* Connect output of the other process with /dev/fd file (when application doesn't support read from STDIN)
    ```bash
    clipcopy <(ping -c 4 localhost)
    ```
* Connect output of the other process with temporary file (if application need seek through data) (ZSH only)
    ```bash
    clipcopy =(ping -c 4 localhost)
    ```
