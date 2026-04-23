# Condition shapes and abstraction guide

Use this reference when the main skill needs sharper language for defining rule shapes, deciding what should stay local, or preventing a reusable condition model from turning into a mystery box.

## Start with the smallest honest question

A condition should answer one focused question.

Good examples:

- can this action start now?
- is this target currently valid?
- may this transition fire?
- is this branch still eligible to continue?

Warning signs:

- the rule name sounds like an entire feature
- the rule decides both *whether* and *how* something should execute
- the rule depends on unrelated subsystems just to answer a boolean question

## Common condition shapes

### 1. Local inline check

Use when:

- the check is simple
- it is only used once
- the call site becomes clearer by keeping it nearby

Good fit:

- one transition edge
- one local editor guard
- one private helper in a small feature boundary

Do not extract this prematurely just to make the code look more architectural.

### 2. Atomic reusable predicate

Use when:

- the same question is asked in several places
- the required inputs are explicit and stable
- the predicate can be named cleanly

Examples:

- `has_line_of_sight`
- `has_required_resource`
- `target_is_hostile`
- `state_can_interrupt`

Healthy atomic predicates usually:

- answer one question
- avoid hidden global state
- stay small enough to explain in one sentence

### 3. Composite condition

Use when:

- multiple atomic predicates form a stable domain rule
- the composition itself deserves a meaningful name
- repeated call sites are rebuilding the same eligibility logic

Examples:

- action may start if target is valid **and** resource is sufficient **and** actor is not stunned
- retreat branch may execute if health is low **and** escape route exists

Composite conditions should not become anonymous nested logic blobs.
If the composition matters, name it.

### 4. Threshold or score-gated rule

Use when:

- the condition depends on thresholds rather than plain true or false inputs
- the rule still answers an eligibility question rather than full utility scoring

Examples:

- stamina above minimum threshold
- alertness below disengage threshold
- cooldown remaining below cancel window threshold

If the problem is really score comparison across multiple options, move closer to Utility AI rather than stretching condition rules into preference ranking.

### 5. Ordered or short-circuit composite rule

Use when:

- evaluation order matters for cost or safety
- one failure should stop deeper checks
- some predicates are cheap guards before expensive checks

Examples:

- validate actor state before performing path or target queries
- reject obviously invalid targets before running heavy spatial checks

Document the ordering rule explicitly if it matters.
Otherwise reviewers will assume the order is arbitrary.

## Boundary stress tests

Use these tests when a proposed condition model feels plausible but may be swallowing adjacent concerns.

### Test 1. Is this really a condition, or a fact problem?

Ask:

- is the hard part deciding whether something is true, observed, stale, or shared?
- does the condition mostly mirror uncertainty about blackboard or planner truth?

If yes, the condition may only be the consumer of a world-fact problem rather than the real design boundary.

### Test 2. Is this really a condition, or a transaction stage?

Ask:

- does the rule decide affordability only, or is it also quietly deciding reservation, spend, or refund semantics?
- would two callers get the same boolean answer but still disagree on what resource change should happen next?

If yes, keep the rule narrow and hand the stage semantics to the resource-transaction model.

### Test 3. Is this really a condition, or a scoring problem?

Ask:

- does the rule still answer one eligibility question, or is it now comparing several simultaneously valid options?
- are thresholds being used only to hide ranking logic that belongs in Utility AI?

If the design is trying to pick the best candidate rather than validate one candidate, the condition layer is already too far downstream.

### Test 4. Is reevaluation policy doing hidden design work?

Ask:

- does the condition seem simple only because polling cadence, invalidation, or cooldown timing are still unspecified?
- would the same rule behave very differently under frame polling versus change-driven reevaluation?

If yes, pair the condition review with time policy or state-change notification instead of pretending the rule can stand alone.

## Ownership guidelines

## Keep ownership explicit

For each rule, be able to answer:

- who owns the rule definition?
- who provides the inputs?
- who triggers evaluation?
- who consumes the result?

If those answers are muddy, the condition model is not stable yet.

## Prefer explicit inputs over ambient lookups

Prefer:

- focused context objects
- direct parameters
- stable identifiers or snapshots

Avoid:

- deep scene lookups hidden inside predicates
- silent dependency on globally mutable state
- rules that reach everywhere because no one decided what should be passed in

## Evaluation timing shapes

### Request-time evaluation

Use when the caller needs an answer now.
This is the default for:

- action validation
- transition checks
- interaction eligibility

### State-change-driven reevaluation

Use when repeated polling would be wasteful and the rule should be reevaluated after explicit change triggers.

### Polled evaluation

Use only when the runtime truly needs repeated checks.
If a rule is polled, name that fact explicitly in the design.

### Cached or memoized evaluation

Use carefully.
Only cache when:

- the inputs are stable enough
- invalidation is clear
- the cost of recomputation actually matters

If cache invalidation is hand-waved, the cache is probably the bug wearing a fake moustache.

## Observability guidelines

A reusable condition model should not force every failure into a featureless `false` if reviewers or debuggers need more context.

Useful observability options:

- named failure reasons
- debug tags
- trace-friendly evaluation logs
- optional review-time diagnostics

Do not over-instrument trivial local checks.
Add observability where shared rules would otherwise be opaque.

## Relationship to adjacent foundations

### Not the same as world facts

Condition rules answer questions.
World facts govern what the system believes is true, observed, inferred, stale, or writable.

### Not the same as resource transactions

A condition may check whether resources appear sufficient.
The transaction model decides reservation, commit, rollback, or refund semantics.

### Not the same as event topology

A state change may trigger reevaluation, but event delivery semantics belong elsewhere.

### Not the same as behavior architecture

A condition model can support FSM, behavior tree, Utility AI, or GOAP.
It should not choose among them.

## Smells that justify review

Run a review when you see patterns such as:

- copy-pasted preconditions with small variations
- giant `can_do_x` functions that know half the world
- rules whose names are too vague to explain
- nested condition composition that nobody wants to touch
- conditions that silently depend on timing or stale data assumptions
- endless boolean parameters or mode flags inside predicates
- disagreement about where a check belongs

## Decision shortcuts

If in doubt, use this shortcut:

- **one place, one simple truth** -> keep it local
- **same question in several places** -> consider atomic reusable predicate
- **same composition keeps reappearing** -> define named composite condition
- **different systems argue about stale truth or sensing** -> look toward world-state facts
- **different systems argue about commit or refund** -> look toward resource transactions
