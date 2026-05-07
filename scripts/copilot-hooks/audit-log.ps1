$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()

try {
    $data = $raw | ConvertFrom-Json
}
catch {
    '{"continue":true}'
    exit 0
}

$dir = ".ai-logs"
if (!(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir | Out-Null
}

$timestamp = if ($data.timestamp) { [string]$data.timestamp } else { Get-Date -Format "o" }
$sessionId = if ($data.sessionId) { [string]$data.sessionId } else { "unknown-session" }
$eventName = if ($data.hookEventName) { [string]$data.hookEventName } else { "PreToolUse" }
$toolName = if ($data.tool_name) { [string]$data.tool_name } else { "unknown-tool" }

$toolInputText = ($data.tool_input | ConvertTo-Json -Depth 10 -Compress)
$toolInputText = $toolInputText -replace "(?i)(api[_-]?key|token|password|secret|private[_-]?key)\s*[:=]\s*[^,}\s]+", '$1=[REDACTED]'

if ($toolInputText.Length -gt 500) {
    $toolInputText = $toolInputText.Substring(0, 500) + "...[truncated]"
}

$line = "[$timestamp] session=$sessionId event=$eventName tool=$toolName input=$toolInputText"
Add-Content -Path "$dir/copilot-hook-audit.log" -Value $line

'{"continue":true}'