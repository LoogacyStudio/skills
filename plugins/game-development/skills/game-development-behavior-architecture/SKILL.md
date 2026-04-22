---
name: game-development-behavior-architecture
description: Use when gameplay, AI, or interaction behavior is growing beyond ad-hoc conditionals and the agent must decide whether the right answer is a simpler rule flow, an FSM, a behavior tree, utility scoring, or GOAP-style planning before locking in architecture.
---

# Game Development Behavior Architecture

Use this skill when the hard part is **choosing the right behavior architecture**, not merely implementing the first architecture-shaped idea that wandered into the room with false confidence.

This skill is for diagnosing behavior-system shape before committing to a design. Its job is to compare simpler alternatives, FSMs, behavior trees, Utility AI, and GOAP-style planners against the actual problem being solved, then return a recommendation brief that another agent can implement or review safely.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot scene-tree lifecycle, Unity authoring tools, or equivalent platform constraints.

For a reusable comparison matrix covering simpler alternatives, FSMs, behavior trees, Utility AI, and GOAP, see `references/architecture-comparison.md`.

## Purpose

This skill is used to:

- identify whether the problem needs a new behavior architecture at all
- compare the real fit of simpler rules, FSMs, behavior trees, Utility AI, and GOAP
- define ownership boundaries so gameplay, animation, orchestration, and presentation do not collapse into one mega-system
- choose a matching data model, interruption model, and planning horizon
- return a structured architecture brief another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- deciding between FSM, behavior tree, Utility AI, or GOAP for gameplay or AI behavior
- refactoring a behavior system that is accumulating flags, nested branches, blackboard sprawl, or duplicated conditions
- choosing whether an agent needs reactive switching, scored selection, or multi-step planning
- evaluating whether engine-native graphs should stay in charge of part of the behavior problem
- requests that explicitly mention `behavior architecture`, `FSM or behavior tree`, `Utility AI`, `GOAP`, `planner`, or `AI architecture`

### Trigger examples

- "Should this enemy AI stay an FSM or move to a behavior tree?"
- "This NPC keeps growing condition branches and interrupt rules"
- "Do I need GOAP here, or is that overkill?"
- "This behavior feels too dynamic for fixed transitions"

## Do not use this skill when

Do not use this skill when:

- the architecture has already been chosen and the task is implementation-only
- the problem is a localized bug or runtime failure rather than an architecture choice
- a tiny enum, rule table, or event flow already solves the problem cleanly
- the task is specifically a state-machine refactor and the choice has already been made; use `game-development-fsm` instead
- the real issue is performance, pooling, or memory churn rather than behavior architecture

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Diagnostic checklist

Evaluate these questions before recommending any architecture:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Are transitions fixed and explainable? | Clear modes and guards | Constant exceptions, hidden branches, or conflicting priorities |
| Is hierarchy important? | Priority and fallback branches are explicit | Branch nesting keeps growing with no clear owner |
| Is dynamic scoring the real need? | Competing options vary by context | Fixed transitions are being stretched to fake fluid choice |
| Is multi-step planning required? | Actions need a goal-driven sequence | The design only needs next-action choice, not planning |
| Who owns shared context? | Data ownership is explicit | Blackboard, flags, and services are mixed across systems |
| Can engine-native tools help? | Native graphs or authoring tools cover part of the problem | The proposal duplicates tools that already own the concern well |

## Decision rules

Before recommending any named architecture, first ask whether the smaller honest answer is:

- a small enum or mode flag
- a clearer event flow
- a rule table or priority table
- a better separation between gameplay and animation authority
- an engine-native tool already suited to the concern

Reject architectural escalation if it mostly renames local rule problems instead of clarifying ownership, interruption, or planning needs.

### Prefer a simpler alternative when

- the behavior has few modes and predictable transitions
- the system is mostly linear or local
- hierarchy, scoring, and planning are absent
- introducing a framework would create more ceremony than clarity

### Prefer FSM when

- behavior is mode-based with explicit transitions
- enter/exit logic matters
- the state count is nameable and bounded
- predictability matters more than emergent variation

### Prefer a behavior tree when

- the problem is hierarchical and branch-based
- fallback, priority, or interruption logic is central
- tasks may return success, failure, or running over time
- designers or reviewers benefit from tree/graph visibility

### Prefer Utility AI when

- multiple options are valid at the same time
- the core question is "what is most valuable right now?"
- the system benefits from scoring across context-sensitive considerations
- fixed transitions are too rigid but full planning is unnecessary

### Prefer GOAP when

- the agent must compose a sequence of actions to reach a goal
- preconditions, postconditions, and action costs matter
- replanning is a normal part of behavior
- next-action choice alone is not enough to explain the system

## Workflow

Follow this sequence every time.

### 1. Frame the behavior problem

State:

- the behavior unit being designed or reviewed
- the success criteria
- what currently hurts: flags, branch sprawl, brittle interrupts, score soup, planner thrash, or mixed ownership

### 2. Consider the lightest viable alternative first

Explicitly test whether the problem is already solved by:

- a tiny enum or switch/match
- a rule table
- an event-driven controller
- animation or engine-native authoring tools

### 3. Diagnose the problem shape

Assess the system on these axes:

- transition predictability
- hierarchy and fallback depth
- scoring versus fixed priority
- planning horizon
- interruption or replanning needs
- shared-context ownership
- authoring and debugging needs

Use `references/architecture-comparison.md` to keep the comparison explicit.

### 4. Compare the candidate architectures

Evaluate at minimum:

- simpler alternative
- FSM
- behavior tree
- Utility AI
- GOAP

For each candidate, note:

- why it fits
- why it may fail
- what extra complexity it introduces

### 5. Choose ownership and boundaries

Define what the chosen architecture owns and what it does not.

Typical boundaries include:

- gameplay authority
- animation authority
- navigation or movement services
- sensing and world-state updates
- presentation/UI concerns
- orchestration or quest flow

### 6. Define the data model and interruption model

At minimum, specify:

- where shared context lives
- who can mutate it
- whether the system uses local state, a blackboard, scores, or world-state facts
- how interruption, aborts, reevaluation, or replanning happen
- what debugging hooks are required

### 7. Recommend the migration path

Prefer incremental rollout: isolate the current boundary, choose the minimum viable architecture, define context ownership and interfaces, migrate one slice first, verify, and then remove duplicate authority.

### 8. Add verification notes

Specify what should be observed after the change, such as:

- transition correctness
- interrupt behavior
- score stability
- replanning frequency
- blackboard or state mutation visibility
- designer/debugger readability

## Output contract

Return the result using `assets/behavior-architecture-brief.md` in this section order.

If the best answer is **not** a new architecture, say so explicitly instead of stretching the problem until a framework appears necessary.

Return the result in these sections:

1. **Behavior problem summary**
2. **Current failure shape**
3. **Simpler alternative considered first**
4. **Candidate comparison matrix**
5. **Recommended architecture**
6. **Ownership and boundary design**
7. **Shared context and data model**
8. **Interrupt / reevaluation / replanning model**
9. **Migration steps**
10. **Verification notes**

Keep the section order stable so architecture recommendations are easy to compare across reviews, refactors, and later specialization work.

## Engine-specific notes

### Godot

- Keep gameplay authority separate from `AnimationTree` or animation-state ownership unless animation truly controls the behavior transition.
- If signals, timers, or scene-tree lifecycle events drive decisions, make those dependencies explicit in the boundary design.
- Avoid turning a node graph into a pseudo-planner unless the game genuinely needs planning.
- Be explicit about reevaluation cadence.

### Unity

- Keep gameplay behavior architecture separate from Animator state graphs unless they intentionally bridge.
- If the project uses Behavior Graph or other authoring tools, decide what remains graph-owned versus code-owned.
- Prefer plain C# ownership boundaries unless engine components materially improve authoring or debugging.
- Do not distribute authority across multiple `MonoBehaviour` callbacks with no clear coordinator.

## Common pitfalls

- treating every messy behavior system as a behavior-tree problem
- jumping to GOAP when the system only needs reactive selection
- using Utility AI without clear score ownership or observability
- forcing fixed-transition systems into scoring models that obscure intent
- letting blackboards become shared junk drawers
- mixing gameplay, animation, UI, and orchestration authority in one behavior layer
- choosing a sophisticated architecture before proving the simple option is insufficient

## Companion files

- `references/architecture-comparison.md` — reusable comparison matrix, selection heuristics, and warning signs for simpler alternatives, FSMs, behavior trees, Utility AI, and GOAP
- `assets/behavior-architecture-brief.md` — reusable output template for returning the architecture recommendation artifact

## Validation

A good result should satisfy all of the following:

- a simpler non-framework alternative was considered first
- the recommendation is tied to the actual behavior shape, not architecture fashion
- ownership, data-model, and interruption-model choices are explicit
- rejected alternatives are named with concrete reasons
- the migration path is incremental enough to verify
- the design does not duplicate engine-native tools without a clear payoff

## Completion rule

This skill is complete when the agent has:

- described the behavior problem in architecture-neutral terms
- checked whether a simpler alternative already solves it
- compared the main candidate architectures explicitly
- recommended the best-fit approach with named tradeoffs
- defined ownership, data, and interruption boundaries
- returned a concrete migration and verification plan