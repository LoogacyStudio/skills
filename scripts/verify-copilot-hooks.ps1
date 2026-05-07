[CmdletBinding()]
param(
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function New-CheckResult {
    param(
        [string]$Name,
        [string]$Category,
        [bool]$Passed,
        [object]$Details
    )

    [pscustomobject]@{
        name     = $Name
        category = $Category
        passed   = $Passed
        details  = $Details
    }
}

function Get-RelativePath {
    param([string]$Path)

    $resolved = (Resolve-Path $Path).Path
    if ($resolved.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $resolved.Substring($repoRoot.Length).TrimStart('\')
    }

    return $resolved
}

function Test-JsonFile {
    param([string]$Path)

    try {
        $null = Get-Content -Path $Path -Raw | ConvertFrom-Json
        return (New-CheckResult -Name $Path -Category 'json' -Passed $true -Details 'Parsed successfully.')
    }
    catch {
        return (New-CheckResult -Name $Path -Category 'json' -Passed $false -Details $_.Exception.Message)
    }
}

function Test-PowerShellAst {
    param([string]$Path)

    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile((Resolve-Path $Path), [ref]$tokens, [ref]$errors)

    return (New-CheckResult -Name $Path -Category 'powershell' -Passed ($errors.Count -eq 0) -Details ([pscustomobject]@{
        errorCount = $errors.Count
        errors     = @($errors | ForEach-Object Message)
    }))
}

function Invoke-HookScript {
    param(
        [string]$ScriptPath,
        [object]$Payload
    )

    $inputJson = if ($null -eq $Payload) {
        '{}'
    }
    else {
        $Payload | ConvertTo-Json -Depth 30 -Compress
    }

    $oldIn = [Console]::In
    try {
        [Console]::SetIn([System.IO.StringReader]::new($inputJson))
        $raw = & (Join-Path $repoRoot $ScriptPath) 2>&1
    }
    finally {
        [Console]::SetIn($oldIn)
    }

    $text = ($raw | Out-String).Trim()
    $parsed = $null

    if (-not [string]::IsNullOrWhiteSpace($text)) {
        try {
            $parsed = $text | ConvertFrom-Json -Depth 30
        }
        catch {
            $parsed = $null
        }
    }

    $permissionDecision = $null
    $additionalContext = $null

    if ($parsed) {
        if ($parsed.PSObject.Properties.Name -contains 'permissionDecision') {
            $permissionDecision = [string]$parsed.permissionDecision
        }

        if ($parsed.PSObject.Properties.Name -contains 'additionalContext') {
            $additionalContext = [string]$parsed.additionalContext
        }

        if ($parsed.PSObject.Properties.Name -contains 'hookSpecificOutput' -and $parsed.hookSpecificOutput) {
            if ($parsed.hookSpecificOutput.PSObject.Properties.Name -contains 'permissionDecision' -and -not $permissionDecision) {
                $permissionDecision = [string]$parsed.hookSpecificOutput.permissionDecision
            }

            if ($parsed.hookSpecificOutput.PSObject.Properties.Name -contains 'additionalContext' -and -not $additionalContext) {
                $additionalContext = [string]$parsed.hookSpecificOutput.additionalContext
            }
        }
    }

    [pscustomobject]@{
        raw                = $text
        permissionDecision = $permissionDecision
        additionalContext  = $additionalContext
    }
}

function Test-HookExpectation {
    param(
        [string]$Name,
        [string]$ScriptPath,
        [object]$Payload,
        [ValidateSet('allow', 'ask', 'deny', 'clean', 'reminder', 'context')]
        [string]$Expectation,
        [string[]]$ExpectedContextContains = @(),
        [string[]]$ExpectedContextNotContains = @()
    )

    $response = Invoke-HookScript -ScriptPath $ScriptPath -Payload $Payload
    $contextText = [string]$response.additionalContext

    $passed = switch ($Expectation) {
        'allow' {
            $response.permissionDecision -eq 'allow'
        }
        'ask' {
            $response.permissionDecision -eq 'ask'
        }
        'deny' {
            $response.permissionDecision -eq 'deny'
        }
        'clean' {
            [string]::IsNullOrWhiteSpace($response.permissionDecision) -and [string]::IsNullOrWhiteSpace($contextText)
        }
        'reminder' {
            -not [string]::IsNullOrWhiteSpace($contextText)
        }
        'context' {
            -not [string]::IsNullOrWhiteSpace($contextText)
        }
    }

    foreach ($fragment in $ExpectedContextContains) {
        if (-not $contextText.Contains($fragment)) {
            $passed = $false
        }
    }

    foreach ($fragment in $ExpectedContextNotContains) {
        if ($contextText.Contains($fragment)) {
            $passed = $false
        }
    }

    return (New-CheckResult -Name $Name -Category 'contract' -Passed $passed -Details ([pscustomobject]@{
        script             = $ScriptPath
        expected           = $Expectation
        expectedContains   = $ExpectedContextContains
        expectedNotContains = $ExpectedContextNotContains
        permissionDecision = $response.permissionDecision
        additionalContext  = $response.additionalContext
        raw                = $response.raw
    }))
}

function Test-LifecycleCheck {
    param(
        [string]$Name,
        [string]$ScriptPath,
        [object]$Payload,
        [string]$LogPath,
        [string]$ExpectedContextFragment
    )

    $fullLogPath = Join-Path $repoRoot $LogPath
    $beforeExists = Test-Path $fullLogPath
    $beforeLength = if ($beforeExists) { (Get-Item $fullLogPath).Length } else { 0 }

    $response = Invoke-HookScript -ScriptPath $ScriptPath -Payload $Payload

    $afterExists = Test-Path $fullLogPath
    $afterLength = if ($afterExists) { (Get-Item $fullLogPath).Length } else { 0 }
    $hasExpectedContext = -not [string]::IsNullOrWhiteSpace($response.additionalContext) -and $response.additionalContext.Contains($ExpectedContextFragment)
    $passed = $afterExists -and ($afterLength -ge $beforeLength) -and $hasExpectedContext

    return (New-CheckResult -Name $Name -Category 'lifecycle' -Passed $passed -Details ([pscustomobject]@{
        script             = $ScriptPath
        logPath            = $LogPath
        beforeExists       = $beforeExists
        afterExists        = $afterExists
        beforeLength       = $beforeLength
        afterLength        = $afterLength
        additionalContext  = $response.additionalContext
        raw                = $response.raw
    }))
}

function Test-FileExistsCheck {
    param([string]$Path)

    $exists = Test-Path (Join-Path $repoRoot $Path)
    return (New-CheckResult -Name $Path -Category 'eval' -Passed $exists -Details ([pscustomobject]@{
        exists = $exists
    }))
}

function Write-CheckSection {
    param(
        [string]$Title,
        [object[]]$Checks
    )

    Write-Output "=== $Title ==="
    foreach ($check in $Checks) {
        $status = if ($check.passed) { 'PASS' } else { 'FAIL' }
        $detailText = if ($check.details -is [string]) {
            $check.details
        }
        else {
            ($check.details | ConvertTo-Json -Depth 10 -Compress)
        }

        Write-Output ("[{0}] {1} :: {2}" -f $status, $check.name, $detailText)
    }

    Write-Output ''
}

Push-Location $repoRoot
try {
    $jsonTargets = @()
    if (Test-Path '.github/hooks') {
        $jsonTargets += Get-ChildItem '.github/hooks/*.json' -File -ErrorAction Stop | Sort-Object FullName | ForEach-Object { Get-RelativePath $_.FullName }
    }
    if (Test-Path '.vscode/settings.json') {
        $jsonTargets += '.vscode/settings.json'
    }

    $jsonChecks = @($jsonTargets | ForEach-Object { Test-JsonFile -Path $_ })

    $powerShellTargets = @()
    if (Test-Path 'scripts/copilot-hooks') {
        $powerShellTargets += Get-ChildItem 'scripts/copilot-hooks/*.ps1' -File -ErrorAction Stop | Sort-Object FullName | ForEach-Object { Get-RelativePath $_.FullName }
    }

    $powerShellChecks = @($powerShellTargets | ForEach-Object { Test-PowerShellAst -Path $_ })

    $destructiveCommandText = ('git reset' + ' --hard')
    $markdownPatchMentioningCSharp = "*** Begin Patch`n*** Update File: docs/ai-governance/runtime-smoke-checklist.md`n@@`n-test`n+Mention tests/RuntimeBreakLab/Main.cs as an example target path in prose.`n*** End Patch"

    $contractChecks = @(
        (Test-HookExpectation -Name 'session context injects project data' -ScriptPath 'scripts/copilot-hooks/inject-session-context.ps1' -Payload @{} -Expectation 'context'),
        (Test-HookExpectation -Name 'destructive command deny' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'run_in_terminal'; tool_input = @{ command = $destructiveCommandText } } -Expectation 'deny'),
        (Test-HookExpectation -Name 'destructive string search allow' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'grep_search'; tool_input = @{ query = $destructiveCommandText } } -Expectation 'allow'),
        (Test-HookExpectation -Name 'governance read allow' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'read_file'; tool_input = @{ filePath = '.github/copilot-instructions.md' } } -Expectation 'allow'),
        (Test-HookExpectation -Name 'governance edit ask' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: .github/copilot-instructions.md`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'ask'),
        (Test-HookExpectation -Name 'verification script edit ask' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: scripts/verify-copilot-hooks.ps1`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'ask'),
        (Test-HookExpectation -Name 'secret read ask' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'read_file'; tool_input = @{ filePath = '.env' } } -Expectation 'ask'),
        (Test-HookExpectation -Name 'normal C# edit allow' -ScriptPath 'scripts/copilot-hooks/pre-tool-policy.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: tests/RuntimeBreakLab/Main.cs`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'allow'),
        (Test-HookExpectation -Name 'read-only markdown clean' -ScriptPath 'scripts/copilot-hooks/post-tool-quality.ps1' -Payload @{ tool_name = 'read_file'; tool_input = @{ filePath = 'docs/ai-governance/runtime-smoke-checklist.md' } } -Expectation 'clean'),
        (Test-HookExpectation -Name 'governance markdown edit reminder' -ScriptPath 'scripts/copilot-hooks/post-tool-quality.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: docs/ai-governance/runtime-smoke-checklist.md`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'reminder' -ExpectedContextContains @('AI governance artifacts changed', 'Markdown changed')),
        (Test-HookExpectation -Name 'verification script edit governance reminder' -ScriptPath 'scripts/copilot-hooks/post-tool-quality.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: scripts/verify-copilot-hooks.ps1`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'reminder' -ExpectedContextContains @('AI governance artifacts changed')),
        (Test-HookExpectation -Name 'markdown prose mentioning C# path does not trigger C# reminder' -ScriptPath 'scripts/copilot-hooks/post-tool-quality.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = $markdownPatchMentioningCSharp } } -Expectation 'reminder' -ExpectedContextContains @('AI governance artifacts changed', 'Markdown changed') -ExpectedContextNotContains @('C#/.NET files changed')),
        (Test-HookExpectation -Name 'C# edit reminder' -ScriptPath 'scripts/copilot-hooks/post-tool-quality.ps1' -Payload @{ tool_name = 'apply_patch'; tool_input = @{ patch = "*** Begin Patch`n*** Update File: tests/RuntimeBreakLab/Main.cs`n@@`n-test`n+test`n*** End Patch" } } -Expectation 'reminder' -ExpectedContextContains @('C#/.NET files changed'))
    )

    $lifecycleChecks = @(
        (Test-LifecycleCheck -Name 'precompact writes state log' -ScriptPath 'scripts/copilot-hooks/precompact-save-state.ps1' -Payload @{ sessionId = 'verify-session'; trigger = 'manual-test' } -LogPath '.ai-logs/precompact-state.log' -ExpectedContextFragment 'Context compaction is about to happen.'),
        (Test-LifecycleCheck -Name 'stop writes closeout log' -ScriptPath 'scripts/copilot-hooks/stop-closeout.ps1' -Payload @{ sessionId = 'verify-session'; stop_hook_active = 'true' } -LogPath '.ai-logs/session-closeout.log' -ExpectedContextFragment 'Session closeout recorded.')
    )

    $evalChecks = @(
        (Test-FileExistsCheck -Path 'evals/hook-policy/destructive-command-denied.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/destructive-string-search-allowed.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/governance-edit-asks.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/governance-read-allowed.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/normal-csharp-edit-allowed.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/post-tool-markdown-prose-csharp-clean.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/post-tool-readonly-markdown-clean.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/secret-file-asks.md'),
        (Test-FileExistsCheck -Path 'evals/hook-policy/verify-script-edit-asks.md')
    )

    $allChecks = @($jsonChecks + $powerShellChecks + $contractChecks + $lifecycleChecks + $evalChecks)
    $overallPass = ($allChecks | Where-Object { -not $_.passed }).Count -eq 0

    $summary = [pscustomobject]@{
        timestamp                = (Get-Date).ToString('o')
        repoRoot                 = $repoRoot
        overallPass              = $overallPass
        counts                   = [pscustomobject]@{
            json       = $jsonChecks.Count
            powershell = $powerShellChecks.Count
            contract   = $contractChecks.Count
            lifecycle  = $lifecycleChecks.Count
            eval       = $evalChecks.Count
            failed     = ($allChecks | Where-Object { -not $_.passed }).Count
        }
        jsonChecks               = $jsonChecks
        powerShellChecks         = $powerShellChecks
        contractChecks           = $contractChecks
        lifecycleChecks          = $lifecycleChecks
        evalChecks               = $evalChecks
        manualSpotChecksRemaining = @(
            'Confirm .github/hooks JSON files are loaded in VS Code diagnostics or Copilot hook output.',
            'Confirm prompt and custom agent routing in the VS Code editor when adding new routed prompts or running a future bounded self-evolution pilot.'
        )
    }

    if ($Json) {
        $summary | ConvertTo-Json -Depth 10
    }
    else {
        Write-Output ("verify-copilot-hooks.ps1 :: repo={0}" -f $repoRoot)
        Write-Output ''
        Write-CheckSection -Title 'JSON checks' -Checks $jsonChecks
        Write-CheckSection -Title 'PowerShell AST checks' -Checks $powerShellChecks
        Write-CheckSection -Title 'Hook contract checks' -Checks $contractChecks
        Write-CheckSection -Title 'Lifecycle checks' -Checks $lifecycleChecks
        Write-CheckSection -Title 'Eval presence checks' -Checks $evalChecks
        Write-Output ("Overall result :: {0}" -f $(if ($overallPass) { 'PASS' } else { 'FAIL' }))
        Write-Output ''
        Write-Output 'Manual spot-checks still recommended:'
        foreach ($item in $summary.manualSpotChecksRemaining) {
            Write-Output ("- {0}" -f $item)
        }
    }

    if (-not $overallPass) {
        exit 1
    }
}
finally {
    Pop-Location
}
