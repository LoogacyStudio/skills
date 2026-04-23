# Stale-reference checklist

Use this reference when reviewing a proposed entity-reference boundary and you need sharper language around lifetime safety, lookup failure, pooled reuse, or payloads that may outlive the references they carry.

## Core principle

A reference model is weak when every bad outcome is treated as either "null" or "probably still fine".

A useful review should distinguish at least the choices that change:

- lifetime safety
- payload validity
- lookup ownership
- pooled-object correctness
- debugging clarity
- cross-system trust

## Review questions

### 1. What counts as stable identity here?

Question:

- what makes this entity the same entity over time for the consumers that care?

Expected design clarity:

- identity type
- identity owner or issuer
- difference between object instance and gameplay identity

### 2. When is a direct reference allowed?

Question:

- where is direct pointer retention acceptable, and where is it not?

Expected design clarity:

- local-only boundaries
- delayed-use restrictions
- cross-system payload restrictions

### 3. Who owns handle resolution?

Question:

- which subsystem resolves IDs, handles, or locators into current runtime objects?

Expected design clarity:

- lookup owner
- failure behavior
- guard against ad-hoc global lookup sprawl

### 4. What happens if the target is gone?

Question:

- how does the system respond when the referenced entity no longer exists?

Expected design clarity:

- rejection or fallback behavior
- cleanup path
- diagnostics or traceability

### 5. What happens if pooling or reuse makes the object look alive but wrong?

Question:

- can the same runtime object be reused in a way that breaks stale-reference assumptions?

Expected design clarity:

- pooled reuse policy
- identity reuse rules
- how consumers detect semantic mismatch rather than mere nullness

### 6. What may events, commands, or queues carry?

Question:

- are cross-system payloads allowed to store direct references, IDs, handles, or only projections?

Expected design clarity:

- payload safety rules
- minimum information needed to re-resolve
- avoidance of accidental lifetime coupling

### 7. Is stale-reference inspection good enough?

Question:

- can a reviewer explain why a resolution failed or why a payload became stale?

Expected design clarity:

- minimum diagnostics
- whether direct vs handle-based references are visible in traces
- whether pooled reuse or late resolution is classifiable

## Cross-foundation handoff prompts

Use these prompts when reference review keeps surfacing issues that are only partly about handles or pointers.

- If the real dispute is whether the target is still true, visible, current, or planner-valid, pair with `game-development-world-state-facts`.
- If delayed resolution failures depend mainly on timing windows, cadence, or timeout ownership, pair with `game-development-time-source-and-tick-policy`.
- If payloads are stale because the notification contract is weak or invalidation boundaries are missing, pair with `game-development-state-change-notification`.
- If the payload is really an action request with validation and delayed execution semantics, pair with `game-development-command-flow`.

## Minimum acceptable clarity

An entity-reference design should be considered under-specified if you cannot answer all of the following:

- what counts as stable identity
- when direct references are allowed
- when handles or IDs are required
- who owns lookup
- what invalidates the reference
- what consumers should do when resolution fails or returns the wrong semantic target

## Smells

These are strong warning signs:

- "we just pass the object around"
- events or commands carrying raw references far beyond their safe lifetime
- global lookups with no ownership or failure policy
- pooled objects reusing identity accidentally
- stale-reference problems showing up only as random null checks
- path-based lookups assumed stable because they worked in one scene layout
- no way to tell whether a payload carried an ID, handle, or direct object ref
