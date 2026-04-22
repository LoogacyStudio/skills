# Godot FSM Reference

This companion reference expands the Godot-specific tradeoffs behind `game-development-fsm`.
Use it when the main `SKILL.md` identifies a state-machine-shaped problem and you need concrete guidance for scene-tree ownership, lifecycle timing, `AnimationTree` boundaries, signals, timers, and state-node composition.

## Start with the ownership boundary, not the class diagram

In Godot, the first FSM decision is usually not "enum vs classes".
It is **what one machine actually owns**.

Good ownership examples:

- player locomotion state
- enemy combat decision state
- interaction tool mode
- menu or dialogue flow state

Warning signs:

- one machine tries to own gameplay rules, animation playback, UI visibility, and cutscene flow at once
- state transitions are triggered from many sibling nodes with no clear authority
- the machine becomes a coordinator for the whole scene instead of one concern

## Choosing a Godot-friendly FSM shape

### `enum` + central owner

Good when:

- state count is small
- transitions are easy to enumerate
- one owner node already legitimately controls the behavior
- editor visibility is not the main requirement

Typical fit:

- player locomotion
- simple enemy patrol/chase/attack loops
- menu tab or tool mode switching

### class-based states

Good when:

- per-state logic is substantial
- enter/update/exit behavior is repeated and deserves separation
- state-specific tests or mockable collaborators matter
- you want one owner node with plain script-side state objects

Typical fit:

- richer AI logic
- interaction systems with meaningful state-local behavior
- complex but still code-centric gameplay flows

### node-based states

Good when:

- scene/editor visibility matters
- each state owns child nodes, timers, or inspector-facing configuration
- designers or reviewers benefit from explicit scene composition

Risks:

- overkill for tiny machines
- easy to create hidden coupling through parent/sibling lookup
- lifecycle assumptions become trickier if state nodes are enabled/disabled dynamically

### AnimationTree or Animator-like native graphs

Use engine-native graphs when animation authoring is the real problem.
Do not replace them with a gameplay FSM just because the word "state" appears in both places.

Good split:

- gameplay FSM decides intent or high-level mode
- animation graph handles pose blending and animation playback
- an explicit bridge maps gameplay state to animation parameters

## Lifecycle facts that affect FSM design

### `_EnterTree()`, `_Ready()`, `_Process()`, `_PhysicsProcess()` are not interchangeable

- `_EnterTree()` runs every time the node enters the scene tree.
- `_Ready()` is for when the node and its children are ready, but it is not a general transition hook.
- `_Process()` is frame-rate dependent.
- `_PhysicsProcess()` is physics-tick dependent.

Practical rule:

- do not perform state transitions in `_Ready()` just because it is convenient
- use `_Ready()` for initialization, dependency capture, and signal hookup
- keep recurring state evaluation in the process loop or in explicit event handlers
- if timing matters for movement or collision logic, keep the relevant transition checks in `_PhysicsProcess()` or in callbacks tied to the physics model

### Enter/Exit should be explicit

Do not rely on node lifecycle callbacks to stand in for state `Enter()` and `Exit()` semantics unless the scene architecture truly makes them equivalent.

A healthy Godot FSM usually has explicit transition methods such as:

- `ChangeState(next)`
- `Enter(previous)`
- `Exit(next)`

This keeps behavior understandable even when nodes remain alive across multiple state changes.

## Signals, timers, and async boundaries

Godot FSM bugs often come from transitions being triggered indirectly from too many asynchronous surfaces.

Watch for these transition sources:

- signals from child nodes or UI controls
- `Timer.Timeout`
- `await ToSignal(...)`
- animation finished callbacks
- navigation target reached callbacks
- collision/body entered callbacks

Practical rules:

- one owner should approve and execute transitions
- states may request transitions, but they should not all mutate global machine state however they like
- unsubscribe or guard signal handlers when a state becomes inactive
- after any awaited signal, re-check whether the state is still current before continuing

Example guard pattern:

```csharp
private int _stateVersion;

private void ChangeState(IState next)
{
    _stateVersion++;
    // transition logic...
}

private async Task WaitThenReturnToIdle()
{
    var version = _stateVersion;
    await ToSignal(GetTree().CreateTimer(0.25f), SceneTreeTimer.SignalName.Timeout);

    if (version != _stateVersion)
    {
        return;
    }

    RequestState(StateId.Idle);
}
```

## Physics, navigation, and input boundaries

### Physics-driven states

For movement, knockback, grounded/airborne, or collision-driven AI:

- prefer `_PhysicsProcess()` for transition checks that depend on physics truth
- avoid splitting one transition between `_Process()` and physics callbacks unless the ownership is explicit
- if collision or floor checks define the state, keep those checks near the machine owner

### Navigation-driven AI states

For patrol, pursue, search, retreat, or investigate states:

- keep pathfinding and navigation agent details in shared context or helper services
- do not let every state reach deep into navigation nodes with duplicated logic
- make arrival, path-fail, and repath rules explicit transition triggers

### Input-driven states

For player or tool modes:

- separate raw input capture from state decisions
- let the FSM consume normalized intent instead of scattering direct input checks through every state
- if multiple modes interpret the same input differently, document that in the state contract instead of hiding it in event noise

## Scene composition and node lookup cautions

If you use node-based states or a Godot owner node with many collaborators, review these risks:

- parent-path assumptions that break when a scene is restructured
- sibling lookup that couples states to presentation layout
- state scripts mutating distant nodes directly
- autoloads becoming de facto transition authorities

Prefer:

- explicit exported references where appropriate
- one owner/context object passed into states
- a clear bridge for animation, VFX, audio, or UI rather than every state touching everything directly

## AnimationTree boundary

A common Godot anti-pattern is letting animation state secretly own gameplay truth.

Healthy pattern:

- gameplay FSM owns movement/combat/interaction truth
- gameplay FSM sets animation parameters intentionally
- animation callbacks may request gameplay transitions, but they should not silently override the machine without a clear rule

Review questions:

- is animation a presentation of gameplay state, or the authority for it?
- if an animation ends early or is interrupted, what gameplay state remains true?
- do transition guards depend on animation playback in a way that can deadlock or jitter?

## Debugging hooks that pay off quickly

Useful Godot-specific debug helpers include:

- a label or overlay that shows current state
- transition logs with trigger and guard outcome
- editor-visible exported debug flags on the owner node
- a text dump of recent transitions for AI or UI flow debugging

If the machine is hard to debug, it is usually also hard to trust.

## Review checklist for a Godot FSM

Before accepting a Godot FSM design or refactor, verify:

- one machine owns one clear concern
- gameplay, animation, UI, and orchestration are not collapsed without reason
- transition authority is explicit
- `_Ready()` is not being misused as a general state-entry mechanism
- async and timer callbacks cannot apply stale transitions silently
- navigation, physics, and input checks live at the right boundary
- node lookup and scene-path assumptions are not hiding fragile coupling
- the chosen shape is no heavier than the problem needs

## Verification patterns

Use these as lightweight regression patterns when reviewing a Godot FSM:

### Transition determinism check

- trigger the same transition twice from the same starting conditions
- verify the resulting state and side effects are identical

### Stale async guard check

- start a timed or awaited transition path
- force another state change before completion
- verify the old async continuation does not revert the machine unexpectedly

### Animation boundary check

- interrupt or skip an animation-linked transition
- verify gameplay truth remains coherent even if presentation timing changes

### Scene restructure check

- move or rename a nearby child node used by the owner/state logic
- verify the FSM design does not depend on brittle scene-path assumptions more than necessary

## Official documentation anchors

These references informed this companion file:

- Godot `Node` lifecycle and processing callbacks
- signals and `ToSignal(...)`
- `SceneTree.CreateTimer(...)`
- `AnimationTree` state machine and parameter usage
- `NavigationAgent2D` / `NavigationAgent3D` behavior patterns
- thread-safety guidance for scene-tree and node mutation
