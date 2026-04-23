# Notification shapes guide

Use this reference when the main skill needs sharper language for deciding what counts as a meaningful state change, when diff payloads beat snapshots, or how to avoid turning every mutation into noisy observer spam.

## Start with the smallest honest question

A state-change notification model should answer a focused question such as:

- what changes deserve external notification at all?
- when should the notification fire?
- what should the payload mean?
- when is invalidation enough?
- when should several changes coalesce into one update?

If the real question is only "should this one callback fire here?", a shared notification model may be unnecessary.

## Common notification shapes

### 1. Local callback

Use when:

- one owner and one nearby consumer care
- there is no shared payload contract across systems
- abstraction would mostly rename one direct update path

Good fit:

- one local UI refresh
- one owner-private cache invalidation
- one feature-local change response

Do not extract this into a shared change model unless reuse pressure is real.

### 2. Invalidation-only signal

Use when:

- consumers only need to know that derived or cached state is no longer trustworthy
- authoritative state is better re-read on demand
- sending full payload data would mostly duplicate the source of truth

Good fit:

- derived score invalidation
- dirty flags for planner views
- cache refresh triggers

### 3. Diff payload

Use when:

- consumers benefit from knowing what changed rather than re-reading everything
- update granularity materially affects behavior or cost
- the system can explain diff semantics consistently

Good fit:

- inventory delta notifications
- status-effect add/remove updates
- set membership changes where full snapshots would be noisy

### 4. Snapshot payload

Use when:

- consumers need a coherent post-change view
- a full snapshot contract is easier to reason about than several deltas
- batching or coalescing naturally produces one stable update image

Use this when clarity beats micro-optimization.

### 5. Batched or coalesced notification

Use when:

- one logical update produces several low-level mutations
- observers care about the end result, not every intermediate change
- notification floods would otherwise waste work or hide meaning

A batch is only helpful if consumers know what guarantees it provides.

## Boundary stress tests

Use these tests when a notification design sounds clean but may still be mixing wiring, meaning, and freshness into one blurry layer.

### Test 1. Is this really a shared notification, or one local callback?

Ask:

- does more than one meaningful consumer need the same change semantics?
- would a direct local update stay clearer because there is only one nearby consumer?

If yes, keep it local.

### Test 2. Is the payload richer than the consumer actually needs?

Ask:

- do consumers truly need a diff or snapshot, or only an invalidation hint?
- is payload detail being added because authoritative re-read boundaries were never made explicit?

If consumers only need to know that state is dirty, prefer invalidation over decorative payloads.

### Test 3. Is the hard part topology rather than meaning?

Ask:

- are people actually arguing about who publishes, who subscribes, and how lifecycle wiring works?
- would the payload question stay easy if the communication boundary were already clear?

If yes, move closer to events-and-signals and keep notification semantics narrower.

### Test 4. Is polling hiding a missing change boundary?

Ask:

- are consumers reevaluating constantly because no one defined meaningful notifications?
- or are notifications being added because a time-policy or fact-freshness issue is still unresolved?

If either is true, pair the design with time policy or world-state facts instead of letting notification semantics absorb every mismatch.

## Boundary guidelines

## Separate meaningful change from raw mutation

Avoid confusing:

- local internal mutation
- externally meaningful state change
- invalidation of derived state
- audit or replay events
- generic framework callbacks

Consumers should not have to guess whether a notification means "something changed" or "this exact semantic update happened".

## Payload meaning first

A payload should earn its existence by making consumers clearer or cheaper, not merely more clever.

For each payload family, be able to answer:

- is this a diff, snapshot, tag, or invalidation notice?
- what may consumers rely on?
- what data is intentionally omitted?
- what should consumers re-read from the source of truth?

If those answers are fuzzy, the payload model is not ready.

## Timing and batching

Many notification bugs come from silently mixing:

- immediate notifications
- deferred notifications
- frame-batched notifications
- transaction-batched notifications
- best-effort suppressed duplicates

A usable change model should make it possible to answer:

- when is the signal emitted?
- may consumers observe intermediate state?
- what changes coalesce?
- what ordering assumptions are safe?

## Relationship to adjacent foundations

### Not the same as event topology

An event or signal topology explains routing and coupling boundaries.
A state-change model explains what the notification means and when it should fire.

### Not the same as world-state facts

A fact model explains what is true, observed, or stale.
A state-change notification model explains how consumers learn that truth changed or became invalid.

### Not the same as time policy

A time policy explains cadence and reevaluation.
A notification model explains whether meaningful changes emit immediately, later, batched, or only as invalidation.

### Not the same as full UI architecture

A state-change notification model may help UI refresh rules.
It should not automatically become a full presentation-layer doctrine.

## Smells that justify review

Run a review when you see patterns such as:

- UI, AI, and caches all reacting to the same change differently
- every mutation emitting something with no named semantic boundary
- diff payloads that consumers interpret inconsistently
- snapshots used where invalidation would have been clearer
- redundant bursts of notifications after one logical update
- suppressed changes that nobody can explain later
- observers relying on notification payloads as if they were the source of truth

## Decision shortcuts

If in doubt, use this shortcut:

- **one owner, one nearby consumer** -> local callback
- **consumer only needs refresh hint** -> invalidation-only notification
- **consumer needs exact delta** -> diff payload
- **consumer needs coherent post-change view** -> snapshot payload
- **many low-level writes equal one meaningful change** -> batched or coalesced notification
