# claude-kit

Reusable Claude Code setup pieces, extracted from per-project `.claude/` folders where they had drifted into independent copies. This is the canonical source — when one of these is improved in a project, port the improvement back here, then re-apply to other projects.

## What's here

```
.claude/hooks/
  claude_turn_logger.ps1     Logs UserPromptSubmit + Stop events to one combined
                              .claude/logs/log_<sessionId>.md per session (ASCII-only source)

.claude/skills/
  powershell-utf8/           Runtime console UTF-8 setup for non-ASCII text in PowerShell
  git-diff/                  Read-only status/diff dump to .claude/diff/latest.txt
  git-pull/                  Pull latest from remote (never commits/pushes local work)
  git-commit/                Stage + commit (never pushes)
  git-push/                  Push (always confirm first, never force without explicit ask)
  session-summary/           Condense a session's log into a catch-up doc
  resume-session/             Read the latest summary + project memory to catch up

claude-md-snippets/
  ascii-only-scripts.md      Paste into a project's CLAUDE.md: hook/PowerShell scripts must be ASCII-only
  readme-vs-claude-md.md     Paste into a project's CLAUDE.md: README vs. CLAUDE.md role split

.claude/settings.json         Hook wiring for claude_turn_logger.ps1, using the Claude Code
                              built-in ${CLAUDE_PROJECT_DIR} placeholder — no project-specific
                              substitution needed, but still needs merging into a project's
                              existing settings.json (see .claude/scripts/apply-claude-hooks.ps1)

.claude/settings.local.json  Permission rules so Claude can edit/write under .claude/ (skills,
                              hooks, settings.json) without a per-edit prompt

.claude/scripts/
  apply-claude-hooks.ps1             Merges this kit's settings.json hooks into a project's
                                      .claude/settings.json (idempotent, preserves permissions
                                      and any other hooks): run with -ProjectRoot <path>
  apply-claude-dir-permissions.ps1   Merges settings.local.json's rules into a
                                      project's .claude/settings.local.json (idempotent,
                                      preserves existing rules): run with
                                      -ProjectRoot <path>

PROJECT_SKILLS_CHECKLIST.md  Read this next — the skills above are not enough on their own;
                              every project also needs its own build/install/test/run skills.
```

## Applying this to a project

1. Copy `.claude/hooks/claude_turn_logger.ps1` to `<project>/.claude/hooks/`.
2. Copy whichever `.claude/skills/*` directories are relevant to `<project>/.claude/skills/`.
3. Run `.claude/scripts/apply-claude-hooks.ps1 -ProjectRoot <project>` to wire up the hook. Idempotent — safe to re-run.
4. Append the relevant `claude-md-snippets/*.md` into `<project>/CLAUDE.md`.
5. Add to the project's `.gitignore`: `.claude/settings.local.json`, `.claude/logs/`, `.claude/diff/`.
6. Run `.claude/scripts/apply-claude-dir-permissions.ps1 -ProjectRoot <project>` so Claude can edit/write under `.claude/` without a per-edit prompt. Idempotent — safe to re-run.
7. Follow `PROJECT_SKILLS_CHECKLIST.md` to author the project-specific skills (build, install, test, run/launch) that this kit deliberately doesn't include.

## Why settings.json uses `${CLAUDE_PROJECT_DIR}` instead of an absolute path

Claude Code expands `${CLAUDE_PROJECT_DIR}` to the project root inside hook `command`/`commandWindows` strings, so the same `settings.json` content works unmodified in any project — no per-project path substitution, no risk of a stale absolute path after a project moves or gets cloned elsewhere.

## Why a project-level skill isn't enough on its own

Skills auto-invoke based on the `description` matching the situation, but Claude won't reliably *remember* to e.g. run `powershell-utf8` before a Japanese-text PowerShell call unless the description makes that trigger explicit. Write descriptions as "use when/before X", not just "what this does".
