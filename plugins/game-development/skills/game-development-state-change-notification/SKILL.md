---
name: game-development-state-change-notification
description: "Use when a cross-engine gameplay task needs a Layer 1 foundation for change callbacks, invalidation signals, observer updates, or diff-vs-snapshot semantics, and the agent must define or review a reusable state-change notification model with explicit change boundaries, timing rules, payload shape, batching policy, and invalidation semantics."
---

# Game Development State Change Notification

Use this skill when the hard part is not behavior architecture or event routing alone, but **how systems announce meaningful state changes consistently without every subsystem inventing its own private notification folklore**.

This skill is for designing, reviewing, or refactoring a reusable state-change notification model in gameplay, AI, UI, observer, invalidation, and coordination-heavy systems. Its job is to define what counts as a meaningful change, when change notifications should fire, what payload they should carry, when diff data is better than snapshots, how batching and invalidation should work, and how consumers avoid drowning in noisy or semantically inconsistent updates.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot signals, Unity event channels, or equivalent framework notification surfaces.

For reusable notification shapes, payload heuristics, and abstraction cautions, see `references/notification-shapes.md`.

## Purpose

This skill is used to:

- determine whether a reusable state-change notification model is justified at all
- define the boundary between one local callback and shared change semantics
- choose timing, payload, diff, snapshot, batching, and invalidation rules deliberately
- make consumer expectations and notification meaning explicit enough to review
- return a structured state-change design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- several systems need to react to the same state changes but currently get notified inconsistently
- observers, UI, AI, or caches keep drifting because invalidation behavior is unclear
- a team needs to distinguish noisy internal mutations from externally meaningful state changes
- diff payloads, snapshots, or change tags are being improvised per caller
- requests that explicitly mention `state change`, `notification`, `invalidation`, `observer update`, `diff`, `snapshot`, `batching`, or `change events`

### Trigger examples

- "Should this system send diffs, full snapshots, or just invalidation pings?"
- "Our UI and AI react to the same changes, but not with the same timing"
- "How do we avoid event floods when several state changes happen in one burst?"
- "Nobody can explain which changes are worth notifying versus staying local"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing event topology, command flow, or behavior architecture; use the narrower skill first
- one local callback is already sufficient and no shared notification contract is needed
- the task is primarily truth ownership rather than change announcement semantics
- the task is primarily timing cadence rather than notification meaning or batching policy
- the task is a localized runtime bug investigation rather than notification-model design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-events-and-signals` if the main problem is publisher/subscriber topology, direct-call boundaries, or lifecycle wiring rather than notification meaning.
- Pair with `game-development-world-state-facts` when invalidation or update semantics are really about fact freshness, truth ownership, or blackboard drift.
- Pair with `game-development-time-source-and-tick-policy` when batching windows, deferred emission, or reevaluation cadence depend on explicit clock policy.
- Pair with `game-development-entity-reference-boundary` when change payloads carry handles, IDs, or references that must survive delayed consumption safely.
- Hand off to `game-development-utility-ai` or `game-development-coordinator` once shared change semantics are clear and the next question is how downstream systems react to them.

## Diagnostic checklist

Evaluate these questions before recommending or refining a state-change notification model:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared notification pressure? | Several consumers need the same change semantics | One local callback is being over-abstracted |
| Is the change boundary explicit? | The team can explain which changes are externally meaningful | Every mutation threatens to emit something |
| Are timing rules clear? | Consumers know when updates arrive relative to the change | Notification timing is implicit and caller-specific |
| Is payload meaning stable? | Diff, snapshot, or invalidation-only payloads have named semantics | Consumers guess what each payload means |
| Are batching and flood control deliberate? | Burst changes have explicit grouping or suppression rules | Notification spam is treated as normal |
| Is invalidation reviewable? | The system can explain who must refresh and why | Caches or observers quietly go stale with no clear trigger |

## Decision rules

Before recommending a reusable state-change notification model, ask whether the smaller honest answer is:

- one local callback at a legitimate boundary
- one subsystem-private invalidation hook
- one world-fact freshness problem rather than a notification problem
- one timing or reevaluation policy issue rather than a change-announcement issue
- one event-topology problem rather than payload or change-boundary semantics

Reject a shared notification layer if it mostly renames obvious callbacks without improving shared meaning, timing clarity, or consumer consistency.

### Prefer a local callback when

- the change is local and only one nearby consumer cares
- there is no need for shared payload or invalidation semantics
- abstraction would mostly hide one obvious owner and effect

### Prefer invalidation-only notifications when

- consumers only need to know that cached or derived state is no longer trustworthy
- the refreshed value is expensive or better resolved on demand
- sending full payload data would mostly duplicate authoritative reads

### Prefer diff payloads when

- consumers materially benefit from knowing what changed instead of re-reading everything
- change granularity matters for performance or behavior
- the system can explain diff semantics consistently

### Prefer snapshot payloads when

- consumers need a coherent post-change view
- diff logic would be more error-prone than a stable snapshot contract
- batching or consolidation makes a single full update clearer than several tiny deltas

### Prefer batching or coalescing when

- one logical update produces several low-level mutations
- notification bursts would otherwise create redundant work or noisy state churn
- consumers care about meaningful update windows rather than every microscopic step

### Escalate to adjacent foundations when

- the real issue is event routing topology rather than notification semantics
- the real issue is world-fact freshness rather than change payload meaning
- the real issue is time cadence rather than batching or invalidation boundaries
- the real issue is condition or scoring reevaluation rules rather than generic change signaling

## Workflow

Follow this sequence every time.

### 1. Identify the change boundary

State what change-related question the system is trying to answer before naming buses, signals, or observer lists.

Examples:

- which mutations deserve external notification
- whether consumers need a diff or a snapshot
- when caches or planners must invalidate derived state
- whether a burst of updates should coalesce into one meaningful change

### 2. Separate local mutations from meaningful external changes

List the important change families explicitly.

Typical categories:

- purely local internal mutations
- externally meaningful state changes
- invalidation-only changes
- batched or consolidated updates
- replay or audit-relevant changes, if any

### 3. Define timing and emission rules

Specify:

- when notifications fire relative to mutation
- whether notifications are immediate, deferred, frame-batched, or transaction-batched
- who owns emission timing
- whether consumers may observe intermediate states or only consolidated ones

### 4. Define payload shape and semantics

Specify:

- whether payloads are diffs, snapshots, tags, or invalidation notices
- what minimum fields consumers may rely on
- how absent, partial, or coalesced change data is represented
- what payloads should never carry

### 5. Define batching, suppression, and invalidation policy

Specify:

- when multiple changes collapse into one notification
- what redundant notifications may be suppressed
- how invalidation differs from full update notification
- who owns recomputation or refresh after invalidation

### 6. Define consumer expectations and debugging visibility

Specify:

- what consumers may assume about ordering and completeness
- how reviewers inspect notification timing and payload meaning
- what diagnostics classify dropped, coalesced, or noisy updates
- what evidence shows consumers are responding to the same change semantics

### 7. Separate state-change notification from adjacent concerns

Clarify what stays outside the notification model, such as:

- event routing topology in full
- world-fact ownership in full
- timing policy in full
- behavior architecture selection
- generic pub-sub frameworks as an end in themselves

### 8. Plan the rollout

Migrate incrementally: isolate one drifting change family, define meaningful change boundaries, choose diff or snapshot rules, add invalidation semantics, coalesce burst updates where needed, replace inconsistent consumers gradually, and verify before widening the notification surface.

## Output contract

Return the result using `assets/state-change-brief-template.md` in this section order.

If the best answer is **not** a reusable notification model, still use the template and say that explicitly instead of wrapping one honest callback in event theater.

Return the result in these sections:

1. **Change boundary**
2. **Local callback vs shared notification model decision**
3. **Notification timing and emission rules**
4. **Payload shape and diff-vs-snapshot policy**
5. **Batching, suppression, and invalidation rules**
6. **Consumer expectations and debugging notes**
7. **Related foundations and handoff notes**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so state-change recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Be explicit about whether a change signal is engine-facing UI glue, gameplay-facing semantic notification, or both.
- Do not let convenient signal emission points silently define the true change boundary for the whole system.
- Be careful when several node-level mutations happen in one frame but only one gameplay-meaningful change should be observed.

### Unity

- Distinguish clearly between local callbacks, event-channel patterns, and gameplay-level change semantics.
- Avoid making inspector-wired events the sole definition of payload meaning or batching policy.
- Be explicit when consumers should re-read authoritative state instead of trusting a serialized or convenience payload.

### Generic C# / engine-neutral

- Prefer named notification families and payload contracts over generic `OnChanged` events everywhere.
- Keep diff and snapshot semantics explicit so consumers do not guess at missing data.
- Use structured notification diagnostics only where they materially improve debugging or reviewability.

## Common pitfalls

- abstracting one local callback into a shared event framework with no reuse benefit
- treating every low-level mutation as a meaningful external change
- mixing diff, snapshot, and invalidation payloads without naming the semantics
- letting notification timing drift across callers with no clear contract
- flooding consumers with redundant updates instead of batching or coalescing
- hiding dropped or suppressed changes until caches or UI drift mysteriously
- turning a notification skill into a full event-topology doctrine or infrastructure obsession
- accidentally using notification payloads as the sole source of truth instead of a consumer aid

## Companion files

- `references/notification-shapes.md` — reusable heuristics for change boundaries, payload types, diff-vs-snapshot trade-offs, and abstraction cautions
- `references/invalidation-and-batching.md` — reusable review guide for invalidation semantics, batching, suppression, consumer refresh rules, and noisy-update handling
- `assets/state-change-brief-template.md` — reusable output template for returning the state-change design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-callback alternative was considered first
- the change boundary is explicit
- timing, payload, and invalidation semantics are distinguished clearly
- batching and suppression rules are concrete enough to review
- consumer expectations and debugging visibility are addressed where relevant
- rollout steps are incremental enough to verify safely
- the design does not quietly expand into world-facts, timing doctrine, or full event-topology architecture by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable notification model is justified at all
- identified the change boundary and notification families
- defined timing, payload, batching, and invalidation semantics
- specified consumer expectations and debugging visibility
- described engine integration notes where relevant
- returned a concrete migration and verification brief
