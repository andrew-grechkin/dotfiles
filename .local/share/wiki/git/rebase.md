# Rebase

man: git-rebase

## Command

```bash
git rebase <ref>
```

```bash
# rebase feature branched from main onto an arbitrary reference
git rebase --onto ref main feature
```

## Useful options

- `--keep-base`: don't change branching point
- `--onto`:      set branching point explicitly
- `-i`:          interactive

# Mnemonic

```bash
git rebase main
# same as git rebase --onto main main..HEAD

git rebase main topic
# same as
git checkout topic
git rebase main

```

# Change commits

- rebase but keep the branching point as is (don't advance forward)

```bash
git rebase --keep-base main topic
# same as
git rebase --reapply-cherry-picks --no-fork-point --onto main...topic main topic
```

- Rebase and set authors date as commit date (basically now):

```bash
git rebase master topic --onto feature --reset-author-date
```

- Rebase and set committer date as authors date (instead of now):

```bash
git rebase master topic --onto feature --committer-date-is-author-date
```

- Rebase and keep committer date:

```bash
git -c rebase.instructionFormat='%s%nexec GIT_COMMITTER_DATE="%cD" git commit --amend --no-edit' rebase -i
```

# Conflicts resolution

Auto resolve conflicts using changes from working branch (ours - is the changes which we're doing during rebase,
theirs is the branch which is being rebased)

```bash
git rebase -Xtheirs main
```
