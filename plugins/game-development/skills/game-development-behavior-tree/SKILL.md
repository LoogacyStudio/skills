---
name: game-development-behavior-tree
description: "Use when a cross-engine gameplay task needs a Layer 2 shared-runtime behavior-tree design for hierarchical priorities, fallback branches, running tasks, or interruptible decisions, and the agent must design or review a behavior tree without letting the tree or blackboard become a junk drawer."
---

# Game Development Behavior Tree

Use this skill when the problem is not merely "AI feels messy," but specifically looks **hierarchical, reactive, and branch-oriented** enough that a behavior tree is a serious candidate or has already been chosen.

This skill is for designing, reviewing, or refactoring behavior-tree-based logic without overfitting every behavior problem into a tree. Its job is to identify the real behavior boundary, define the tree shape, keep blackboard ownership explicit, choose a safe interruption model, and return a structured design brief another agent can implement or review safely.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Unreal decorators and services, Unity Behavior graphs and blackboards, or equivalent framework constraints.

For reusable behavior-tree heuristics, blackboard rules, interrupt models, and engine-aware notes, see `references/behavior-tree-design-guide.md`.

## Purpose

This skill is used to:

- determine whether a behavior tree is the right shape for the problem at all
- define a clear hierarchy of priorities, sequences, and fallback behavior
- separate tree-owned control flow from gameplay systems, animation, movement, and presentation
- keep blackboard design explicit instead of accidental
- make running-task, interrupt, and update rules explicit enough to review
- return a structured design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- a behavior problem has clear priority branches or fallback flow
- AI logic needs interruptible running tasks such as patrol, chase, attack, investigate, or flee
- the team wants graph visibility for higher-level behavior orchestration
- a project already uses Unreal Behavior Trees, Unity Behavior graphs, or a generic BT library and needs design cleanup
- requests that explicitly mention `behavior tree`, `BT`, `blackboard`, `decorator`, `selector`, `service`, `interrupt`, or `observer abort`

### Trigger examples

- "Should this enemy AI become a behavior tree?"
- "This patrol/chase/attack logic keeps duplicating priority checks"
- "Our blackboard is growing and nobody owns it"
- "We need running tasks that can be interrupted safely"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still architecture selection across FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the behavior is small enough for a simple enum, rule table, or event flow
- the task is specifically a localized FSM refactor and tree hierarchy is not the real issue; use `game-development-fsm`
- the system mainly needs goal-driven planning rather than hierarchical reactive choice
- the task is a runtime bug investigation rather than design or review of BT structure

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if the system is only suspected to be tree-shaped and the architecture choice is not settled yet.
- Pair with `game-development-world-state-facts` when blackboard truth, observed-vs-derived facts, or freshness rules are central.
- Pair with `game-development-condition-rule-engine` when decorators, guards, or branch eligibility checks need shared rule semantics.
- Pair with `game-development-time-source-and-tick-policy` when services, reevaluation cadence, or running-task polling cadence are part of the design risk.
- Pair with `game-development-state-change-notification` when observer aborts, invalidation, or change-driven reevaluation matter more than constant polling.
- Hand off to `game-development-entity-reference-boundary` when tasks or blackboards must carry target identities safely across running behavior.

## Diagnostic checklist

Evaluate these questions before recommending or refining a behavior tree:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is the problem hierarchical? | Clear priority or fallback branches | Mostly flat logic with no real hierarchy |
| Are running tasks central? | Actions persist and may need interruption | Everything is instantaneous or mode-based |
| Is blackboard data explainable? | Shared facts have named owners | Blackboard is becoming a generic state dump |
| Are conditions centralized? | Guards live at branch boundaries | Same checks are repeated deep in many leaves |
| Can engine-native BT tools help? | Existing graph/editor/runtime fits the need | The tree would duplicate simpler engine-native systems |

## Decision rules

Before recommending a behavior tree, ask whether the smaller honest answer is:

- a small FSM
- a rule table or event-driven controller
- engine-native animation or interaction logic that already owns the control flow
- the architecture-level answer in `game-development-behavior-architecture`

Reject a behavior tree if it mostly turns readable local rules into graph ceremony without clarifying hierarchy, ownership, or interruption.

### Avoid BT when

- the behavior is mostly fixed-state mode switching
- there is no meaningful hierarchy or fallback logic
- the system would need a large blackboard only because ownership is unclear
- the tree would hide simple logic behind graph ceremony

### Use BT when

- higher-priority behavior must pre-empt lower-priority behavior
- branch structure is the clearest way to express intent
- tasks can run over time and report success, failure, or running
- design and debugging benefit from a readable hierarchy

### Prefer a hybrid design when

- the BT should orchestrate high-level priorities while child systems own lower-level execution
- a subtree should call into an FSM, animation state graph, navigation system, or scripted action runner instead of owning everything itself
- the blackboard should carry intent and facts, not become a mirror of the entire game state

## Workflow

Follow this sequence every time.

### 1. Identify the tree boundary

State what the behavior tree actually owns before naming nodes or editor graphs.

### 2. Extract the branch structure

List the major branches already implied by the behavior or code.

For each branch, note:

- purpose
- priority
- entry condition
- success condition
- failure condition
- whether work is instantaneous or running

### 3. Choose the tree shape

At minimum, identify selectors, sequences, decorators or guards, real work leaves, and any services/observers the runtime actually needs.

### 4. Design the blackboard or shared context

Define:

- what facts live on the blackboard
- who writes each fact
- who reads each fact
- whether the fact is local, graph-owned, or shared across agents/subgraphs

Do not put derived, duplicated, or ownership-free data into shared context just because a node can see it.

### 5. Define the interrupt model

Specify how higher-priority behavior interrupts lower-priority work.

Consider:

- observer or decorator-based aborts
- re-evaluation cadence
- self-abort versus lower-priority abort
- what happens to running tasks when interrupted

### 6. Separate tree logic from execution systems

Clarify what remains outside the BT, such as:

- movement execution
- animation playback
- combat resolution
- sensing implementation
- dialogue/UI presentation

### 7. Add debugging and verification hooks

Useful hooks include:

- current branch or active leaf visibility
- blackboard change logging
- task start/finish logging
- interrupt or abort logging
- graph or tree snapshots for review

### 8. Plan the rollout

Migrate incrementally: isolate the high-level boundary, define the first selector/sequence structure, define blackboard ownership, move one branch at a time, verify interrupts, and then remove duplicated conditional logic.

## Output contract

Return the result using `assets/behavior-tree-design-brief.md` in this section order.

If the best answer is **not** a behavior tree, still use the template and say that explicitly instead of force-growing a tree out of polite stubbornness.

Return the result in these sections:

1. **Behavior boundary**
2. **Branch hierarchy**
3. **Tree shape recommendation**
4. **Blackboard design**
5. **Interrupt and running-task model**
6. **Execution-system boundaries**
7. **Implementation plan**
8. **Verification notes**

Keep the section order stable so BT recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Unreal Engine

- Prefer decorators for branch conditions instead of leaf tasks whose only job is to say yes or no.
- Use services for periodic updates that should stay active while execution remains in a subtree.
- Use observer-style aborts to express higher-priority interruption clearly.
- Prefer simple, readable concurrent patterns over elaborate pseudo-concurrency.

### Unity

- Treat Unity Behavior graphs as high-level decision tools, not replacements for every low-level gameplay script.
- Keep graph-local blackboards and shared blackboard assets intentional; shared variables need explicit ownership.
- Use observer-based priority interruption when higher-priority branches should interrupt lower-priority work.
- Be explicit about what is graph-owned versus code-owned.

### Generic BT libraries

- Make `SUCCESS`, `FAILURE`, and `RUNNING` semantics explicit for every task.
- Treat asynchronous tasks as first-class design concerns, not hidden implementation details.
- Prefer logging or profiling hooks whenever the runtime supports them.

## Common pitfalls

- building a giant tree when a smaller structure would do
- repeating the same conditions across many leaves
- treating the blackboard as a dumping ground for every available value
- hiding subsystem ownership behind generic task nodes
- leaving interrupt semantics vague for running tasks
- using the tree to own animation, gameplay, sensing, movement, and UI all at once

## Companion files

- `references/behavior-tree-design-guide.md` — reusable heuristics for tree shape, blackboard ownership, interrupt models, and engine-aware design notes
- `assets/behavior-tree-design-brief.md` — reusable output template for returning the BT design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler non-BT option was considered first
- the behavior boundary is explicit
- branch hierarchy, blackboard ownership, and interrupt behavior are concrete enough to review
- execution systems remain separated from decision flow where appropriate
- rollout steps are incremental enough to verify safely

## Completion rule

This skill is complete when the agent has:

- decided whether a behavior tree is justified at all
- identified the tree-owned behavior boundary
- defined the major branches and their priorities
- specified blackboard ownership and interrupt behavior
- described execution-system boundaries
- returned a concrete design or review brief with rollout and verification steps