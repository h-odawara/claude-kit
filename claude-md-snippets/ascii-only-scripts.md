## Windows / PowerShell / UTF-8

Hook scripts and PowerShell scripts (`.claude/hooks/*.ps1`, `scripts/*.ps1`) must be written in ASCII only — no em-dashes, smart quotes, or non-English text, even in comments. This is a separate concern from runtime console encoding (see the `powershell-utf8` skill): a `.ps1` *file* containing non-ASCII bytes can be misparsed by `powershell.exe` depending on how the file was saved (BOM vs. no BOM, system codepage) regardless of any `chcp`/console-encoding fix applied at runtime. Non-ASCII text belongs only in source string constants/documentation in other languages, never in PowerShell source.

Before treating a `.ps1` file as done, check it: `LANG=C LC_ALL=C grep -n '[^ -~	]' path/to/script.ps1` should produce no output.
