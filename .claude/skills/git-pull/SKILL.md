---
name: git-pull
description: Pull the latest changes from the remote, bringing the local branch up to date. Use when the user asks to update/pull/sync with remote, or before starting work on a branch that might be behind origin.
---

Bring the local branch up to date with its remote — distinct from `git-commit` (saving local changes) and `git-push` (publishing local changes).

## Steps

1. `git status` first. If there are uncommitted changes, ask whether to commit them (see `git-commit`) or stash before pulling — don't guess, and don't pull over a dirty tree without asking.
2. `git fetch origin` to see what's new without touching the working tree yet.
3. `git pull` (or `git pull --rebase` if this repo's convention prefers rebase — check `git config pull.rebase` or recent log style first; don't switch conventions without asking).
4. If a conflict comes up, resolve it by reading both sides — never blindly accept "ours"/"theirs" or discard a side to make the conflict disappear.
5. Report what came in, e.g. `git log --oneline <old-head>..<new-head>`.

## Never

- Never pull with `--force` or anything that discards local commits without being asked.
- Never resolve a merge conflict by guessing instead of reading both sides.
