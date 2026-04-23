# Behavior Architecture Comparison Guide

Use this reference to compare the lightest viable option against progressively heavier behavior architectures.

The point is not to crown a universal winner. The point is to match the architecture to the problem shape.

## Quick chooser

| Candidate | Best fit | Strongest signal | Main benefit | Main warning sign |
| --- | --- | --- | --- | --- |
| Simpler alternative | Small, local, predictable behavior | Few explicit modes or rules | Lowest complexity and easiest debugging | You keep adding exceptions or duplicated transition logic |
| FSM | Mode-based behavior with bounded transitions | Clear states with meaningful enter/exit behavior | Predictable transitions and explicit ownership | State explosion or mixed concerns |
| Behavior tree | Hierarchical reactive behavior | Priority, fallback, and interruption dominate the problem | Branch composition and readable reactive flow | Tree bloat, duplicated conditions, or blackboard junk-drawer growth |
| Utility AI | Context-sensitive choice among multiple valid options | The question is "what is most valuable right now?" | Fluid selection without hard-coded transitions | Score soup, opaque tuning, or unstable priorities |
| GOAP | Goal-driven multi-step action selection | A sequence of actions must be planned, not merely chosen | Dynamic planning with explicit world-state reasoning | Planner thrash or overkill for simple reactive problems |

## Selection axes

Score or describe the problem across these axes before recommending an architecture.

### 1. Transition predictability

- **Low complexity:** few named modes, clear guard conditions
- **Medium complexity:** multiple branches with recurring transitions
- **High complexity:** many context exceptions, hidden priorities, or competing conditions

Implication:

- lower complexity favors simpler alternatives or FSMs
- higher hierarchy pressure may favor behavior trees
- high contextual competition may favor Utility AI

### 2. Hierarchy and fallback

Ask:

- Does the agent need layered priority behavior?
- Are fallback branches part of the core design?
- Do actions run over time and need to report success, failure, or running?

Implication:

- if yes, behavior trees become more attractive
- if hierarchy is absent, a tree may be ceremony without payoff

### 3. Scoring versus fixed rules

Ask:

- Are several options simultaneously valid?
- Does context continuously change their desirability?
- Is a hard transition table becoming artificial?

Implication:

- if yes, Utility AI is a serious candidate
- if no, fixed rules are often clearer than score tuning

### 4. Planning horizon

Ask:

- Is choosing the next action enough?
- Or must the system plan a sequence to reach a goal?
- Are preconditions, postconditions, and action costs central?

Implication:

- short horizon favors simpler alternatives, FSMs, behavior trees, or Utility AI
- long horizon with explicit goal satisfaction favors GOAP

### 5. Interruption and reevaluation model

Ask:

- How often may behavior be interrupted?
- Does the system reevaluate on events, on ticks, on timers, or after plan steps?
- Must in-progress tasks be safely aborted?

Implication:

- behavior trees fit explicit reactive interruption well
- Utility AI fits repeated re-scoring well
- GOAP needs clear replanning rules to avoid churn
- FSMs need explicit transition authority to stay predictable

### 6. Shared context ownership

Ask:

- Where does shared decision context live?
- Who updates it?
- Who is allowed to mutate it?
- Is the design about to create a blackboard that nobody truly owns?

Implication:

- all non-trivial architectures need context discipline
- Utility AI and GOAP become fragile quickly if facts, scores, or sensors have fuzzy ownership

### 7. Authoring and debugging needs

Ask:

- Does the team need graph visibility?
- Do designers need to edit behavior safely?
- How will you inspect transitions, scores, or plans at runtime?

Implication:

- if observability is weak, prefer simpler models over clever opaque ones

## Candidate notes

### Simpler alternative

Typical shapes:

- enum plus centralized switch or match
- rule table
- event-driven controller
- engine-native authoring graph already covering the concern

Good when:

- behavior is local and predictable
- the number of modes is small
- debugging simplicity matters more than flexibility

Bad signs:

- repeated enter/exit logic spreads across files
- transition rules are duplicated
- hidden flags create fake sub-states

### FSM

Strongest when:

- states are explicit and bounded
- transitions are meaningful and reviewable
- one owner should control mode changes

Watch for:

- state explosion
- one FSM owning gameplay, animation, UI, and orchestration at once
- transitions scattered across unrelated systems

### Behavior tree

Strongest when:

- behavior is hierarchical
- fallback and priority switching are core to the design
- tasks can remain running and be interrupted or rechecked

Watch for:

- giant trees with duplicated conditions
- condition logic smeared between tasks, decorators, and services
- blackboard growth with unclear ownership

### Utility AI

Strongest when:

- behavior should feel fluid rather than transition-driven
- many candidate actions remain valid simultaneously
- context-sensitive choice is more important than fixed branch ordering

Watch for:

- opaque scoring formulas
- difficult tuning and weak runtime visibility
- score inputs being mutated from too many places

### GOAP

Strongest when:

- the agent must achieve goals through chained actions
- preconditions, postconditions, and action costs are first-class design concepts
- the environment changes enough that replanning matters

Watch for:

- planning cost or complexity that exceeds gameplay needs
- action libraries that are too coarse or too granular
- constant replanning with little behavioral gain

## Boundary guardrails

Whatever architecture you choose, keep these boundaries explicit:

- **gameplay authority** — who decides what the agent is trying to do
- **animation authority** — who decides how intent becomes animation state
- **navigation or movement services** — who provides pathing or locomotion execution
- **sensing or world-state updates** — who publishes facts into shared context
- **presentation** — what should stay outside decision logic

If one architecture starts owning all five at once, stop and simplify.

## Rejection heuristics

Reject or down-rank a candidate when:

- the main benefit does not match the actual failure mode
- its required shared context would be harder to own than the current system
- its debugging story is weaker than the existing pain warrants
- it duplicates engine-native tools without reducing complexity
- it expands the mutation surface before the current boundary is even clear

## Boundary stress tests

Use these tests when the architecture debate feels real, but the actual problem may still live in a lower shared-semantics layer.

### Test 1. Is this really an architecture problem, or a condition/fact problem?

Ask:

- are people arguing about whether the agent "knows" something, or only whether a branch should be legal right now?
- would the same architecture options look clearer if reusable conditions or world facts already had named ownership?

If yes, pair the review with `game-development-condition-rule-engine` or `game-development-world-state-facts` before committing to a heavier architecture.

### Test 2. Is this really an architecture problem, or a reevaluation-policy problem?

Ask:

- is the pain actually about interrupt timing, polling cadence, cooldown windows, or replan frequency?
- are architecture candidates being compared through different hidden timing assumptions?

If yes, pair the review with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification` so the architecture is not being forced to own cadence by accident.

### Test 3. Is this really an architecture problem, or an action boundary problem?

Ask:

- is the hard part deciding behavior structure, or deciding how actions are requested, queued, committed, or cancelled?
- would a cleaner command surface make the architecture choice much less dramatic?

If yes, pair the review with `game-development-command-flow` before promoting the architecture change as the main fix.

### Test 4. Is this really a planning/scoring debate, or a missing comparison boundary?

Ask:

- are BT, Utility AI, and GOAP being compared because they are all plausible, or because the decision boundary was never stated clearly?
- is the real decision about reactive priority, contextual scoring, or multi-step goal satisfaction?

If the debate stays mushy, rewrite the decision boundary first, then compare only the closest two families instead of staging a five-way cage match.

### Test 5. Is reference stability the hidden blocker?

Ask:

- do candidate designs keep depending on targets, handles, or actor references that may go stale between evaluation and execution?
- would the architecture be easier to reason about if identity and validity boundaries were already explicit?

If yes, pair the review with `game-development-entity-reference-boundary` rather than blaming the architecture choice for stale-reference bugs.

## Recommendation discipline

When returning a final recommendation:

1. name the simplest viable option considered first
2. compare at least the closest two alternatives
3. state the ownership boundary explicitly
4. specify the data model and interruption model
5. keep migration incremental
