# Timing shapes and clock-boundary guide

Use this reference when the main skill needs sharper language for choosing a timing model, separating clock ownership from convenience polling, or preventing gameplay systems from quietly drifting into incompatible update assumptions.

## Start with the smallest honest question

A time policy should answer a focused question such as:

- which clock does this system use?
- how often does this logic run?
- what pauses or ignores pause?
- should this work be frame-driven, fixed-step, or event-driven?
- what happens when updates arrive late?

If the real question is only "should this one thing wait 0.5 seconds?", a local timer may be enough.

## Common timing shapes

### 1. Local one-off timer

Use when:

- one feature needs one delay or timeout
- no shared cooldown or cadence semantics exist
- abstraction would mostly rename an obvious wait

Good fit:

- a one-off UI transition
- a single temporary delay in one feature boundary
- one self-contained timeout with no cross-system meaning

Do not extract this into a shared time policy unless reuse pressure is real.

### 2. Shared sampled clock

Use when:

- several systems need the same notion of elapsed time
- consumers may run in different loops but read one named clock
- cooldowns or delays need consistent interpretation across systems

Good fit:

- gameplay cooldowns shared by UI, AI, and runtime execution
- delayed command windows that should survive different callers
- common scaled versus unscaled clock semantics

### 3. Frame-driven cadence

Use when:

- the logic is lightweight and responsiveness matters more than exact step boundaries
- small per-frame variance is acceptable
- the update is presentation-coupled or short-lived

Be honest about where frame variance is acceptable and where it is not.

### 4. Fixed-step cadence

Use when:

- consistent step boundaries matter materially
- accumulation or cooldown logic would become misleading under variable frame sampling
- gameplay meaning changes if frame rate changes too much

Use carefully.
If fixed-step is chosen only because it sounds rigorous, the model is probably overbuilt.

### 5. Event-driven or invalidation-driven cadence

Use when:

- reevaluation only matters after meaningful state changes
- constant polling would mostly waste work or hide ownership
- the design benefits from explicit invalidation

Examples:

- recomputing affordance only after state changes
- reevaluating target validity when relevant facts change
- updating cached scores only when inputs become dirty

### 6. Hybrid cadence

Use when:

- part of the system runs on intervals and part reacts to events
- event-driven invalidation narrows the work while periodic sampling preserves safety
- the design needs explicit boundaries between fast and slow paths

If hybrid is chosen, the boundary between event-triggered and interval-triggered work must be named clearly.

## Boundary stress tests

Use these tests when a timing proposal sounds tidy but may still be hiding a different problem.

### Test 1. Is this really a shared clock problem, or one local wait?

Ask:

- would one local timer solve the issue without introducing shared semantics?
- are several systems truly trying to interpret elapsed time the same way?

If the answer stays local, keep it local.

### Test 2. Is cadence doing hidden ownership work?

Ask:

- is the system polling every frame because nobody owns invalidation?
- is a fixed-step or interval loop standing in for a missing state-change boundary?

If yes, pair the design with state-change notification instead of using cadence as architectural duct tape.

### Test 3. Is the hard part freshness rather than time?

Ask:

- are people actually arguing about whether an answer is still current, rather than which clock drives it?
- would the problem shrink if fact staleness and invalidation were made explicit?

If yes, move closer to world-state facts.

### Test 4. Is the proposed clock boundary robust against lifetime churn?

Ask:

- do transient nodes, pooled objects, or scene-local helpers accidentally own important timers?
- would the same timing policy survive if the current owner were destroyed and rebuilt?

If not, the clock boundary is not stable yet.

## Ownership guidelines

## Name the authoritative clock

For each timing family, be able to answer:

- where does authoritative time come from?
- who advances it or owns its lifecycle?
- who samples it read-only?
- is it scaled, unscaled, paused, or custom?
- what other clocks exist and why?

If those answers are fuzzy, the timing policy is not ready.

## Separate loop choice from clock meaning

Avoid confusing:

- the callback or loop that executes work
- the clock whose elapsed time the work uses
- the pause semantics of the owning system
- the rate limit or reevaluation policy layered on top

Examples:

- a system may run every frame but still reason about an unscaled cooldown clock
- two systems may both use a fixed-step callback yet intentionally read different clocks

## Pause and scaling policy

Many timing bugs come from silently mixing:

- scaled time
- unscaled time
- paused time
- manually advanced time

If the team cannot explain what pauses, what scales, and what keeps running, the policy is not stable yet.

## Drift and late-update shapes

### Skip late work

Use when stale work should be discarded rather than replayed.

### Catch up with limits

Use when missed intervals matter, but unbounded catch-up would be dangerous.

### Clamp elapsed time

Use when long frames should not explode downstream logic.

### Surface drift visibly

Use when debugging or review depends on knowing that cadence is slipping.

Do not choose implicitly.
The system should be able to explain why one drift policy is appropriate.

## Relationship to adjacent foundations

### Not the same as resource transactions

A resource transaction may define when spending commits.
The time policy defines which clock and cadence make that timing meaningful.

### Not the same as condition rules

A condition rule may define what must be true.
The time policy defines when and how often that rule is reevaluated.

### Not the same as world-state freshness

A fact model may define staleness boundaries.
The time policy defines how clocks and reevaluation cadence interact with that freshness model.

### Not the same as networking determinism

A time policy may prepare the ground for deterministic concerns.
It should not automatically expand into a full replay or netcode doctrine.

## Smells that justify review

Run a review when you see patterns such as:

- UI, AI, and gameplay all counting cooldowns differently
- repeated `delta` math with no named clock boundary
- several subsystems all assuming they own pause behavior
- logic polling every frame because nobody named an invalidation path
- pooled or transient objects accidentally owning important timers
- disagreements about whether a system should use scaled or unscaled time
- long frames causing odd behavior that nobody can classify as skip, clamp, or catch-up

## Decision shortcuts

If in doubt, use this shortcut:

- **one delay, one place, no reuse** -> keep it local
- **same elapsed-time meaning in several places** -> shared sampled clock
- **presentation-sensitive lightweight logic** -> frame-driven cadence
- **stable simulation step matters** -> fixed-step cadence
- **reevaluation only matters after meaningful change** -> event-driven cadence
- **interval plus invalidation both matter** -> explicit hybrid model
