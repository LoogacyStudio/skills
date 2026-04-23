# Identity vs reference guide

Use this reference when the main skill needs sharper language for deciding what counts as stable gameplay identity, when direct references are acceptable, or how handles and lookups should replace unsafe pointer retention.

## Start with the smallest honest question

An entity-reference boundary should answer a focused question such as:

- what counts as stable identity here?
- when is a direct reference safe enough?
- when should a system store a handle or ID instead?
- how is lookup performed, and by whom?
- what happens when the target no longer exists?

If the real question is only "can this one method pass a local reference right now?", a shared reference policy may be unnecessary.

## Common reference shapes

### 1. Local direct reference

Use when:

- the reference is used immediately and locally
- there is no delayed handoff or cross-system payload risk
- abstraction would mostly rename an obvious object field or parameter

Good fit:

- one local interaction method call
- one immediate state transition inside the same owner boundary
- one short-lived helper invocation

Do not extract this into a shared reference layer unless reuse pressure is real.

### 2. Stable gameplay identity

Use when:

- consumers need to refer to the same conceptual entity across time
- the runtime object may disappear, respawn, reload, or be pooled
- reviewability improves when identity is not conflated with one specific object instance

Examples:

- actor ID
- target ID
- gameplay entity handle backed by a registry
- stable slot or unit identity separate from scene object lifetime

### 3. Handle plus lookup

Use when:

- references may cross frames, queues, or subsystem boundaries
- consumers should resolve the current object only when needed
- stale resolution must become an explicit case rather than silent pointer rot

A handle is only useful if lookup ownership and failure behavior are explicit.

### 4. Path or locator reference

Use when:

- the design relies on structured lookup within a known hierarchy
- the path semantics are actually stable enough for the use case
- consumers can explain why a locator is safer than retaining a raw object reference

Be careful.
A path is not automatically stable identity.

### 5. Payload-safe projection

Use when:

- a message or queue only needs targeting information, not full object access
- several downstream consumers may resolve differently
- the system benefits from carrying lightweight identity plus metadata instead of a full pointer

Examples:

- target ID plus team or zone context
- interaction token plus origin metadata
- queue item storing handle plus intent data

## Boundary stress tests

Use these tests when a reference proposal sounds safe on paper but may still be relying on accidental object lifetime.

### Test 1. Is this really cross-time identity, or one immediate local pointer?

Ask:

- will the consumer use the value right away inside one owner boundary?
- would a handle only add ceremony without improving safety?

If yes, keep the direct reference local.

### Test 2. Could the object stay alive while becoming the wrong thing?

Ask:

- can pooling, respawn, rebind, or scene churn make the instance technically present but semantically wrong?
- would a null check fail to catch the real mismatch?

If yes, the design needs explicit identity semantics, not just lifetime checks.

### Test 3. Is the real issue lookup ownership rather than reference form?

Ask:

- are several systems allowed to resolve handles however they want?
- would two consumers resolve the same token differently or at unsafe times?

If yes, the boundary needs stronger lookup ownership before it needs fancier handle types.

### Test 4. Is the payload trying to carry authority it should not have?

Ask:

- does a message or queue item actually need full object access, or only identity plus enough metadata to resolve safely later?
- are direct references being used because no one specified a smaller payload contract?

If yes, prefer payload-safe projections over shipping pointers by habit.

## Identity guidelines

## Name what is actually stable

For each entity family, be able to answer:

- what makes this entity the same entity over time?
- who issues or owns that identity?
- can a runtime object disappear while the identity still matters?
- can a pooled or respawned object reuse the same identity safely?
- what makes a reference stale or wrong?

If those answers are fuzzy, the reference model is not ready.

## Separate object lifetime from gameplay identity

Avoid confusing:

- the current runtime object instance
- the conceptual gameplay entity
- the handle or token used to resolve it
- the payload data that refers to it
- the registry or owner that tracks it

Consumers should not have to guess whether a value is a pointer, an ID, a path, or a conceptual identity.

## Lookup ownership

Many reference bugs come from everybody being allowed to resolve everything however they want.

A usable reference model should make it possible to answer:

- who is allowed to resolve this handle?
- where does the lookup happen?
- what happens if resolution fails?
- what happens if the resolved object is alive but semantically no longer the right target?

## Stale-reference shapes

### Target destroyed or despawned

Use when the referenced object no longer exists.

### Target pooled and reused

Use when the object exists but now represents different gameplay identity or state.

### Scene or subsystem reloaded

Use when references become invalid because the owning context changed.

### Delayed command resolved too late

Use when the payload was valid earlier but is no longer valid now.

### Locator still resolves but meaning drifted

Use when a path or registry lookup returns something technically present but semantically wrong.

Do not collapse all of these into one generic null case if design or debugging needs the distinction.

## Relationship to adjacent foundations

### Not the same as world-state facts

A fact model explains what is true, observed, or stale in world-state terms.
An entity-reference boundary explains how systems safely point at entities over time.

### Not the same as time policy

A time policy explains cadence and reevaluation.
The reference boundary explains whether something can still be resolved safely when the time comes.

### Not the same as event topology

Event systems may transport identity or references.
The reference boundary explains what those payloads are allowed to carry.

### Not the same as networking identity by default

A local gameplay identity model may inform future network design.
It should not automatically expand into full distributed identity doctrine.

## Smells that justify review

Run a review when you see patterns such as:

- delayed commands firing on dead targets
- pooled objects reappearing with accidental identity reuse
- events carrying direct references across subsystem boundaries casually
- several systems mixing IDs, handles, object refs, and paths with no naming discipline
- disagreement about whether a null means dead target, missing lookup, or stale payload
- registries or lookup services that anybody may call with no ownership rules
- scene reloads or transitions invalidating payloads unpredictably

## Decision shortcuts

If in doubt, use this shortcut:

- **one use, one owner, one frame** -> local direct reference
- **entity must remain referable across time** -> stable gameplay identity
- **reference crosses queues or subsystems** -> handle plus lookup
- **payload only needs targeting data** -> payload-safe projection
- **people argue about whether a reference is still valid** -> make lifetime and stale-resolution rules explicit first
