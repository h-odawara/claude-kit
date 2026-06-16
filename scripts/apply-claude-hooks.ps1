param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectRoot
)

# Merges the claude_turn_logger.ps1 hook wiring (from settings.json in this kit) into
# <ProjectRoot>/.claude/settings.json. Safe to run repeatedly: replaces only the
# UserPromptSubmit/Stop hook entries that call claude_turn_logger.ps1, leaves
# permissions and any other hooks untouched.
#
# Uses ${CLAUDE_PROJECT_DIR}, a Claude Code built-in that expands to the project root,
# so the resulting settings.json is portable and never hardcodes an absolute path.

$ErrorActionPreference = "Stop"

$kitRoot = Split-Path -Parent $PSScriptRoot
$templatePath = Join-Path $kitRoot "settings.json"
$claudeDir = Join-Path $ProjectRoot ".claude"
$settingsPath = Join-Path $claudeDir "settings.json"
$hookFileName = "claude_turn_logger.ps1"

if (-not (Test-Path $claudeDir)) {
    throw "No .claude directory found at: $claudeDir"
}

if (-not (Test-Path (Join-Path $claudeDir "hooks\$hookFileName"))) {
    Write-Warning "$hookFileName not found under $claudeDir\hooks - copy it from this kit's hooks/ first."
}

$template = Get-Content -Path $templatePath -Raw | ConvertFrom-Json

if (Test-Path $settingsPath) {
    $raw = Get-Content -Path $settingsPath -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) {
        $config = [PSCustomObject]@{}
    }
    else {
        $config = $raw | ConvertFrom-Json
    }
}
else {
    $config = [PSCustomObject]@{}
}

if (-not ($config.PSObject.Properties.Name -contains "hooks")) {
    $config | Add-Member -MemberType NoteProperty -Name "hooks" -Value ([PSCustomObject]@{})
}

foreach ($eventName in @("UserPromptSubmit", "Stop")) {
    $config.hooks | Add-Member -MemberType NoteProperty -Name $eventName -Value $template.hooks.$eventName -Force
}

$json = $config | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($settingsPath, $json, [System.Text.UTF8Encoding]::new($false))

Write-Output "Merged claude_turn_logger.ps1 hooks (UserPromptSubmit, Stop) into: $settingsPath"
