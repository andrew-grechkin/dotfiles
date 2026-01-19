# Globbing & Pattern Matching

The complete reference for Zsh filename generation (globbing) and pattern matching.

Patterns are used in several places, and only *filename generation* treats `/` and a leading `.` specially:

- **Filename generation (globbing)** - expanding words to matching file names
- **`case`** statements and the `[[ ... ]]` conditional operators `==`, `!=`, `=`
- **Parameter expansion** - `${var#pattern}`, `${var/pat/repl}`, and friends

---

## Gotchas

- **No match aborts the command.** With the default `NOMATCH`, `ls zzz*` prints `no matches found` and does not run; in
  a script the rest of the line is skipped. Use [`NULL_GLOB`](#10-options), [`CSH_NULL_GLOB`](#10-options) or the `(N)`
  qualifier to make it expand to nothing
- **`[[ ]]` and `case` match the whole string.** `[[ $x == foo ]]` is false for `foobar`; add `*` for a partial match.
  `${x#pat}` strips only a prefix and `${x%pat}` only a suffix.
- **A pattern kept in a variable is literal on the right of `==`.** `p='f*'; [[ foo == $p ]]` does not match; use
  `${~p}` (or [`GLOB_SUBST`](#10-options))
- **`(#i)` does not case-fold inside `[...]`.** `(#i)[a-z]` still matches only lowercase; use `[[:alpha:]]` or list both
  cases
- **`<1-5>` is not a fixed width.** It matches `img1.png`, `img01.png` and `img001.png` alike, unlike `{1..5}` which
  generates literal words
- **Scalar assignment does not glob, array assignment does.** `f=*` keeps the literal `*`; `arr=(*)` expands
- **`**/` does not follow symlinks, `***/` does.** Both match zero directory levels, so `**/*.txt` also finds files in
  the current directory
- **Precedence:** `^foo/bar` means `(^foo)/bar`, not `^(foo/bar)`; inside the excluded side of `x~y`, `/` and `.` are
  not special

---

## 1. Basic wildcards

| Pattern | Matches |
| :--- | :--- |
| `*` | Any string, including the empty. In filename generation it does not match `/` nor a leading `.` (see [`GLOB_DOTS`](#10-options)) |
| `?` | Exactly one character (does not match `/` in filename generation) |
| `[abc]` | Any one of the enclosed characters |
| `[a-z]` | Any character in the range |
| `[^abc]` / `[!abc]` | Any character **not** in the set |
| `[[:alpha:]]` | POSIX named character class (see below) |
| `<x-y>` | Any number in the inclusive range `x` to `y` |

Notes:

- `/` must be matched explicitly in filename generation, and a leading `.` is skipped by default. See
  [`GLOB_DOTS`](#10-options) or the [`D` qualifier](#5-glob-qualifiers). No pattern matches `.` or `..`
- A `-` first or last inside `[...]` is literal; a `]` as the first character is literal
- `<x-y>`: either bound may be omitted. `<->` matches any number, `<x->` matches `>= x`, `<-y>` matches `<= y`. This
  operator does not require `EXTENDED_GLOB`
- Trap: `<0-9>*` matches *any* number, because `<0-9>` consumes the first digit and `*` the rest. Use `<0-9>[^[:digit:]]*` instead
- To match a literal special character, quote it: `\*`, `\?`, `\(`, `\[`, `\<`, `\#`, `\~`, `\^`, or use single quotes

### POSIX character classes

`[:alnum:]`, `[:alpha:]`, `[:ascii:]`, `[:blank:]`, `[:cntrl:]`, `[:digit:]`, `[:graph:]`, `[:lower:]`, `[:print:]`,
`[:punct:]`, `[:space:]`, `[:upper:]`, `[:xdigit:]`

Built in (locale independent): `[:IDENT:]`, `[:IFS:]`, `[:IFSSPACE:]`, `[:INCOMPLETE:]`, `[:INVALID:]`, `[:WORD:]`

The brackets are additional, so a single alphanumeric character is `[[:alnum:]]`. Classes combine with other sets:
`[[:alpha:]0-9]`.

### Examples

```zsh
# List every `.txt` file in the current directory. `*` matches any name but skips dotfiles and `/`:
ls *.txt
```

```zsh
# Exactly one character in that position:
ls file?.log          # file1.log, fileA.log, but not file10.log
```

```zsh
# Names that start with a digit. `<0->` is a numeric range from 0 upwards:
ls <0->*.log          # 1.log, 42-debug.log
```

```zsh
# Select an embedded number in a range. Any width and leading zeros are accepted:
ls img<1-50>.png      # img1.png, img5.png, img01.png, img001.png
```

```zsh
# Invert a character class:
ls [^0-9]*            # names not starting with a digit
```

---

## 2. Brace expansion (not globbing)

Brace expansion runs *before* filename generation and produces literal words. It does not look at the filesystem.

| Pattern | Result |
| :--- | :--- |
| `{a,b,c}` | `a b c` |
| `file.{txt,md}` | `file.txt file.md` |
| `{1..5}` | `1 2 3 4 5` (inclusive, reverse if descending) |
| `{01..05}` | `01 02 03 04 05` (zero padded if any bound starts with `0`) |
| `{1..10..2}` | `1 3 5 7 9` (step, negative step reverses) |
| `{-99..100..01}` | Step with its own padding |
| `{a..e}` | `a b c d e` (character range, `{d..a}` reverses) |

- Braces nest, and a comma can be quoted to keep it literal
- Brace expansion **generates** words and never touches the filesystem: `{1..5}` always yields `1 2 3 4 5`. The numeric
  glob `<1-5>` in section 1 instead **matches** an existing name containing a number in that range, e.g. `img<1-5>.png`,
  and is the only one of the two that supports open-ended bounds such as `<->`
- With [`BRACE_CCL`](#10-options): `{abcdef0-9}`
- Brace expansion is **not** a single pattern. `*/{foo,bar}` becomes two patterns `*/foo` and `*/bar`, so a missing
  match errors in either one. By contrast `*/(foo|bar)` is one pattern and only errors if nothing matches

### Examples

```zsh
# Create a project layout. Brace expansion generates the three directory names before anything touches the disk:
mkdir -p project/{src,test,doc}
```

```zsh
# Zero-padded numeric range:
touch log_{01..12}.txt      # log_01.txt ... log_12.txt
```

```zsh
# Step and character ranges:
echo {0..10..2}             # 0 2 4 6 8 10
echo {a..e}                 # a b c d e
```

```zsh
# Brace expansion creates separate patterns, so a missing is an error, whereas the group form still matches the other:
ls report.{txt,pdf}         # error if only one of the two exists
ls report.(txt|pdf)         # matches whichever exists
```

---

## 3. Grouping and alternation

| Pattern | Meaning |
| :--- | :--- |
| `(pattern)` | Grouping |
| `x\|y` | Match `x` or `y` (lowest precedence; must be inside parentheses) |
| `(a\|b\|c)` | Match one of the alternatives, tried left to right |
| `(pat\|)` / `(\|pat)` | Optional `pat` (zero or one occurrence) |

- Grouping may not span multiple directories, with one exception: `(pat/)#` as a complete path segment matches a
  sequence of matching directories, e.g. `foo/(a*/)#bar` matches `foo/bar`, `foo/any/bar`, and so on

### Examples

```zsh
# Match several extensions with one pattern:
ls *.(jpg|png|gif)
```

```zsh
# Alternatives at the start of a name:
ls (README|LICENSE)*
```

```zsh
# An optional piece (zero or one occurrence):
ls file(|s).txt             # file.txt and files.txt
```

```zsh
# A repeated group can also match a run of dir. `(a*/)#` means zero or more directories whose names start with `a`:
ls foo/(a*/)#bar            # foo/bar, foo/any/bar, foo/any/anyother/bar
```

---

## 4. Recursive globbing

| Pattern | Meaning |
| :--- | :--- |
| `**/` | Zero or more directory levels; equivalent to `(*/)#`. Matches the current directory too. Does **not** follow symbolic links |
| `***/` | Same as `**/` but **does** follow symbolic links |
| `(*/)#` | Explicit recursive directory match |

### Examples

```zsh
# Find a file at any depth. `**/` matches zero or more directories, so files in the current directory are included too:
ls **/*.txt                 # every .txt below the current directory
```

```zsh
# `(*/)#` is the general form of `**/` and reads as "zero or more path segments". These two are equivalent:
ls **/bar
ls (*/)#bar
```

```zsh
# Because the repeated group is a real pattern, you can constrain the intermediate directories:
ls foo/(a*/)#bar            # foo/bar, foo/any/bar, foo/any/anyother/bar
```

```zsh
# `***/` is identical to `**/` but also follows symbolic links:
ls ***/*.txt                # descends through symlinked directories
```

Notes:

- Neither form can be combined with other inside the same path segment; the `*` then reverts to normal behaviour
- Shorter forms are available with [`GLOB_STAR_SHORT`](#10-options): `**.c` and `***.c`

---

## 5. Glob qualifiers

Qualifiers go at the very end of a pattern in parentheses and filter the matches. The bare `(...)` form is controlled by
[`BARE_GLOB_QUAL`](#10-options); the `(#q...)` form (section 9) is an unambiguous, chainable alternative. To force a
`(...)` group to be treated as a pattern rather than qualifiers, double the parentheses: `((^x))`.

### File type

| Qualifier | Selects |
| :--- | :--- |
| `/` | Directories |
| `F` | Non-empty ("full") directories. `(/^F)` gives empty directories |
| `.` | Plain files |
| `@` | Symbolic links |
| `=` | Sockets |
| `p` | Named pipes (FIFOs) |
| `*` | Executable plain files |
| `%` | Device files (block or character) |
| `%b` / `%c` | Block / character special files |

#### Examples

Keep only one kind of entry:

```zsh
ls -d *(/)                  # directories
ls *(.)                     # plain files
ls -l *(@)                  # symbolic links
ls -d *(F)                  # non-empty directories
ls -d *(/^F)                # empty directories
```

### Permissions

| Qualifier | Selects | Qualifier | Selects |
| :--- | :--- | :--- | :--- |
| `r` | Owner-readable | `R` | World-readable |
| `w` | Owner-writable | `W` | World-writable |
| `x` | Owner-executable | `X` | World-executable |
| `A` | Group-readable | `s` | setuid |
| `I` | Group-writable | `S` | setgid |
| `E` | Group-executable | `t` | sticky bit |

`f` allows arbitrary mode tests: `(f70?)` owner rwx and no group rights; `(f-100)` owner not executable;
`(f:gu+w,o-rx:)` owner and group writable, others no read/execute.

#### Examples

```zsh
# Select by permission class, including negated ones:
ls *(x)                     # owner-executable
ls *(I)                     # group-writable
ls *(^W)                    # not world-writable
```

```zsh
# Arbitrary mode tests with `f`:
ls *(f-100)                 # owner does not have execute permission
ls *(f:gu+w,o-rx:)          # owner and group writable, others no read/execute
```

### Ownership

| Qualifier | Selects |
| :--- | :--- |
| `U` | Owned by the effective user ID |
| `G` | Owned by the effective group ID |
| `u:id` / `u[name]` / `u:name:` | Owned by user (id or name) |
| `g:id` / `g[name]` / `g:name:` | Owned by group (id or name) |

#### Examples

```zsh
# Filter by owner and group, by ID or by name:
ls **/*(.U)                 # regular files owned by me
ls **/*(/G)                 # directories owned by my group
ls **/*(.u:root:)           # regular files owned by root
ls **/*(.^U)                # regular files not owned by me
```

### Time

Format: `a`, `m` or `c` followed by an optional unit and a sign, then `n`. `a` = access time, `m` = modification time,
`c` = inode change time. Units: `M` months (30 days), `w` weeks, `h` hours, `m` minutes, `s` seconds, `d` days
(default). `-n` means within the last `n`, `+n` means older than `n`, `n` means exactly `n`.

| Example | Selects |
| :--- | :--- |
| `*(m-1)` | Modified within the last day |
| `*(mw-1)` | Modified within the last week |
| `*(mh-2)` | Modified within the last 2 hours |
| `*(a+30)` | Accessed more than 30 days ago |
| `*(c+1)` | Inode changed more than 1 day ago |

#### Examples

```zsh
# Recent files, recent access, and stale files:
ls -lt **/*(.m-1)           # regular files modified in the last day
ls ~/Downloads/*(mh-2)      # files downloaded in the last 2 hours
ls *(.aw-1)                 # regular files accessed in the last week
ls *(.m+90)                 # regular files untouched for 90 days
```

### Size and links

| Qualifier | Selects |
| :--- | :--- |
| `L[+\|-]n` | Length less than (`-`), more than (`+`) or exactly (`n`) `n` bytes |
| `Lk[+\|-]n` | Same, in kilobytes (also `K`) |
| `Lm[+\|-]n` | Same, in megabytes (also `M`) |
| `Lp[+\|-]n` | Same, in 512-byte blocks (also `P`); `g`/`t` for giga/terabytes where available |
| `l[-\|+]ct` | Link count less than, greater than or equal to `ct` |
| `d:dev:` | Files on device `dev` |

Size and unit order matters: it is `Lm+50` (megabytes, greater than 50), **not** `L+50m`. `*(L0)` selects empty files.
`*(Lm1)` selects files from 1 byte up to and including 1 MiB.

#### Examples

```zsh
# Large files, empty files, and link counts:
ls -lh **/*(.Lm+50)         # regular files larger than 50 MB
ls **/*(.L0)                # empty regular files
ls *(.Lk+1)                 # regular files larger than 1 KB
ls *(.l+1)                  # regular files with more than one hard link
ls *(.^l1)                  # regular files whose link count is not 1
```

### Sorting

`o` sorts ascending (youngest/smallest first), `O` descending.

| Field | Sort key |
| :--- | :--- |
| `n` | Name (default) |
| `L` | Size (length) |
| `l` | Number of links |
| `a` | Access time, youngest first |
| `m` | Modification time, youngest first |
| `c` | Inode change time, youngest first |
| `d` | Directories first (per level) |
| `N` | No sorting |
| `e:string:` / `+cmd` | Custom sort via shell code modifying `$REPLY` |

Multiple sort specifiers resolve ties (up to 12). Subsequent `o`/`O` qualify earlier ones as e.g. `odon`.

#### Examples

```zsh
# Newest, largest, and custom orderings:
ls -l **/*(.om[1,3])        # the 3 most recently modified regular files
ls -lh **/*(.OL[1,5])       # the 5 largest regular files
ls **/*(.On)                # names in reverse order
ls **/*(odon)               # entries in subdirectories first, then by name
```

### Control and ranges

| Qualifier | Effect |
| :--- | :--- |
| `^` | Negate all following qualifiers. `(^/)` = non-directories |
| `-` | Operate on the symlink target instead of the link (default is the link itself) |
| `[beg,end]` | Keep only the given range of matches, array-subscript syntax incl. negatives. `[1,3]` = first three |
| `P:string:` | Prepend `string` as a separate word to each match. With `^` it appends |
| `e:string:` / `+cmd` | Keep a match only if shell code returns 0; `$REPLY` holds the name |
| `N` | Apply [`NULL_GLOB`](#10-options) to this pattern |
| `D` | Apply [`GLOB_DOTS`](#10-options) to this pattern |
| `n` | Apply [`NUMERIC_GLOB_SORT`](#10-options) to this pattern |
| `M` | Apply [`MARK_DIRS`](#10-options) to this pattern |
| `T` | Append type marks like `LIST_TYPES` |
| `Y`n | Stop after at most `n` matches (implies `oN`) |

- Qualifiers in a comma-separated list are ORed; qualifiers within one sublist are ANDed. `M`, `T`, `N`, `D`, `n`, `o`,
  `O` and `[...]` apply globally to the whole expression
- A `:` inside the qualifier list switches the remainder to [modifiers](#6-modifiers)

#### Examples

```zsh
# Negate, follow symlinks, limit results, and act on each match:
ls -d *(^/)                 # everything that is not a directory
ls -ld -- *(-@)             # broken symlinks
ls -ld -- *(-/)             # dirs and symlinks pointing to dirs
ls **/*(.[1,5])             # first 5 plain files
ls *(.N)                    # plain files, no error if there are none
ls -d *(D/)                 # directories including dotfiles
ls *(P:-f:)                 # prepend -f to every match
ls *(.e:'[[ $REPLY == *.txt ]]':)   # keep matches whose name ends in .txt
```

```zsh
# Qualifiers combine. Here ownership, type control, negation and a modifier are used together:
ls -d *~(.git|.snapshots)(D/)   # dirs incl. dotdirs, except .git and .snapshots
print -rC1 /tmp/foo*(u0^@:t)    # basenames of root-owned non-symlink foo* files
```

---

## 6. Modifiers

Modifiers are introduced by `:` and can be applied to glob matches, parameter expansions and history words. They chain
left to right.

| Modifier | Effect |
| :--- | :--- |
| `a` | Absolute path (logical, resolves `.`/`..`) |
| `A` | Absolute path then `realpath(3)` (resolves symlinks) |
| `P` | `realpath(3)`-like; absolute, no symlinks, preserves non-existent trailing parts |
| `c` | Resolve a command name by searching `PATH` |
| `e` | Keep only the extension (after the last `.`) |
| `r` | Remove the extension |
| `h[digits]` | Head: remove one trailing path component (`dirname`). With digits, keep that many leading components |
| `t[digits]` | Tail: keep one final path component (`basename`). With digits, keep that many trailing components |
| `l` | Lowercase |
| `u` | Uppercase |
| `q` | Quote the result |
| `Q` | Remove one level of quotes |
| `x` | Like `q` but split into words at whitespace |
| `s/l/r/` | Substitute first `l` with `r`. `gs/l/r/` or `:G` for global. `&` repeats the last `s` |
| `f` | Repeat the following modifier until the result stops changing |
| `F:expr:` | Repeat the following modifier `expr` times |
| `w` | Apply the following modifier to each word |
| `W:sep:` | Like `w`, using `sep` as the word separator |

### Examples

```zsh
# Print absolute, symlink-resolved, lowercased names:
print -l *(:A:l)
```

```zsh
# Keep only the extension of each match:
print -l *(:e)
```

```zsh
# Split a path into its parts (`:h` = dirname, `:t` = basename, `:r` = root, `:e` = extension):
p=/usr/local/share/thing.tar.gz
print ${p:h}                # /usr/local/share
print ${p:t}                # thing.tar.gz
print ${p:r}                # /usr/local/share/thing.tar
print ${p:e}                # gz
```

```zsh
# Modifiers work on matches too. This renames in the listing only, without touching the files:
print -l *(:s/txt/TXT/)
```

---

## 7. Pattern matching outside filename generation

The same patterns work in `case`, `[[ ]]`, and parameter expansion. In these contexts `/` and a leading `.` are **not**
special.

```zsh
case $file in
  (*.jpg|*.png) print image ;;
  (*)           print other ;;
esac

[[ $file == *.tex ]] && print "tex"
[[ $name != [a-z]* ]] && print "not lowercase"
```

### Parameter expansion

| Form | Effect |
| :--- | :--- |
| `${var#pat}` / `${var##pat}` | Remove shortest / longest matching prefix |
| `${var%pat}` / `${var%%pat}` | Remove shortest / longest matching suffix |
| `${var/pat/repl}` | Replace first match |
| `${var//pat/repl}` | Replace all matches |
| `${var:#pat}` | Empty if `var` matches; otherwise unchanged (arrays: remove matching elements, `(M)` keeps matches) |
| `${var/pat}` | Remove first match (`repl` empty) |
| `${(S)var//pat/repl}` | Same, but shortest matches |

Anchors: a leading `#` in the pattern anchors to the start, `%` to the end, `#%` to the whole string.

```zsh
foo="twinkle twinkle little star"
print ${foo#*t}        # winkle twinkle little star
print ${foo%star}      # twinkle twinkle little
print ${foo//twinkle/TWINKLE}
print ${foo/(#i)star/SUN}
```

### Dynamic patterns

`${~spec}` turns the result of a substitution into a pattern; it is the per-expansion form of
[`GLOB_SUBST`](#10-options).

```zsh
pat='*.c'
print ${~pat}          # expands to .c files
```

### Examples

```zsh
# A `[[ ]]` match covers the whole string, so a suffix must be matched explicitly:
[[ report.pdf == report ]]          # false
[[ report.pdf == report* ]]         # true
```

```zsh
# Case-insensitive test with `(#i)` (requires `EXTENDED_GLOB`):
[[ $file == (#i)*.jpg ]]            # true for PHOTO.JPG
```

```zsh
# Strip and replace with the same pattern syntax as globbing:
path=/var/log/app.log
print ${path:t:r}                   # app
print ${path//\//_}                 # _var_log_app.log
```

---

## Opt-in features

Sections 8 and 9, and the `(#q...)` qualifier form, require the [`EXTENDED_GLOB`](#10-options) option:

```zsh
setopt EXTENDED_GLOB
```
---

## 8. Extended operators

| Operator | Meaning |
| :--- | :--- |
| `^x` | Anything **except** `x`. Higher precedence than `/` |
| `x~y` | Anything matching `x` but **not** `y`. Lower precedence than all but `\|` |
| `x#` | Zero or more occurrences of `x`. High precedence: `12#` means `1(2#)` |
| `x##` | One or more occurrences of `x`. High precedence: `12##` means `1(2##)` |

Notes:

- `^foo/bar` searches directories in `.` except `./foo` for a file named `bar`
- Multiple exclusions chain: `foo~bar~baz`
- Inside the excluded pattern `y`, `/` and `.` are **not** special
- An unquoted `#` after something that cannot be repeated (empty string, another `##`) is an error. No more than two
  active `#` characters may be adjacent

### Examples

```zsh
# Exclude by name with `^`. Everything except `.bak`:
ls ^*.bak
```

```zsh
# Exclude with `~`. All files except minified JavaScript:
ls -- *~*.min.js
```

```zsh
# Exclude a group:
ls ^(*.o|*.a)
```

```zsh
# Repetition: `x#` is zero or more, `x##` is one or more:
ls file(0)#.txt             # file.txt, file0.txt, file00.txt, ...
ls file(ab)##.txt           # fileab.txt, fileabab.txt, ...
```

---

## 9. Globbing flags

Flags affect all text to their right until the end of the enclosing group or pattern.

| Flag | Effect |
| :--- | :--- |
| `(#i)` | Case-insensitive from here on |
| `(#l)` | Lowercase letters in the pattern match either case; uppercase still match only uppercase |
| `(#I)` | Revert to case-sensitive |
| `(#b)` | Activate backreferences; fills `$match`, `$mbegin`, `$mend`. Not for filename generation |
| `(#B)` | Deactivate backreferences |
| `(#m)` | Set `$MATCH`, `$MBEGIN`, `$MEND` for the whole match. Not for filename generation |
| `(#M)` | Deactivate `(#m)` |
| `(#cN,M)` | Match the preceding unit between `N` and `M` times (like regex `{N,M}`). `(#cN)` = exactly `N`; `(#c,M)` = `0..M`; `(#cN,)` = `N..` |
| `(#s)` | Match only at the start of the test string (like regex `^`) |
| `(#e)` | Match only at the end of the test string (like regex `$`) |
| `(#aN)` | Approximate matching, allowing up to `N` errors |
| `(#q...)` | Glob qualifiers inside a pattern (chainable; multiple sets are ANDed) |
| `(#u)` / `(#U)` | Respect / ignore multibyte characters (overrides [`MULTIBYTE`](#10-options)) |

### Approximate matching

Approximate matching counts four error types: a different character, a transposition, a missing character, and an extra
character. Non-literal pattern parts (ranges, `?`) must match exactly, and slashes cannot be transposed. Exclusion is
approximated separately.

```zsh
print (#i)readme          # case-insensitive
print (#a2)readme         # up to two errors
```

### Captures and backreferences

With `(#b)`, backreferences populate `$match`, `$mbegin`, `$mend`. With `(#m)`, `$MATCH`, `$MBEGIN`, `$MEND` hold the
whole match. Both work in pattern matching and parameter substitution, not in filename generation.

```zsh
foo="a_string_with_a_message"
[[ $foo = (a|an)_(#b)(*) ]] && print ${foo[$mbegin[1],$mend[1]]}

arr=(veldt jynx grimps waqf zho buck)
print ${arr//(#m)[aeiou]/${(U)MATCH}}   # vEldt jynx grImps wAqf zhO bUck

[[ abab = (#b)([ab])# ]] && print $match[1]   # b (last repetition only)
```

---

## 10. Options

Every option referenced in this document. Defaults are marked; unset them (or use the `NO_` form) for the opposite
behaviour.

| Option | Description |
| :--- | :--- |
| `EXTENDED_GLOB` | Enables the extended operators `^`, `~`, `#`, `##` and every `(#...)` globbing flag. Required for sections 8 and 9 |
| `BARE_GLOB_QUAL` (default) | Treats a trailing `(...)` as a glob qualifier list when it contains no `\|`, `(` or `~`. Without it, use the `(#q...)` form |
| `GLOB` (default) | Enables filename generation. Unset it to turn globbing off entirely |
| `GLOB_DOTS` | Makes `*` and `?` match a leading `.`, so dotfiles are included. The `D` qualifier does this for a single pattern |
| `NOMATCH` (default) | Prints an error when a pattern has no matches |
| `NULL_GLOB` | Deletes the word when a pattern has no matches instead of reporting an error. The `N` qualifier does this for a single pattern |
| `CSH_NULL_GLOB` | Like `NULL_GLOB`, but reports an error only if all patterns in the command fail to match |
| `GLOB_SUBST` | Treats characters produced by parameter and command substitution as a pattern. The `${~spec}` form applies it to a single expansion |
| `GLOB_STAR_SHORT` | When not followed by `/`, `**` stands for `**/*` and `***` for `***/*` |
| `NUMERIC_GLOB_SORT` | Sorts numeric file names numerically instead of lexicographically. The `n` qualifier does this for a single pattern |
| `CASE_GLOB` (default) | Case-sensitive globbing. Unsetting it (`NO_CASE_GLOB`) makes globbing case-insensitive |
| `CASE_PATHS` | Restricts `NO_CASE_GLOB` to path components that contain glob characters; the others stay case-sensitive |
| `BRACE_CCL` | Expands a `{...}` that matches no other brace form into a sorted list of its characters |
| `EQUALS` | Expands an unquoted leading `=cmd` to the full path of `cmd` |
| `MARK_DIRS` | Appends a trailing `/` to directory names produced by globbing. The `M` qualifier does this for a single pattern |
| `MULTIBYTE` (default) | Counts multibyte characters as single characters rather than bytes |

---

## See also

- [Brace expansion and parameters](https://zsh.sourceforge.io/Doc/Release/Expansion.html)
- [Glob qualifiers](https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers)
- [zmv](zmv) - batch renaming built on the pattern matcher
- [Pipelines](pipelines)
