param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectRoot
)

# Merges the .claude/ edit permission rules into <ProjectRoot>/.claude/settings.local.json.
# Safe to run repeatedly: only adds missing rules, never removes or replaces existing ones.

$ErrorActionPreference = "Stop"

$requiredRules = @("Edit(.claude)", "Write(.claude)")
$claudeDir = Join-Path $ProjectRoot ".claude"
$settingsPath = Join-Path $claudeDir "settings.local.json"

if (-not (Test-Path $claudeDir)) {
    throw "No .claude directory found at: $claudeDir"
}

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

if (-not ($config.PSObject.Properties.Name -contains "permissions")) {
    $config | Add-Member -MemberType NoteProperty -Name "permissions" -Value ([PSCustomObject]@{})
}

if (-not ($config.permissions.PSObject.Properties.Name -contains "allow")) {
    $config.permissions | Add-Member -MemberType NoteProperty -Name "allow" -Value @()
}

$existingRules = @($config.permissions.allow)
$addedRules = @()

foreach ($rule in $requiredRules) {
    if ($existingRules -notcontains $rule) {
        $existingRules += $rule
        $addedRules += $rule
    }
}

$config.permissions.allow = $existingRules

$json = $config | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($settingsPath, $json, [System.Text.UTF8Encoding]::new($false))

if ($addedRules.Count -gt 0) {
    Write-Output ("Added rule(s): " + ($addedRules -join ", "))
}
else {
    Write-Output "All required rules were already present. No changes made."
}

Write-Output "Updated: $settingsPath"
