---
name: git-commit
description: Stage and commit the current changes in this repo (commit only, never pushes). Use when the user asks to commit progress.
---

Stage and commit — never push from this skill; pushing is `git-push`.

## Steps

1. Run `git status` and `git diff` (and `git log --oneline -5` for message-style consistency) in parallel.
2. Stage specific files by name — never `git add -A`/`git add .`. Exclude anything that looks like a secret (`.env`, credentials) and warn if the user asked for one of those explicitly.
3. Draft a commit message: 1-2 sentences, focused on *why*, not a restatement of the diff. Match this repo's emerging convention once one exists (check `git log` style).
4. Commit via heredoc:
   ```bash
   git commit -m "$(cat <<'EOF'
   <message>

   Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
   EOF
   )"
   ```
5. Run `git status` after to confirm a clean tree.
6. If a pre-commit hook fails: fix the issue, re-stage, and create a **new** commit. Never `--no-verify`.

## Before the first commit in a new repo

Check `.gitignore` exists and covers this project's build output directories (language-specific bin/obj/dist/__pycache__/etc.) before staging anything.

If this project exposes one source tree into another location via a symlink or NTFS junction (e.g. a shared core library mounted into an app project), explicitly `.gitignore` the link's destination path — Git for Windows walks into junctions like a normal directory and will happily track the same files a second time under the linked path. Verify after staging that `git status` doesn't show the same source files twice under two different paths.

Never amend an existing commit unless the user explicitly asks — always create a new one.
