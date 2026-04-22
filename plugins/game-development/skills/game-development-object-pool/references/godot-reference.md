# Godot Pooling Reference

This companion reference expands the Godot-specific pitfalls behind `object-pool`.
Use it when the main `SKILL.md` identifies pooling as a likely fit and you need concrete engine-facing guidance for node reuse, reset, and verification.

## Lifecycle facts that matter for pooling

### `_EnterTree()`, `_Ready()`, `_ExitTree()` are not interchangeable

- `public override void _EnterTree()` runs **every time** the node enters the scene tree.
- `public override void _Ready()` runs when the node and its children are ready, but it is **not** a general-purpose reuse hook.
- `public override void _ExitTree()` runs when the node is leaving the tree.

For pooled nodes, do **not** assume `_Ready()` will magically re-run on every acquire.
If your reuse strategy removes a node from the tree and later re-adds it, call `RequestReady()` before re-entry **only when** you deliberately want `_Ready()` to run again.
Otherwise, prefer an explicit pool contract such as:

- `OnAcquire(context)`
- `ResetState()`
- `OnRelease()`

### Useful notification detail

Godot sends `NOTIFICATION_POST_ENTER_TREE` every time a node enters the tree, unlike `NOTIFICATION_READY`-style one-time assumptions. This can help when you need a repeatable tree-entry hook without overloading `_Ready()` semantics.

## Deactivation strategies

Different “release” strategies have different side effects. Choose intentionally.

| Strategy | Good for | Risks / caveats |
|---|---|---|
| `Visible = false` | simple visual hiding | processing, physics, timers, and signals may still keep running |
| `SetProcess(false)` / `SetPhysicsProcess(false)` | stopping per-frame callbacks | does not automatically stop tweens, timers, signals, particles, or custom async continuations |
| disable collision / monitoring | bullets, hitboxes, trigger volumes | easy to forget one flag and leak gameplay behavior |
| `RemoveChild()` | detaching from active scene | transform context, parent assumptions, ownership, and ready semantics change |
| reparent to pool root | scene-local pools with controlled ownership | world/UI coordinate assumptions and parent-dependent logic must be reset |
| `ProcessMode = Disabled` | hard pause for node subtree | can change notification behavior and must be restored explicitly |

## Pool topology and ownership

Prefer a topology that makes lifecycle visible instead of “magic global reuse”.

### Good default

- one pool per scene or subsystem
- one active parent for live instances
- one inactive pool root for released instances

This keeps ownership, cleanup, and scene transition behavior easier to reason about.

### Review prompts

- does reparenting change local vs global transform assumptions?
- does the pooled node rely on its parent path, sibling lookup, or inherited canvas/world state?
- does the node need group membership restored on acquire?
- if the scene is reloaded, who owns disposal of the inactive pool root?
- do you rely on `Owner` or editor serialization semantics anywhere in the reuse path?

## Signals, events, and duplicate subscriptions

Pooling keeps objects alive longer, so “it will disconnect when freed” is no longer a safe assumption.

### Watch for these cases

- Godot signals connected in code or editor
- C# event subscriptions using `+=`
- lambda handlers capturing stale state
- repeated acquire paths that subscribe again without unsubscribe

### Safe rule

If a pooled object subscribes on acquire or activation, it must unsubscribe on release or deactivation.

Prefer named handlers over anonymous lambdas when the handler must be removed later.

```csharp
private void OnTimeout()
{
    // ...
}

public void OnAcquire(Timer timer)
{
    timer.Timeout -= OnTimeout;
    timer.Timeout += OnTimeout;
}

public void OnRelease(Timer timer)
{
    timer.Timeout -= OnTimeout;
}
```

## Tweens, timers, deferred calls, and async ghosts

### Common failure mode

A pooled node is released, but a delayed callback returns later and mutates stale state.

Typical sources:

- `CreateTween()` / `SceneTreeTween`
- `GetTree().CreateTimer(...)`
- `await ToSignal(...)`
- deferred calls that run after release

### Practical guardrails

- kill or invalidate active tweens on release
- stop or ignore timers that no longer belong to the current generation
- use a generation token / version counter on acquire
- after every awaited signal, re-check that the node is still active and still belongs to the same pooled lifecycle

```csharp
private int _generation;

public void OnAcquire()
{
    _generation++;
}

public async Task FlashAsync()
{
    var generation = _generation;
    await ToSignal(GetTree().CreateTimer(0.2f), SceneTreeTimer.SignalName.Timeout);

    if (generation != _generation)
    {
        return;
    }

    // Safe to continue for the current lifecycle only.
}
```

## Shared resources can contaminate the whole pool

Be careful when mutating shared resources on a reused instance:

- `Material` / `ShaderMaterial`
- particle process materials
- `SpriteFrames`
- theme resources
- other shared `Resource` instances

If one pooled instance changes a shared resource, the rest of the pool may inherit the mutation.

### Safe rule

If a pooled instance needs per-instance mutation, either:

- restore the mutated values during release, or
- duplicate the resource before per-instance edits

## Node-type reset hints

Use these as review prompts, not a substitute for system-specific tests.

### `Area2D` / trigger hitbox

Reset at minimum:

- position / rotation / scale
- monitoring flags
- collision layer and mask if modified dynamically
- enabled / disabled state
- hit registry or already-hit cache
- trail / VFX child state if attached

### `RigidBody2D` / physics-driven projectile

Reset at minimum:

- linear and angular velocity
- sleeping state
- applied forces / impulses assumptions
- transform
- collision exceptions if added during runtime
- interpolation-sensitive state after teleport/reuse

If the body is effectively teleported during reuse, also review whether physics interpolation or post-release collisions need explicit reset ordering.

### `AnimationPlayer`

Reset at minimum:

- stop current playback if release occurs mid-animation
- rewind or seek to desired start time
- playback speed if modified
- event-driven animation callbacks

### `GPUParticles2D` / `GPUParticles3D`

Reset at minimum:

- emitting state
- one-shot assumptions
- whether `Restart()` is required
- whether previous particles must fully finish before restart in your effect design
- material overrides or per-instance parameters

Official docs note that restarting particles clears the current cycle, and one-shot `finished` behavior matters.

### `AudioStreamPlayer2D` / `AudioStreamPlayer3D`

Reset at minimum:

- stop playback
- bus, pitch, volume, and autoplay-style assumptions
- spatial position if world-space audio is reused
- finish callbacks or chained playback logic

### UI labels / floating numbers

Reset at minimum:

- text
- modulate / alpha / visibility
- scale and position offsets
- focus state if relevant
- active tweens / timers
- theme overrides

## Groups, pause state, and input

Reusable nodes can leak participation state even if their visuals look reset.

Review at minimum:

- `AddToGroup(...)` / `RemoveFromGroup(...)` assumptions
- `ProcessMode` restoration after release
- focus ownership for UI controls
- whether a released node can still receive input or callbacks indirectly
- scene-transition behavior when pooled UI and world objects live longer than the active scene

## Threading boundary

For Godot/.NET pooling, the safe mental model is simple:

- background work may prepare plain data or load compatible resources where safe
- scene-tree and `Node` mutations belong on the main thread

Treat these as main-thread operations unless you have explicit, verified engine guarantees for your case:

- `PackedScene.Instantiate()` in gameplay flow
- `AddChild()` / `RemoveChild()` / reparenting
- changing live `Node` state used by the scene tree
- most reuse activation and release transitions

## Prewarm caveat

Prewarming nodes does **not** automatically eliminate every first-use hitch.

You may still see first-time cost from:

- shader / pipeline compilation
- particles starting for the first time
- texture upload or other render-side warm-up

So treat prewarm as one tool, not proof that runtime hitching is solved.

## Review checklist for a Godot pool

Before accepting a pooling change, verify:

- acquire does not rely on `_Ready()` accidentally re-running
- release fully disables processing, collision, and visual side effects as intended
- signal and event subscriptions cannot duplicate across reuse cycles
- async callbacks cannot mutate released objects
- shared resources cannot leak per-instance mutations across the pool
- UI-space and world-space pooled objects are not mixed carelessly
- group membership, pause state, and input handling return to the intended baseline on release
- reparenting does not break transform or parent-dependent logic
- profiling shows measurable benefit compared with simpler allocation-based behavior

## Verification patterns

Use these as lightweight regression patterns when reviewing a pooling implementation:

### Duplicate-subscription test

- acquire the same instance twice across two lifecycles
- trigger the subscribed signal once
- verify the handler fires once, not twice

### Stale-async test

- start a timer/tween/await path
- release the object before completion
- reacquire the same instance
- verify the old callback does not mutate the new lifecycle

### State-bleed test

- acquire, mutate visible/runtime state, release
- reacquire from the same pool
- verify baseline state is restored before gameplay resumes

### Transform re-entry test

- release from one parent/context
- reacquire under another parent/context
- verify local/global position, collision, and presentation still match intent

## Official documentation anchors

These references informed this companion file:

- Godot `Node` lifecycle and notifications
- `request_ready()` behavior
- C# signals and `ToSignal(...)`
- `SceneTree.CreateTimer(...)`
- particle `restart()` / `finished` behavior
- thread-safe API guidance in Godot docs
