---
name: session-summary
description: Summarize the current Claude Code session's log into a condensed catch-up document. Use when the user asks to wrap up, summarize progress, or before a long session risks losing context — also useful right before switching to a new session.
---

Condense the current session's raw prompt/turn log into a short catch-up document, so a future session (or a human skimming later) can reconstruct what happened without rereading the full transcript.

## Steps

1. Find the active session log: the most recently modified file matching `.claude/logs/log_*.md` directly under `.claude/logs/` (not inside `.claude/logs/summaries/`).
2. Read it in full (it interleaves `## Prompt <timestamp>` and `## Turn Result <timestamp>` entries chronologically, including git diff stats per turn — see the `claude_turn_logger.ps1` hook).
3. Write a summary to `.claude/logs/summaries/summary_<sessionId>_<yyyyMMdd-HHmm>.md` with these sections:
   - **Goal** — what the user was trying to accomplish this session, in 1-2 sentences.
   - **Decisions made** — design/architecture choices and *why* (not just what), especially ones that overrode an earlier assumption.
   - **Files changed** — group by area/module, not a raw file list.
   - **Open questions / next steps** — anything explicitly deferred or left for the user to decide.
   - **Gotchas** — anything a future session would otherwise have to rediscover the hard way (e.g. a wrong assumption that got corrected, an environment quirk).
4. Keep it under ~500 words. This is a catch-up briefing, not a transcript — prefer "why" over "what" wherever the log shows reasoning.
5. If this project already has durable memory entries (see `~/.claude/projects/*/memory/`) covering a decision, don't repeat it at length here — just reference it by name.

## When NOT to duplicate memory

This summary is about *this session's* events (a timeline), not durable project facts. Durable architecture/feedback/project facts belong in the memory system, not here — if something surfaces during summarization that looks like it should be a memory and isn't yet, flag it to the user rather than silently writing both.
