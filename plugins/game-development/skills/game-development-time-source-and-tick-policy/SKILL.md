---
name: game-development-time-source-and-tick-policy
description: Use when gameplay, AI, interaction, or runtime systems are accumulating ad-hoc timer logic, update cadence assumptions, cooldown clocks, pause rules, or frame-vs-fixed-step decisions, and the agent must define or review a reusable time-source and tick policy with explicit ownership, sampling cadence, drift handling, pause and scaling semantics, and observability boundaries.
---

# Game Development Time Source and Tick Policy

Use this skill when the hard part is not behavior architecture or event routing alone, but **how time is sourced, sampled, advanced, paused, scaled, and interpreted without every subsystem quietly inventing its own private clock law**.

This skill is for designing, reviewing, or refactoring a reusable time policy in gameplay, AI, interaction, cooldown, timer, and update-heavy systems. Its job is to define where authoritative time comes from, which systems sample or advance it, when work runs per frame versus fixed step versus event-driven cadence, how cooldowns and reevaluation intervals are expressed, and how drift or pause behavior stays understandable enough to debug and review.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot process modes and timers, Unity update loops, or equivalent framework scheduling constraints.

For reusable timing shapes, cadence heuristics, and clock-boundary cautions, see `references/timing-shapes.md`.

## Purpose

This skill is used to:

- determine whether a reusable time-source or tick policy is justified at all
- define the boundary between one local timer choice and shared timing semantics
- choose frame, fixed-step, event-driven, or sampled-clock models deliberately
- make cooldown, reevaluation, pause, scaling, and drift rules explicit enough to review
- return a structured time-policy design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- several systems use timers or cooldowns but disagree on what clock they mean
- gameplay logic keeps assuming `every frame` without a named cadence policy
- AI, UI, pooling, and runtime execution all need clearer reevaluation intervals
- a team needs to separate authoritative time sources from convenience sampling helpers
- requests that explicitly mention `tick`, `update cadence`, `timer`, `cooldown`, `fixed step`, `delta time`, `pause`, `time scale`, or `reevaluation interval`

### Trigger examples

- "Our cooldowns work, but every system seems to count time differently"
- "Should this logic run every frame, on a fixed step, or only when state changes?"
- "How do we define pause and time-scale behavior so timers stop drifting?"
- "We need one clear policy for AI reevaluation instead of each behavior polling however it wants"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing behavior architecture, command flow, or event topology; use the narrower skill first
- one local timer decision is already sufficient and no shared timing contract is needed
- the task is primarily resource spend, reservation, or rollback behavior rather than cadence semantics
- the task is primarily world-fact freshness or observation truth rather than time-source policy
- the task is a localized runtime bug investigation rather than time-policy design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Reviewer**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if the bigger uncertainty is still which control model owns reevaluation at all.
- Pair with `game-development-state-change-notification` when the design should stop polling and move toward meaningful invalidation or state-change-driven updates.
- Pair with `game-development-world-state-facts` when the real disagreement is freshness, staleness, or observation validity rather than the clock itself.
- Pair with `game-development-resource-transaction-system` when reservation windows, cooldown-spend interactions, or delayed commit semantics depend on shared time rules.
- Hand off to `game-development-utility-ai`, `game-development-fsm`, `game-development-behavior-tree`, or `game-development-object-pool` once the clock and cadence policy are clear and the next question is subsystem behavior.

## Diagnostic checklist

Evaluate these questions before recommending or refining a time policy:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared timing pressure? | Several systems depend on the same cadence or clock semantics | One local timer is being over-abstracted |
| Is the time source explicit? | The authoritative clock can be named clearly | Callers read whatever time value is nearby |
| Does cadence materially affect behavior? | Polling, fixed-step, and event-driven choices lead to different outcomes | Cadence is treated as an implementation afterthought |
| Are pause and scaling rules defined? | The team can explain what pauses, what scales, and what ignores scaling | Some timers stop, some do not, and nobody knows why |
| Are cooldown semantics stable? | Cooldowns share a named clock and evaluation rule | Each caller reinvents its own elapsed-time math |
| Is drift observable? | The system can explain late, skipped, or desynced updates | Timing errors show up as vague flakiness |

## Decision rules

Before recommending a reusable time policy, ask whether the smaller honest answer is:

- one local timer choice at a legitimate call site
- one scheduler or loop decision already owned by a specific subsystem
- one cooldown rule that does not need a shared clock contract
- one world-fact freshness or sensing problem rather than a timing problem
- one engine-specific integration concern rather than a cross-system time policy

Reject a shared timing layer if it mostly renames one obvious timer without improving consistency, debuggability, or cross-system coordination.

### Prefer a local timer decision when

- the timing rule is simple and used in one place
- there is no shared cooldown, reevaluation, or pause contract to preserve
- abstraction would mostly hide an obvious delay or interval

### Prefer frame-driven cadence when

- the logic is lightweight and naturally tied to presentation or immediate responsiveness
- slight variance per frame is acceptable
- there is no strong need for deterministic step boundaries

### Prefer fixed-step cadence when

- the design needs stable simulation intervals or consistent step boundaries
- gameplay meaning changes if frame rate changes materially
- cooldown or accumulation logic would become misleading under variable sampling

### Prefer event-driven or state-change-driven cadence when

- reevaluation only matters after meaningful state transitions
- polling every frame would mostly waste work or hide ownership
- the design benefits from explicit invalidation rather than constant checking

### Prefer sampled-clock semantics when

- several systems need a common notion of elapsed time without sharing the same update loop
- cooldowns, delayed actions, or AI reevaluation all read from one named clock
- pause or scaling behavior must be explained independently of how each consumer runs

### Escalate to adjacent foundations when

- the real issue is resource reservation or commit timing rather than cadence policy
- the real issue is stale world observations rather than clock ownership
- the real issue is condition composition rather than when rules are reevaluated

## Workflow

Follow this sequence every time.

### 1. Identify the timing boundary

State what time-related question the system is trying to answer before naming loop APIs, timers, or engine callbacks.

Examples:

- which clock a cooldown should use
- how often AI should reevaluate
- whether an update belongs to frame, fixed-step, or event-driven cadence
- what should pause, scale, or continue while paused

### 2. Separate time sources from time consumers

For each important path, specify:

- authoritative time source
- who advances or owns that source
- who samples it read-only
- whether multiple clocks exist and why
- how callers know which clock they are using

### 3. Define cadence and sampling rules

For each important system, decide whether work is:

- frame-driven
- fixed-step
- event-driven
- sampled on demand
- batched or rate-limited

Specify what makes that choice appropriate.

### 4. Define cooldown, delay, and reevaluation semantics

Specify:

- what clock cooldowns use
- whether elapsed time is scaled or unscaled
- whether reevaluation is interval-based, event-driven, or hybrid
- how delayed actions or pooled-object resets measure time

### 5. Define pause, slow-motion, and time-scale policy

Specify:

- what pauses
- what ignores pause
- what respects global time scale
- whether some subsystems use unscaled time intentionally
- how pause and resume affect pending timers or cooldowns

### 6. Define drift, desync, and catch-up policy

Specify:

- what counts as acceptable drift
- whether late updates are skipped, caught up, or clamped
- how long frames or missed ticks are handled
- how the system distinguishes timing lag from logic failure

### 7. Define observability and debugging expectations

Specify:

- what minimum timing traces or debug views are needed
- whether cooldown or reevaluation state is inspectable
- how reviewers can tell which clock a system is using
- what evidence helps confirm timing consistency across systems

### 8. Separate timing policy from adjacent concerns

Clarify what stays outside the time policy, such as:

- full behavior architecture choice
- resource-spend or rollback semantics
- world-fact truth ownership
- network replay or deterministic lockstep in full
- engine-specific scheduler tutorials

### 9. Plan the rollout

Migrate incrementally: isolate one repeated cooldown or reevaluation family, name the clock boundary, define cadence rules, add pause and drift policy, replace divergent callers gradually, and verify before widening the timing surface.

## Output contract

Return the result using `assets/time-policy-template.md` in this section order.

If the best answer is **not** a reusable time policy, still use the template and say that explicitly instead of wrapping one honest timer choice in temporal pageantry.

Return the result in these sections:

1. **Timing boundary**
2. **Local timer vs shared time policy decision**
3. **Time source and ownership model**
4. **Cadence and sampling design**
5. **Cooldown, delay, and reevaluation model**
6. **Pause, scaling, and drift policy**
7. **Observability and debugging notes**
8. **Related foundations and handoff notes**
9. **Engine integration notes**
10. **Migration plan**
11. **Verification notes**

Keep the section order stable so time-policy recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Keep authoritative clock choice explicit instead of letting `_Process`, `_PhysicsProcess`, timers, and scene-tree pause behavior blur together.
- If some timers must keep running while paused, state that policy directly rather than hiding it inside node configuration.
- Be careful when pooled or transient nodes own timers; the lifetime of the node should not accidentally redefine global timing semantics.

### Unity

- Distinguish clearly between `Update`, `FixedUpdate`, coroutine delays, and any custom scheduler or tick service.
- Make unscaled versus scaled time choices explicit where pause menus, UI, or cooldowns differ.
- Avoid letting inspector-configured intervals imply a global cadence policy if the runtime ownership story is unclear.

### Generic C# / engine-neutral

- Prefer named clocks and cadence rules over magic numbers scattered through callers.
- Keep reevaluation policy explicit so systems do not silently drift from event-driven to polling behavior.
- Use structured timing diagnostics only where they materially improve reviewability or runtime debugging.

## Common pitfalls

- abstracting one local timer into a shared timing framework with no reuse benefit
- letting every subsystem sample a different clock without naming the difference
- assuming `every frame` is automatically the right cadence for gameplay logic
- mixing scaled and unscaled time without policy clarity
- hiding pause behavior inside engine defaults nobody has documented
- making cooldown math differ between UI preview, AI evaluation, and runtime execution
- treating drift and missed ticks as mysterious flakiness instead of defined policy questions
- expanding a time-policy skill into a full determinism or networking doctrine too early

## Companion files

- `references/timing-shapes.md` — reusable heuristics for time-source choice, cadence boundaries, pause semantics, drift handling, and abstraction cautions
- `references/cooldown-and-reevaluation-guide.md` — reusable review guide for cooldown clocks, interval reevaluation, state-change triggering, and hybrid timing models
- `assets/time-policy-template.md` — reusable output template for returning the time-policy design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-timer alternative was considered first
- the timing boundary is explicit
- authoritative time sources and consumers are distinguishable clearly
- cadence, cooldown, and reevaluation rules are concrete enough to review
- pause, scaling, and drift behavior are stated explicitly
- observability and debugging expectations are addressed where relevant
- rollout steps are incremental enough to verify safely
- the design does not quietly expand into resource semantics, world-fact ownership, or full networking determinism by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable time policy is justified at all
- identified the timing boundary and authoritative clock model
- defined cadence, cooldown, reevaluation, and pause semantics
- specified drift handling, observability, and debugging expectations
- described engine integration notes where relevant
- returned a concrete migration and verification brief
