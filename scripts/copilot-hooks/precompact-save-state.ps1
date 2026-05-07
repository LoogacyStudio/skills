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

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$trigger = if ($data.trigger) { [string]$data.trigger } else { "unknown" }
$sessionId = if ($data.sessionId) { [string]$data.sessionId } else { "unknown-session" }

$content = @"
[$timestamp] PreCompact triggered.
Session: $sessionId
Trigger: $trigger

Recommended agent action:
- Preserve current task goal.
- Preserve files changed.
- Preserve decisions made.
- Preserve unresolved risks.
- Preserve next action.
"@

Add-Content -Path "$dir/precompact-state.log" -Value $content

@{
    hookSpecificOutput = @{
        hookEventName     = "PreCompact"
        additionalContext = "Context compaction is about to happen. Preserve task goal, modified files, decisions, unresolved risks, and next action before continuing."
    }
} | ConvertTo-Json -Depth 8