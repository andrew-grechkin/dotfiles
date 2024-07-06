# Globbing

## [Operators](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Filename-Generation)

* exact match
    ```bash
    ls dir_name
    ```
* recursively first level
    ```bash
    ls dir_name/*
    ```
* recursively second level
    ```bash
    ls dir_name/*/*
    ```
* recursively full tree
    ```bash
    ls dir_name/**/*
    ```
* recursively full tree with regex matching
    ```bash
    ls dir_name/**/*.txt
    ```

### Examples

* list .txt files recursively that end in a number from 1 to 10
    ```bash
    ls **/*<1-10>.txt
    ```
* list .txt files recursively that start with the letter a
    ```bash
    ls **/[a]*.txt
    ```
* list .txt files recursively that start with either ab or bc
    ```bash
    ls **/(ab|bc)*.txt
    ```
* list .txt files recursively that don't start with a lower or uppercase c
    ```bash
    ls **/[^cC]*.txt
    ```

## [Qualifiers](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers)

1. Type
    - .  plain files
    - \*  executable plain files
    - @  symbolic links
    - /  directories
    - F  non-empty directories
    - d  + device
    - %  device files
    - =  sockets
    - p  named pipes (FIFOs)
1. Permissions
    - A  group-readable
    - E  group-executable
    - f  + access rights
    - G  owned by EGID
    - g  + owning group
    - I  group-writeable
    - r  owner-readable
    - R  world-readable
    - S  setgid
    - s  setuid
    - t  sticky bit set
    - U  owned by EUID
    - u  + owning user
    - w  owner-writeable
    - W  world-writeable
    - x  owner-executable
    - X  world-executable
1. Size
    - L  + size
    - l  + link count
1. Time
    - a  + access time
    - c  + inode change time
    - m  + modification time
1. Sort
    - O  + sort order, down
    - o  + sort order, up
1. Misc
    - ^  negate qualifiers
    - \-  follow symlinks toggle
    - \+  + command name
    - D  glob dots
    - e  execute code (grep like)
    - M  mark directories
    - :  modifier
    - n  numeric glob sort
    - N  use NULL_GLOB
    - P  prepend word
    - [  + range of files
    - T  mark types
    - Y  + at most ARG matches

### Examples

* all regular files with 'blah' in the name recursively
    ```bash
    ls **/*blah*(.)
    ```
* all executable files recursively
    ```bash
    ls **/*(.x)
    ```
* all files recursively non-writable by owner group
    ```bash
    ls **/*(.:g-w:)
    ```
* all files recursively having the same owner group as my group
    ```bash
    ls **/*(.G)
    ```
* all dirs recursively owned by me
    ```bash
    ls **/*(/U)
    ```
* all files recursively owned by user
    ```bash
    ls **/*(.u:user:)
    ```
* all files recursively not owned by me and root
    ```bash
    ls **/*(.^Uu0)
    ```
* all files recursively modified during last week
    ```bash
    ls **/*(.mw-1)
    ```
* all files recursively larger then 50 M
    ```bash
    ls **/*(.Lm+50)
    ```
* all files recursively larger then 50 M, modified lash hour and show last 3
    ```bash
    ls -l zsh_demo/**/*(.Lm+50mh-1om[1,3])
    ```
* all files recursively not having 'blah' in the path
    ```bash
    ls **/*(e:'[[ ! "$REPLY" =~ blah ]]':)
    ```

## [Modifiers](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers)

* a  absolute
* A  absolute + realpath
* c  absolute path of command by searching in PATH
* e  extension
* h [digit]  remove trailing path components
* t [digit]  remove heading path components
* l  lowercase
* u  uppercase
* P  absolute path to the directory
* q  quote
* r  remove extension

### Examples

Print lowercase absolute paths to the all files in current directory and resolve all symlinks
    ```bash
    print -l *(:A:l)
    ```
