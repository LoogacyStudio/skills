---
name: game-development-utility-ai
description: Use when a gameplay or AI problem is fundamentally about choosing the most valuable option right now from several simultaneously valid candidates, and the agent must design or review a Utility AI system with explicit scorers, score ownership, tuning rules, and observability instead of drifting into opaque score soup.
---

# Game Development Utility AI

Use this skill when the hard part is not fixed transitions or multi-step planning, but **context-sensitive scoring among multiple valid options**.

This skill is for designing, reviewing, or refactoring Utility AI systems without overfitting every behavior problem into a scoring model. Its job is to define the scoring boundary, shape considerations and score mappings, keep score ownership explicit, specify reevaluation and tie-breaking rules, and return a structured design brief another agent can implement or review safely.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Unity integrations, graph tooling, or equivalent framework constraints.

For reusable heuristics covering considerations, score composition, tuning, observability, and hybrid designs, see `references/utility-ai-design-guide.md`.

## Purpose

This skill is used to:

- determine whether Utility AI is the right shape for the problem at all
- define a clear scoring boundary and candidate-action or candidate-state model
- shape considerations, conditions, and score mappings so decisions remain reviewable
- keep score ownership, update cadence, and tuning discipline explicit
- separate high-level scoring from execution systems such as movement, combat, animation, or interaction code
- return a structured Utility AI design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- several options are valid at the same time and the system needs to choose the best one for the current context
- fixed transitions are becoming too rigid but full planning is unnecessary
- a project already uses or strongly leans toward Utility AI and needs design cleanup
- the system needs scoring, desirability, urgency, or preference modeling rather than hard-coded priority branches
- requests that explicitly mention `Utility AI`, `utility scoring`, `consideration`, `score curve`, `score mapping`, `desirability`, or `tuning`

### Trigger examples

- "Should this NPC use Utility AI instead of fixed transitions?"
- "We need to score multiple tactical choices each update"
- "Our Utility AI is impossible to tune and I need a design review"
- "This system has many valid targets and needs dynamic choice"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still architecture selection across FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the system mainly needs fixed-state transitions or explicit reactive hierarchy
- the system mainly needs multi-step planning instead of next-choice scoring
- a simple rule table, priority list, or event flow already solves the problem cleanly
- the task is a runtime bug investigation rather than Utility AI design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Diagnostic checklist

Evaluate these questions before recommending or refining a Utility AI system:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Are multiple options truly valid at once? | The system must compare competing choices | Only one or two branches really make sense at any time |
| Is scoring the real problem shape? | Context changes desirability continuously | Fixed transitions or priorities are actually sufficient |
| Are scorers explainable? | Each score input has a named meaning and owner | Scores come from many places with unclear semantics |
| Is reevaluation intentional? | The system knows when and why to rescore | Scoring may happen everywhere or constantly by habit |
| Is tuning observable? | Designers or developers can inspect why a winner won | Final scores are opaque and hard to trace |

## Decision rules

Before recommending Utility AI, ask whether the smaller honest answer is:

- a rule table or priority table
- a behavior tree with clear interrupt rules
- an FSM with explicit transitions
- the architecture-level answer in `game-development-behavior-architecture`

Reject Utility AI if it mostly replaces understandable rules with opaque score math that nobody can explain or tune.

### Avoid Utility AI when

- the system mostly needs fixed transitions or explicit branch order
- candidate options are few and stable enough for simple rules
- score inputs cannot be defined cleanly
- debugging or tuning visibility would be too weak for the project
- a scoring layer would hide intent better than it reveals it

### Use Utility AI when

- several candidate actions or states remain valid simultaneously
- the right answer depends on contextual desirability rather than fixed branching
- the system benefits from fluid, continuous choice rather than explicit transitions
- scoring can be made observable enough to tune and review

### Prefer a hybrid design when

- Utility AI should choose high-level intent while FSMs, BTs, or action runners execute the chosen behavior
- scoring should select between modes or targets, but lower-level execution belongs elsewhere
- only part of the behavior problem needs scoring and the rest is better handled with fixed structure

## Workflow

Follow this sequence every time.

### 1. Identify the scoring boundary

State what the Utility AI actually owns before naming formulas or score curves.

### 2. Define the candidate set

List the candidate actions, states, or targets being scored.

For each candidate, note:

- purpose
- when it is available
- what execution system carries it out
- whether it represents a state, action, or target choice

### 3. Define conditions and considerations

For each candidate, specify:

- gating conditions if any
- considerations or score inputs
- the meaning of each input
- the owner or source of each input

### 4. Define score mapping and composition

Specify:

- how raw inputs are normalized or mapped
- how multiple considerations combine, such as multiply, sum, weighted sum, or custom mapping
- whether there are clamps, floors, caps, or tie-break rules
- how deterministic or stochastic the final choice should be

### 5. Define reevaluation rules

Specify:

- when rescoring happens
- what events or cadence trigger reevaluation
- whether the current choice can be interrupted immediately or only at safe checkpoints
- how score hysteresis, cooldowns, or lockouts prevent jitter

### 6. Separate scoring from execution systems

Clarify what remains outside Utility AI, such as:

- movement and pathfinding execution
- animation playback
- combat resolution
- sensing implementation
- UI or presentation systems

### 7. Add debugging and verification hooks

Useful hooks include:

- per-candidate score breakdowns
- consideration-level logging
- winner selection logging
- reevaluation trigger logging
- designer-friendly score overlays or tables where practical

### 8. Plan the rollout

Migrate incrementally: isolate the scoring boundary, define the smallest viable candidate set, implement a small set of considerations, add transparent score output, verify stability, and expand only after observability is good.

## Output contract

Return the result using `assets/utility-ai-design-brief.md` in this section order.

If the best answer is **not** Utility AI, still use the template and say that explicitly instead of turning a clear rule system into a score blender.

Return the result in these sections:

1. **Scoring boundary**
2. **Candidate model**
3. **Scorer design**
4. **Score composition model**
5. **Reevaluation and stability model**
6. **Execution-system boundaries**
7. **Implementation plan**
8. **Verification notes**

Keep the section order stable so Utility AI recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Unity

- Keep score inputs and candidate availability separate from raw component state unless the bridge is explicit.
- Use visualization or inspector-friendly debugging where possible so tuning is not blind.
- Prefer small, auditable scorer sets before introducing weighted randomness everywhere.

### Godot

- Keep score inputs planner-meaningful and separate from scene-tree noise; translate runtime details into clean considerations.
- Use signals, timers, or frame cadence intentionally so rescoring is predictable.
- Let the chosen action hand off to gameplay systems rather than embedding execution logic inside the scorer layer.

### Generic Utility AI implementations

- Normalize and document score ranges explicitly.
- Make score composition rules and tie-break behavior reviewable.
- Prefer tooling or logs that show why a candidate won.

## Common pitfalls

- scoring options that should really be fixed rules
- creating considerations with unclear ownership or semantics
- stacking many score mappers until nobody can reason about the outcome
- rescoring so often that the AI jitters between choices
- letting randomization mask weak scoring design
- adding more scorers before score observability exists

## Companion files

- `references/utility-ai-design-guide.md` — reusable heuristics for candidates, considerations, score composition, tuning, observability, and engine-aware design notes
- `assets/utility-ai-design-brief.md` — reusable output template for returning the Utility AI design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler non-Utility option was considered first
- the scoring boundary is explicit
- candidates, score inputs, and reevaluation behavior are concrete enough to review
- score composition is concrete enough to reason about
- execution systems remain separated from scoring where appropriate
- rollout steps are incremental enough to verify safely
- scoring complexity is justified by the problem shape

## Completion rule

This skill is complete when the agent has:

- decided whether Utility AI is justified at all
- identified the scoring-owned boundary
- defined candidates, considerations, and score composition rules
- specified reevaluation and stability behavior
- described execution-system boundaries
- returned a concrete design or review brief with rollout and verification steps