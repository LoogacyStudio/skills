---
name: game-development-goap
description: Use when a gameplay or AI problem is fundamentally goal-driven and needs multi-step action planning with explicit world facts, action preconditions and effects, costs, and replanning rules, and the agent must design or review a GOAP system without letting facts, actions, or replanning drift into chaos.
---

# Game Development GOAP

Use this skill when the hard part is not merely choosing the next branch, but planning **a sequence of actions that transforms the current world state into a desired goal state**.

This skill is for designing, reviewing, or refactoring GOAP-style systems without overfitting every AI problem into a planner. Its job is to define the planning boundary, choose a sane world-fact model, shape the goal and action contracts, specify replanning rules, and return a structured design brief another agent can implement or review safely.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Unity or Godot adapters, engine-managed sensors, or equivalent framework constraints.

For reusable heuristics covering goals, facts, actions, replanning, and execution boundaries, see `references/goap-design-guide.md`.

## Purpose

This skill is used to:

- determine whether GOAP is the right shape for the problem at all
- define a clear planning boundary and world-state model
- shape goals, actions, preconditions, effects, and action costs so planning remains reviewable
- separate planner-owned reasoning from execution systems such as movement, combat, animation, or interaction code
- make replanning and sensor/update rules explicit enough to review
- return a structured GOAP design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- an agent must achieve goals through reusable multi-step action sequences
- current logic is brittle because transitions are hardcoded instead of planned from world facts
- a project already uses or strongly leans toward GOAP and needs design cleanup
- the system needs action reuse, world-state reasoning, and replanning when conditions change
- requests that explicitly mention `GOAP`, `goal oriented action planning`, `planner`, `preconditions`, `effects`, `world state`, or `replanning`

### Trigger examples

- "Should this NPC use GOAP instead of hardcoded sequences?"
- "We need goals, actions, and replanning for our worker AI"
- "Our action planner keeps growing and I need a design review"
- "This AI needs to adapt when resources or targets disappear"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still architecture selection across FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the behavior only needs reactive priority switching rather than multi-step planning
- a small FSM, behavior tree, or scripted sequence already solves the problem cleanly
- the task is a runtime bug investigation rather than GOAP design or review
- the system has no stable notion of goals, world facts, or reusable actions

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if GOAP is only one candidate and the planning-vs-reactive question is still open.
- Pair with `game-development-world-state-facts` when planner memory, sensed truth, derived facts, or freshness policy need a real foundation instead of ad-hoc blackboard drift.
- Pair with `game-development-condition-rule-engine` when action preconditions need reusable predicate structure instead of planner-local custom checks everywhere.
- Pair with `game-development-resource-transaction-system` when action costs, reservations, or commit semantics materially affect action viability and planning.
- Pair with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification` when replanning cadence depends on explicit clocks, invalidation, or state-change triggers.
- Hand off to `game-development-command-flow` when planned actions need a stable execution, queuing, or replay surface outside the planner itself.

## Diagnostic checklist

Evaluate these questions before recommending or refining a GOAP system:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is multi-step planning really needed? | The agent must compose a sequence to reach a goal | The system only needs next-action choice or simple branch priority |
| Are world facts explicit? | Facts can be named, owned, and updated clearly | State is vague, duplicated, or mixed with raw subsystem internals |
| Are actions reusable? | Actions can serve multiple goals and contexts | Every action is effectively a one-off script fragment |
| Is replanning part of the design? | World changes can invalidate or improve plans | Replanning behavior is undefined or would happen every moment by panic |
| Are goals comparable? | Goals have explicit priority or selection rules | Goals are vague wishes with no selection discipline |

## Decision rules

Before recommending GOAP, ask whether the smaller honest answer is:

- a scripted sequence or quest flow
- a behavior tree with reactive priorities
- an FSM with explicit transitions
- the architecture-level answer in `game-development-behavior-architecture`

Reject GOAP if it mostly wraps fixed scripted behavior in planner terminology without meaningful goals, facts, or replanning.

### Avoid GOAP when

- the system only needs the next best action, not a planned chain
- goals are too fuzzy to encode as desired world states
- actions cannot state meaningful preconditions and effects
- replanning would be constant churn with little gameplay benefit
- the action library would merely duplicate fixed scripted paths

### Use GOAP when

- the agent must combine reusable actions to satisfy goals
- world-state facts can be observed or inferred clearly
- preconditions, effects, and costs are first-class design concepts
- plan invalidation and replanning are meaningful parts of behavior

### Prefer a hybrid design when

- GOAP should choose high-level action plans while BTs, FSMs, or action runners execute individual steps
- the planner should decide intent while movement, animation, and combat remain outside the planner
- a goal plan should call into narrower behavior systems rather than own all low-level control directly

## Workflow

Follow this sequence every time.

### 1. Identify the planning boundary

State what the planner actually owns before naming actions or graph nodes.

### 2. Define the world-state or memory model

List the core facts the planner reads.

For each fact, note:

- meaning
- owner or writer
- update source such as sensor, query, or derived logic
- lifetime and scope

### 3. Define goals and goal selection

For each goal, specify:

- desired world state
- selection rule or priority
- when the goal becomes valid or invalid
- what success means

### 4. Define the action library

For each action, specify:

- preconditions
- effects or postconditions
- cost
- runtime execution responsibility
- whether the action is atomic, running, or composite

Prefer actions that are reusable and meaningful. Avoid action granularity that is so fine it explodes the plan graph or so coarse it kills reuse.

### 5. Define planning and replanning rules

Specify:

- when planning happens
- when replanning happens
- what invalidates a plan
- whether goal selection is deterministic, weighted, or otherwise prioritized
- how partial execution affects the world-state model

### 6. Separate planner logic from execution systems

Clarify what remains outside GOAP, such as:

- movement and pathfinding execution
- animation playback
- combat resolution
- sensing implementation
- UI or presentation systems

### 7. Add debugging and verification hooks

Useful hooks include:

- goal selection logging
- plan creation or update logging
- action begin / success / failure logging
- world-fact or memory change logging
- plan snapshots or traces for review

### 8. Plan the rollout

Migrate incrementally: isolate the planning boundary, define the smallest viable fact model, implement one or two real goals, add a minimal reusable action set, verify replanning, and expand only after traceability is good.

## Output contract

Return the result using `assets/goap-planning-brief.md` in this section order.

If the best answer is **not** GOAP, still use the template and say that explicitly instead of inflating a simple problem into a planner thesis.

Return the result in these sections:

1. **Planning boundary**
2. **World-state model**
3. **Goal model**
4. **Action library design**
5. **Planning and replanning model**
6. **Execution-system boundaries**
7. **Implementation plan**
8. **Verification notes**

Keep the section order stable so GOAP recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Unity

- Keep planner memory or state facts separate from raw component state unless you intentionally bridge them.
- Unity adapters or planner managers can help with scene integration, but they should not hide fact ownership or action semantics.
- Prefer deterministic debugging modes when available.

### Godot

- Keep planner facts separate from scene-tree noise; sensors or adapters should translate runtime details into planner-meaningful facts.
- Planner-driven actions should call into existing gameplay systems rather than absorb node lifecycle and animation concerns.
- Be explicit about when plan updates occur relative to runtime events.

### Generic GOAP libraries

- Make goal selection rules, action costs, and fact updates explicit.
- Prefer runtimes with logging, plan traces, or debugger hooks when available.
- Be clear about how running actions report status back to the planner.

## Common pitfalls

- modeling vague desires as goals with no precise success state
- turning the world-state model into a duplicate of the entire game state
- using actions that are too tiny or too huge to plan with sanely
- leaving replanning cadence vague until it turns into planner thrash
- letting the planner own movement, animation, combat, and sensing all at once
- adding many goals and actions before logging and traceability exist

## Companion files

- `references/goap-design-guide.md` — reusable heuristics for facts, goals, actions, replanning, execution boundaries, and engine-aware design notes
- `assets/goap-planning-brief.md` — reusable output template for returning the GOAP design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler non-GOAP option was considered first
- the planning boundary is explicit
- facts, goals, actions, and replanning behavior are concrete enough to review
- execution systems remain separated from planning where appropriate
- rollout steps are incremental enough to verify safely
- planner complexity is justified by the problem shape

## Completion rule

This skill is complete when the agent has:

- decided whether GOAP is justified at all
- identified the planner-owned boundary
- defined the world-state, goal, and action contracts
- specified planning and replanning behavior
- described execution-system boundaries
- returned a concrete design or review brief with rollout and verification steps