# Failure and cancellation cases for resource transactions

Use this reference when reviewing a proposed transaction model and you need sharper language around what can fail, when it can fail, and how the system should react.

## Core principle

A transaction model is weak when every bad outcome is labeled simply as "failed".

A useful review should distinguish at least the cases that change:

- user-facing behavior
- rollback policy
- auditability
- system integrity
- follow-up control flow

## Failure families

### 1. Not affordable at validation time

Question:

- did the action ever have enough value to begin with?

Expected design clarity:

- where affordability is checked
- whether the caller gets a reason or only a rejection
- whether this is preview-visible before execution starts

### 2. Reservation could not be created

Question:

- did provisional locking fail before execution began?

Expected design clarity:

- whether reservation creation is atomic
- what happens when contention exists
- whether retry is allowed or meaningful

### 3. Reservation became stale before commit

Question:

- was the claim valid earlier but no longer valid now?

Expected design clarity:

- invalidation triggers
- timeout or expiration behavior
- whether the caller retries, revalidates, or fails fast

### 4. Execution failed after reservation

Question:

- did the action reserve value successfully, then fail before completion?

Expected design clarity:

- whether rollback is full, partial, or none
- whether side effects outside the resource system also need compensation
- how the failure is surfaced to callers or logs

### 5. User or system cancellation

Question:

- was the action intentionally canceled rather than rejected or broken?

Expected design clarity:

- whether cancellation refunds fully
- whether cancellation after a certain stage forfeits value
- whether cancellation and hard failure differ in UX or telemetry

### 6. Owner or target disappeared

Question:

- did the transaction lose a required actor, target, or execution context before commit?

Expected design clarity:

- who detects disappearance
- whether reservations auto-release
- whether the transaction record remains auditable after cleanup

### 7. Double spend or duplicate commit risk

Question:

- can the same transaction path commit more than once accidentally?

Expected design clarity:

- idempotency expectations
- duplicate submission handling
- retry safety

### 8. Preview and commit diverged

Question:

- did UI, AI, or planning preview a different affordability answer than execution ultimately used?

Expected design clarity:

- whether preview shares the same validation logic
- whether stale preview is possible and how it is surfaced
- whether the system tolerates divergence or treats it as a bug smell

## Review questions

Use these questions when evaluating a proposed resource-transaction model:

- Which failure cases are intentionally distinguished?
- Which cases are intentionally collapsed together, and why is that acceptable?
- When does the system still owe a refund, release, or cleanup action?
- Which failures are visible to users, and which are internal only?
- How does the model prevent invisible value loss or accidental double spend?
- If a queued action resolves much later, what protects the transaction from becoming stale nonsense?

## Cross-foundation handoff prompts

Use these prompts when transaction failures keep pointing at another design seam.

- If "failure" really means stale observations, missing world truth, or planner-visible drift, pair with `game-development-world-state-facts`.
- If the dispute is mostly about when windows expire, when retries are allowed, or which clock owns reservation life, pair with `game-development-time-source-and-tick-policy`.
- If queued or delayed execution fails because payload references went stale, pair with `game-development-entity-reference-boundary`.
- If preview, invalidation, or change bursts are driving retries and refresh logic, pair with `game-development-state-change-notification`.

## Minimum acceptable clarity

A transaction design should be considered under-specified if you cannot answer all of the following:

- what counts as not affordable
- what counts as reserved
- what counts as committed
- what happens on cancellation
- what happens on failure after provisional success
- who owns cleanup for stale or abandoned transactions

## Smells

These are strong warning signs:

- "we'll just handle failures case by case"
- one generic `TrySpend()` hiding several materially different outcomes
- refunds that only happen because a particular caller remembered to do them
- preview paths that knowingly use looser rules than commit paths
- action queues that create reservations with no expiration or invalidation policy
- transaction state hidden in unrelated runtime objects with unclear lifetime
