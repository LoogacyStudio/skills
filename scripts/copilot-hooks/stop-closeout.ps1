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
$sessionId = if ($data.sessionId) { [string]$data.sessionId } else { "unknown-session" }
$stopHookActive = if ($data.stop_hook_active) { [string]$data.stop_hook_active } else { "false" }

$content = @"
[$timestamp] Copilot agent session ended.
Session: $sessionId
stop_hook_active: $stopHookActive

Recommended closeout:
- Summarize files changed.
- Summarize tests/checks run.
- Summarize unresolved risks.
- Extract reusable learning if repeated friction occurred.
"@

Add-Content -Path "$dir/session-closeout.log" -Value $content

@{
    hookSpecificOutput = @{
        hookEventName     = "Stop"
        additionalContext = "Session closeout recorded. If this was a large task, consider running the extract-learning prompt and updating the change log."
    }
} | ConvertTo-Json -Depth 8