---
name: powershell-utf8
description: Configure PowerShell for UTF-8 before working with non-ASCII text (Japanese or otherwise), file paths, or documents. Use proactively before any powershell.exe Bash call that will read/print non-ASCII text or write non-ASCII text to files.
---

Run this in a PowerShell session before reading or printing non-ASCII text:

```powershell
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
```

## When to use

Use this before:
- Reading documents/design notes containing non-ASCII text
- Processing file paths or filenames containing non-ASCII characters
- Any PowerShell session where non-ASCII text appears in output
- Running scripts that read or write non-ASCII text files

## Behavior note

Claude should invoke this itself before issuing a `powershell.exe` Bash command where non-ASCII text is involved, rather than waiting to be asked — garbled output (mojibake) from a missing UTF-8 setup is hard to debug after the fact.

This is about runtime console I/O encoding only. It does not fix encoding issues in the *script files themselves* — see `ascii-only-scripts.md` in `claude-md-snippets/` for that separate concern.
