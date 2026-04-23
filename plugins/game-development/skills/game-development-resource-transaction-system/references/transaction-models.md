# Transaction models and ownership guide

Use this reference when the main skill needs sharper language for choosing a transaction shape, separating ownership from authoring convenience, or preventing gameplay resource logic from devolving into inconsistent invisible mutations.

## Start with the smallest honest question

A transaction model should answer a focused question such as:

- when do we check affordability?
- when is value actually spent?
- do we need reservation before execution?
- what happens on cancellation or failure?

If the real question is only "can this one action pay this one cost right now?", a local check may be enough.

## Common transaction shapes

### 1. Local immediate spend

Use when:

- one action validates and executes in one step
- interruption after validation is negligible
- there is no need for shared preview, reservation, or refund logic

Good fit:

- one local interaction
- one editor tool action
- one tightly scoped non-queued ability

Do not extract this into a shared transaction layer unless reuse pressure is real.

### 2. Shared immediate spend

Use when:

- several systems need the same affordability and spend semantics
- the action still commits immediately after validation
- reservation is unnecessary but consistency matters

Good fit:

- several ability entry points
- UI, AI, and input all triggering the same action family
- repeated cost semantics with identical timing

### 3. Reserve then commit

Use when:

- validation and execution are separated in time
- the system needs provisional claims before execution finishes
- queued actions, previews, or planning paths must not overbook resources

Good fit:

- queued command systems
- plan-then-execute flows
- interactions with interruptible wind-up time

Reservation only helps if invalidation and expiration rules are also explicit.

### 4. Reserve with timeout or invalidation

Use when:

- provisional claims may become stale
- ownership can change before commit
- the system needs to recover from abandoned or expired reservations

Examples:

- queued actions that may never fire
- targets or actors disappearing before completion
- multi-step actions that can time out or be canceled

### 5. Partial commit or staged commit

Use when:

- execution may succeed in phases
- the design needs to distinguish provisional progress from final success
- rollback is not always all-or-nothing

Use this carefully.
If the system does not truly need staged semantics, keep it simpler.

### 6. Refund or rollback model

Use when:

- cancellation after reservation is meaningful
- failure after provisional success must be handled explicitly
- UX and fairness depend on predictable recovery rules

Possible policies:

- full refund
- partial refund
- no refund
- conditional refund based on stage reached

If the team cannot explain the refund rule in one sentence, the model is not stable yet.

## Boundary stress tests

Use these tests when a transaction proposal sounds reasonable but may still be hiding the real design seam.

### Test 1. Is this really shared transaction semantics, or one local spend?

Ask:

- would a direct spend at one call site solve the real problem cleanly?
- is the proposed abstraction doing more than renaming one subtraction and one guard?

If not, keep it local.

### Test 2. Is preview doing the same job as commit?

Ask:

- will UI, AI, and runtime all rely on the same affordability answer?
- can a preview succeed while the actual execution later disagrees for predictable reasons?

If preview and commit have different rules, the model needs to say why instead of hoping nobody notices.

### Test 3. Is the hard part timing rather than spending?

Ask:

- does the design mainly hinge on windows, timeouts, queue latency, or delayed commit cadence?
- would two transaction shapes behave the same if time were not part of the problem?

If timing changes the meaning materially, pair the review with the time-source and tick policy rather than burying clock assumptions here.

### Test 4. Is the real risk stale truth or disappearing context?

Ask:

- does affordability depend on observed world state that may already be stale?
- can reservation fail later because the actor, target, or context vanished?

If yes, clarify world facts or entity/reference policy instead of forcing transaction semantics to compensate for missing ownership upstream.

## Ownership guidelines

## Name the source of truth

For each resource family, be able to answer:

- where does the authoritative value live?
- who is allowed to mutate it?
- who may only read or preview it?
- how does a provisional reservation relate to the committed value?

If those answers are fuzzy, the transaction model is not ready.

## Separate authoring data from runtime ownership

Avoid confusing:

- authored cost data
- runtime balance or state
- reservation records
- commit history

Examples:

- a ScriptableObject may define the cost shape, but it should not automatically become the mutable transaction ledger
- a Godot Resource may define transaction parameters, but the runtime mutation owner still needs to be explicit

## Preview versus commit

Many systems need to answer preview questions such as:

- can the player afford this?
- what would this action consume?
- what does AI think it can pay for?

Preview should not silently drift away from commit semantics.
If preview and commit disagree often, the model is lying to someone.

## Failure and cancellation shapes

### Not affordable

Use when the action never had enough value to begin with.

### Reservation invalidated

Use when the provisional claim used to be valid but is no longer valid now.

### Execution failed after reservation

Use when the system reserved value, then failed before final completion.

### Canceled by user or system

Use when the action stops intentionally rather than due to invalidity or hard failure.

### Target or owner disappeared

Use when the transaction cannot complete because the relevant actor, target, or context no longer exists.

Do not collapse all of these into one generic failure if design, UX, or debugging needs the distinction.

## Relationship to adjacent foundations

### Not the same as condition rules

A condition rule may answer whether a cost appears payable.
The transaction model decides when value is reserved, committed, refunded, or rolled back.

### Not the same as timing policy

A timing model may explain when reevaluation occurs.
The transaction model explains what resource state changes happen at each stage.

### Not the same as inventory architecture

An inventory system may store items or currencies.
A transaction model explains how value changes are validated and committed.

### Not the same as economy balancing

The transaction model is about consistency of semantics, not final tuning numbers.

## Smells that justify review

Run a review when you see patterns such as:

- UI, AI, and runtime all checking affordability differently
- repeated action costs with slightly different spend timing
- silent refunds or silent forfeits after cancellation
- queued or delayed actions that spend too early or too late
- mutations hidden inside unrelated animation or effect code
- disagreement about whether preview and commit are using the same rules
- several systems all believing they own the same resource

## Decision shortcuts

If in doubt, use this shortcut:

- **one action, one immediate spend, no reuse** -> keep it local
- **same spend semantics in several places** -> shared immediate spend model
- **validation and execution separated in time** -> consider reservation
- **cancellation or failure after reservation matters** -> define explicit refund or rollback policy
- **people argue about stale claims or ownership** -> make source of truth and invalidation rules explicit first
