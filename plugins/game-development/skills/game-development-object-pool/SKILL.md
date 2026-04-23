---
name: game-development-object-pool
description: "Use when a cross-engine gameplay task needs a Layer 2 shared-runtime performance review for spawn/despawn churn, GC spikes, or short-lived reusable objects, and the agent must decide whether pooling is truly justified before introducing reuse infrastructure."
---

# Game Development Object Pool

Use this skill when repeated creation and destruction of short-lived objects is causing measurable hot-path churn and the real question is whether reuse infrastructure is justified, bounded, and safe.

This skill is for reviewing or designing pooling boundaries without turning pooling into a default architecture. Its job is to prove the hot path exists, define a safe reset contract, choose the smallest ownership boundary, and return a practical implementation and verification brief another agent can apply incrementally.

If the engine is unspecified, keep the recommendation engine-agnostic first. Do not assume Godot `Node` lifecycle, Unity `GameObject` pooling, or ECS-specific reuse patterns until the target runtime is explicit.

For engine-facing lifecycle, signal, timer, and resource-sharing details, see `references/godot-reference.md`.

## Purpose

This skill is used to:

- determine whether pooling is justified at all
- identify which object types are worth pooling and which are not
- define ownership boundary, API, exhaustion behavior, and reset rules explicitly
- keep engine lifecycle hazards visible instead of hidden inside reuse infrastructure
- return a concrete rollout and benchmark plan

## Use this skill when

Use this skill when you see one or more of these signals:

- frequent spawn/despawn cycles for short-lived objects
- GC spikes or allocation churn during gameplay
- frame drops when many identical objects appear at once
- systems such as bullets, hit VFX, floating damage numbers, enemy spawn waves, or recycled UI rows/cards
- repeated `Instantiate` / `QueueFree` style churn in a hot path
- the user explicitly mentions optimization, too many instantiate/destroy calls, lag when spawning, GC spikes, or pooling

### Trigger examples

- "We get frame drops when many bullets spawn at once"
- "Should these floating damage numbers use pooling?"
- "This VFX spam causes GC spikes during combat"
- "Please review whether pooling is actually justified here"

## Do not use this skill when

Do not use this skill when:

- object count is small or infrequent
- the object has complex external state that is expensive or unsafe to reset
- profiling shows no meaningful CPU, allocation, or GC problem
- the lifecycle is too irregular to estimate capacity sanely
- engine-native reuse already solves the problem
- pooling would create a global mutable dependency for unrelated systems

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start here only after there is measured churn; if the real issue is scene or subsystem ownership of reused objects, pair early with `game-development-coordinator`.
- Pair with `game-development-entity-reference-boundary` when pooled reuse makes direct references, IDs, handles, or delayed callbacks unsafe across object lifetimes.
- Pair with `game-development-state-change-notification` when acquisition and release should invalidate caches, refresh observers, or suppress stale UI/gameplay listeners.
- Pair with `game-development-time-source-and-tick-policy` when pooled objects carry timers, cooldown windows, delayed release, or cadence-sensitive reset logic.
- Hand off to `game-development-command-flow` when pooled objects are only one piece of a larger queued action or spawn-dispatch surface.
- Hand off to engine-specific lifecycle references once the pool boundary is justified and the remaining risk is runtime lifecycle correctness rather than pooling fit.

## Diagnostic checklist

| Question | Good sign for pooling | Warning sign |
|---|---|---|
| Creation frequency | High and repeated | Rare or incidental |
| Lifetime | Short and bounded | Long-lived or highly variable |
| Reset complexity | Small and deterministic | Order-sensitive or leaky |
| Capacity estimate | Reasonably predictable | Unknown or wildly unstable |
| Profiling evidence | Clear hot-path churn | No measurable bottleneck |

## Decision rules

### Prefer pooling when

- reuse is frequent
- allocation/free cost is visible in profiling
- object behavior is standardized enough to reset safely
- pool size can be estimated or capped
- the hot path is local to a scene or subsystem

### Avoid or limit pooling when

- usage is too sparse to justify complexity
- object state crosses too many boundaries
- reset logic is more error-prone than the original allocation cost
- pooling would hide design problems instead of fixing them

### Partial strategy

Pool only the hot-path objects first.

Do not globalize pooling prematurely. Prefer the smallest ownership boundary that matches the reuse pattern:

- scene-local
- system-local
- shared service only when clearly justified

Before recommending pooling, also consider whether the simpler answer is:

- reducing spawn frequency
- batching or effect consolidation
- using engine-native virtualization or reuse already present
- caching plain data while leaving object lifecycles alone

## Workflow

1. Confirm the symptom with profiling or a reproducible hot path.
   - Capture baseline frame time
   - Note spike frequency
   - Check allocation / GC evidence
   - Record peak concurrent active object count

2. Identify candidate object types.
   - short-lived reusable
   - long-lived but stable
   - not worth pooling

3. Define pool boundary.
   - per scene
   - per gameplay system
   - shared service only if multiple consumers truly need the same lifecycle rules

4. Define the pool API.
   Typical surface:
   - `Get()`
   - `Release()`
   - `Prewarm(count)`
   - exhaustion policy (`expand`, `fallback instantiate`, or `drop request`)

5. Define lifecycle hooks.
   - `OnAcquire`
   - `OnRelease`
   - `ResetState`

6. Write the reset contract before implementation.
   Review at minimum:
   - transform / position / rotation / scale
   - visibility and z-order
   - velocity / movement state
   - timers / tweens / animation state
   - collision and hitbox state
   - text / UI content
   - signal or event subscriptions
   - async / cancellation state
   - parent attachment / process mode / layer or canvas state

7. Integrate with the target engine safely.
   - identify which object lifecycle rules are engine-native and which are app-owned
   - prefer explicit activation/deactivation over magical hidden reuse
   - avoid duplicate event or signal connections on reuse
   - keep world-space and UI-space lifecycles separate
   - if the task is Godot-specific, use `references/godot-reference.md` for scene-tree and signal details

8. Add safety checks.
   - double-release guard
   - missing-release detection
   - pool exhaustion behavior
   - debug counters or structured logging where helpful

9. Re-profile with the same scenario.
   Keep the pool only if the gain is measurable and the lifecycle remains understandable.

## Output contract

Return the result using `assets/object-pool-brief.md` in this section order.

When using this skill, return these sections:

1. **Candidate analysis**
2. **Pool design**
3. **Reset contract**
4. **Engine integration notes**
5. **Migration steps**
6. **Benchmark plan**

## Engine-specific notes

### Godot / .NET

- `Node` lifecycle safety matters more than clever pooling.
- Reused nodes can leak state through:
  - signals
  - child nodes
  - tweens
  - animation state
  - stale parent attachment
  - pending async callbacks
- For UI recycling, verify:
  - text
  - focus
  - bindings
  - visibility
  - layout assumptions
- For gameplay recycling, verify:
  - transform
  - collision
  - process state
  - timers
  - callbacks
- If pooling removes GC spikes but makes behavior nondeterministic, the design is not done yet.
- Use `references/godot-reference.md` when you need concrete guidance on `_Ready()` vs `_EnterTree()`, `RequestReady()`, release strategies, async ghost callbacks, or shared-resource contamination.

If the target runtime is not Godot/.NET, translate these notes into the equivalent lifecycle and ownership model instead of copying Node-specific advice verbatim.

## Common pitfalls

- pooling everything blindly
- adding a global pool before identifying a hot path
- missing one reset responsibility and leaking state across uses
- allowing unbounded growth with no visibility
- mixing unrelated lifecycles in one pool
- keeping pooling after measurements show no material win

## Companion files

- `assets/object-pool-brief.md` — reusable output template for returning the pooling implementation or review artifact
- `references/godot-reference.md` — Godot-specific lifecycle, signal, timer, async, and resource-sharing cautions for pooled nodes

## Validation

A good result should satisfy all of the following:

- simpler non-pooling alternatives were considered first
- pooling candidates were justified by evidence, not instinct
- reset rules and ownership boundaries are explicit enough to review
- exhaustion behavior is defined
- before/after verification is included
- the proposed pooling keeps the codebase understandable

## Completion rule

This skill is complete when the agent has:

- decided whether pooling is justified at all
- identified what should and should not be pooled
- defined the ownership boundary, API, exhaustion behavior, and reset contract
- described engine lifecycle and integration risks clearly
- returned a concrete migration and benchmark plan
