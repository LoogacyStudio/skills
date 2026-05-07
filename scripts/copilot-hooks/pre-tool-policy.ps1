$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()

try {
    $data = $raw | ConvertFrom-Json
}
catch {
    @{
        hookSpecificOutput = @{
            hookEventName            = "PreToolUse"
            permissionDecision       = "ask"
            permissionDecisionReason = "Hook could not parse tool input JSON. Manual approval required."
        }
    } | ConvertTo-Json -Depth 8
    exit 0
}

$toolName = [string]$data.tool_name
$toolInputText = ($data.tool_input | ConvertTo-Json -Depth 30 -Compress)
$modificationToolPattern = "edit|create|replace|write|delete|move|rename|apply"
$isModificationTool = $toolName -match $modificationToolPattern
$executionToolPattern = "terminal|execution|send_to_terminal|run_in_terminal"
$isExecutionTool = $toolName -match $executionToolPattern

function Get-ToolSubjectText($toolName, $toolInput) {
    $fragments = @()

    if ($null -eq $toolInput) {
        return ""
    }

    foreach ($propertyName in @("command", "filePath", "file", "path", "dirPath", "query", "includePattern")) {
        if ($toolInput.PSObject.Properties.Name -contains $propertyName) {
            $value = $toolInput.$propertyName
            if ($null -ne $value) {
                $fragments += [string]$value
            }
        }
    }

    foreach ($propertyName in @("input", "patch")) {
        if ($toolInput.PSObject.Properties.Name -contains $propertyName) {
            $patchText = [string]$toolInput.$propertyName
            foreach ($line in ($patchText -split "`r?`n")) {
                if ($line -match "^\*\*\* (?:Update|Add|Delete) File:\s+(.+?)\s*$") {
                    $fragments += $Matches[1]
                }
            }
        }
    }

    return ($fragments -join "`n")
}

$toolSubjectText = Get-ToolSubjectText $toolName $data.tool_input
$executionSubjectText = if ($isExecutionTool) { $toolInputText } else { "" }
$sensitiveSubjectText = ($toolSubjectText, $executionSubjectText -join "`n")

$denyReason = $null
$askReason = $null
$additionalContext = @()

$dangerousPatterns = @(
    "rm\s+-rf",
    "Remove-Item\s+.*-Recurse\s+.*-Force",
    "del\s+/s",
    "rmdir\s+/s",
    "format\s+[A-Za-z]:",
    "git\s+reset\s+--hard",
    "git\s+clean\s+-fdx",
    "git\s+push\s+--force",
    "DROP\s+TABLE",
    "DELETE\s+FROM\s+\w+\s*(;|$)",
    "TRUNCATE\s+TABLE",
    "chmod\s+-R\s+777"
)

foreach ($pattern in $dangerousPatterns) {
    if ($isExecutionTool -and $executionSubjectText -match $pattern) {
        $denyReason = "Blocked destructive operation by Copilot hook policy: pattern '$pattern'."
        break
    }
}

$governancePatterns = @(
    "\.github[\\/]+copilot-instructions\.md",
    "\.github[\\/]+instructions[\\/]+.*\.instructions\.md",
    "\.github[\\/]+prompts[\\/]+.*\.prompt\.md",
    "\.github[\\/]+hooks[\\/]+",
    "scripts[\\/]+copilot-hooks[\\/]+",
    "scripts[\\/]+verify-copilot-hooks\.ps1",
    "\.github[\\/]+agents[\\/]+.*\.agent\.md",
    "\.github[\\/]+skills[\\/]+.*SKILL\.md",
    "docs[\\/]+ai-governance[\\/]+(skill-authoring-contract|hook-policy)\.md"
)

if ($isModificationTool) {
    foreach ($pattern in $governancePatterns) {
        if ($toolSubjectText -match $pattern) {
            $askReason = "Editing AI governance files, prompts, hooks, agents, or skills requires manual approval."
            $additionalContext += "Governance edit detected. Require: reason, before/after behavior, regression risk, eval suggestion, and changelog entry."
            break
        }
    }
}

$secretPatterns = @(
    "\.env",
    "\.env\.",
    "secrets?",
    "credentials?",
    "private[_-]?key",
    "id_rsa",
    "id_ed25519",
    "\.pfx",
    "\.pem",
    "appsettings\.Production\.json"
)

foreach ($pattern in $secretPatterns) {
    if ($sensitiveSubjectText -match $pattern) {
        $askReason = "Potential secret or production credential access requires manual approval."
        $additionalContext += "Do not print, copy, summarize, or transform secrets into chat output."
        break
    }
}

$gitSensitivePatterns = @(
    "git\s+push",
    "git\s+rebase",
    "git\s+merge",
    "git\s+tag",
    "git\s+checkout\s+--",
    "git\s+restore",
    "git\s+reset"
)

foreach ($pattern in $gitSensitivePatterns) {
    if ($isExecutionTool -and $executionSubjectText -match $pattern) {
        if (-not $denyReason) {
            $askReason = "Sensitive git operation requires manual approval."
        }
        break
    }
}

if ($toolInputText.Length -gt 50000) {
    $askReason = "Large tool input detected. Manual approval recommended to avoid accidental bulk modification."
}

if ($denyReason) {
    @{
        hookSpecificOutput = @{
            hookEventName            = "PreToolUse"
            permissionDecision       = "deny"
            permissionDecisionReason = $denyReason
            additionalContext        = ($additionalContext -join "`n")
        }
    } | ConvertTo-Json -Depth 8
    exit 0
}

if ($askReason) {
    @{
        hookSpecificOutput = @{
            hookEventName            = "PreToolUse"
            permissionDecision       = "ask"
            permissionDecisionReason = $askReason
            additionalContext        = ($additionalContext -join "`n")
        }
    } | ConvertTo-Json -Depth 8
    exit 0
}

@{
    hookSpecificOutput = @{
        hookEventName      = "PreToolUse"
        permissionDecision = "allow"
    }
} | ConvertTo-Json -Depth 8