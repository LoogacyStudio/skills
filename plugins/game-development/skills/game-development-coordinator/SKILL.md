---
name: game-development-coordinator
description: "Use when a cross-engine gameplay task needs a Layer 2 shared-runtime coordination boundary for brittle reference chains, root-node god scripts, scattered cross-system callbacks, or unclear scene ownership, and the agent must design or review a bounded coordinator layer with an explicit public surface, internal ownership map, forwarding rules, collaboration boundaries, and god-object safeguards."
---

# Game Development Coordinator

Use this skill when the hard part is not event topology, command execution flow, or behavior selection, but **how one scene or subsystem should coordinate collaboration across a bounded internal surface without turning into a manager soup monster**.

This skill is for designing, reviewing, or refactoring a coordinator layer in gameplay, UI, quest, encounter, cutscene, or scene-root flows. Its job is to decide whether a bounded coordinator is justified at all, where the coordination boundary lives, what the outside world may ask of it, what stays hidden behind it, and how to prevent the coordinator from quietly becoming a god object.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot scene-root gateways, bubbled signals, and child-node encapsulation, Unity `MonoBehaviour`/service/ScriptableObject coordination surfaces, or equivalent framework constraints.

For reusable heuristics covering coordinator fit, mediator-vs-facade tradeoffs, boundary design, public surface discipline, lifecycle rules, and god-object avoidance, see `references/coordinator-design-guide.md`.

## Purpose

This skill is used to:

- determine whether a bounded coordinator is justified at all
- define a clear scene or subsystem coordination boundary
- choose the coordinator shape deliberately
- design a minimal public surface and explicit ownership map
- keep direct calls, events, and commands on the right side of the boundary
- return a structured coordination design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- a scene root, feature root, or subsystem entry point is accumulating ad-hoc coordination logic
- multiple external systems need access to one volatile internal scene or subsystem surface
- a project has growing reference forwarding, node-path lookup, callback tangles, or "just pass it through one more layer" architecture
- a UI, quest, encounter, inventory, vehicle, ship, or cutscene system needs one safe entry point instead of many direct internals references
- the team needs to decide whether a root object should act as a gateway, mediator, or coordinator for a bounded area
- the project already has a scene manager, service object, or orchestrator-like class and needs design cleanup before it becomes the office kitchen junk drawer
- requests that explicitly mention `coordinator`, `mediator`, `orchestrator`, `scene root gateway`, `subsystem gateway`, `encounter coordinator`, `quest flow coordinator`, or `scene facade`

### Trigger examples

- "Should this scene root coordinate the inventory and world interactions instead of exposing child nodes everywhere?"
- "This encounter flow has too many direct references between spawner, UI, rewards, and state"
- "Do I need a coordinator here, or would events and commands be cleaner?"
- "Please review this quest manager before it becomes a god object"

## Do not use this skill when

Do not use this skill when:

- the hard problem is notification topology, publisher/subscriber ownership, or signal lifecycle; use `game-development-events-and-signals`
- the hard problem is request-versus-execution boundaries, action queues, undo/redo, or replay; use `game-development-command-flow`
- the hard problem is still choosing FSM, BT, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- one direct dependency is already the honest and stable relationship
- the task is only wrapping a third-party API with a simpler interface and does not involve bounded in-game collaboration ownership
- the task is a localized runtime bug investigation rather than coordinator design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-events-and-signals` if the actual pain is notification topology rather than one bounded gateway owning collaboration.
- Start with `game-development-command-flow` if the real question is request execution, queuing, or history rather than coordination surface design.
- Pair with `game-development-entity-reference-boundary` when the coordinator exists partly to shield callers from volatile child references, handles, or lookup rules.
- Pair with `game-development-state-change-notification` when the coordinator must expose meaningful invalidation, bubbled state changes, or change aggregation at the boundary.
- Pair with `game-development-world-state-facts` when the coordinator owns or brokers shared observed truth instead of just forwarding calls.
- Hand off to `game-development-behavior-architecture` when the coordinator is being asked to own AI or decision structure that should live in a behavior model instead.

## Diagnostic checklist

Evaluate these questions before recommending or refining a coordinator design:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there a real coordination boundary? | One scene or subsystem has volatile internals and a stable external seam | The class is just a renamed utility bag |
| Are multiple collaborators involved? | Several internal or external participants must collaborate through one authority point | One honest direct reference would solve it |
| Is ownership explicit? | You can say what the coordinator owns and what it only forwards | The coordinator slowly owns everything nearby |
| Is the public surface minimal? | Only necessary getters, helpers, and signals are exposed | The coordinator mirrors every child API blindly |
| Is lifecycle safer through a coordinator? | Refactors, scene churn, or runtime registration become easier to contain | The coordinator adds ceremony without reducing fragility |
| Is god-object risk manageable? | The boundary can be scoped, split, or layered if it grows | "We’ll just put it in the coordinator" keeps winning every argument |

## Decision rules

Before recommending a coordinator, ask whether the smaller honest answer is:

- a direct method call between legitimate collaborators
- an events/signals topology if the hard part is who needs to hear about something
- a command-flow design if the hard part is request dispatch or execution timing
- a simpler facade over one subsystem API if collaboration rules are not the real issue
- a behavior architecture decision if the hard part is AI/gameplay decision structure

Reject a coordinator if it mostly centralizes naming, references, and anxiety without clarifying ownership.

### Prefer a direct call when

- there is one clear client and one clear callee
- the dependency is stable and honest
- no bounded internal seam needs protection
- inserting a coordinator would mostly rename an existing path

### Prefer a bounded coordinator when

- one scene or subsystem should expose a stable public seam while hiding volatile internals
- several collaborators need one authority point for cross-component coordination
- refactors should be absorbed at one boundary instead of breaking many external callers
- the outside world should not know which child nodes, components, or services actually do the work

### Prefer events or signals instead when

- the hard part is one-to-many notification topology
- collaborators should remain loosely coupled without a central authority deciding the whole collaboration
- the main surface is subscriptions and payloads, not a bounded gateway

### Prefer command flow instead when

- the hard part is request execution, queues, validation, or history
- producers and executors need a stable action contract more than a bounded scene/subsystem gateway

### Escalate to split or layered coordinators when

- one coordinator starts mixing unrelated domains such as encounter flow, inventory, quest, UI, and save logic at once
- a public surface keeps growing because the boundary is too broad
- separate sub-coordinators would clarify ownership better than one large root object

## Workflow

Follow this sequence every time.

### 1. Identify the coordination boundary

State which scene, subsystem, or feature boundary the coordinator would own before you name the class.

### 2. Map inside versus outside collaborators

List which collaborators are internal to the boundary, which are external clients, and who should be allowed to know about whom.

### 3. Choose the coordinator shape

For the candidate boundary, decide whether the right shape is:

- a scene-root coordinator or gateway
- a subsystem service coordinator
- a ScriptableObject or asset-backed coordination surface
- a small facade-like entry surface with a few coordination rules
- split or layered coordinators instead of one large object

### 4. Define the public surface

Specify what the coordinator may expose, such as:

- forwarded getters
- helper functions
- bubbled signals or events
- registration hooks
- narrow action entry points

Anything not clearly justified should stay internal.

### 5. Define ownership and routing rules

Specify:

- what the coordinator owns directly
- what children or collaborators still own themselves
- which calls are forwarded unchanged
- which calls are coordinated across multiple internals
- which flows should stay direct, evented, or command-driven instead

### 6. Define lifecycle and reference policy

Specify how the coordinator handles:

- child lookup or dependency capture
- registration and unregistration
- scene reloads, enable/disable cycles, or prefab/instance churn
- refactor resilience when internal structure changes

### 7. Add observability and god-object guards

Useful hooks include:

- public surface inventory tables
- internal ownership maps
- forwarding or routing logs where needed
- growth warnings such as "split when unrelated domains accumulate"

### 8. Plan the rollout

Migrate incrementally: isolate one boundary, introduce one stable public seam, move one collaboration path behind it, verify that internals are less exposed, and split if the coordinator starts swelling during rollout.

## Output contract

Return the result using `assets/coordinator-design-brief.md` in this section order.

If the best answer is **not** a coordinator, still use the template and say that explicitly instead of promoting a root object to office manager of the entire game.

Return the result in these sections:

1. **Coordination boundary**
2. **Why coordinator is justified**
3. **Coordinator shape recommendation**
4. **Public surface design**
5. **Internal ownership map**
6. **Direct vs event vs command split**
7. **Lifecycle and reference policy**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so coordinator recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- A scene root can act as a gateway to its internals by forwarding narrow getters, helper functions, and bubbled child signals.
- Prefer exported or captured references inside the coordinator over making outside systems walk fragile child paths.
- Keep scene-specific coordination local; do not autoload a scene-bound coordinator just because it has become popular.
- If the coordinator re-emits child signals, keep signal names and payload meaning stable at the boundary.

### Unity

- The coordinator may be a `MonoBehaviour`, plain C# service, or `ScriptableObject` coordination surface depending on scene ownership and authoring needs.
- Prefer one clear runtime owner over scattered `MonoBehaviour` cross-callback coordination.
- Keep inspector wiring intentional; do not turn serialized references into a hidden dependency spiderweb.
- If using `ScriptableObject` coordination surfaces, make registration lifecycle explicit for runtime-created participants.

### Generic C# / engine-neutral

- Prefer stable interfaces and explicit ownership maps over letting the coordinator expose every dependency directly.
- Keep the public surface small enough that future subsystem changes stay local.
- Split unrelated coordination responsibilities early instead of waiting for a large-class obituary.

## Common pitfalls

- turning the coordinator into a god object that owns every nearby decision
- mirroring every child API instead of exposing a bounded surface
- using a coordinator where one direct dependency is already the honest design
- confusing coordinator boundaries with global event bus design
- confusing coordinator entry points with full command-flow architecture
- mixing gameplay logic, UI logic, save logic, quest logic, and diagnostics in one root object
- autoloading a scene-specific coordinator and accidentally making it global
- hiding ownership problems behind a nicer class name instead of actually clarifying them

## Companion files

- `references/coordinator-design-guide.md` — reusable heuristics for choosing coordinator fit, bounding the public surface, separating coordinator vs mediator vs facade vs event bus vs command flow, and avoiding god-object growth
- `assets/coordinator-design-brief.md` — reusable output template for returning the coordinator design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler direct-call or non-coordinator alternative was considered first
- the coordination boundary is explicit
- the public surface and internal ownership map are concrete enough to review
- direct vs event vs command splits are intentional
- lifecycle and refactor-resilience rules are explicit
- the design reduces exposure to volatile internals without becoming a god object
- rollout steps are incremental enough to verify safely

## Completion rule

This skill is complete when the agent has:

- decided whether a bounded coordinator is justified at all
- identified the scene/subsystem boundary and collaboration seam
- chosen the coordinator shape and public surface
- defined internal ownership, routing, and lifecycle rules
- separated coordinator concerns from events, commands, and behavior architecture
- returned a concrete migration and verification brief