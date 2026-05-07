$ErrorActionPreference = "SilentlyContinue"

$raw = [Console]::In.ReadToEnd()

function Safe-Run($command) {
    try {
        $result = Invoke-Expression $command 2>$null
        if ([string]::IsNullOrWhiteSpace($result)) {
            return "unknown"
        }
        return ($result | Out-String).Trim()
    }
    catch {
        return "unknown"
    }
}

$branch = Safe-Run "git branch --show-current"
$dotnetVersion = Safe-Run "dotnet --version"

$godotDetected = Test-Path "project.godot"
$godotHint = if ($godotDetected) { "Godot project detected" } else { "Godot project not detected from workspace root" }

$solutionCount = @(Get-ChildItem -Path . -Filter *.sln -Recurse -ErrorAction SilentlyContinue).Count
$csprojCount = @(Get-ChildItem -Path . -Filter *.csproj -Recurse -ErrorAction SilentlyContinue).Count

$context = @"
Project context injected by Copilot hook:

- Git branch: $branch
- .NET SDK: $dotnetVersion
- Godot: $godotHint
- Solution files found: $solutionCount
- C# project files found: $csprojCount

AI governance mode:
- Prefer skill-driven workflows.
- Follow Layer 0 governance in .github/copilot-instructions.md.
- Preserve Domain / Application / Presentation boundaries in Godot/.NET guidance.
- Governance, hooks, agents, prompts, and skills require controlled review and closeout.
- Hooks enforce safety; skills provide method; evals verify regression risk.
"@

$output = @{
    hookSpecificOutput = @{
        hookEventName     = "SessionStart"
        additionalContext = $context
    }
}

$output | ConvertTo-Json -Depth 8