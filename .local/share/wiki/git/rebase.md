# Rebase

- mnemonic

    ```bash
    git rebase main
    # same as
    # mnemonic git rebase --onto main main..HEAD

    # rebase feature to an arbitrary commit in main branch
    git rebase --onto ref main feature

    git rebase main topic
    # same as
    git checkout topic
    git rebase main

    # rebase but keep the branch point as is (don't advance forward)
    git rebase -i --keep-base main topic
    # same as
    git rebase -i --reapply-cherry-picks --no-fork-point --onto main...topic main topic
    ```

- Auto resolve conflicts using changes from working branch (ours - is the changes which we ared doing during rebase,
  theirs is the branch which is being rebased)

    ```bash
    git rebase -Xtheirs main
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
