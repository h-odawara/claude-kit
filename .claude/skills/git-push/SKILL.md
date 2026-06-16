---
name: git-push
description: Push committed changes to the remote for this repo. Use only when the user explicitly asks to push — never as a follow-on from git-commit without being asked separately.
---

Pushing affects shared/remote state — always confirm explicitly before running this, even if the user approved a push earlier in the session. Approval doesn't carry forward automatically.

## Steps

1. `git status` and `git log --oneline @{u}.. 2>/dev/null` (or `git log --oneline -5` if no upstream yet) to show exactly what's about to be pushed.
2. Confirm the target branch/remote with the user if there's any ambiguity (e.g. first push of a new branch, or this repo has no upstream configured yet).
3. Push:
   ```bash
   git push -u origin <branch>   # first push of a branch
   git push                      # subsequent pushes with upstream already set
   ```
4. Never `--force`/`--force-with-lease` unless the user explicitly asks, and warn clearly if the target is `main`/`master`.
5. Report the result, including the remote URL pushed to, so the user can verify.
