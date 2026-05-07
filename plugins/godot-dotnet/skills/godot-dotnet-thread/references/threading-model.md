# Godot/.NET Threading Model Notes

Use this reference to decide what kind of work can leave the Godot main thread and which execution model fits the task.

This is not a general .NET threading reference. Use it only when the thread or async decision intersects with Godot-owned state, `SceneTree` access, `Node` / `Resource` lifetime, UI/presentation updates, Godot resource loading, or main-thread result application.

If a question is fully answerable as ordinary .NET concurrency with no Godot engine boundary, keep it out of this skill.

## Scope gate

Before using any threading model below, identify the Godot boundary trigger:

- live `Node`, `SceneTree`, `Control`, `Resource`, `PackedScene`, signal, or autoload access
- async continuation that applies to scene, UI, presentation, loading, or gameplay-facing engine state
- work that can outlive `_ExitTree`, scene transition, node disposal, or loading-screen ownership
- frame hitch or crash tied to Godot lifecycle or engine API usage
- resource loading where Godot threaded loading may be safer than custom .NET workers

If none apply, route to general .NET guidance instead.

## Default safety stance

Treat live Godot engine state as main-thread-affine unless the project has verified, version-specific documentation for the exact API being used.

Default main-thread surfaces:

- `SceneTree` access and mutation
- node hierarchy changes such as `AddChild`, `RemoveChild`, `QueueFree`, and `Free`
- UI `Control` updates
- node property mutation used by presentation or gameplay state
- scene instantiation into the tree
- signal emission that drives scene or UI behavior
- live `Resource` mutation that the engine or scene is using

Safer background surfaces:

- pure C# calculation over immutable data
- pathfinding over copied grid/nav data
- procedural data generation that returns DTOs or value objects
- JSON/CSV/config parsing into plain models
- compression, hashing, serialization, or remote-data post-processing
- batched transformations over snapshots that do not touch live engine objects

These are in scope because they eventually cross a Godot boundary. Pure server-style or console-style concurrency that never returns to Godot-owned state is out of scope here.

## Work classification

| Work type | Typical safer model | Notes |
| --- | --- | --- |
| Cheap engine mutation | Main thread | Threading adds risk with little benefit |
| Heavy pure calculation | `Task.Run` or bounded worker | Use snapshots and plain results |
| Many independent data chunks | `WorkerThreadPool` | Track completion, cancellation, and stale results |
| Large resource load | Godot threaded resource loading | Instantiate/apply on the main thread |
| Repeated scene interaction | Frame-slicing/chunking | Often safer than cross-thread scene access |
| Long-lived background service | Dedicated owner + cancellation | Rare; requires explicit shutdown and no scene-tree mutation |
| UI update after await | Main-thread apply | Check owner still alive before updating |

## `Task.Run` review cues

`Task.Run` is not forbidden. It is a risk signal.

Acceptable shape:

```text
main thread captures snapshot
Task.Run calculates over snapshot
Task returns DTO/result
main thread validates owner and applies result
```

Risky shape:

```text
Task.Run captures Node/Resource/SceneTree
Task body calls GetNode/AddChild/QueueFree/UI setters
Task result is applied without cancellation or owner validity checks
```

Common red flags:

- `Task.Run(() => GetNode(...))`
- `Task.Run(() => node.Position = ...)`
- `Task.Run(() => AddChild(...))`
- `Task.Run(() => scene.Instantiate())`
- `Task.Run(() => ResourceLoader.Load(...))` without checking Godot threaded loading options
- `.Wait()` or `.Result` on the main thread

## `WorkerThreadPool` review cues

Prefer `WorkerThreadPool` when the work is batchable, bounded, and does not require scene-tree access inside the job.

Check:

- job result has a task ID or completion tracking path
- result application is main-thread-only
- scene exit cancels or ignores stale work
- no worker blocks the main thread for completion
- group work has an upper bound and does not flood the project with hidden jobs

Do not treat `WorkerThreadPool` as safer than `Task` if the job still touches live Godot objects.

## Background resource loading

Separate resource loading from custom CPU work.

Prefer Godot threaded resource loading when:

- loading large `PackedScene`, `Texture`, `AudioStream`, or other engine resources
- the goal is reducing loading hitch rather than custom data computation
- progress or loading-screen behavior matters

Still keep these steps on the main thread:

- instantiating scenes into the tree
- assigning resources to live UI or scene nodes
- mutating materials, textures, or resources already in active use unless documented safe
- handling owner scene lifetime before apply

## Frame-slicing instead of threads

Use chunking or frame-slicing when:

- the work must frequently inspect or mutate scene state
- the task can progress across frames without blocking user input
- a thread would require too many snapshots or unsafe live references
- deterministic ownership is more valuable than raw throughput

Threading is not the only answer to frame hitches. Sometimes the right fix is to do less per frame and keep ownership simple.
