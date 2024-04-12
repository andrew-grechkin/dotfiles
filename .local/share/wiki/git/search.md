# Grep code (WHERE is it in the worktree)

man: git-grep

## Command

```bash
git grep needle [ref...] -- [pathspec...]
```

## Useful options

- `--break`:   add empty line between files
- `--heading`: group matches under file name
- `-n`:        add line numbers
- `-p`:        print context
- `-P`:        use PCRE
- `--and`:     combine by AND instead of OR
- `-e`:        search regex

## search function named name1 or name2 in ref (HEAD by default)

```bash
git grep -P --break --heading -n -e '\bdef\b' --and \( -e name1 -e name2 \) [ref]
```

## count occurrences

```bash
git grep --count -P '\bdef\b'
```

# Log changes (WHEN it was introduced)

man: git-log

## Command

```bash
git log [ref...] -- [pathspec...]
```

## Useful options

- `--author`:    filter by author
- `--committer`: filter by committer
- `--since`:     filter since
- `--until`:     filter until
- `--no-merges`: filter out merge commits
- `--grep`:      search regex in commit message
- `-G`:          search regex in diffs
- `-S`:          search exact match in occurrences
- `-L`:          history of a line or a function
- `-p`:          print context

## Search commits where commit message matching

```bash
git log --grep='chore'
```

## Search for changes containing 'Backend'

```bash
git log -S Backend --oneline
```

## Search for changes containing 'Backend' at the end of the line

```bash
git log -G '\bBackend$' -p
```

## Show history of a function/object in a file

```bash
git log -L ':function_name:filename'
```

## Show history of a file starting on line and until the end

```bash
git log -L 'line:filename'
```

## Show history of a file starting on lines

```bash
git log -L 'start-line,end-line:filename'
```
