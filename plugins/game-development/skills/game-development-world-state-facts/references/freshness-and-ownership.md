# Freshness and ownership guide

Use this reference when reviewing a proposed world-fact model and you need sharper language around truth ownership, stale observations, invalidation, or who is allowed to mutate shared state.

## Core principle

A fact model is weak when every state answer is treated as equally current, equally trustworthy, and equally writable.

A useful review should distinguish at least the choices that change:

- truth ownership
- planner trust
- blackboard readability
- stale-observation handling
- debugging clarity
- mutation safety

## Review questions

### 1. Where does this fact ultimately come from?

Question:

- what is the source of truth for this fact family?

Expected design clarity:

- source owner
- whether the stored value is observed or derived
- whether the fact is authoritative or only a projection

### 2. Who is allowed to write or invalidate it?

Question:

- which systems may mutate this fact, and which are read-only consumers?

Expected design clarity:

- write authority
- invalidation authority
- whether planners or behavior systems are readers only by default

### 3. When does the fact become stale?

Question:

- what makes this answer too old to trust as current truth?

Expected design clarity:

- staleness trigger
- whether freshness is time-based, event-based, or source-based
- whether stale values remain visible with metadata or are removed entirely

### 4. How are observed and derived facts kept distinct?

Question:

- can consumers tell direct observations from conclusions built on top of them?

Expected design clarity:

- provenance markers or separate fact families
- whether derived facts can be persisted
- how stale inputs affect derived outputs

### 5. What do consumers see when truth is absent, false, unknown, or stale?

Question:

- are those states distinct, or are they being collapsed into one ambiguous answer?

Expected design clarity:

- representation of missing vs false vs stale
- consumer expectations for each case
- planner or blackboard behavior when certainty drops

### 6. What happens if the source disappears or changes?

Question:

- how does the model respond when the owner, sensor, target, or context no longer exists?

Expected design clarity:

- cleanup or invalidation path
- whether last-known facts remain visible and how they are labeled
- how consumers avoid trusting dead references as living truth

### 7. Is fact inspection good enough?

Question:

- can a reviewer explain why a fact exists, where it came from, and how current it is?

Expected design clarity:

- minimum debugging surface
- provenance visibility
- freshness visibility
- meaningful inspection instead of an opaque bag of values

## Cross-foundation handoff prompts

Use these prompts when a fact review keeps discovering that truth ownership is only part of the real problem.

- If consumers are really asking reusable yes-or-no questions on top of facts, pair with `game-development-condition-rule-engine`.
- If freshness review keeps tripping over clock ownership, reevaluation cadence, or pause policy, pair with `game-development-time-source-and-tick-policy`.
- If stale facts are really stale handles, dead targets, or pooled identity reuse in disguise, pair with `game-development-entity-reference-boundary`.
- If the hard part is how downstream systems learn that facts changed or became invalid, pair with `game-development-state-change-notification`.

## Minimum acceptable clarity

A world-fact design should be considered under-specified if you cannot answer all of the following:

- what counts as a fact in this model
- where each important fact comes from
- who may write or invalidate it
- what makes it stale
- how observed and derived facts differ
- what consumers should do with stale or unknown answers

## Smells

These are strong warning signs:

- "everything just goes in the blackboard"
- any system can write planner-visible facts whenever convenient
- timestamps exist but nobody can explain how they are used
- stale observations remain forever because cleanup ownership is unclear
- planners treat guessed or derived values as if they were direct truth
- direct references to transient runtime objects are stored as if they were durable facts
- `false`, `missing`, and `unknown` all map to the same branch with no review justification
