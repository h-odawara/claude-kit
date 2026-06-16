$ErrorActionPreference = "Stop"
chcp 65001 > $null
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Get-SafeName([string]$Value) {
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return "unknown"
    }
    return ($Value -replace '[^A-Za-z0-9_.-]', '_')
}

function Add-Utf8Text([string]$Path, [string]$Text) {
    $dir = Split-Path -Parent $Path
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    [System.IO.File]::AppendAllText($Path, $Text, [System.Text.UTF8Encoding]::new($false))
}

function Get-GitOutput([string[]]$ArgsList) {
    $repoArgIndex = [Array]::IndexOf($ArgsList, "-C")
    if ($repoArgIndex -ge 0 -and $ArgsList.Length -gt ($repoArgIndex + 1)) {
        $gitDir = Join-Path $ArgsList[$repoArgIndex + 1] ".git"
        if (-not (Test-Path $gitDir)) {
            return "(not a git repository)"
        }
    }
    try {
        $output = & git @ArgsList 2>&1
        if ($LASTEXITCODE -ne 0) {
            return "git $($ArgsList -join ' ') failed: $($output -join [Environment]::NewLine)"
        }
        return ($output -join [Environment]::NewLine)
    }
    catch {
        return "git $($ArgsList -join ' ') failed: $($_.Exception.Message)"
    }
}

$stdinText = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($stdinText)) {
    exit 0
}

try {
    $event = $stdinText | ConvertFrom-Json
}
catch {
    exit 0
}

$cwd = if ($event.cwd) { [string]$event.cwd } else { (Get-Location).Path }
$projectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

try {
    $repoRoot = (& git -C $cwd rev-parse --show-toplevel 2>$null | Select-Object -First 1)
    if ([string]::IsNullOrWhiteSpace($repoRoot)) {
        $repoRoot = $projectRoot
    }
}
catch {
    $repoRoot = $projectRoot
}

$sessionId = Get-SafeName ([string]$event.session_id)
$turnId = Get-SafeName ([string]$event.turn_id)
$stamp = Get-Date -Format "yyyyMMdd-HHmm"
$eventName = [string]$event.hook_event_name
# One combined file per session (prompts and turn results interleaved chronologically) -
# there is no separate consumer for "just prompts" vs "just turns", so keep them together.
$sessionLog = Join-Path $repoRoot ".claude\logs\log_${sessionId}.md"

if ($eventName -eq "UserPromptSubmit") {
    $prompt = if ($null -ne $event.prompt) { [string]$event.prompt } else { "" }
    $entryLines = @(
        "",
        "## Prompt $stamp",
        "",
        "- session_id: $sessionId",
        "- turn_id: $turnId",
        "- cwd: $cwd",
        "- model: $($event.model)",
        "",
        '```text',
        $prompt,
        '```'
    )
    $entry = ($entryLines -join [Environment]::NewLine) + [Environment]::NewLine
    Add-Utf8Text $sessionLog $entry
    exit 0
}

if ($eventName -eq "Stop") {
    $summary = if ($null -ne $event.last_assistant_message) { [string]$event.last_assistant_message } else { "" }
    $diffStat = Get-GitOutput @("-C", $repoRoot, "diff", "--stat")
    $diffNameStatus = Get-GitOutput @("-C", $repoRoot, "diff", "--name-status")
    $diff = Get-GitOutput @("-C", $repoRoot, "diff", "--")
    if ([string]::IsNullOrWhiteSpace($diffStat)) {
        $diffStat = "(no working tree diff)"
    }
    if ([string]::IsNullOrWhiteSpace($diffNameStatus)) {
        $diffNameStatus = "(no working tree diff)"
    }
    if ([string]::IsNullOrWhiteSpace($diff)) {
        $diff = "(no working tree diff)"
    }

    $entryLines = @(
        "",
        "## Turn Result $stamp",
        "",
        "- session_id: $sessionId",
        "- turn_id: $turnId",
        "- cwd: $cwd",
        "- model: $($event.model)",
        "",
        "### Assistant Summary",
        "",
        '```markdown',
        $summary,
        '```',
        "",
        "### Diff Stat",
        "",
        '```text',
        $diffStat,
        '```',
        "",
        "### Changed Files",
        "",
        '```text',
        $diffNameStatus,
        '```',
        "",
        "### Diff",
        "",
        '```diff',
        $diff,
        '```'
    )
    $entry = ($entryLines -join [Environment]::NewLine) + [Environment]::NewLine
    Add-Utf8Text $sessionLog $entry
    exit 0
}

exit 0
