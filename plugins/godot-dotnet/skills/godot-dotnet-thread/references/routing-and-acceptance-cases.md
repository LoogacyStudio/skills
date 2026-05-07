# Routing and Acceptance Cases

Use these cases to review whether `godot-dotnet-thread` is invoked for the right requests and returns the right kind of artifact.

The routing rule is intentionally strict: this skill requires a Godot engine, scene, resource, lifecycle, loading, UI, or main-thread marshaling boundary. A request that only asks about .NET concurrency is not enough.

These are reference cases for future eval or checklist work. They are not a benchmark corpus by themselves.

## Positive routing cases

| User ask | Expected route | Why |
| --- | --- | --- |
| "I use `Task.Run` for pathfinding but sometimes Godot crashes" | `godot-dotnet-thread` | Threading plus Godot main-thread affinity risk |
| "Loading a large scene hitches; should I use background loading?" | `godot-dotnet-thread` | Resource loading and frame-hitch execution model decision |
| "`WorkerThreadPool` generates chunks and then updates `TileMap`" | `godot-dotnet-thread` | Worker result must return to main-thread scene mutation |
| "After awaiting HTTP, my UI updates after the scene is gone" | `godot-dotnet-thread` | Await continuation plus node lifetime safety |
| "Can I call `AddChild` inside a background task?" | `godot-dotnet-thread` | Direct Godot scene-tree threading safety question |

## Negative routing cases

| User ask | Better route | Why |
| --- | --- | --- |
| "Design a cooldown system" | `game-development-time-source-and-tick-policy` or adjacent gameplay skill | Timing semantics, not threading safety |
| "UI theme layout is not responsive" | `ui-ux-review` or UI implementation route | UX/layout issue without async/thread risk |
| "Teach me C# locks in a console app" | General C# answer | No Godot overlay context |
| "Should I use `ConcurrentDictionary` or `lock` in my pure C# cache?" | General C# answer or project-specific implementation route | Generic .NET concurrency unless the cache result crosses a Godot main-thread/lifecycle boundary |
| "How do TPL schedulers work in .NET?" | General C# answer | No Godot engine state, lifecycle, or main-thread apply risk |
| "A backend worker library used by the game has race conditions, but it never touches Godot objects" | General .NET debugging/refactoring route | The bug is in a pure .NET boundary unless the fix changes Godot result application |
| "Godot build fails after SDK upgrade" | `runtime-triage` or `version-upgrade-review` | Toolchain/version issue, not threading-first |
| "This scene owns too many responsibilities" | `scene-architecture-review` | Ownership/coupling issue unless async work is central |

## Acceptance case

Input:

```text
I await Task.Run in _Ready to load data, then AddChild enemies when it finishes.
Sometimes changing scenes during loading causes errors.
```

Expected output should include:

- classify as mixed background data loading plus main-thread scene mutation
- warn that `AddChild` must happen in the main-thread apply step
- recommend snapshot/data loading in worker and result DTOs back to owner
- require cancellation or stale-result handling on `_ExitTree`
- require owner validity check before apply
- avoid `.Wait()` / `.Result`
- validate scene switch during loading, repeated enter/exit, and slow-task simulation

## Regression cases

A result is weak if it:

- says only "use async" without naming main-thread touch points
- recommends `Task.Run` around `GetNode`, `AddChild`, UI updates, or scene instantiation
- assumes `await` resumes safely on the Godot main thread without evidence
- omits cancellation and scene-exit behavior for node-owned long-running work
- treats `WorkerThreadPool` as automatically safe because it is Godot-provided
- turns into a generic C# concurrency tutorial with no Godot lifecycle analysis
- treats `.NET`, `Task`, `Thread`, `lock`, or `ConcurrentDictionary` as sufficient routing evidence without a Godot boundary trigger
- suggests a global dispatcher without explaining ownership, shutdown, queue policy, and why local apply methods are insufficient

## Future eval suggestion

A minimal eval pack should cover:

1. positive route: `Task.Run` pathfinding crash
2. positive route: threaded resource loading vs custom `Task.Run(ResourceLoader.Load)`
3. positive route: await HTTP then update freed UI
4. negative route: cooldown/tick policy without threading
5. negative route: generic `.NET lock` / `ConcurrentDictionary` / TPL scheduler question without Godot boundary
6. negative route: SDK upgrade failure
7. acceptance artifact: mixed `_Ready` + `Task.Run` + `AddChild` + scene switch
8. anti-pattern guard: `.Wait()`/`.Result` main-thread blocking
9. robustness guard: noisy prompt that mentions both performance and scene ownership but centers on worker apply safety
