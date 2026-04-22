# Command Flow Design Guide

Use this reference to keep game command flow explicit, reviewable, and scoped instead of letting action dispatch dissolve into direct-call tangles, command soup, or queue mysticism.

## What this pattern family is actually for

Command flow is strongest when one or more systems need to express **a request to do something** independently from the place or moment where the work is actually executed.

Common fits:

- input, UI, AI, or tools issuing the same gameplay action surface
- turn queues, combo buffers, or resource-gated action execution
- undo and redo for tools, tactics, or puzzle-style interactions
- replay, record, or deterministic command streams

Weak fits:

- one sender with one legitimate receiver and an immediate result
- pure event topology where the real meaning is "something happened"
- low-level input binding with no need for shared action contracts
- timing indirection that could be solved by a simpler queue API without reifying commands

## Command family chooser

Choose the lightest command shape that matches the real need.

| Model | Best fit | Main benefit | Main warning sign |
| --- | --- | --- | --- |
| Direct call | One clear dependency | Maximum clarity and zero command ceremony | Shared action boundary does not really exist |
| Lightweight command | Multiple producers share one action surface | Decouples producers from execution details | Command object is just a renamed direct call wrapper |
| Queued / buffered command | Execution timing matters | Time decoupling, sequencing, gating, buffering | Timing does not really need decoupling |
| Historical / reversible command | Undo, redo, or auditing matters | Stores enough action context to reverse or inspect | Before-state is missing or unstable |
| Replayable / serializable command | Re-execution or transmission matters | Stable stream for replay, sync, or record | Command depends on fragile runtime references |

Practical rule:

- If you only need to decouple **who** asks for the action, lightweight commands may be enough.
- If you need to decouple **when** it happens, you are in queue territory.
- If you need to decouple **what already happened** for later reversal or re-run, you are in history territory.

## Producer / executor boundary questions

For every proposed action path, ask:

- Who produces this command?
- Who executes it?
- Is execution authority actor-owned, service-owned, or system-owned?
- Does the producer need an immediate result?
- Would a direct method call be clearer?

Healthy command flow looks like:

- producers that issue requests without performing the whole action themselves
- executors that own the side effects and validation surface
- explicit authority boundaries

Unhealthy command flow looks like:

- invokers that quietly know every subsystem detail
- commands that hide who really performs the work
- command layers introduced purely to look abstract

## Command contract discipline

Each command should answer:

- **What** is being requested?
- **Who** or what is the target or execution context?
- **Which data** must be stored?
- **When** can it execute?
- **Can it be replayed or undone?**

Healthy contracts:

- use names that describe requested actions clearly
- keep parameters explicit
- distinguish reusable action types from one-shot historical instances

Warning signs:

- command names that merely mirror method names with no new boundary value
- commands that require hidden global lookups to run safely
- delayed commands holding references that may already be invalid later

## Validation, cancellation, and failure semantics

Commands should not fail by theatrical surprise.

For each command path, define:

- preconditions
- where validation runs
- what happens when validation fails
- whether cancellation is possible
- whether invalid commands are dropped, retried, or remain queued

Healthy behavior:

- validation is explicit and centralized enough to review
- failure semantics are intentional
- retries or pending states exist only when the use case truly needs them

Warning signs:

- validation hidden inside deep receiver methods with no observable contract
- commands that remain queued forever with no timeout or cancel rule
- replay systems that cannot explain why the same command now behaves differently

## History, undo, and redo discipline

Undoable commands are not just executable; they are accountable.

Ask:

- Does the action need history at all?
- What minimal before-state must be stored?
- Does redo re-run the command or reapply stored effects?
- When should redo history be discarded?
- How large can history become?

Healthy history design:

- stores only the state required to reverse or re-run correctly
- makes branch invalidation explicit when new commands diverge from past history
- keeps undo ownership and scope clear

Warning signs:

- snapshotting large unstable state by default
- pretending an action is undoable when side effects are irreversible
- keeping redo history after a new branch without deciding the policy explicitly

## Replay and serialization discipline

Replayable commands need more stable contracts than immediate-only ones.

Ask:

- Can the command be serialized safely?
- Does it reference stable identifiers or ephemeral runtime objects?
- Does execution rely on hidden world state that will differ later?
- Is deterministic behavior required?

Healthy replay design:

- uses stable identifiers and explicit payloads
- records enough context to re-run meaningfully
- distinguishes replayable commands from transient commands when needed

Warning signs:

- storing callback context, node references, or frame-local assumptions for later re-use
- replaying commands against a world that cannot reproduce the same preconditions

## Queue and timing semantics

Queues are useful, but only when time is part of the problem.

Ask:

- Should commands execute now, later, or when a gate opens?
- Is the queue FIFO, priority-based, phase-based, or work-stealing?
- Can commands be dropped or coalesced?
- What happens when the target disappears before dequeue?

Healthy queue design:

- states why delayed execution is necessary
- makes queue ownership explicit
- defines backpressure, cancellation, or rejection policy

Warning signs:

- queueing everything because it feels scalable
- no policy for stale pending commands
- delayed execution that still depends on current mutable world state rather than explicit payloads

## Input abstraction vs command flow

Input abstraction is not the same thing as command flow.

- Unity `InputAction` and Godot `InputMap` help map physical input to logical actions.
- Command flow begins when those logical actions become explicit requests that can be validated, executed, queued, stored, or replayed.

If the problem is only device mapping or rebinding, command flow is probably too much.

## Event vs command distinction

Use this distinction aggressively:

- **Event / signal:** something happened
- **Command / request:** please do this

If the name sounds imperative, you probably want a command.
If the name sounds historical or descriptive, you probably want an event.

Confusing these two makes systems feel decoupled while secretly becoming harder to reason about.

## Engine-aware notes

### Godot / .NET

- `InputMap` and `InputEvent` are producer-side abstractions, not full action history systems.
- Controller-node or tool-script producers are natural places to emit commands.
- `UndoRedo` and `EditorUndoRedoManager` already provide strong reversible-action semantics for tool-facing flows.
- Delayed commands should use stable data or validity checks instead of assuming nodes will still be alive later.

### Unity

- `InputAction` is a strong producer abstraction, but command execution and history should live elsewhere.
- Invokers should usually be code-owned services or coordinators, not anonymous callback tangles.
- Undo/redo stacks, action queues, or replay logs need explicit ownership and lifecycle.

### Generic C# / engine-neutral

- Prefer explicit command interfaces or contracts when multiple operations beyond `Execute()` matter.
- Be cautious with closures when commands need stable stored data, undo state, or unsubscription-like lifecycle reasoning.
- If the runtime provides official undo or transaction mechanisms, integrate intentionally rather than duplicating them blindly.

## Rejection heuristics

Reject or down-rank a command-flow recommendation when:

- a direct call is already the honest relationship
- the problem is really event topology or signal lifecycle
- the project only needs rebinding or input abstraction, not action history or dispatch boundaries
- queueing exists only because the architecture is otherwise muddy
- undo, replay, or serialization is being mentioned as decoration rather than an actual requirement

## Review checklist

Before approving a command-flow design, verify that:

1. a simpler direct-call alternative was considered first
2. the action boundary is concrete
3. producers and executors are named clearly
4. the command contract is explicit enough to review
5. immediate vs queued vs historical execution was chosen deliberately
6. validation and failure semantics are explicit
7. undo, redo, or replay requirements are justified and scoped
8. queue ownership and stale-command handling were considered when relevant
9. the design does not quietly drift into event topology or behavior architecture
