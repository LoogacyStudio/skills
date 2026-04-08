---
name: post-change-review
description: Use when a large refactor, multi-file implementation, or new feature in a Godot/.NET project needs a post-change review across layer boundaries, engine usage, docs or content sync, and verification evidence before the work should be treated as complete.
---

# Post-Change Review

Use this skill when a Godot 4.6 + .NET/C# project has already been changed and the next question is **whether the work is actually ready to call done**.

This skill is for reviewing the **post-change state** of a large refactor, multi-file implementation, or new feature. Its job is not to re-plan the feature from scratch or to give a generic code review. Its job is to inspect whether the change now holds together across **layer boundaries, Godot engine usage, docs or content sync, and verification evidence**.

Prefer this skill when the user wants a completion-minded review before claiming success, especially after a broad change where “it compiles” is not enough.

## Purpose

This skill is used to:

- review whether a completed or near-complete change has healthy boundaries after implementation
- check whether Godot engine usage and lifecycle assumptions still look sound
- detect missing synchronization between code, scenes, resources, docs, content, config, or user-facing behavior
- evaluate whether the provided verification evidence is strong enough for the claimed completion level
- return a structured review with readiness verdict, remaining risks, and the smallest follow-up actions

## Use this skill when

Invoke this skill for tasks such as:

- a large refactor that touched several scenes, scripts, services, or feature seams
- a multi-file implementation that crosses gameplay, UI, tools, resources, or configuration
- a new feature that now "works" but needs a post-change architecture and verification review
- a change where docs, content, migration notes, or editor-facing setup may have drifted from the implementation
- a pull request or implementation summary that claims completion and needs a last review pass grounded in architecture and evidence

### Trigger examples

- "This Godot refactor is done—can you check whether it's actually complete?"
- "This feature spans scenes, C#, and docs—did I miss any sync work?"
- "Give me a post-change review focused on layer boundaries and verification evidence"
- "Can this multi-file implementation reasonably claim done?"
- "Check this change for engine-usage, content-sync, and regression-evidence risks"

## Do not use this skill when

Do not use this skill when:

- the work has not been implemented yet and the user mainly needs design or planning guidance
- the task is only a narrow bug triage or one-file fix review
- the main ask is feature implementation rather than readiness review
- the problem is purely UX quality, art quality, or copy review with no architecture or verification question
- the user already knows the exact missing follow-up and only wants help doing it

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Tool Wrapper**, **Generator**

Why this fit is better than the alternatives:

- the job is primarily to evaluate an implemented change against explicit readiness criteria
- the skill also packages reusable Godot/.NET review rules for boundary health, engine usage, sync surfaces, and evidence quality
- the output should be a repeatable structured review report rather than loose commentary
- a full Pipeline would add unnecessary ceremony, because the review already has a clear ordered flow without non-skippable runtime stages

## Review dimensions that must be covered

Every review must explicitly assess the following areas, even if some are healthy:

1. **change surface clarity**
2. **layer and ownership boundary health**
3. **Godot engine and lifecycle usage**
4. **scene / resource / config / content sync**
5. **docs and operational sync**
6. **verification evidence and regression coverage**
7. **completion risk and readiness verdict**

If a dimension is not currently problematic, say so briefly instead of silently skipping it.

## Inputs

Collect or infer these inputs when available:

- the change summary in plain language
- the main files, scenes, scripts, resources, or systems touched
- what the author claims is finished
- relevant architecture seams or layer boundaries crossed by the implementation
- Godot-specific behaviors involved: scene tree, signals, autoloads, resources, export settings, input flow, editor tooling, lifecycle callbacks, async/timing, etc.
- docs, config, content, migration notes, or setup instructions that may need to stay in sync
- test results, smoke results, manual verification notes, screenshots, logs, or other evidence used to justify completion
- known limitations, TODOs, follow-up items, or intentionally deferred work

If some inputs are missing, do not block on perfect context. Infer the most likely change shape, call out the assumptions that affect the verdict, and keep the review scoped to observable evidence.

## Workflow

Follow this sequence every time.

### 1. State the change and the claimed done state

Summarize:

- what changed
- why it changed
- what “done” appears to mean for this task

Examples:

- a gameplay/UI refactor moved state ownership out of a HUD controller and now claims reduced coupling
- a new editor tool feature touched UI, command handling, and docs and now claims release readiness
- a migration-related implementation touched project config, runtime seams, and smoke notes and now claims safe completion

Do not review in a vacuum. Anchor the review in the claimed completion state.

### 2. Map the touched surfaces and likely drift surfaces

Identify the surfaces that changed or should have been reviewed together.

Examples:

- scenes, child scenes, and attached scripts
- gameplay, UI, service, or tool-layer boundaries
- signals, autoloads, exported fields, resources, and config
- content, localization, tutorial text, setup notes, README sections, migration notes, or operational docs
- smoke paths, regression seams, or manual verification checkpoints

Call out where drift is most likely: code vs scene wiring, config vs docs, feature behavior vs validation notes, or implementation vs user-facing content.

### 3. Review boundary health after the change

Inspect whether the implementation improved or worsened ownership and layer clarity.

Check for:

- responsibilities that moved but remain half-owned in old and new places
- refactors that reduced file size but not actual coupling
- new cross-layer dependencies that make future changes harder
- UI, gameplay, tool, service, or autoload seams that still look muddy
- “temporary” glue that now behaves like permanent architecture

The goal is not theoretical purity. The goal is to decide whether the post-change structure is coherent enough to support future work and verification.

### 4. Review Godot engine usage and lifecycle assumptions

Inspect engine-facing correctness and fit.

Check for:

- scene-tree or node-lifecycle assumptions that became more fragile after the change
- signal connection/disconnection health and event ownership clarity
- resource loading, exported fields, node-path assumptions, or inspector-driven configuration drift
- autoload, singleton, input, timing, physics, async, or tool-mode usage that now crosses layers awkwardly
- implementation choices that are technically valid but likely to create fragile runtime behavior or editor confusion

This is not a full bug triage. Focus on whether the change left risky engine-facing assumptions behind.

### 5. Check docs, content, config, and operational sync

Review whether surrounding surfaces stayed aligned with the implementation.

Examples to check:

- README or feature docs still matching the new workflow
- migration notes or setup steps matching new config or required resources
- editor setup, export settings, input map, or project config still reflecting the change
- localization strings, labels, tutorial prompts, placeholder text, or content data matching the new behavior
- comments or internal notes that now claim behavior the implementation no longer follows

Do not assume “docs sync” only means markdown files. In Godot projects, user-facing content and project setup are often part of the real completion surface.

### 6. Judge verification evidence and regression confidence

Review whether the claimed completion is supported by enough evidence.

Check for:

- targeted tests or smoke checks on the highest-risk path
- proof that the changed seam was exercised, not just compiled
- regression checks for the most likely nearby breakage
- gaps between the change scope and the evidence scope
- weak claims such as “should be fine” where one focused check was still needed

If evidence is light, do not automatically fail the work. Instead, explain what smallest missing proof would upgrade confidence.

### 7. Return the review report with a readiness verdict

Return the result using `assets/review-report.md`.

The review must:

- state what was changed and what completion claim is being evaluated
- describe the main post-change strengths and risks
- call out sync gaps across code, scenes, docs, content, config, or verification
- give a readiness verdict
- recommend the smallest useful follow-up actions before the work is treated as complete

## Output contract

Return the result using `assets/review-report.md` in this section order:

- `Change summary`
- `Touched surfaces`
- `Boundary and ownership review`
- `Engine usage review`
- `Docs, content, and config sync`
- `Verification evidence`
- `Completion risks`
- `Readiness verdict`
- `Recommended next step`

Output rules:

- tie findings to files, scenes, scripts, resources, docs, config, or explicit evidence when possible
- distinguish healthy areas from gaps instead of only listing problems
- keep the verdict grounded in evidence, not gut feeling
- prefer a small number of decisive follow-up actions over an endless backlog
- do not collapse the review into a generic PR summary or generic architecture lecture
- be explicit when the change is close to done but missing one or two proof points

## Godot/.NET post-change heuristics

- A refactor is not truly “done” if ownership only moved on paper but the old seam still leaks behavior.
- A feature is not truly “done” if scene wiring, exported settings, resource references, or lifecycle assumptions still depend on invisible setup knowledge.
- Docs or content drift matters when it changes how another developer, designer, or player understands the feature.
- Verification evidence should scale with risk: the broader the seam, the less acceptable “trust me” becomes.
- One high-signal smoke or regression check is often more valuable than a long list of vague validation claims.
- Completion review should separate **architecture health**, **engine-facing fit**, **sync discipline**, and **evidence quality** rather than blending them into one fuzzy impression.

## Companion files

- `references/review-checklist.md` — reusable completion-review criteria for boundaries, engine usage, sync surfaces, and evidence quality
- `assets/review-report.md` — reusable template for the final post-change review output

## Validation

A good review should satisfy all of the following:

- the change and claimed done state are stated clearly
- touched surfaces and likely drift surfaces are identified
- boundary health is reviewed after the implementation, not as abstract design commentary
- Godot engine usage and lifecycle assumptions are assessed explicitly
- docs, content, config, or operational sync is considered where relevant
- verification evidence is judged against the change scope
- the readiness verdict is explicit and justified
- recommended follow-up actions are small, concrete, and prioritized

## Common pitfalls

- treating compile success as proof of completion
- reviewing only code files while ignoring scenes, resources, config, or content drift
- calling a refactor “cleaner” without checking whether ownership actually improved
- assuming docs sync is irrelevant because the main change was technical
- accepting weak verification evidence for a broad cross-layer change
- turning the review into a giant rewrite wishlist instead of a completion-minded decision

## Completion rule

This skill is complete when the agent has:

- explained the implemented change and the claimed completion state
- mapped the touched and likely drift-prone surfaces
- reviewed layer boundaries, engine usage, sync surfaces, and evidence quality
- identified the main completion risks without exaggeration
- issued a clear readiness verdict
- recommended the smallest useful next steps before the work is treated as done
