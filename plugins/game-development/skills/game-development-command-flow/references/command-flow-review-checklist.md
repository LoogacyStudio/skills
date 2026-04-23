# Command-flow review checklist

Use this checklist to review a proposed command-flow model before the codebase commits to ceremonial action objects, vague invokers, or queue machinery that solves the wrong problem very confidently.

## Command necessity and fit

- [ ] Was a simpler direct-call alternative considered first?
- [ ] Is there a real action boundary that can be named independently of the current caller?
- [ ] Do multiple producers genuinely need the same action surface?
- [ ] Does the command model improve ownership, timing, or history semantics rather than merely renaming calls?

## Producer and executor clarity

- [ ] Are producers, invokers, and executors named concretely?
- [ ] Is it explicit who owns side effects and validation?
- [ ] Does the model avoid hiding execution authority behind a vague central invoker?
- [ ] Can reviewers explain who would still be responsible if commands were removed?

## Contract and execution model

- [ ] Does each command have explicit intent, parameters, target/context, and side-effect meaning?
- [ ] Is immediate vs queued vs deferred vs historical execution chosen deliberately?
- [ ] Are cancellation, expiration, or stale-pending rules explicit when timing is decoupled?
- [ ] Is the command model clear about which commands are reusable contracts versus one-shot historical records?

## Validation, failure, and history discipline

- [ ] Are preconditions and validation boundaries explicit?
- [ ] Is failure behavior intentional rather than hidden in deep receiver code?
- [ ] If undo/redo is required, is the reversible state explicit enough to trust?
- [ ] If replay is required, does the contract rely on stable data rather than fragile runtime references?

## Queue, replay, and observability

- [ ] Is queue ownership explicit where queueing exists?
- [ ] Are stale-command handling and backpressure or rejection rules named where relevant?
- [ ] Are command creation, validation, rejection, queue depth, or replay traces inspectable?
- [ ] Does the model avoid adding history, queueing, and replay all at once before one action path is stable?

## Cross-foundation handoff prompts

Use these prompts when a command review keeps finding the same friction and the real problem likely lives nearby.

- If the message mostly describes something that already happened rather than requesting execution, pair with `game-development-events-and-signals`.
- If affordability, reservation, rollback, refund, or commit stages dominate the debate, pair with `game-development-resource-transaction-system`.
- If repeated command validation is really reusable eligibility logic, pair with `game-development-condition-rule-engine`.
- If delayed or replayed commands depend on unstable targets or handles, pair with `game-development-entity-reference-boundary`.
- If timing windows, buffering cadence, or invalidation policy are the real source of complexity, pair with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification`.

## Rollout safety

- [ ] Can one high-value action boundary migrate first?
- [ ] Are producer and executor paths comparable during rollout?
- [ ] Is validation centralized before queueing or history spreads?
- [ ] Are verification notes strong enough to catch silent failures, stale pending commands, or undo corruption early?

## Final reviewer question

If this command layer were removed tomorrow, would the team still say the real problem was action-request architecture rather than events, timing policy, or transaction semantics?

- If **no**, the command model may still be compensating for a different missing boundary.
- If **yes**, the command boundary is more likely justified.
