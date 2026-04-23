# Events-and-signals review checklist

Use this checklist to review a proposed events-and-signals topology before notification links multiply into hidden coupling, cleanup bugs, or a bus that thinks it is a city planner.

## Necessity and delivery choice

- [ ] Was a direct-call alternative considered first?
- [ ] Was direct call vs synchronous event vs scoped channel vs queue decided explicitly?
- [ ] Does the relationship really describe "something happened" rather than "please do this"?
- [ ] Is the chosen delivery model justified by the actual timing need?

## Publisher/subscriber topology

- [ ] Are publishers, subscribers, and scope concrete enough to review?
- [ ] Is the topology one-to-one, one-to-many, or many-to-many by design rather than accident?
- [ ] Does the proposal avoid expanding into a vague global bus?
- [ ] Can reviewers explain why decoupling is valuable for each important link?

## Contract and payload discipline

- [ ] Do event names describe happenings rather than commands?
- [ ] Is payload meaning explicit and stable enough for the chosen delivery model?
- [ ] Are ordering, idempotence, or single-fire assumptions documented when they matter?
- [ ] Does the payload avoid depending on implicit mutable world state when listeners react later?

## Lifecycle and cleanup discipline

- [ ] Is it clear when listeners connect and disconnect?
- [ ] Is duplicate-subscription risk addressed explicitly?
- [ ] Are pooled, disabled, reloaded, or freed object paths covered by cleanup rules?
- [ ] Are anonymous handlers, captured lambdas, or runtime-specific cleanup traps reviewed explicitly?

## Blocking, loops, and observability

- [ ] Have blocking listeners or slow handlers been considered for synchronous links?
- [ ] Are feedback-loop or re-entrant emission risks named where relevant?
- [ ] Is listener ordering irrelevant, or explicitly acknowledged where correctness depends on it?
- [ ] Are logs, matrices, or inspection hooks planned so topology remains debuggable?

## Cross-foundation handoff prompts

Use these prompts when a notification review keeps finding problems that do not actually belong to topology alone.

- If the message really means an action request, validation path, or execution contract, pair with `game-development-command-flow`.
- If listeners mostly care about dirty-state, batching, or invalidation rather than open-ended broadcast, pair with `game-development-state-change-notification`.
- If delayed processing really needs explicit phases, cooldown windows, or cadence policy, pair with `game-development-time-source-and-tick-policy`.
- If payloads keep carrying stale handles, disappearing objects, or unsafe references, pair with `game-development-entity-reference-boundary`.
- If subscriptions sprawl because grouping or matching is weak, pair with `game-development-gameplay-tags-and-query`.

## Rollout safety

- [ ] Can one messy boundary be migrated first before broadening the event surface?
- [ ] Are current and proposed links comparable during rollout?
- [ ] Are cleanup rules introduced before adding more listeners?
- [ ] Are verification notes strong enough to catch duplicate subscriptions, missing listeners, or looped emissions early?

## Final reviewer question

If this event topology were removed tomorrow, would the team still say the real need was notification decoupling rather than command flow, invalidation policy, or lifecycle cleanup discipline?

- If **no**, the event layer may be hiding a different boundary.
- If **yes**, the topology is more likely justified.
