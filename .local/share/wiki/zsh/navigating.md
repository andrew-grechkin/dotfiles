# [Navigating command line](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html)

## List all key bindings
```bash
bindkey | grep -v 'self-insert' | less
```

## Misc
* Ctrl-l        : Clear screen
* Ctrl-m        : Accept line (Enter)
* Ctrl-v        : Insert quoted key combination
* Ctrl-x,a      : Expand alias
* Ctrl-x,h      : Completion help
* Ctrl-x,?      : Completion debug
* Ctrl-x,Ctrl-e : Edit current command in EDITOR
* Ctrl-x,v      : Edit current command in EDITOR (nonstandard)
* Ctrl-x,u      : Undo change

## History
* Ctrl-p : Previous command
* Ctrl-n : Next command
* Ctrl-r : Start search
* Ctrl-g : Cancel search

## Lines
* Ctrl-a : Beginning of the line
* Ctrl-e : End of the line
* Ctrl-u : Delete to beginning
* Ctrl-k : Delete to end
* Ctrl-y : Yank deleted text

## Words
* Alt-b  : Back one word
* Alt-f  : Forward one word
* Ctrl-w : Delete word back
* Alt-d  : Delete word forward
* Alt-t  : Transpose words

## Chars
* Ctrl-b : Back one char
* Ctrl-f : Forward one char
* Ctrl-h : Backward delete char
* Ctrl-d : Forward delete current char (expand completion if EOL)
