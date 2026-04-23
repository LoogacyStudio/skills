# Invalidation and batching guide

Use this reference when reviewing a proposed state-change notification model and you need sharper language around invalidation semantics, change suppression, batching, or consumer refresh behavior.

## Core principle

A notification model is weak when every consumer gets either too much noise or too little meaning.

A useful review should distinguish at least the choices that change:

- notification timing
- payload trust
- invalidation behavior
- batching guarantees
- consumer refresh cost
- debug visibility

## Review questions

### 1. What counts as a meaningful change here?

Question:

- which changes deserve external notification instead of remaining local?

Expected design clarity:

- change boundary
- externally meaningful vs internal mutation distinction
- what is intentionally not notified

### 2. What does the payload mean?

Question:

- is this notification a diff, snapshot, tag, or invalidation notice?

Expected design clarity:

- payload family
- consumer guarantees
- what must still be read from authoritative state

### 3. When is invalidation enough?

Question:

- do consumers really need change data, or only a signal to refresh or recompute?

Expected design clarity:

- invalidation-only use cases
- refresh owner
- avoidance of fake payload richness

### 4. When are multiple changes batched or suppressed?

Question:

- what low-level changes collapse into one higher-level notification?

Expected design clarity:

- batching or coalescing rule
- duplicate suppression rule
- what intermediate states are intentionally hidden

### 5. What may consumers assume about timing and ordering?

Question:

- are notifications immediate, deferred, frame-batched, or transaction-batched?

Expected design clarity:

- emission timing
- ordering guarantees, if any
- whether consumers may observe intermediate state

### 6. How do consumers recover from missed or invalidated updates?

Question:

- what should a consumer do when it only receives invalidation or a coalesced change?

Expected design clarity:

- refresh strategy
- re-read boundary
- handling of dropped or consolidated information

### 7. Is noisy or misleading notification behavior inspectable?

Question:

- can a reviewer explain why a consumer refreshed, missed, or coalesced changes?

Expected design clarity:

- diagnostics for invalidation and suppression
- visibility into batch boundaries
- meaningful traces instead of callback mysticism

## Cross-foundation handoff prompts

Use these prompts when notification review reveals that change semantics are only one layer of the real issue.

- If consumers mainly disagree about truth ownership, freshness, or what counts as current state, pair with `game-development-world-state-facts`.
- If the design cannot explain when reevaluation happens because cadence or clock policy is still fuzzy, pair with `game-development-time-source-and-tick-policy`.
- If payloads are unsafe because they carry unstable targets or direct references across time, pair with `game-development-entity-reference-boundary`.
- If listeners are really reacting through reusable guards, score triggers, or condition gates, pair with `game-development-condition-rule-engine`.

## Minimum acceptable clarity

A state-change notification design should be considered under-specified if you cannot answer all of the following:

- what changes are externally meaningful
- what the payload means
- when invalidation is used instead of update data
- when batching or suppression happens
- what consumers may assume about timing
- how consumers recover from consolidated or omitted detail

## Smells

These are strong warning signs:

- "everything emits OnChanged"
- consumers assuming payloads always contain the full truth
- diff and snapshot notifications mixed with no explicit semantics
- batching happening implicitly because of frame timing rather than design
- duplicate notification floods treated as normal cost of doing business
- invalidation signals with no clear owner responsible for refresh
- no way to inspect why one consumer refreshed and another did not
