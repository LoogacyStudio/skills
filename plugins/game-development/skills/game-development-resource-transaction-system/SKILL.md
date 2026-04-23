---
name: game-development-resource-transaction-system
description: "Use when a cross-engine gameplay task needs a Layer 1 foundation for cost, spend, reservation, refund, or commit-and-rollback semantics, and the agent must define or review a reusable resource-transaction model with explicit ownership, affordability timing, reservation semantics, failure handling, auditability, and integration boundaries."
---

# Game Development Resource Transaction System

Use this skill when the hard part is not command dispatch or behavior choice alone, but **how gameplay resources are checked, reserved, spent, refunded, committed, or rolled back without every action path inventing a slightly different economy law**.

This skill is for designing, reviewing, or refactoring a reusable resource-transaction model in gameplay, AI, interaction, and action-heavy systems. Its job is to define where resource checks belong, when affordability is evaluated, when value is reserved versus immediately consumed, how failed or canceled actions affect resources, and how transaction outcomes stay consistent enough to review and debug.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot resources and node ownership, Unity ScriptableObject-driven data authoring, or equivalent framework constraints.

For reusable transaction shapes, reservation models, and commit-versus-rollback trade-offs, see `references/transaction-models.md`.

## Purpose

This skill is used to:

- determine whether a reusable resource-transaction model is justified at all
- define the boundary between one-off cost checks and shared transaction semantics
- choose immediate spend versus reservation versus staged commit deliberately
- make affordability timing, failure handling, and refund semantics explicit enough to review
- return a structured resource-transaction design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- several systems need to pay the same kinds of costs but currently check and spend resources differently
- gameplay actions need explicit rules for affordability, reservation, refund, or cancellation
- action flow, AI, UI, or interaction systems all touch the same resource types and keep drifting out of sync
- the team needs to separate `can pay`, `reserve`, `commit`, and `refund` semantics instead of collapsing them into one hidden helper
- requests that explicitly mention `cost`, `resource spend`, `reservation`, `refund`, `rollback`, `transaction`, `mana`, `stamina`, `charges`, or `affordability`

### Trigger examples

- "Our abilities all spend stamina a little differently and the rules keep drifting"
- "Should this system reserve resources before execution instead of paying up front?"
- "How do we handle refunds when an action is canceled after validation?"
- "We need shared cost semantics across UI previews, AI choices, and gameplay execution"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing command flow, event topology, or behavior architecture; use the narrower skill first
- the task is primarily inventory structure, item storage, or broad economy balancing rather than transaction semantics
- one local cost check is already sufficient and no shared contract is needed
- the task is primarily cooldown timing or reevaluation cadence rather than resource commit behavior
- the task is a localized runtime bug investigation rather than resource-transaction design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-command-flow` if the main problem is request-vs-execution ownership rather than cost semantics themselves.
- Pair with `game-development-time-source-and-tick-policy` when reservations expire, costs lock for a window, or commit timing depends on a shared clock policy.
- Pair with `game-development-world-state-facts` when affordability depends on stale observations, planner-readable availability, or truth-source drift.
- Pair with `game-development-condition-rule-engine` when the hard part is reusable eligibility logic and the resource effect is only one input to that decision.
- Hand off to `game-development-goap` or `game-development-utility-ai` once the transaction model is clear and the next question is planning, scoring, or action selection.

## Diagnostic checklist

Evaluate these questions before recommending or refining a resource-transaction design:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared transaction pressure? | Several systems need the same spend semantics | One local cost check is being over-abstracted |
| Is resource ownership clear? | The source of truth for each resource can be named | Different systems all mutate the same resource casually |
| Does timing matter? | It matters when value is checked, reserved, or committed | Timing is hand-waved and differs per caller |
| Is cancellation meaningful? | Actions may fail, be interrupted, or be rolled back after validation | The system assumes every validated action always completes |
| Are failure modes explicit? | Not-affordable, stale reservation, canceled, and invalid-input cases are distinguishable | All failures collapse into vague booleans or silent no-ops |
| Is auditability needed? | Reviews or debugging need to explain what changed and why | Resource mutations happen invisibly inside unrelated logic |

## Decision rules

Before recommending a reusable resource-transaction model, ask whether the smaller honest answer is:

- one local affordability check at a legitimate call site
- one command-validation boundary that does not need shared reservation semantics
- one cooldown or timing rule rather than a resource rule
- one inventory or economy-structure problem rather than a transaction problem
- one balance-tuning problem rather than a consistency-of-semantics problem

Reject a shared transaction layer if it mostly renames a single direct spend without improving consistency, failure handling, or multi-system coordination.

### Prefer a local spend check when

- the cost is simple and used in one place
- there is no need for shared preview, reservation, or rollback semantics
- abstraction would mostly rename one obvious subtraction

### Prefer immediate spend semantics when

- action validation and execution are effectively one step
- interruption after validation is negligible or impossible
- rollback is not meaningful enough to justify more ceremony

### Prefer reservation semantics when

- validation and execution are separated in time
- multiple actors or systems may compete for the same resource window
- UI previews, AI planning, or queued actions need provisional resource claims
- cancellation or timeout can happen after a provisional success

### Prefer staged commit or rollback semantics when

- an action may validate successfully but still fail before completion
- partial execution and cancellation need explicit treatment
- the design needs to distinguish provisional success from committed success
- reviews need to reason about refunds, forfeits, or stale reservations explicitly

### Escalate to adjacent foundations when

- the real issue is timing cadence rather than transaction semantics
- the real issue is world-fact truth or stale observations rather than spend contracts
- the real issue is condition composition rather than resource commitment behavior

## Workflow

Follow this sequence every time.

### 1. Identify the transaction boundary

State what resource-changing question the system is trying to answer before naming accounts, ledgers, or services.

Examples:

- whether an action can afford to start
- whether resources should be reserved before execution
- whether value is committed only on success
- whether cancellation should refund fully, partially, or not at all

### 2. Separate affordability, reservation, and commit stages

List the important stages explicitly rather than letting them blur together.

Typical stages:

- affordability check
- reservation or provisional hold
- commit on success
- rollback or refund on failure or cancellation

### 3. Define the resource ownership model

For each resource family, specify:

- source of truth
- mutation owner
- read-only observers
- whether previews use the same data or a derived projection
- what happens if the owner disappears or changes before commit

### 4. Choose the transaction model

For each important action path, decide whether the system uses:

- direct immediate spend
- reserve then commit
- reserve with timeout or invalidation
- staged partial commit
- explicit refund or rollback policy

### 5. Define failure, cancellation, and refund semantics

Specify:

- what not-affordable means
- what stale-reservation means
- what happens if execution fails after reservation
- whether refunds are full, partial, or none
- how cancellation differs from hard failure

### 6. Define observability and auditability

Specify:

- whether transaction reasons or tags should be visible
- what minimum logs or traces are needed
- whether UI previews and debug tools should expose provisional versus committed state
- what evidence helps reviewers confirm resource consistency

### 7. Separate transaction rules from adjacent concerns

Clarify what stays outside the transaction model, such as:

- broad inventory layout
- economy tuning and balance formulas
- timing cadence in full
- world-fact truth ownership
- event delivery topology

### 8. Plan the rollout

Migrate incrementally: isolate one repeated cost family, define ownership, choose the transaction shape, add cancellation and refund rules, replace divergent callers gradually, and verify before widening the model.

## Output contract

Return the result using `assets/transaction-brief-template.md` in this section order.

If the best answer is **not** a reusable transaction model, still use the template and say that explicitly instead of wrapping one honest cost check in financial theater.

Return the result in these sections:

1. **Transaction boundary**
2. **Local spend vs shared transaction decision**
3. **Resource ownership model**
4. **Affordability, reservation, and commit design**
5. **Failure, cancellation, and refund model**
6. **Auditability and UI exposure notes**
7. **Related foundations and handoff notes**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so resource-transaction recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Keep resource ownership separate from whichever node happens to trigger the action.
- If transaction data is authored as resources, make runtime ownership and mutation boundaries explicit rather than relying on scene-tree convenience.
- Be careful when provisional reservations depend on transient nodes, scene reloads, or object pooling; stale owners should not silently commit value.

### Unity

- Keep ScriptableObject-authored cost data separate from runtime transaction ownership.
- Avoid making inspector-authored data the implicit transaction ledger unless the mutation story is genuinely clear.
- Keep preview and commit paths aligned so UI, AI, and execution do not drift into parallel spend semantics.

### Generic C# / engine-neutral

- Prefer explicit transaction stages over giant helpers with hidden flags.
- Keep provisional and committed state distinguishable where cancellation matters.
- Use structured transaction reasons only where they materially improve debugging, UX, or reviewability.

## Common pitfalls

- abstracting one local spend into a shared ledger framework with no reuse benefit
- checking affordability in one place and spending elsewhere with no clear contract
- letting several systems mutate the same resource with incompatible timing assumptions
- treating reservation and commit as the same thing when interruption clearly exists
- silently refunding or silently forfeiting value without policy clarity
- mixing economy balancing concerns into transaction-boundary design
- making UI previews use different cost semantics than actual execution
- hiding resource mutations inside unrelated command, animation, or effect code

## Companion files

- `references/transaction-models.md` — reusable heuristics for immediate spend, reservation, staged commit, rollback, refund, and ownership trade-offs
- `references/failure-cases.md` — reusable failure and cancellation cases for reviewing transaction semantics before they spread
- `assets/transaction-brief-template.md` — reusable output template for returning the resource-transaction design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-spend alternative was considered first
- the transaction boundary is explicit
- affordability, reservation, and commit semantics are distinguished clearly
- ownership and mutation rights are concrete enough to review
- failure, cancellation, and refund behavior are stated explicitly
- auditability or UI exposure needs are addressed where relevant
- rollout steps are incremental enough to verify safely
- the design does not quietly expand into inventory architecture, balance doctrine, or timing policy by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable resource-transaction model is justified at all
- identified the transaction boundary and ownership model
- defined affordability, reservation, commit, and refund semantics
- specified failure handling, auditability, and observability expectations
- described engine integration notes where relevant
- returned a concrete migration and verification brief
