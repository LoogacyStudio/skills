---
name: game-development-fsm
description: Use when gameplay, AI, UI flow, or interaction logic is buried in growing if/else or switch branches, repeated enter/exit behavior, or scattered transition rules and the agent must decide whether to keep it simple, use a lightweight state machine, or refactor into a structured FSM without over-engineering.
---

# Game Development FSM

Use this skill when a game system's behavior is becoming state-heavy enough that ad-hoc conditionals are harder to reason about than the feature itself.

This skill is for **refactoring or designing maintainable state logic**. Its job is not to force every feature into a heavyweight framework. Its job is to identify the real state boundary, choose the lightest structure that matches the transition complexity, and return a refactor plan that keeps states, transitions, and shared context understandable.

Prefer this skill when the main risk is growing state complexity across gameplay, AI, UI flow, or interaction logic.

For Godot-specific state ownership, scene-tree lifecycle, signal, timer, and `AnimationTree` boundary guidance, see `references/godot-reference.md`.
If the engine is unspecified, keep the recommendation engine-agnostic first and use Godot-specific guidance only when the task explicitly involves Godot scene-tree behavior or equivalent engine constraints.

## Purpose

This skill is used to:

- identify whether the problem is truly state-machine shaped
- separate distinct states from generic flags or one-off branches
- choose the right FSM weight: avoid, lightweight, or structured
- define clear state responsibilities and transition ownership
- prevent gameplay, animation, UI, and orchestration concerns from collapsing into one god machine
- return a structured refactor artifact another agent can implement safely

## Use this skill when

Invoke this skill for requests such as:

- large `if` / `else if` chains or `switch` logic controlling behavior
- repeated enter / exit logic across multiple modes
- growing AI behavior logic with unclear transition rules
- UI or gameplay flows that keep accumulating mode flags
- state bugs caused by hidden side effects or mixed responsibilities
- requests that explicitly mention `state machine`, `FSM`, `AI logic messy`, `too many conditions`, or `state transitions`

### Trigger examples

- "This enemy AI has too many condition branches"
- "Should this player controller become a state machine?"
- "My UI flow is turning into a giant switch statement"
- "We keep duplicating enter and exit behavior for states"

## Do not use this skill when

Do not use this skill when:

- there are only 2–3 simple states with trivial transitions
- the logic is linear and does not need a reusable state model
- a single boolean or tiny enum is already sufficient
- the real issue is event ordering, data ownership, or timing rather than state shape
- engine-native tools already own the concern cleanly, such as an animation state graph that should not be replaced by gameplay FSM glue

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if the team has not yet proved that an FSM is the right control shape.
- Pair with `game-development-condition-rule-engine` when guards, transition checks, or reusable state-entry rules are starting to sprawl.
- Pair with `game-development-time-source-and-tick-policy` when state updates, cooldown exits, or reevaluation cadence depend on explicit clock rules.
- Pair with `game-development-state-change-notification` when transitions should be state-change-driven, emit meaningful payloads, or invalidate downstream consumers.
- Pair with `game-development-world-state-facts` when state transitions depend on shared observed truth rather than local-only fields.
- Hand off to `game-development-coordinator` or `game-development-command-flow` when the real pain is subsystem collaboration or action dispatch around the state machine rather than the machine itself.

## Diagnostic checklist

Evaluate these questions before recommending an FSM shape:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| How many states exist? | Clear, nameable modes | Growing ad-hoc flags or hidden submodes |
| Are transitions defined? | Trigger and guard are explainable | Branches are scattered or implicit |
| Are responsibilities mixed? | One machine owns one concern | Gameplay, animation, UI, and orchestration are entangled |
| What kind of state is this? | Gameplay, AI, UI, animation, or interaction is explicit | Multiple categories are collapsed into one machine |
| Can engine-native tools help? | Animator, AnimationTree, navigation, or behavior tools cover part of the problem | The proposed FSM would duplicate native engine responsibilities |

## Decision rules

Before recommending any FSM shape, first ask whether the smaller honest answer is:

- a clearer event flow
- a small enum or mode flag
- a data table or rule table
- engine-native tooling that already owns the state concern

Reject an FSM if it mostly formalizes mixed responsibilities instead of clarifying state boundaries and transition ownership.

### Avoid FSM when

- the flow is linear or barely branching
- there are only a few stable modes with no repeated enter / exit logic
- the complexity comes from data dependencies rather than transition rules
- an FSM would be more code than problem

### Use a lightweight FSM when

- the state count is still small
- transitions are easy to enumerate
- one owner script can safely hold the machine
- an `enum` + centralized update / transition logic stays readable

Good default shapes:

- `enum` + `switch` / `match`
- small transition table
- explicit `ChangeState(next)` method with guard checks

### Use a structured FSM when

- state count is growing or likely to grow
- state-specific enter / update / exit logic is substantial
- multiple systems read the current state but one owner should control transitions
- testability, reuse, or extension cost matters

Good default shapes:

- class-based states with `Enter()`, `Update()`, `Exit()`
- node-based states when scene composition and editor visibility matter
- a separate transition authority instead of transitions being scattered through every state

## Workflow

Follow this sequence every time.

### 1. Identify the real state boundary

State what the machine actually owns before choosing an implementation shape.

### 2. Extract the current states

List the actual modes already present in the code, even if they are currently expressed as booleans, enums, or branch clusters.

For each state, note:

- purpose
- owner
- entry trigger
- exit trigger
- side effects

### 3. Separate responsibilities

Check whether one proposed machine is mixing concerns such as:

- gameplay logic
- animation playback
- UI presentation
- navigation
- cutscene or orchestration flow

### 4. Map transitions

Build a transition table or text diagram that captures:

- source state
- destination state
- trigger
- guard condition
- side effects or cleanup

### 5. Choose the implementation shape

Pick the lightest structure that matches the real complexity:

- `enum`-based for small, centralized state logic
- class-based for richer behavior and clearer state ownership
- node-based when engine/editor composition benefits from explicit state nodes
- script-swapping or engine-native graphs only when they genuinely reduce complexity

### 6. Define the state interface and shared context

At minimum, consider:

- `Enter()`
- `Update()` or event handlers
- `Exit()`

Define shared context separately from per-state behavior. Shared context may include:

- owner node or component
- movement or stats services
- input snapshot
- animation bridge
- timers, cooldowns, or blackboard data

### 7. Integrate with engine systems

Review how the state model interacts with:

- input
- animation
- gameplay events
- UI events
- navigation or physics callbacks
- async, timer, or coroutine flows

### 8. Add debugging and verification hooks

Useful additions include:

- current-state logging
- transition logging with trigger and guard result
- debug labels or overlays
- simple text-based state diagrams for review

### 9. Plan the refactor order

Migrate incrementally: isolate current states, define transitions, introduce the machine shell, move one state at a time, verify behavior after each move, and then remove obsolete branch logic.

## Output contract

Return the result using `assets/fsm-refactor-brief.md` in this section order.

If the best answer is **not** an FSM, still use the template and state that explicitly instead of stretching the problem until an FSM appears to fit.

Return the result in these sections:

1. **State boundary**
2. **State list**
3. **State diagram**
4. **Transition table**
5. **Recommended FSM shape**
6. **Class or interface design**
7. **Integration plan**
8. **Refactor steps**
9. **Verification notes**

Keep the section order stable so FSM recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot

- keep gameplay FSM separate from `AnimationTree` state unless animation truly owns the gameplay transition
- if state logic relies on node lifecycle, scene-tree timing, or signals, make those dependencies explicit in the state/context contract
- node-based states help when editor visibility and scene composition matter, but they can be overkill for tiny machines

### Unity

- keep gameplay FSM separate from Animator state machines unless you intentionally bridge them
- if the project uses ECS, do not force an OO-style FSM where data-oriented flow control is the better fit
- do not hide transition authority across multiple `MonoBehaviour` callbacks with no clear owner

## Common pitfalls

- building a god FSM that owns everything
- scattering transition rules across unrelated systems
- mixing gameplay, animation, UI, and orchestration in one machine
- letting states mutate broad global state with hidden side effects
- replacing a simple enum with a framework-sized abstraction for no gain
- migrating all logic at once and losing behavioral checkpoints

## Companion files

- `references/godot-reference.md` — Godot-specific lifecycle, signal, timer, animation, and scene-composition cautions for FSM design
- `assets/fsm-refactor-brief.md` — reusable output template for returning the FSM refactor artifact

## Validation

A good result should satisfy all of the following:

- a simpler non-FSM alternative was considered before recommending a machine
- the true state boundary is identified
- states and transitions are predictable and reviewable
- the FSM shape matches the actual complexity
- engine-native tooling is used where appropriate, not duplicated blindly
- the refactor plan is incremental enough to verify safely

## Completion rule

This skill is complete when the agent has:

- decided whether an FSM is justified at all
- identified the owned state boundary
- listed the key states and transitions
- recommended the lightest suitable implementation shape
- described integration boundaries with engine systems
- returned a concrete refactor and verification plan
