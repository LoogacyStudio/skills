# Events and Signals Design Guide

Use this reference to keep game event topology understandable, scoped, and reviewable instead of letting it collapse into signal spaghetti, hidden coupling, or a global event swamp.

## What this pattern family is actually for

Events and signals are strongest when one system needs to announce that **something happened** without hard-coding who reacts to it.

Common fits:

- gameplay state changes that UI, audio, analytics, or tutorial systems may react to
- interaction boundaries where several unrelated listeners may care
- scene or subsystem notifications where one publisher should not know all listeners

Weak fits:

- one sender with one legitimate receiver and an immediate return value
- command dispatch, undo/redo, or queued action execution
- time-decoupled work that should be aggregated, throttled, or processed later

## Delivery model chooser

Choose the lightest communication shape that matches the real need.

| Model | Best fit | Main benefit | Main warning sign |
| --- | --- | --- | --- |
| Direct call | One clear dependency | Maximum clarity and debuggability | Hidden abstraction adds more confusion than coupling |
| Synchronous signal / event | One-to-many notification now | Decouples sender from listeners without time delay | Slow handlers block the sender |
| Scoped channel / shared event object | Domain- or scene-level shared authoring surface | Keeps several publishers/listeners aligned without a giant global bus | Scope quietly expands until everything routes through it |
| Queue / deferred message | Work must happen later, elsewhere, or in aggregate | Time decoupling, batching, phase or thread handoff | Payload stales, feedback loops, or sender loses necessary response semantics |

Practical rule:

- If you only need to decouple **who** receives the notification, synchronous signals/events are usually enough.
- If you need to decouple **when** it gets processed, you are in queue territory.

## Publisher/subscriber topology questions

For every proposed link, ask:

- Who publishes this?
- Who subscribes, and why?
- Is this one-to-one, one-to-many, or many-to-many?
- Is the scope local, scene-level, subsystem-level, or effectively global?
- Would a direct method call be clearer?

Healthy topology looks like:

- publishers that announce domain-relevant happenings
- subscribers that belong to genuinely separate concerns
- explicit scope boundaries

Unhealthy topology looks like:

- notifications compensating for unclear ownership
- listeners that secretly depend on processing order
- a bus or channel that everything can read and everything can write

## Event naming and meaning rules

An event name is a contract, not decoration.

Prefer names that indicate something that **already happened**:

- `HealthChanged`
- `EnemyDefeated`
- `QuestCompleted`
- `health_depleted`

Use present-tense or cancellable naming only when that distinction is intentional:

- `Closing`
- `BeforeDoorOpens`

Avoid names that blur notification with command:

- `DoPlaySound`
- `HandleDamage`
- `RunQuestUpdate`

If the name sounds like an imperative request, you may really want a command, not an event.

## Payload discipline

Ask what receivers need to act safely.

Healthy payloads:

- contain the minimum stable facts needed by listeners
- are explicit about source, identifiers, and relevant values
- do not rely on listeners re-querying world state that may already differ

Warning signs:

- payload is so thin that receivers must inspect mutable global state
- payload is so heavy that the event becomes a disguised snapshot bus
- queued or deferred events reference objects whose relevant state may be gone later

Queued or delayed processing generally needs heavier, more stable payloads than synchronous events.

## Lifecycle and subscription discipline

Subscription bugs are where innocent event systems go to become ghost stories.

For each subscription, define:

- where it is connected
- where it is disconnected
- who owns the cleanup obligation
- how duplicate subscriptions are prevented

### Safe default rules

- connect and disconnect at explicit lifecycle boundaries
- keep a reference to handlers you will need to remove later
- guard reconnection paths with `is_connected()` or equivalent when the runtime allows it
- treat pooled, disabled, or scene-reloaded objects as lifecycle edge cases, not afterthoughts

### Common traps

- lambdas that capture variables and cannot be safely unsubscribed later
- custom event systems that do not auto-clean on receiver destruction
- repeated enable/acquire/re-enter paths that subscribe again
- assuming garbage collection implies automatic unsubscription semantics

## Ordering, blocking, and feedback loops

Synchronous notifications are immediate.

This means:

- a slow listener can block the publisher
- ordering may matter more than people admit
- re-entrant notifications can create cycles quickly

Review questions:

- must listeners finish quickly?
- does any listener publish another event while handling this one?
- would a queue or deferred work item be safer for slow processing?
- do multiple listeners accidentally rely on order?

If listener order matters for correctness, the system is less decoupled than it claims.

## Observability and debugging

If communication is implicit, debugging must become explicit.

Useful tools:

- publisher/subscriber matrices in docs or review artifacts
- event flow logging
- connection inspection where supported
- duplicate-subscription tests
- feedback-loop notes or guards

If you cannot explain who sends, who listens, and why, the event system is already too magical.

## Engine-aware notes

### Godot / .NET

- Godot signals are first-class and can be connected through typed APIs.
- In C#, prefer typed events where possible for better safety.
- Pair subscriptions with explicit node lifecycle boundaries.
- Capturing lambdas and some custom signal scenarios may require manual disconnect discipline.
- `ToSignal(...)`, timers, and async continuations can blur lifecycle boundaries if a receiver becomes stale.

### Unity

- Plain C# events are a strong default for code-owned runtime notifications.
- `UnityEvent` is valuable when persistent inspector wiring materially helps designers or authoring flow.
- `UnityEvent` listeners and serialized callbacks still have lifetime implications; treat them as topology, not magic.
- ScriptableObject-backed event channels can be useful as scoped assets, but do not treat them as the automatic answer for every communication problem.

### Generic C# / engine-neutral

- Events provide synchronous broadcast semantics by default.
- Delegate references must be preserved if unsubscription is required later.
- If delayed processing is needed, move to a queue deliberately instead of smuggling time decoupling into synchronous notifications.

## Rejection heuristics

Reject or down-rank an events/signals recommendation when:

- a direct call is already the honest relationship
- the proposed bus or channel has no clear scope boundary
- the system needs a response value or command semantics rather than broadcast notification
- lifecycle cleanup cannot be explained clearly
- the proposal exists mainly to hide architecture confusion behind a nicer vocabulary

## Review checklist

Before approving an events/signals design, verify that:

1. a direct-call alternative was considered first
2. direct call vs synchronous event vs queue was decided explicitly
3. publishers, subscribers, and scope are concrete
4. event names describe happenings rather than commands
5. payloads are stable enough for their delivery model
6. connect/disconnect timing is explicit
7. duplicate-subscription risk is addressed
8. blocking, ordering, and feedback-loop risks were considered
9. observability is good enough to debug the topology
