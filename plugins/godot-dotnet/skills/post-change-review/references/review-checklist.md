# Post-Change Review Checklist

Use this checklist when reviewing whether a broad Godot/.NET implementation is truly ready to be treated as complete.

The goal is not to force every change through the same bureaucracy. The goal is to catch the common false-done patterns that appear after large refactors, multi-file implementations, and cross-layer feature work.

## 1. Change surface and claimed completion

Check that you can answer all of these clearly:

- What changed?
- Why did it change?
- What does the author or task currently claim is complete?
- Which surfaces were definitely touched?
- Which nearby surfaces were likely affected even if not edited directly?

Warning signs:

- the review cannot state the change in one or two sentences
- “done” means different things in different notes or files
- broad behavior changed but only one local file is being discussed
- the implementation summary avoids saying what still depends on manual knowledge

## 2. Boundary and ownership health

Review whether the post-change structure actually improved or at least stayed coherent.

Check:

- which scene, script, service, or autoload now owns each main responsibility
- whether old and new owners overlap awkwardly
- whether UI/gameplay/tool/service seams became clearer or more muddled
- whether the change introduced new broad cross-layer dependencies
- whether temporary adapters or compatibility shims now behave like permanent architecture

Warning signs:

- logic moved files but not ownership
- the old seam still partially drives behavior
- one new coordinator became the dumping ground for all change fallout
- the change is “modular” only because complexity was redistributed, not reduced

## 3. Godot engine and lifecycle fit

Review whether the implementation still fits the engine cleanly.

Check:

- node lifecycle assumptions (`_Ready`, deferred setup, freed-node safety, ordering)
- signal connection/disconnection ownership and event flow clarity
- node-path, exported-field, and inspector-driven configuration assumptions
- resource loading, scene loading, and serialized data expectations
- test-harness cleanup for nodes that never enter the `SceneTree`; these should use `Free()` instead of relying on deferred `QueueFree()` cleanup
- tool scripts, autoloads, input routing, timing, async, or physics seams touched by the change

Warning signs:

- setup now depends on hidden editor state or scene-tree order knowledge
- exported fields or resources changed but no one checked downstream scenes
- signals were rerouted but ownership is harder to follow than before
- runtime correctness now depends on fragile timing or implicit scene presence
- tests or fixtures leave off-tree nodes pending because cleanup assumes `QueueFree()` will run without scene-tree processing

## 4. Scene, resource, config, docs, and content sync

Review whether adjacent surfaces stayed aligned with the implementation.

Check:

- scene wiring and resource references still match the code path
- project config, input map, export settings, or setup instructions still match reality
- README, migration notes, editor setup notes, or usage docs still describe the new behavior
- localization strings, labels, tutorial prompts, or content data still match the new flow
- comments or internal notes have not become misleading after the refactor or feature change

Warning signs:

- the feature works only if someone remembers undocumented setup steps
- resource or config changes were made but not reflected in docs or operational notes
- user-facing text or content still describes the old interaction model
- scene or content references still point at legacy structure even though code moved on

## 5. Verification evidence and regression confidence

Review whether completion is supported by enough proof for the risk involved.

Check:

- whether the highest-risk changed path was actually exercised
- whether the evidence matches the real change scope
- whether the most likely nearby regression seam got at least one focused check
- whether smoke, runtime, manual, or automated evidence is specific instead of ceremonial
- whether there is one smallest missing proof that would materially raise confidence

Warning signs:

- "build passes" is treated as proof for a scene-heavy or flow-heavy change
- large architectural movement has no smoke or seam verification
- evidence covers the happy path only while the fragile seam stayed untested
- the review can see a clear regression risk but no one checked it

## 6. Readiness verdict discipline

Use a verdict that matches evidence.

Suggested verdicts:

- **Ready** — the change is coherent, sync surfaces look aligned, and evidence is proportionate
- **Nearly ready** — the change looks solid but one or two focused proof points or sync fixes are still missing
- **Not ready** — the change still has meaningful boundary, engine-fit, sync, or evidence gaps

Do not inflate confidence just because the implementation was large or expensive.

## 7. Follow-up action discipline

Good follow-up actions are:

- small
- high-signal
- directly tied to the review gaps
- enough to upgrade confidence without reopening the whole project

Bad follow-up actions are:

- giant rewrite wish lists
- generic cleanup chores not tied to the completion question
- “test more” with no target seam
- vague demands for better documentation with no missing audience or artifact named
