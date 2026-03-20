# Upgrade Plan

Use this template to return a staged, risk-aware upgrade plan for a Godot + .NET/C# project.

Rules:

- prefer step-by-step sequencing over all-at-once migration
- explain why each step exists
- call out third-party dependency and export-chain impact explicitly
- keep validation tied to actual risk, not generic filler
- include rollback thinking before irreversible changes

## Current state

- Godot engine:
- .NET SDK:
- Target framework / language version:
- Addons / plugins / NuGet dependencies:
- Export targets / templates / CI packaging:
- Known fragile areas:

## Target state

- Target Godot engine:
- Target .NET SDK:
- Target framework / language version:
- Required addon / plugin compatibility state:
- Required export pipeline state:

## Upgrade scope

- Primary classification: Patch / Minor / Major / SDK / Export chain
- Secondary classification(s):
- Why this scope matters:
- Main compatibility surfaces:

## Risk areas

- **Godot engine**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **.NET SDK / target framework**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **C# compatibility**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **Addon / plugin compatibility**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **Export pipeline**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **Verification coverage gaps**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

- **Rollback complexity**
  - Risk level:
  - Why it is risky:
  - Evidence or dependency to verify first:

## Recommended sequence

1. **Baseline and branch prep**
   - Goal:
   - Actions:
   - Exit criteria:

2. **Step 1**
   - Goal:
   - Why this step comes now:
   - Main changes:
   - Smoke checks:
   - Rollback trigger:

3. **Step 2**
   - Goal:
   - Why this step comes now:
   - Main changes:
   - Smoke checks:
   - Rollback trigger:

4. **Step 3**
   - Goal:
   - Why this step comes now:
   - Main changes:
   - Smoke checks:
   - Rollback trigger:

5. **Post-upgrade cleanup**
   - Non-blocking warnings or tidy-up work:
   - Deferred follow-ups:

## Validation checklist

- [ ] Current-version baseline captured before first change
- [ ] Project opens/imports cleanly after each stage
- [ ] Restore/build succeeds after each stage
- [ ] One or more critical scenes or flows still run
- [ ] Addon/plugin dependent paths were checked
- [ ] Export preset/template path was validated
- [ ] Highest-risk regression path was re-checked
- [ ] Evidence captured for failures and recoveries

## Rollback considerations

- Recommended branch / tag / checkpoint approach:
- What should trigger rollback immediately:
- What can be fixed in-place without rolling back:
- Whether rollback is step-local or full-plan:
- Evidence to keep for diffing old vs new behavior:
- Follow-up decision after rollback:
