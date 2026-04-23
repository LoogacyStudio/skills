---
name: test-strategy-review
description: "Use when a Godot/.NET task needs a Layer 4 overlay validation plan for a feature, bug fix, refactor, migration, or UI change, and the agent must separate pure .NET tests from Godot runtime-dependent coverage, prioritize the highest-risk paths first, and return a minimal test matrix plus regression guidance."
---

# Test Strategy Review

Use this skill when a Godot 4.6 + .NET/C# project needs a realistic test strategy before or alongside implementation.

This skill is for deciding **what to test first, what can stay in pure .NET, what must run inside Godot, and what minimal regression coverage is worth the cost**.

It does **not** exist to dump a giant wish list or teach one specific test framework. Its job is to turn a change into a focused, layered, cost-aware validation plan.

Prefer this skill when the main deliverable is a bounded validation plan, even if some scene or seam context matters. If the request truly needs a combined architecture + UX review artifact, that is a different route.

## Purpose

This skill is used to:

- identify the most valuable tests for a feature, system, migration, or fix
- separate pure logic tests from Godot runtime-dependent tests
- determine when scene, integration, UI, smoke, and regression checks are justified
- produce a minimal test matrix with explicit priorities
- recommend a regression strategy that matches risk instead of fantasy land coverage

## Use this skill when

Invoke this skill for tasks such as:

- new gameplay or tool feature planning
- runtime architecture changes
- scene wiring or signal-heavy behavior changes
- migration or upgrade validation planning
- UI flow or interaction changes
- bug fix verification planning
- deciding whether a testing request should stay in pure .NET or move into Godot runtime

### Trigger examples

- "What should I test first for this Godot feature?"
- "Which parts can stay in pure C# tests and which must run in runtime?"
- "How should I do smoke and regression checks for these scenes after the upgrade?"
- "What tests are worth adding for this UI flow change?"
- "Give me a minimal test matrix instead of testing everything"

## Do not use this skill when

Do not use this skill when:

- the user already knows the exact tests to write and wants implementation only
- the project already uses GoDotTest and the main need is framework-specific runtime test implementation, setup, debugging, or coverage guidance — use `godot-godottest`
- the task is a framework-specific testing tutorial
- the user only wants a tool recommendation list
- there is no meaningful change surface to analyze
- the output would just be "test everything" with no prioritization

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**

Why this fit is better than the alternatives:

- the skill must produce a repeatable, structured testing strategy and test matrix
- it also packages reusable heuristics for Godot/.NET test-layer selection and cost-aware prioritization
- a full Pipeline would add ceremony without enough value, because the required order can live directly in the workflow
- an Inversion-first flow is optional, not primary, because the required job is usually clear once the change and risk surface are known

## Test layers this skill must consider

Every result must consider the following layers, even if some are intentionally skipped:

1. **pure C# logic tests**
2. **Godot runtime-dependent tests**
3. **scene / integration tests**
4. **UI / flow / interaction validation**
5. **smoke tests**
6. **regression checks**

If a layer is not recommended, say **why it is unnecessary right now** instead of silently omitting it.

## Inputs

Collect or infer these inputs when available:

- feature, bug fix, migration, refactor, or UI change summary
- affected systems, scripts, scenes, nodes, signals, resources, and data paths
- what changed recently and what is expected to keep working
- player-facing or business-facing impact if the change breaks
- whether the logic can run without engine state, scene tree, timing, rendering, physics, or signals
- known fragile areas, previously broken flows, and upgrade-sensitive scenes
- release pressure or testing budget if relevant

If some inputs are missing, do not block on perfect detail. Infer a sensible first-cut strategy and call out the assumptions that matter.

## Workflow

Follow this sequence every time.

### 1. Identify the change type and failure surface

State what kind of change is being reviewed.

Choose one primary type:

- feature addition
- bug fix
- refactor
- migration / upgrade
- scene wiring change
- UI / flow change
- cross-cutting architecture change

Then state the main failure surface in plain language.

Examples:

- deterministic combat math changed
- node lookup and signal flow changed
- scene composition or resource loading changed
- editor tool behavior changed
- migration may break startup or key scenes

Do not start from test types. Start from what can fail.

### 2. Split non-runtime logic from runtime-dependent behavior

For each important behavior, decide whether it belongs to one of these buckets:

- **pure logic** — deterministic rules, transformations, validation, mapping, calculations, state transitions that do not need engine-owned objects or scene lifecycle
- **runtime-dependent** — behavior that depends on Node lifecycle, scene tree presence, signals, timing, physics, resource loading, input routing, rendering state, or engine callbacks
- **mixed** — logic core is pure, but orchestration depends on runtime wiring

Rules:

- push testable business or rule logic down into pure logic coverage when possible
- keep runtime tests for engine behavior, wiring, and integration assumptions
- when runtime tests create Godot `Node` instances that never enter the `SceneTree`, plan teardown with `Free()` instead of relying on `QueueFree()` alone
- call out mixed areas explicitly so the strategy can split them instead of testing everything at the highest-cost layer

### 3. Assess risk, fragility, and player impact

Rank the most important targets using these signals:

- how often the path is used
- how badly it hurts if it breaks
- how likely the change is to introduce regressions
- whether the area has failed before or is historically fragile
- whether migration or upgrade work makes the area especially volatile
- whether the verification cost is cheap, moderate, or expensive

Always optimize for **signal per test**, not test count.

Priority heuristics:

- test the most fragile paths first
- test high-impact player-facing flows before edge-case polish
- test upgrade-sensitive startup, load, and core progression paths early
- prefer a small number of decisive tests over broad low-signal coverage

### 4. Choose the minimum useful layer coverage

Recommend the smallest combination of test layers that can give confidence.

At minimum, evaluate each of the six layers and mark one of:

- **must have now**
- **nice to have later**
- **skip for now**

Decision guidance:

- use **pure C# logic tests** for deterministic rules and fast feedback
- use **Godot runtime-dependent tests** when behavior depends on engine-managed lifecycle or callbacks
- use **scene / integration tests** when the main risk is object wiring, resource connections, or multi-object interaction
- use **UI / flow / interaction validation** when the change is experienced through menus, prompts, transitions, or player-driven sequences
- use **smoke tests** to prove the critical path still boots, loads, and reaches the expected baseline state
- use **regression checks** to protect the path most likely to break again, especially after upgrades, refactors, or bug fixes

If runtime-dependent coverage is **must have now** and the project already uses **GoDotTest**, say so explicitly and point the implementation phase to `godot-godottest` for suite scaffolding, scene wiring, CLI/debug setup, or coverage execution details instead of inventing generic framework guidance.

If the proposed runtime coverage creates helper or fixture nodes outside the tree, call out cleanup explicitly: nodes that never enter the `SceneTree` should be torn down with `Free()`, because `QueueFree()` alone depends on tree-driven deferred processing.

### 5. Produce the final strategy and minimal test matrix

Return the strategy using `assets/test-matrix.md`.

The result must:

- include only the most meaningful target areas
- show whether Godot runtime is required
- give minimal cases rather than exhaustive suites
- include regression priority
- stay concrete enough that another agent can turn it into tests or manual checks
- keep the short narrative sections aligned with the matrix instead of repeating it loosely

Do not produce a giant backlog unless the user explicitly asks for a full plan.

### 6. Recommend execution priority

After the matrix, give a short ordered list of what to validate first.

The priority order should usually resemble:

1. cheap, high-signal pure logic checks
2. runtime or scene checks for the most fragile wiring
3. one or two critical smoke paths
4. focused regression checks for previously broken or upgrade-sensitive paths
5. lower-value UI or edge-path coverage later

If the situation differs, explain why.

### 7. Define regression strategy

Recommend a regression plan that matches the change type.

Examples:

- for bug fixes: protect the exact failing case and one nearby variant
- for migrations: smoke the startup path, core scenes, save/load or config path, and the most version-sensitive interactions
- for UI changes: verify the happy path, one interruption path, and one state persistence path
- for architecture changes: protect the public seam plus the most important integrated flow

Keep regression scope narrow and intentional. The goal is to catch repeat breakage, not to rebuild QA from scratch.

## Output contract

Return the result using `assets/test-matrix.md` in this section order:

- `Change summary`
- `Risk and failure surface`
- `Runtime vs non-runtime split`
- `Recommended layer coverage`
- `Priority order`
- `Minimal test matrix`
- `Regression strategy`
- `Assumptions and skips`

Output rules:

- be explicit about what should be tested first
- distinguish required runtime coverage from optional runtime coverage
- justify every expensive test layer
- mention skipped layers when relevant and say why they are skipped
- prefer a few high-value cases over exhaustive wish lists
- keep the matrix and surrounding sections aligned so another agent can execute the plan without guessing the missing narrative

## Cost-awareness rules

This skill must never default to "test everything".

Always answer these questions, explicitly or implicitly:

- what is the most fragile part?
- what is the highest-risk path?
- what hurts players or users the most if broken?
- what is most likely to explode after a migration or upgrade?
- what is the cheapest test that gives strong confidence?

If two testing approaches cover similar risk, prefer the cheaper one.

If a pure logic test can protect the real failure mode, do not force it into runtime just because runtime exists.

If runtime coverage is unavoidable, keep it focused on the exact engine-dependent behavior.

## Companion files

- `references/testing-notes.md` — guidance for separating pure logic from runtime-dependent coverage, defining scene/integration boundaries, validating UI changes, and planning migration smoke/regression
- `assets/test-matrix.md` — reusable template for the final test strategy and matrix output

## Validation

A good result should satisfy all of the following:

- the change type and failure surface are clearly identified
- pure logic and runtime-dependent behavior are separated
- all six test layers are considered, even if some are skipped
- the result prioritizes high-risk, high-impact paths first
- the matrix is minimal, concrete, and cost-aware
- regression guidance is specific to the change, not generic filler
- the output helps another agent decide what to automate, what to run in runtime, and what to smoke manually

## Common pitfalls

- recommending every possible test type with no prioritization
- forcing engine-dependent coverage onto logic that could be tested purely
- ignoring scene wiring or signal behavior because the code "looks simple"
- treating smoke tests as optional after migrations or risky refactors
- listing UI validation vaguely without identifying the key player flow
- writing a framework tutorial instead of a strategy review

## Completion rule

This skill is complete when the agent has:

- identified the change type and the likely failure surface
- separated pure logic, runtime-dependent, and mixed behaviors
- decided which test layers are must-have, later, or skipped
- produced a minimal test matrix with clear priorities
- recommended a regression strategy tied to actual risk and cost
- avoided the trap of "everything is important"
