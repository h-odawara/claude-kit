---
name: resume-session
description: Catch up on prior work on this project at the start of a new session, using the latest session-summary and project memory, before diving into new requests. Use at the start of a session when the user references earlier work ("前回の続き", "前のセッションの続き", "continue from last time") or when picking a project back up after a gap.
---

Reconstruct context from prior sessions without rereading full raw logs.

## Steps

1. Read `.claude/logs/summaries/` and take the most recently modified `summary_*.md` (if the folder is empty, no summary exists yet — fall back to skimming the tail of the most recent `.claude/logs/log_*.md` instead, and tell the user no summary was found).
2. Read the project memory index at `~/.claude/projects/*/memory/MEMORY.md` (the path containing this project's slug) and follow any `[[links]]` relevant to what the summary mentions as in-progress or next steps.
3. Skim the project's design docs / README only if the summary references a question those would resolve — don't reread everything by default.
4. Report back to the user in a short brief (not a wall of text): what was done, what's open, what you'd suggest next — then wait for direction rather than assuming "next steps" should be started immediately.

## Why this exists

A project's accumulated decisions span many turns. Re-deriving "why was it built this way" from scratch wastes a turn and risks re-litigating settled decisions. Durable project memory holds the facts; the session summary holds the timeline; this skill's job is to combine both into one short briefing.
