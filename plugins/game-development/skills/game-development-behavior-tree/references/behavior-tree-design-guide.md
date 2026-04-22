# Behavior Tree Design Guide

Use this reference to keep behavior trees expressive, readable, and reviewable instead of letting them become a decorative hiding place for mixed responsibilities.

## What a behavior tree is good at

Behavior trees are strongest when the problem is:

- hierarchical
- priority-driven
- reactive
- made of tasks that may succeed, fail, or remain running

Common fits:

- patrol / investigate / chase / attack / flee
- high-level NPC or boss behavior orchestration
- interaction flow where branch priority matters more than explicit state transitions

Behavior trees are weaker when the problem is mostly:

- flat mode switching
- score-based arbitration
- multi-step goal planning
- low-level execution details

## Core building blocks

### Selectors or priority branches

Use when the system must choose the best available branch.

Healthy sign:

- clear top-down priority ordering

Warning sign:

- dozens of siblings with fuzzy priority rules

### Sequences

Use when multiple steps must succeed in order.

Healthy sign:

- each child advances a meaningful stage of work

Warning sign:

- the sequence is really hiding stateful logic that belongs in a task or child system

### Decorators or guards

Use to gate an entire branch or subtree.

Healthy sign:

- condition logic is visible at the branch boundary

Warning sign:

- the same conditions are copied into multiple leaves

### Tasks or leaves

Use for actual work.

Healthy sign:

- each task has explicit success, failure, and running semantics

Warning sign:

- tasks secretly own branching policy, global state mutation, and animation authority all at once

### Services, observers, or periodic evaluators

Use for context updates or reactive interruption support when the runtime provides them.

Healthy sign:

- update cadence is explicit and tied to a subtree or branch boundary

Warning sign:

- context changes come from everywhere and nobody knows why a branch flipped

## Blackboard discipline

Blackboards are useful shared context, not magical absolution.

For each blackboard key, define:

- **Owner:** who writes it
- **Readers:** what nodes or systems rely on it
- **Lifetime:** temporary, branch-local, graph-local, or shared across agents/graphs
- **Source:** sensed fact, derived fact, intent, or cached target

Prefer putting these into the blackboard:

- sensed facts needed across multiple branches
- chosen targets or high-level intent
- branch-relevant transient facts with clear ownership

Avoid putting these into the blackboard:

- every raw gameplay value available in the project
- duplicated mirrors of component state with no clear owner
- presentation-only data
- values that only one task needs privately

## Interrupt model guide

Behavior trees get much of their value from clear interruption behavior.

Ask:

- What can interrupt what?
- When is reevaluation triggered?
- What happens to running tasks when interrupted?
- Does the branch self-abort, lower-priority-abort, or both?

Good interruption design looks like:

- one condition declared once at the correct priority boundary
- lower-priority work does not duplicate higher-priority exit checks everywhere
- running tasks have explicit cleanup or cancellation behavior

Bad interruption design looks like:

- every low-priority leaf manually checking whether a higher-priority branch wants control
- abort behavior depending on unstated side effects
- no logging for branch change or task interruption

## Execution-system boundary rules

Use the tree to decide **what should happen next**, not to personally perform every subsystem responsibility.

Keep these boundaries explicit:

- **movement** — navigation, steering, locomotion execution
- **animation** — clips, blend trees, animation state graphs
- **combat or interaction resolution** — hit logic, cooldown application, inventory mutation
- **sensing** — perception or environment queries
- **presentation** — UI, VFX, dialogue presentation

If a task node starts owning many of these at once, the tree is probably swallowing too much.

## Engine-aware notes

### Unreal-style BTs

- event-driven execution makes observer-friendly conditions especially important
- decorators are better branch guards than condition-only leaves
- services are appropriate for periodic updates tied to subtree activity
- simple parallel patterns are usually easier to reason about than full conceptual concurrency

### Unity Behavior graphs

- behavior graphs are high-level decision tools, not full replacements for all gameplay logic
- graph-local and shared blackboards should be chosen intentionally
- observer-based priority interruption works best when left-to-right priority is obvious in the graph
- custom nodes should not hide ownership boundaries

### Generic libraries

- make task return semantics explicit
- document async or running-task cancellation rules
- prefer runtimes with logging, profiling, or replay visibility when available

## Rejection heuristics

Reject or down-rank a BT recommendation when:

- the system is mostly state-machine shaped
- blackboard needs are vague or excessive
- there is no meaningful branch hierarchy
- the main challenge is dynamic scoring, not branch choice
- the main challenge is multi-step planning, not reactive priority flow

## Review checklist

Before approving a BT design, verify that:

1. the behavior boundary is explicit
2. the top-level branch order is understandable
3. conditions live at branch boundaries, not copied deep in leaves
4. blackboard keys have named ownership
5. running tasks have explicit interrupt semantics
6. the tree does not absorb unrelated subsystem authority
7. logging or visibility hooks are planned
