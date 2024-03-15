# Git search

## Grep code (WHERE it is)

### Useful options

- `--break`: add empty line between files
- `--heading`: add file name
- `-n`: add line numbers
- `-p`: print context
- `-P`: use PCRE
- `--and`: combine by AND instead of OR

### search function named name1 or name2 in ref (HEAD by default)

```
git grep --break --heading -n -P '\bdef\b' --and \( -P name1 -P name2 \) [ref]
```

### count occurrences
```
git grep --count -P '\bdef\b'
```

## Log (WHEN it was introduced)

### Useful options

- `--author`: filter by author
- `--grep`: filter by log message regex
- `-S`: search for addition/deletion
- `-G`: search difs for regex
- `-p`: print context
- `-L`: history of a line or a function

### Search my commits with message match

```
git log --author=agrechkin --grep='chore'
```

### Search for changes containing 'Backend'

```
git log -S Backend --oneline
```

### Search for changes containing 'Backend' at the end of the line

```
git log -G '\bBackend$' -p
```

### Show history of a function/object in a file

```
git log -L ':Function-name:filename'
```
