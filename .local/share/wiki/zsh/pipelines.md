# [Pipelines](https://zsh.sourceforge.io/Doc/Release/Shell-Grammar.html#Simple-Commands-_0026-Pipelines)

## [Redirection](https://zsh.sourceforge.io/Doc/Release/Redirection.html)

[Tutorial](https://web.archive.org/web/20230315225157/https://wiki.bash-hackers.org/howto/redirection_tutorial)

- Pipe STDIN from file
    ```bash
    clipcopy < path/to/file
    ```
- Pass data as STDIN from a process (space is required between < < in bash), as a temp file from process and as an ordinary file
    ```bash
    cli-echo < <(cat README.md) <(cat README.md) README.md
    ```
- Pipe STDIN from heredoc (type end-word for stop reading)
    ```bash
    clipcopy << 'END'
    ```
- Pipe STDIN from heredoc and strip leading tabs
    ```bash
    clipcopy <<- 'END'
    ```
- Pipe STDIN from heredoc with parameters expansion
    ```bash
    clipcopy << END
    ```
- Pipe STDIN from a string (new line is added at the end)
    ```bash
    clipcopy <<< 'arbitrary string'
    ```
- redirect STDERR to a file
    ```bash
    clippaste 2>/dev/null
    ```
- Explicitly write to an output stream

    ```bash
    echo 'to Standard Output' 2>&1
    2>&1 echo 'to Standard Output'
    echo 'dont do this, will break if on a higher level redirected to a file' >/dev/stdout
    >/dev/stdout echo 'same here'

    echo 'to Standard Error' 1>&2
    1>&2 echo 'to Standard Error'
    echo 'dont do this, will break if on a higher level redirected to a file' >/dev/stderr
    >/dev/stderr echo 'same here'
    ```

- Read STDIN to variable

    ```bash
    var1=$(</dev/stdin)
    var2=`cat`
    ```

- redirect all output to a file

    ```bash
    clippaste &>/dev/null
    ```

- Redirect script output to file (order is important)

    ```bash
    cat >file 2>&1
    ```

- Read from 2 inputs (data from file and user input from stdin)

    ```bash
    exec 3<file
    while read -u 3 line; do echo "$line"; read -p "Press any key" -n 1; done
    ```

- Close file descriptors
    ```bash
    $ cat <&- 2>&-
    ```

## [Process substitution](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Process-Substitution)

- Multiplex STDOUT to several processes. Redirect to `/dev/null` is necessary to prevent tee from printing to STDOUT. The order of execution is reversed

    ```bash
    clippaste | tee >(cat) >(cat) >/dev/null
    ```

- Connect output of the other process as `/dev/fd` file (when application doesn't support read from STDIN)

    ```bash
    clipcopy <(ping -c 4 localhost)
    ```

- Connect output of the other process with temporary file (if application need seek through data) (ZSH only)

    ```bash
    clipcopy =(ping -c 4 localhost)
    ```

- Separately redirect STDOUT and STDERR

    ```bash
    command 1> >(process stdout) 2> >(process stderr)

    $ { echo 'print err' >&2; echo 'print out'; } 1> >(inp=`cat`; echo "this is from stdout: $inp") 2> >(inp=`cat`; echo "this is from stderr: $inp")
    this is from stdout: print out
    this is from stderr: print err
    ```
