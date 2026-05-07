# Main-Thread Marshaling Patterns

Use this reference when a Godot/.NET task needs background work to return safely to engine-owned state.

## Preferred pattern: Snapshot -> Work -> Result -> Apply

```text
1. Main thread captures immutable snapshot
2. Worker processes only snapshot/plain data
3. Worker returns plain result or DTO
4. Main thread verifies owner still valid and request still current
5. Main thread applies result to Node/SceneTree/UI/Resource
```

This pattern keeps live Godot objects out of worker closures and makes stale-result handling explicit.

## Snapshot rules

A snapshot should contain:

- primitive values
- immutable records or DTOs
- IDs or stable handles that will be resolved later on the main thread
- copied arrays, grids, dictionaries, or serialized data
- resource paths rather than live `Resource` instances when possible

A snapshot should avoid:

- live `Node` references
- `SceneTree` references
- mutable `Resource` instances currently used by the scene
- closures over `this` when `this` is a node with scene lifetime
- references that become invalid on scene exit

## Result rules

A worker result should contain:

- a success/failure state
- plain data needed by the apply step
- request ID or version ID when repeated requests can overlap
- diagnostics useful for error reporting
- enough context to decide whether the result is stale

A worker result should not directly mutate the scene as part of completion.

## Main-thread apply rules

Before applying a result, check:

- the owner still exists and has not exited its intended lifetime
- the request/version ID still matches the current request
- the node is still expected to update UI or scene state
- cancellation was not requested
- the target resource or scene dependency is still relevant

Apply only the Godot-facing state changes in this step.

Examples of main-thread-only apply work:

- `AddChild` / `RemoveChild`
- assigning UI text, textures, or progress state
- updating `TileMap`, `AnimationPlayer`, or scene node properties
- instantiating a `PackedScene` into the active scene
- emitting scene-facing signals

## Marshaling options

Use the smallest project-appropriate return path.

| Option | Use when | Caution |
| --- | --- | --- |
| `CallDeferred` | A node-owned apply method should run later on the main thread | Validate owner/request before applying; avoid hiding ownership in string calls |
| Main-thread signal or frame boundary | The project already uses a known main-thread awaited boundary | Do not assume every signal or continuation is equivalent; state the exact boundary |
| Project-owned dispatcher | The project already has a documented dispatcher boundary | Do not invent one casually; define owner, queue policy, and shutdown semantics |
| Direct continuation | Only when the runtime context is known and verified | Do not assume `await` resumes on the Godot main thread without evidence |
| Frame-sliced loop | Work can be broken into chunks that run over multiple frames | Keep cancellation and progress state explicit |

## Dispatcher caution

A global main-thread dispatcher can be useful, but it is an architecture decision, not a default patch.

Before recommending one, confirm:

- which layer owns it
- how it shuts down
- whether queued actions are dropped, flushed, or rejected on scene exit
- whether it preserves ordering guarantees
- how errors are reported
- why `CallDeferred`, a signal/frame boundary, or local owner apply method is insufficient

## Stale-result handling

Use stale-result protection when:

- a user can trigger the same work repeatedly
- scene changes can happen before completion
- loading can be cancelled or superseded
- slow workers may finish after newer workers

Common patterns:

- monotonically increasing request ID
- cancellation token tied to owner lifetime
- state machine that rejects old completions
- comparison against current target scene/resource/path before apply

Do not rely only on "the task usually finishes fast" as a safety argument.
