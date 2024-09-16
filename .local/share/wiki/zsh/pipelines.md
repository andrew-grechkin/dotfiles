# [Pipelines](https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Simple-Commands-_0026-Pipelines)

## [Redirection](https://zsh.sourceforge.io/Doc/Release/Redirection.html)

[Tutorial](https://web.archive.org/web/20230315225157/https://wiki.bash-hackers.org/howto/redirection_tutorial)

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
    >&1 echo 'to Standard Output'
    echo 'to Standard Output' >/dev/stdout
    >/dev/stdout echo 'to Standard Output'

    echo 'to Standard Error' >&2
    >&2 echo 'to Standard Error'
    echo 'to Standard Error' >/dev/stderr
    >/dev/stderr echo 'to Standard Error'
    ```

* Read STDIN to variable
    ```bash
    var1=$(</dev/stdin)
    var2=`cat`
    ```

* Redirect script output to file (order is important)
    ```bash
    cat >file 2>&1
    ```

* Read from 2 inputs (data from file and user input from stdin)
    ```bash
    exec 3<file
    while read -u 3 line; do echo "$line"; read -p "Press any key" -n 1; done
    ```

* Close file descriptors
    ```bash
    $ cat <&- 2>&-
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

* Separately redirect STDOUT and STDERR
    ```bash
    command 1> >(process stdout) 2> >(process stderr)

    $ { echo 'print err' >/dev/stderr; echo 'print out'; } 1> >(inp=`cat`; echo "this is from stdout: $inp") 2> >(inp=`cat`; echo "this is from stderr: $inp")
    this is from stdout: print out
    this is from stderr: print err
    ```
