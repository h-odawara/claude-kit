---
name: git-diff
description: Show a quick, read-only overview of the working tree state for this repo — status, staged/unstaged diff, and recent log. Use before deciding what to commit, or when the user asks "what's changed".
---

Read-only repo inspection. Safe to run anytime, no confirmation needed.

Write the full output to a file instead of dumping it into the conversation — diffs get long, and a file is easier for the user to open and review on their own:

```bash
mkdir -p .claude/diff
{
  echo "=== git status ==="
  git status
  echo
  echo "=== git diff (unstaged) ==="
  git diff
  echo
  echo "=== git diff --staged ==="
  git diff --staged
  echo
  echo "=== git log --oneline -10 ==="
  git log --oneline -10
} > .claude/diff/latest.txt
```

`.claude/diff/latest.txt` is overwritten each run (not timestamped — it's a scratch file, not a history). Add `.claude/diff/` to `.gitignore`.

Report back concisely in the conversation: what's changed and why it matters, plus the file path so the user can open it themselves. Don't paste the raw diff into the conversation unless asked. If the repo has no commits yet, say so plainly rather than treating empty `git log` output as an error.
