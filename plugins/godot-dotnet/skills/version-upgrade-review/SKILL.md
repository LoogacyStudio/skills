---
name: version-upgrade-review
description: Use when a Godot/.NET project needs an upgrade plan that evaluates engine, SDK, C# compatibility, addons/plugins, export pipeline, verification, and rollback risk, then returns a staged sequence instead of a risky all-at-once migration.
---

# Version Upgrade Review

Use this skill when a Godot + .NET/C# project needs a **risk-aware upgrade plan** before changing versions.

This skill is for planning and reviewing upgrades, not for blindly editing every versioned file and hoping the build gods are in a good mood.

Its job is to:

- identify the upgrade type and blast radius
- classify the highest-risk areas before changes begin
- recommend a staged upgrade order rather than an all-at-once jump
- account for Godot, .NET SDK, C# compatibility, addons/plugins, and export pipeline implications
- define smoke, regression, and rollback thinking before execution starts

## Purpose

This skill is used to:

- review the current and target version state
- assess whether the upgrade is patch, minor, major, SDK, or export-chain affecting
- identify compatibility risks across engine, project files, packages, addons, and toolchain
- propose a practical upgrade sequence with validation gates
- produce an upgrade plan that includes verification checkpoints and rollback considerations

## Use this skill when

Invoke this skill for requests such as:

- planning a Godot engine upgrade
- moving to a new .NET SDK or target framework
- checking whether a C# language/runtime change is safe enough
- reviewing addon or plugin compatibility before migration
- validating whether export templates or export pipeline tooling may break
- deciding how to sequence upgrades across engine, SDK, packages, and export settings

### Trigger examples

- "幫我規劃 Godot 4.x 升級次序"
- "升 .NET SDK 前想知道風險同驗證點"
- "這次 upgrade 會唔會炸 addon / export？"
- "Godot + C# project 想升版，但不要一次升爆全部"
- "先升 engine 定先升 SDK？"

## Do not use this skill when

Do not use this skill when:

- the task is a known, tiny version pin change with no meaningful compatibility risk
- the user wants direct implementation only and the upgrade path is already approved
- the request is mainly about debugging a failure that already happened after the upgrade
- the task is general bug fixing with no version, toolchain, or migration scope
- the output would just repeat release notes without sequencing, validation, or rollback thinking

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**, **Reviewer**

Why this fit is better than the alternatives:

- the core job is to produce a repeatable structured upgrade plan
- the skill must also package reusable upgrade heuristics for Godot, .NET, C#, addons/plugins, and export chains
- the skill includes a review step that highlights high-risk areas before changes are recommended
- a full Pipeline is unnecessary because the required staged order can live directly in the workflow without extra ceremony

## Upgrade domains that must be covered

Every result must explicitly assess the following areas, even if some are low risk:

1. **Godot engine version**
2. **.NET SDK and project target changes**
3. **C# compatibility implications**
4. **addon / plugin compatibility**
5. **export pipeline implications**
6. **verification strategy**
7. **rollback / branch strategy**

If an area appears unaffected, say so briefly instead of silently skipping it.

## Inputs

Collect or infer these inputs when available:

- current Godot version and target Godot version
- current .NET SDK, target SDK, current target framework, and proposed target framework
- notable C# language or API compatibility constraints
- addon, plugin, NuGet package, and tool dependencies that may be version-sensitive
- current export targets, export templates, CI/export scripts, and distribution pipeline assumptions
- recent pain points, known fragile scenes, build steps, or platform-specific constraints
- desired risk appetite: conservative staged path vs faster migration path
- whether the user wants a planning artifact only or also wants follow-up implementation later

If the current or target state is materially missing, ask for the smallest missing version facts before finalizing the sequence.

## Workflow

Follow this sequence every time.

### 1. Confirm current state and target state

State the important version facts first.

At minimum, confirm:

- current engine/toolchain state
- target engine/toolchain state
- whether the move is patch, minor, major, SDK, target-framework, or export-chain affecting

Do not start recommending order before the source and destination are clear.

### 2. Classify the upgrade scope

Classify the change using one or more of these buckets:

- **patch** — bug-fix level version movement that still deserves verification
- **minor** — feature/behavior change with moderate compatibility risk
- **major** — migration-level change with meaningful API, tooling, or behavior risk
- **SDK / target** — .NET SDK, target framework, language version, or build toolchain movement
- **export chain** — export templates, platform exporters, CI packaging, signing, or deployment changes

Explain why the classification matters.

Do **not** assume a minor upgrade is painless. Minor releases are perfectly capable of creative mischief.

### 3. Map the risk areas

Review each required domain and identify the highest-risk seams.

Look for risks such as:

- Godot project format or editor behavior changes
- API shifts affecting C# code or generated bindings
- target framework support drift in SDK, NuGet packages, or IDE tooling
- nullable, language version, analyzer, or source-generator behavior changes
- addon/plugin version ranges, undocumented breakage, or maintenance gaps
- export preset, template, platform SDK, signing, and packaging drift
- CI or local environment mismatches between old and new toolchains

Separate **high-risk blockers** from **likely follow-up cleanup**. Do not frame every warning as a release blocker.

### 4. Propose a staged upgrade sequence

Recommend the safest practical order.

The sequence should usually favor:

1. branch and rollback preparation
2. baseline verification on the current version
3. the smallest foundational toolchain upgrade that unlocks later work
4. one major compatibility surface at a time
5. smoke verification after each step
6. regression checks on the most fragile paths before moving to the next step

If a combined step is acceptable, explain why it is safe enough.

The output must show **stepwise upgrade thinking**. Avoid all-at-once migrations unless the evidence strongly supports it.

### 5. Define smoke and regression checkpoints

For each meaningful step, recommend the smallest useful validation.

Cover at least:

- project open / import / editor startup
- restore / build / run
- one or more critical scenes or flows
- addon/plugin dependent paths
- export pipeline baseline for at least one important target
- any path known to be historically fragile

Prefer high-signal checks over giant wish lists.

### 6. Define rollback and branch strategy

Every plan must include rollback thinking.

At minimum, address:

- recommended branch or checkpoint structure
- when to tag or snapshot the pre-upgrade state
- what signals should trigger rollback vs continue with fixes
- whether rollback should be full, partial, or step-local
- how to preserve comparison evidence between old and new behavior

Do not plan upgrades as if failure is impossible.

### 7. Return the upgrade plan

Return the result using `assets/upgrade-plan.md`.

The plan should:

- summarize the current and target state
- classify the upgrade scope clearly
- identify the main risks
- recommend an ordered sequence
- include validation checkpoints
- include rollback considerations

## Output contract

Return the result using `assets/upgrade-plan.md` in this section order:

- `Current state`
- `Target state`
- `Upgrade scope`
- `Risk areas`
- `Recommended sequence`
- `Validation checklist`
- `Rollback considerations`

Output rules:

- prefer ordered steps over broad advice
- explicitly distinguish high-risk areas from lower-risk follow-up work
- do not recommend upgrading everything at once by default
- do not treat migration work as ordinary bug fixing
- do not stop at version numbers; always include validation and rollback thinking
- mention third-party dependencies explicitly when they materially affect risk
- keep the output staged and section-aligned so each upgrade step has an obvious validation and rollback context

## Upgrade heuristics

- Prefer **one major compatibility surface at a time** when risk is moderate or high.
- Confirm the **current baseline** before the first upgrade step so later failures have meaning.
- If engine and SDK changes are both significant, avoid moving both at once unless one is a hard prerequisite.
- Treat export and deployment as a separate compatibility surface, not as an afterthought.
- A green local build is not enough if editor import, addons, or export templates can still fail.
- If a dependency has unclear compatibility status, downgrade confidence and isolate that change.
- Resolve blockers first, warnings second, nice-to-have cleanup last.

## Companion files

- `assets/upgrade-plan.md` — reusable template for the final upgrade plan
- `references/migration-notes.md` — risk categories, pre-upgrade inventory prompts, addon/plugin and export-chain notes, and smoke test ideas

## Validation

A good result should satisfy all of the following:

- current and target states are explicit enough to reason about
- the upgrade type is classified correctly
- all seven upgrade domains are considered explicitly
- high-risk areas are identified and explained
- the sequence is staged rather than all-at-once by default
- validation checkpoints are tied to meaningful risk
- rollback thinking is concrete rather than ceremonial
- third-party dependencies are not ignored

## Common pitfalls

- assuming a minor upgrade is automatically safe
- collapsing Godot, SDK, addon, and export changes into one giant step
- treating migration work like an ordinary bug-fix patch
- planning only the version changes and forgetting verification
- ignoring third-party dependency compatibility or maintenance status
- trying to clear every warning before confirming the main upgrade path works
- having no branch, tag, or rollback checkpoint

## Completion rule

This skill is complete when the agent has:

- confirmed the current and target states
- classified the upgrade scope accurately
- identified the highest-risk compatibility areas
- proposed a staged upgrade order
- defined smoke and regression checks for the important steps
- included rollback and branch strategy thinking
- returned a structured upgrade plan rather than loose upgrade advice
