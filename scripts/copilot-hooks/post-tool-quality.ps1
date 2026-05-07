$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()

try {
    $data = $raw | ConvertFrom-Json
}
catch {
    '{"continue":true}'
    exit 0
}

$toolName = [string]$data.tool_name
$toolInputText = ($data.tool_input | ConvertTo-Json -Depth 30 -Compress)
$messages = @()

$modificationToolPattern = "edit|create|replace|write|delete|move|rename|apply"
$isModificationTool = $toolName -match $modificationToolPattern

if (-not $isModificationTool) {
    '{"continue":true}'
    exit 0
}

function Get-ModifiedTargetText($toolInput) {
    $fragments = @()

    if ($null -eq $toolInput) {
        return ""
    }

    foreach ($propertyName in @("filePath", "file", "path", "dirPath", "query", "includePattern")) {
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

$modifiedTargetText = Get-ModifiedTargetText $data.tool_input

if ($modifiedTargetText -match "\.cs|\.csproj|\.sln") {
    $sln = Get-ChildItem -Path . -Filter *.sln -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($sln) {
        $messages += "C#/.NET files changed. Recommended follow-up: run dotnet format and relevant test suite for solution: $($sln.FullName)."
    }
    else {
        $messages += "C# files changed but no .sln found from workspace root. Verify project path before running tests."
    }
}

if (Test-Path "project.godot") {
    if ($modifiedTargetText -match "\.cs|\.gd|\.tscn|\.tres") {
        $messages += "Godot project detected. Verify Domain/Application layers do not reference Godot Node, Control, Resource, SceneTree, or Signal APIs improperly."
        $messages += "Presentation code may adapt engine events, but gameplay rules should remain in Domain/Application."
    }
}

if ($modifiedTargetText -match "\.github[\\/]+(hooks|skills|agents|instructions|prompts)|copilot-instructions\.md|scripts[\\/]+verify-copilot-hooks\.ps1|docs[\\/]+ai-governance") {
    $messages += "AI governance artifacts changed. Required closeout: explain reason, before/after behavior, regression risk, eval suggestion, and changelog entry."
}

if ($modifiedTargetText -match "\.md") {
    $messages += "Markdown changed. Verify headings, relative links, and whether this update should be reflected in docs/ai-governance/skill-change-log.md or learning-notes.md."
}

if ($messages.Count -eq 0) {
    '{"continue":true}'
    exit 0
}

@{
    hookSpecificOutput = @{
        hookEventName     = "PostToolUse"
        additionalContext = ($messages -join "`n")
    }
} | ConvertTo-Json -Depth 8