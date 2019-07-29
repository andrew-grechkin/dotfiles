## Plumbing

- Provide content or type and size information for repository objects

```bash
git cat-file <type> <object>

# check existence
git cat-file -e <object>

# pretty print
git cat-file -p HEAD

# show type
git cat-file -t <object>

# show size
git cat-file -s <object>
```

- list the contents of a tree object (pretty print version of `git cat-file tree<object>`)

```bash
git ls-tree HEAD

# recursive
git ls-tree -r HEAD
```

- lists commit objects in reverse chronological order

```bash
git rev-list <range>
```

- parse references and ranges

```bash
git rev-parse [options] <reference|range>

# parse the range to parameters for the range
git rev-parse --sq --short --symbolic <ref>..<ref>
```

- compute object ID and optionally creates a blob from a file

```bash
git hash-object [-w] [file]
```

- show information about files in the index and the working tree

```bash
git ls-files [options]

# staged files
git ls-files -s
```

- rewrite branches

```bash
# remove file from all commits
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
```

- give an object a human readable name based on an available ref

```bash
git describe HEAD
```
