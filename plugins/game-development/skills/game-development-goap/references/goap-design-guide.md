# GOAP Design Guide

Use this reference to keep GOAP systems reviewable, traceable, and worth their planning overhead instead of letting them dissolve into fact soup, action spam, or replanning panic.

## What GOAP is good at

GOAP is strongest when the problem is:

- goal-driven
- composed from reusable actions
- dependent on world facts
- meaningfully improved by multi-step planning

Common fits:

- worker or villager task planning
- combat survival or tactical recovery planning
- resource gathering, crafting, delivery, or service loops
- simulation agents that must adapt when the world changes

GOAP is weaker when the problem is mostly:

- flat mode switching
- simple reactive priority choice
- purely score-based arbitration
- a fixed scripted sequence with little need for replanning

## Core building blocks

### World-state or memory facts

Use facts to represent planner-meaningful information about the world.

Healthy sign:

- facts are explicit, named, and owned

Warning sign:

- the fact model mirrors every subsystem variable with no selection discipline

Examples:

- `hasAmmo = true`
- `coverAvailable = true`
- `resourceCount.wood >= 3`
- `targetVisible = false`

### Goals

Use goals to define desired end states or target world conditions.

Healthy sign:

- each goal has a clear success state and selection rule

Warning sign:

- goals are vague intentions with no measurable completion condition

### Actions

Use actions as reusable steps with preconditions, effects, and costs.

Healthy sign:

- actions can contribute to multiple goals or plan variants

Warning sign:

- every action is really a one-off branch of a scripted quest line

### Sensors or fact updaters

Use sensors, memory updaters, or fact writers to translate runtime state into planner-readable facts.

Healthy sign:

- update sources are explicit and bounded

Warning sign:

- facts are mutated from everywhere with no traceability

### Planner and replanning rules

Use the planner to build a valid action sequence and react when the world changes.

Healthy sign:

- planning and invalidation rules are explicit

Warning sign:

- nobody knows when replanning should happen or why a plan was discarded

## Fact discipline

For each fact, define:

- **Owner:** who writes it
- **Readers:** planner, actions, or diagnostics that rely on it
- **Source:** sensed, queried, or derived
- **Lifetime:** transient, local, planner-owned, or shared

Prefer putting these into planner memory:

- compact facts needed for goal satisfaction or action preconditions
- values that affect plan validity or action cost
- selected targets or intent-level facts with clear ownership

Avoid putting these into planner memory:

- every raw animation or physics detail
- duplicated mirrors of large component state with no planner use
- presentation-only values
- opaque blobs that cannot be reasoned about in preconditions or effects

## Goal selection guide

Ask:

- Are goals deterministic, priority-based, or weighted?
- When does a goal become valid?
- When is it considered satisfied, suspended, or abandoned?
- Can two goals fight for control in unclear ways?

Good goal design looks like:

- explicit success criteria
- clear selection rules
- manageable competition between goals

Bad goal design looks like:

- many overlapping goals with similar success states
- no explanation of why one goal beats another
- hidden rules outside the planner deciding what “really” matters

## Action granularity guide

Action granularity is one of the fastest ways to make a GOAP system great or miserable.

Too fine:

- graph explodes
- plans become noisy and fragile
- debugging becomes tedious

Too coarse:

- actions lose reuse value
- preconditions and effects become vague
- planner flexibility collapses

Good actions usually:

- represent a meaningful step of work
- have clear preconditions and effects
- can be reused across more than one situation or goal
- delegate low-level execution to underlying systems where appropriate

## Replanning guide

Replanning should be intentional, not constant.

Ask:

- What invalidates the current plan?
- Which fact changes matter enough to replan?
- Can an action fail and recover locally before full replanning?
- Is plan generation deterministic or intentionally weighted/randomized?

Good replanning design looks like:

- explicit invalidation triggers
- reproducible debugging modes when possible
- action outcome reporting that explains why a plan was continued, updated, or discarded

Bad replanning design looks like:

- replanning every frame by default
- silent plan invalidation with no logs
- no separation between sensor noise and meaningful planner state change

## Execution-system boundary rules

Use GOAP to decide **which action sequence best satisfies a goal**, not to personally implement every subsystem detail.

Keep these boundaries explicit:

- **movement** — pathfinding and locomotion execution
- **animation** — clip or state-graph control
- **combat or interaction resolution** — hits, cooldowns, inventory mutation, crafting resolution
- **sensing** — perception or environment queries
- **presentation** — UI, VFX, or dialogue display

If the planner or actions start owning all five at once, the planning layer is swallowing too much.

## Engine-aware notes

### Unity-style integrations

- adapters and planner managers can help bind planners to scene objects, but they should not obscure fact ownership
- deterministic or seeded goal selection modes can be valuable for testability and replay
- planner memory should stay meaningfully smaller than total component state

### Godot-style integrations

- fact writers should translate scene state into planner-relevant memory instead of leaking scene-tree mechanics into planning logic
- planner-chosen actions should call existing gameplay systems rather than rebuild them inside planner code
- runtime event cadence matters; be explicit about how timers, signals, or frame updates affect planning

### Generic GOAP libraries

- choose libraries that make action traces, goal selection, or planner events observable when possible
- keep cost rules and comparator conditions explicit enough to review
- be clear about how running actions report success, failure, or partial progress

## Rejection heuristics

Reject or down-rank a GOAP recommendation when:

- the system is primarily reactive rather than plan-driven
- goals cannot be expressed as desired world states with clear success criteria
- action effects are too fuzzy to reason about
- replanning pressure would exceed the gameplay value of planning
- a simpler FSM, BT, or scripted sequence is already a better fit

## Boundary stress tests

Use these tests when GOAP feels attractive, but the real difficulty may still live in the planner's supporting semantics.

### Test 1. Is planner memory actually a world-facts problem?

Ask:

- are design arguments really about who writes facts, how fresh they are, and when they should invalidate?
- does the planner look confusing mainly because memory ownership is fuzzy?

If yes, pair the review with `game-development-world-state-facts` before expanding the planner surface.

### Test 2. Are action preconditions actually reusable condition rules?

Ask:

- are GOAP actions re-encoding the same eligibility checks with small variations?
- would action design become clearer if common preconditions had stable names and inputs?

If yes, pair the review with `game-development-condition-rule-engine` so planner actions do not become a graveyard of copy-pasted gate logic.

### Test 3. Are action costs or effects really transaction semantics?

Ask:

- does an action merely require resources, or is it also deciding reservation, commit, rollback, or refund policy?
- would the planner still make sense if resource stage semantics were owned elsewhere?

If the real debate is about commitment rather than planning, pair with `game-development-resource-transaction-system`.

### Test 4. Is replanning pressure really a time or invalidation problem?

Ask:

- are plans being discarded because the world changes meaningfully, or because cadence and invalidation rules are unspecified?
- would GOAP look calmer if fact refresh, event triggers, or plan commitment windows were explicit?

If yes, pair the design with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification` before blaming the planner for churn.

### Test 5. Are targets and world objects stable enough for plans to survive?

Ask:

- do actions depend on entity handles that may disappear or mutate before execution?
- are plans built around stable identifiers, reacquisition, or validity checks?

If not, pair the review with `game-development-entity-reference-boundary` so plan failure is not quietly driven by stale references.

## Review checklist

Before approving a GOAP design, verify that:

1. the planning boundary is explicit
2. facts have named ownership and update sources
3. goals are concrete and comparable
4. actions have reviewable preconditions, effects, and costs
5. replanning triggers are explicit
6. execution systems remain separated from planning logic
7. logging or trace hooks are planned
