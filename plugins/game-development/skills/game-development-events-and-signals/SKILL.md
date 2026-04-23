---
name: game-development-events-and-signals
description: Use when gameplay, UI, interaction, or cross-system flow is accumulating signal spaghetti, hidden event coupling, duplicate subscriptions, or unclear direct-call vs event boundaries, and the agent must design or review an events-and-signals topology with explicit ownership, lifecycle, payload, and traceability rules.
---

# Game Development Events and Signals

Use this skill when the hard part is not behavior architecture or command dispatch, but **how systems notify each other cleanly without collapsing into signal spaghetti or a global event swamp**.

This skill is for designing, reviewing, or refactoring event and signal topology in gameplay, UI, interaction, and cross-system flows. Its job is to decide when direct calls are clearer than notifications, where synchronous signals or events are justified, when queues are actually needed, and how to keep publishers, subscribers, payloads, and lifecycle rules explicit.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot signals, C# event lifecycle, UnityEvent inspector wiring, or equivalent framework constraints.

For reusable heuristics covering topology, payload design, lifecycle, observability, and escalation to queues, see `references/events-and-signals-design-guide.md`.

## Purpose

This skill is used to:

- determine whether events or signals are justified at all
- choose the delivery model deliberately
- define clear publisher and subscriber ownership boundaries
- make event contracts and lifecycle rules explicit enough to review
- return a structured event-topology design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- gameplay, UI, audio, tutorial, quest, or analytics hooks are being stitched together with unclear notifications
- a project has growing signal spaghetti, event soup, or invisible cross-system coupling
- the team needs to decide whether a relationship should stay a direct method call or become an event/signal link
- multiple listeners need to react to the same happening without the sender knowing them directly
- the project already uses Godot signals, C# events, UnityEvents, or event channels and needs design cleanup
- requests that explicitly mention `signal`, `event`, `observer`, `event bus`, `pub/sub`, `subscription`, `unsubscribe`, or `event channel`

### Trigger examples

- "Our UI and gameplay code are connected by too many signals"
- "Should this stay a direct call or become an event?"
- "We keep getting duplicate subscriptions after scene reloads"
- "How should these systems communicate without hidden coupling?"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing behavior architecture across FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the task is primarily command dispatch, undo/redo, replay, or action execution flow rather than notification topology
- one direct dependency is already legitimate and clearer than introducing notifications
- the real need is time-decoupled batching, aggregation, or thread handoff rather than synchronous notification; use queue or messaging guidance instead of stretching signals too far
- the task is a localized runtime bug investigation rather than event-topology design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-coordinator` if the main problem is one bounded scene or subsystem seam rather than publisher/subscriber topology itself.
- Start with `game-development-command-flow` if the message really means "please do this action" rather than "this happened."
- Pair with `game-development-state-change-notification` when the hard part is payload meaning, diff-vs-snapshot semantics, invalidation, or batching rather than wiring alone.
- Pair with `game-development-entity-reference-boundary` when event payloads risk carrying stale references, unsafe handles, or dead object pointers.
- Pair with `game-development-time-source-and-tick-policy` when delivery should shift by phase, cadence, deferred update window, or explicit throttling policy.
- Hand off to `game-development-condition-rule-engine` or `game-development-world-state-facts` when listeners are really reacting to shared rules or fact freshness rather than communication topology.

## Diagnostic checklist

Evaluate these questions before recommending or refining an events-and-signals design:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is decoupling actually needed? | Multiple unrelated listeners may care | One direct dependency is already the clearest truth |
| Is synchronous notification acceptable? | Handlers should react immediately and return quickly | Delivery must be deferred, aggregated, or handed to another update phase |
| Is the ownership boundary clear? | Publisher and subscribers belong to distinct concerns | Notifications are compensating for muddy architecture |
| Is lifecycle explicit? | Connect/disconnect timing is nameable | Listeners appear and disappear with no cleanup discipline |
| Is the payload stable enough? | Receivers can act on explicit event data | Receivers must look up ephemeral world state that may already differ |
| Is traceability good enough? | You can explain who sends, who listens, and why | Communication only exists at runtime in invisible wiring |

## Decision rules

Before recommending any event or signal topology, ask whether the smaller honest answer is:

- a direct method call between already legitimate collaborators
- a local callback or delegate owned by one feature boundary
- a state transition, rule table, or behavior architecture change
- a command or request object rather than a notification
- a queue because the real need is time decoupling, aggregation, or thread handoff

Reject events or signals if the proposal mostly hides straightforward ownership behind nicer vocabulary.

### Prefer a direct call when

- there is one clear receiver
- the caller already legitimately knows the callee
- the sender needs an immediate result, success/failure, or return value
- hiding the link behind notifications would make the code harder to reason about

### Prefer synchronous events or signals when

- one happening should notify multiple listeners immediately
- the sender should not know who is listening
- handlers should react now and return quickly
- the event data is still valid at emission time

### Prefer a scoped channel or shared event object when

- the project benefits from a shared authoring surface, such as Unity inspector wiring or an explicit scene/system event boundary
- the relationship is broader than one direct publisher/subscriber pair but should still stay scoped to a domain, scene, or subsystem
- a global bus would be too vague but some shared hub is still justified

### Escalate to a queue when

- the receiver should process the work later
- requests must be aggregated or throttled
- the work belongs to a different phase, thread, or update loop

## Workflow

Follow this sequence every time.

### 1. Identify the communication boundary

State what is trying to notify what before naming events, buses, or channels.

### 2. Map the current communication paths

List the existing paths and note whether each one is local, scene-scoped, system-scoped, or effectively global.

### 3. Choose the delivery model

For each important link, decide whether it should be a direct call, synchronous event or signal, scoped channel, or queue, and say why.

### 4. Define the publisher/subscriber topology

For each event link, specify:

- publisher
- subscriber(s)
- scope
- why the decoupling is justified
- whether the relationship is one-to-one or one-to-many

### 5. Define the event contract

Specify:

- event or signal name
- tense and meaning
- payload fields
- whether the payload describes something that happened or requests something to happen
- delivery assumptions such as ordering, single-fire, or idempotence

### 6. Define lifecycle and subscription rules

Specify:

- when listeners connect
- when listeners disconnect
- how duplicate subscriptions are prevented
- how pooled, freed, disabled, or scene-reloaded objects avoid stale handlers
- whether lambda captures or anonymous handlers are safe in the target runtime

### 7. Add observability and safety hooks

Useful hooks include:

- event flow logs
- publisher/subscriber diagrams or tables
- duplicate-subscription checks
- runtime connection inspection where supported
- feedback-loop detection notes

### 8. Plan the rollout

Migrate incrementally: identify the highest-value boundary, replace the messiest path first, define lifecycle rules before broadening listeners, add traceability, and verify delivery plus cleanup before expanding scope.

## Output contract

Return the result using `assets/events-and-signals-brief.md` in this section order.

If the best answer is **not** events or signals, still use the template and say that explicitly instead of forcing the codebase into an event religion.

Return the result in these sections:

1. **Communication boundary**
2. **Direct call vs event vs queue decision**
3. **Publisher/subscriber matrix**
4. **Event contract design**
5. **Lifecycle and subscription model**
6. **Engine integration notes**
7. **Migration plan**
8. **Verification notes**

Keep the section order stable so event-topology recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Prefer typed signal/event APIs where possible over stringly wiring.
- Pair signal connections with explicit lifecycle boundaries such as `_EnterTree()` / `_ExitTree()` or equivalent owner hooks.
- Be careful with captured lambdas in C# signal subscriptions; automatic disconnection is not always reliable there.
- Use manual cleanup expectations or duplicate-guard checks when reconnect paths can run more than once.

### Unity

- Prefer plain C# events for code-owned runtime links that do not need inspector authoring.
- Prefer `UnityEvent` when serialized inspector wiring and persistent listeners materially improve workflow.
- Treat ScriptableObject-backed channels as scoped authoring assets, not the default nervous system for the whole game.
- Keep scene unload, listener disable, and target lifetime rules explicit.

### Generic C# / engine-neutral

- Use event names that reflect time semantics clearly: past tense for things that happened, present-tense or cancellable phrasing only when that distinction matters.
- Keep a reference to delegates or handlers you will need to unsubscribe later.
- Do not hand-wave cleanup responsibility when receiver lifecycle is fuzzy.

## Common pitfalls

- introducing events where one direct dependency is already clearer
- hiding architectural muddiness behind a bus or channel abstraction
- duplicate subscriptions after re-entry, re-enable, pooling, or scene reload
- using anonymous or captured handlers that cannot be cleaned up safely
- publishing events whose payload is too thin for delayed or decoupled handling
- relying on listener ordering when the design claims listeners are independent
- creating a global event bus that becomes a dumping ground for everything
- using synchronous notifications for work that should really be queued or throttled

## Companion files

- `references/events-and-signals-design-guide.md` — reusable heuristics for choosing direct call vs signal vs queue, shaping event contracts, lifecycle rules, observability, and engine-aware guidance
- `assets/events-and-signals-brief.md` — reusable output template for returning the event-topology design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler direct-call alternative was considered first
- direct call vs event vs queue was decided explicitly
- publishers, subscribers, scope, and payload meaning are concrete enough to review
- lifecycle and unsubscription rules are explicit
- engine-native features are used intentionally, not by accident
- rollout steps are incremental enough to verify safely
- the design does not expand into a vague global bus without justification

## Completion rule

This skill is complete when the agent has:

- decided whether events or signals are justified at all
- identified the communication boundary and delivery model
- defined the publishers, subscribers, scope, and event contracts
- specified lifecycle and duplicate-subscription rules
- described engine integration notes where relevant
- returned a concrete migration and verification brief