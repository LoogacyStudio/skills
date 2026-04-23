# Utility AI Design Guide

Use this reference to keep Utility AI systems understandable, tunable, and observable instead of letting them decay into score soup, tuning folklore, or jittery indecision.

## What Utility AI is good at

Utility AI is strongest when the problem is:

- about choosing among several simultaneously valid options
- context-sensitive rather than transition-driven
- improved by continuous desirability scoring
- better expressed by preference than by fixed branch order

Common fits:

- target selection
- desire or need arbitration
- tactical action choice where many options remain plausible
- simulation agents choosing between work, safety, rest, social, or resource behaviors

Utility AI is weaker when the problem is mostly:

- flat mode switching
- explicit reactive hierarchy
- multi-step goal planning
- a small fixed rule table

## Core building blocks

### Candidates

Candidates are the actions, states, or targets that compete to win the current decision.

Healthy sign:

- the candidate set is explicit and small enough to reason about

Warning sign:

- candidates mix different abstraction levels with no clear decision boundary

### Conditions

Conditions gate whether a candidate should be considered at all.

Healthy sign:

- conditions rule out impossible or irrelevant options early

Warning sign:

- conditions duplicate score logic or become hidden fixed transitions inside a supposedly fluid model

### Considerations

Considerations transform context into score inputs.

Healthy sign:

- each consideration has a named meaning, owner, and interpretable range

Warning sign:

- considerations are vague formulas nobody can explain in domain terms

### Score mappings and composition

Mappings normalize or reshape raw inputs. Composition combines them into a final candidate score.

Healthy sign:

- the combination rule is documented and auditable

Warning sign:

- the stack of weights, products, clamps, and random multipliers has become arcane ritual

### Reevaluation rules

Utility AI depends on when and how it rescans the world.

Healthy sign:

- reevaluation cadence and interruption rules are explicit

Warning sign:

- rescoring happens everywhere or constantly by habit, producing flicker and noise

## Candidate discipline

For each candidate, define:

- **Role:** state, action, or target choice
- **Availability rule:** when it can compete
- **Executor:** what system performs it if chosen
- **Granularity:** why this candidate is the right decision unit

Prefer candidates that:

- represent meaningful alternatives
- can be compared on the same decision boundary
- delegate actual execution elsewhere when appropriate

Avoid candidates that:

- mix high-level desires with low-level micro-actions in one pool
- are merely aliases for the same underlying outcome
- exist only because the scorer model was copied, not because the decision needs them

## Consideration discipline

For each consideration, define:

- **Meaning:** what it represents in game terms
- **Owner / source:** who supplies the input
- **Range:** raw and normalized
- **Direction:** what high versus low means
- **Usage:** which candidates depend on it

Good considerations look like:

- hunger level
- target proximity
- cover safety
- ammo scarcity
- social urgency

Bad considerations look like:

- blended mystery values with no owner
- duplicated values pulled from multiple sources
- inputs whose range or semantics are undocumented

## Score composition guide

Ask:

- Are scores normalized into a predictable range?
- Is the combination rule additive, multiplicative, weighted, or custom?
- Are there caps, floors, or bias terms?
- How are ties handled?
- Is randomness deterministic, weighted, or absent?

Good composition design looks like:

- small number of understandable mappings
- explicit reasons for each weight or multiplier
- documented tie-break rules

Bad composition design looks like:

- a formula nobody can explain without opening three spreadsheets and a prayer circle
- hidden random terms that mask weak candidate modeling
- mixed ranges causing one input to dominate accidentally

## Stability and reevaluation guide

Utility AI becomes painful when it is technically responsive but behaviorally twitchy.

Ask:

- When does reevaluation occur?
- Can the current choice be interrupted immediately?
- Are there cooldowns, hysteresis, or commitment windows?
- What prevents rapid score oscillation between close candidates?

Good stability design looks like:

- explicit reevaluation cadence
- safe interruption points
- hysteresis or lockout rules where needed
- logs explaining why a choice changed

Bad stability design looks like:

- reselecting a different winner every tiny context fluctuation
- instant cancellation of long actions with no cleanup rule
- no trace of why an option stopped winning

## Execution-system boundary rules

Use Utility AI to decide **what is currently most valuable**, not to personally execute every subsystem concern.

Keep these boundaries explicit:

- **movement** — pathfinding and locomotion execution
- **animation** — clip or state-graph control
- **combat or interaction resolution** — hit logic, cooldowns, inventory mutation
- **sensing** — perception or environment queries
- **presentation** — UI, VFX, dialogue display

If scoring logic or candidates start owning all five at once, the scoring layer is swallowing too much.

## Engine-aware notes

### Unity-style integrations

- inspector-visible score data can dramatically improve tuning quality
- keep scorer inputs separate from raw component implementation details
- weighted randomness should be intentional, not a substitute for clearer considerations

### Godot-style integrations

- score inputs should come from clean adapters or signal-driven updates rather than scene-tree noise directly
- reevaluation cadence should be explicit relative to `_Process`, timers, and signals
- selected actions should hand off to gameplay systems cleanly

### Generic Utility AI implementations

- document normalization ranges and combination rules
- make winner selection inspectable per candidate
- keep the scorer set small until observability is strong

## Rejection heuristics

Reject or down-rank a Utility AI recommendation when:

- a fixed rule hierarchy already models the problem clearly
- the decision boundary only has one real plausible choice at a time
- score inputs are too vague or too noisy to own properly
- tuning visibility would be too weak to support maintenance
- a simpler FSM, BT, or rule table is already a better fit

## Boundary stress tests

Use these tests when Utility AI sounds like the right answer, but the scoring layer may actually be absorbing unresolved lower-level concerns.

### Test 1. Are candidate gates really reusable condition rules?

Ask:

- are candidates competing meaningfully, or are most of them only present because their availability logic is unclear?
- would the scorer become simpler if impossible options were filtered by explicit reusable conditions first?

If yes, pair the review with `game-development-condition-rule-engine` before adding more score math.

### Test 2. Are score inputs really world-fact ownership problems?

Ask:

- do teams disagree about score formulas, or about whether the input facts are observed, derived, stale, or trustworthy?
- are the same values being supplied from multiple places with slightly different semantics?

If yes, pair the design with `game-development-world-state-facts` so Utility AI is not forced to clean up fact ambiguity through tuning.

### Test 3. Is score instability really a cadence or invalidation problem?

Ask:

- is the system flickering because the math is wrong, or because reevaluation cadence and interruption windows are underspecified?
- would the same scoring model behave better with explicit cooldowns, hysteresis timing, or change-driven reevaluation?

If yes, pair the review with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification` before retuning everything in circles.

### Test 4. Are resource-aware scores really hiding transaction semantics?

Ask:

- is a score reasoning about scarcity only, or is it also quietly deciding reserve, spend, and refund behavior?
- would the candidate comparison remain valid if commitment stages were defined elsewhere?

If the real fight is about resource stage semantics, pair with `game-development-resource-transaction-system` instead of inflating the score layer.

### Test 5. Are noisy targets or groups the hidden source of score confusion?

Ask:

- do candidate sets depend on unstable references, weak grouping rules, or ad hoc target discovery?
- would explicit tags, query boundaries, or stable identity rules make the scoring layer much smaller?

If yes, pair the design with `game-development-gameplay-tags-and-query` or `game-development-entity-reference-boundary` before widening the scorer set.

## Review checklist

Before approving a Utility AI design, verify that:

1. the scoring boundary is explicit
2. candidates are comparable and at the right abstraction level
3. considerations have named ownership and interpretable meaning
4. score composition rules are documented
5. reevaluation and stability rules are explicit
6. execution systems remain separated from scoring logic
7. score logs or observability hooks are planned
