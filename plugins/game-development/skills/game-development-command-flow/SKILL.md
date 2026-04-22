---
name: game-development-command-flow
description: Use when gameplay, input, UI, AI, tool, or network-facing action flow is accumulating direct method-call coupling, ad-hoc action queues, fragile undo/redo, or unclear request-versus-execution boundaries, and the agent must design or review a command-flow architecture with explicit command contracts, producer and executor roles, validation, timing, and history or replay rules.
---

# Game Development Command Flow

Use this skill when the hard part is not behavior architecture or event topology, but **how requested actions are expressed, dispatched, executed, optionally queued, and sometimes recorded for undo, redo, or replay**.

This skill is for designing, reviewing, or refactoring command-flow architecture in gameplay, UI, tools, input handling, AI control, or network-facing action paths. Its job is to decide whether commands are justified, where the action boundary lives, who produces and executes requests, and whether queueing, history, undo/redo, or replay belong in the model.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot `InputMap`, `UndoRedo`, or controller nodes, Unity `InputAction` producers and invoker services, or equivalent framework constraints.

For reusable heuristics covering command families, action-flow boundaries, validation, queue timing, undo/redo, replay, and engine-aware guidance, see `references/command-flow-design-guide.md`.

## Purpose

This skill is used to:

- determine whether command flow is justified at all
- define a clear boundary between producers, commands, executors, and direct method calls
- choose the execution model and history model deliberately
- make contracts, validation, cancellation, and failure semantics explicit enough to review
- return a structured command-flow design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- input, UI, AI, cutscene, or tool systems all need to trigger the same gameplay actions without duplicating execution logic
- a project has growing direct method-call coupling around actions such as move, attack, interact, build, or place
- the team needs action queues, combo buffers, turn queues, or resource-gated execution
- undo, redo, replay, or action history is being added and the current code has no clear action boundary
- the project already uses command objects or invokers and needs design cleanup
- requests that explicitly mention `command pattern`, `command flow`, `action queue`, `command invoker`, `undo redo`, `replay`, or `input command`

### Trigger examples

- "Should input, UI, and AI all issue the same commands instead of calling gameplay code directly?"
- "We need undo/redo for this tool and the action history is a mess"
- "This turn-based system needs queued actions with validation before execution"
- "How should we structure replayable actions without coupling everything to input callbacks?"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing behavior architecture across FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the hard problem is notification topology, publisher/subscriber ownership, or signal lifecycle; use `game-development-events-and-signals`
- one direct dependency is already legitimate and clearer than adding commands
- the task is only low-level input binding or device mapping, not action-dispatch architecture
- the task is a localized runtime bug investigation rather than command-flow design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Diagnostic checklist

Evaluate these questions before recommending or refining a command-flow design:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there a real action boundary? | The request can be named independently of the caller | The action only exists as a thin wrapper around one direct call |
| Are multiple producers involved? | Input, UI, AI, tools, or networking need the same action surface | There is one caller and one legitimate callee |
| Is execution timing part of the problem? | Actions may be delayed, queued, buffered, or gated | Everything should happen immediately in one place |
| Is validation explicit? | Preconditions, cooldowns, and resource checks are nameable | Commands fail mysteriously inside deep receiver code |
| Is history or replay valuable? | Undo/redo, replay, or audit trail is a real requirement | History is mentioned aspirationally but has no practical use |
| Is receiver ownership clear? | Executors are concrete systems or actors | Commands hide who actually performs the work |

## Decision rules

Before recommending command flow, ask whether the smaller honest answer is:

- a direct method call between already legitimate collaborators
- an event or signal if the real meaning is "something happened" instead of "please do this"
- a queue or deferred worker API if timing is the only hard part and there is no meaningful command contract
- a behavior, state, or interaction refactor rather than action dispatch architecture

Reject command flow if it mostly renames an existing call chain without improving ownership, execution timing, or history semantics.

### Prefer a direct call when

- there is one clear producer and one clear executor
- the caller already legitimately knows the receiver
- the sender needs an immediate return value or success/failure result
- adding command objects would mostly rename the existing call chain

### Prefer command flow when

- several producers should trigger the same gameplay action surface
- the request should be expressed independently of the current input device or caller
- validation and execution should be centralized instead of repeated across producers
- queueing, history, or replay may be needed now or soon

### Escalate to queued or historical command flow when

- actions should execute later, in sequence, at turn end, after resource readiness, or through combo buffering
- ordering, throttling, batching, or cooldown gating matters explicitly
- undo or redo is a real requirement
- replay or deterministic re-execution matters
- the action must remember enough before-state or parameters to reverse or re-run safely

## Workflow

Follow this sequence every time.

### 1. Identify the action boundary

State what the system is actually requesting before you name classes, buses, stacks, or interfaces.

### 2. Map producers and executors

List who can issue the action and who actually performs it. If producers and executors are still tangled together, the design is not ready.

### 3. Define the command contract

For each command, specify:

- command name
- intent or meaning
- required parameters
- target or execution context
- expected result or side effect
- whether it is reusable, one-shot, historical, or reversible

Keep contracts explicit enough that another agent can tell whether the command is a request, not a disguised event.

### 4. Choose the execution model

For each important action path, decide whether execution is immediate, buffered, queued, deferred, or tied to history/replay, and say why.

### 5. Define validation, cancellation, and failure semantics

Specify:

- where validation happens
- which preconditions are checked before execution
- whether invalid commands are rejected, become no-ops, retry later, or stay pending
- how cancellation works
- what happens if the target or context disappears before execution

### 6. Decide history, undo/redo, and replay rules

Specify whether the command model needs no history, audit-only history, undo/redo, replay, or deterministic re-execution, and what data must be stored.

### 7. Separate command flow from adjacent systems

Clarify what stays outside command flow, such as:

- input binding and device mapping
- event or signal topology
- behavior architecture choice
- animation playback
- navigation or physics execution details

### 8. Add observability and rollout hooks

Useful hooks include:

- command creation logging
- validation or rejection logs
- queue depth or pending-command visibility
- undo/redo history visibility
- replay trace markers

Then plan the rollout incrementally: isolate one action boundary, centralize one path, define validation, add history or queueing only where it pays off, and verify before broadening the surface.

## Output contract

Return the result using `assets/command-flow-brief.md` in this section order.

If the best answer is **not** command flow, still use the template and say that explicitly instead of wrapping a simple direct call in ceremonial abstractions.

Return the result in these sections:

1. **Action boundary**
2. **Producer / invoker model**
3. **Receiver / executor model**
4. **Command contract design**
5. **Immediate vs queue vs history decision**
6. **Validation / cancellation / failure model**
7. **Undo / redo / replay model**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so command-flow recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Treat `InputMap` and `InputEvent` as producer-side abstractions; keep execution and history ownership elsewhere.
- Use `UndoRedo` or `EditorUndoRedoManager` when reversible tool actions should integrate with Godot history.
- For delayed or queued commands, prefer stable data or explicit validity checks over stored node assumptions.

### Unity

- Treat `InputAction` as the producer-side abstraction, not the command object itself.
- Prefer plain C# command contracts and invoker services for code-owned runtime flow.
- Keep gameplay execution and history ownership outside `PlayerInput` or callback surfaces.

### Generic C# / engine-neutral

- Separate producers from executors explicitly.
- Favor stable identifiers and serializable data over captured runtime references when replay or networking matters.

## Common pitfalls

- wrapping every direct call in a command object with no real payoff
- confusing events that describe what happened with commands that request what should happen
- pushing input binding concerns into the command layer
- hiding executor ownership behind a vague invoker that knows too much
- queueing commands when timing does not actually need decoupling
- designing undo without recording enough reversible state
- capturing unstable world references for delayed or replayed execution
- adding history, queueing, and replay all at once before one action path is stable

## Companion files

- `references/command-flow-design-guide.md` — reusable heuristics for command families, producer/executor boundaries, validation, queue timing, undo/redo, replay, and engine-aware design notes
- `assets/command-flow-brief.md` — reusable output template for returning the command-flow design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler direct-call alternative was considered first
- the action boundary and producer/executor roles are explicit
- immediate vs queued vs historical execution was decided explicitly
- validation, failure, and history requirements are concrete enough to review
- rollout steps are incremental enough to verify safely
- the design does not collapse into event topology or behavior architecture by accident

## Completion rule

This skill is complete when the agent has:

- decided whether command flow is justified at all
- identified the action boundary and producer/executor roles
- defined the command contracts and execution model
- specified validation, cancellation, and failure behavior
- decided whether history, undo/redo, or replay is required
- returned a concrete migration and verification brief