---
name: godot-dotnet-thread
description: "Use when a Godot/.NET task needs a Layer 4 overlay review or plan for threading, async/await, Task.Run, WorkerThreadPool, threaded resource loading, main-thread marshaling, scene-freeze mitigation, or node lifetime safety specifically because Godot engine state, SceneTree access, Node/Resource lifetime, or main-thread affinity is at risk. Do not use for generic .NET threading without a Godot engine boundary."
---

# Godot .NET Threading

Use this skill when a Godot 4.6 + .NET/C# task involves **threading, async work, background loading, main-thread marshaling, or lifetime hazards after `await`**.

This skill is not a generic C# threading tutorial, not a `.NET Threading` skill in disguise, and not a permission slip to throw Godot APIs into `Task.Run`. Its job is to review or design a safe execution flow for Godot/.NET projects only when Godot engine state, scene lifecycle, resource loading, or main-thread affinity is part of the risk: decide what may leave the Godot main thread, what must return before touching engine-owned state, and how cancellation, stale results, and scene exit are validated.

Prefer this skill when the main risk is code that looks asynchronous but may crash, freeze, update freed nodes, mutate the `SceneTree` from a worker, or hide a lifetime bug behind a cheerful little `await`.

If the task can be answered entirely with ordinary .NET concepts such as locks, `ConcurrentDictionary`, TPL scheduling, channels, cancellation-token basics, or thread-safe collections without mentioning Godot-owned objects, `SceneTree`, `Node`, `Resource`, `Control`, lifecycle callbacks, or main-thread apply, do not use this skill.

## Purpose

This skill is used to:

- classify work as CPU-bound, IO-bound, resource-loading, scene mutation, UI update, or mixed
- identify Godot `Node`, `SceneTree`, `Control`, `Resource`, and `Object` operations that must stay on or return to the main thread
- choose the safest execution model: frame-slicing, `Task`, `Thread`, `WorkerThreadPool`, Godot threaded resource loading, or no threading
- design a `Snapshot -> Work -> Result -> Main-thread apply` flow
- define explicit continuation, marshaling, cancellation, and scene-lifetime rules
- return a structured threading review or execution plan another agent can implement safely

## Hard boundary: Godot first, .NET second

This skill must stay anchored to Godot/.NET overlay concerns.

Use it only when at least one of these is true:

- background work may touch `Node`, `SceneTree`, `Control`, `Resource`, `PackedScene`, signals, autoloads, or live scene state
- an async continuation may update UI, presentation, scene nodes, resources, or gameplay-facing engine state
- a task may outlive `_ExitTree`, scene transition, loading-screen ownership, or node disposal
- the decision is between Godot-specific models such as main-thread apply, frame-slicing, `WorkerThreadPool`, or Godot threaded resource loading
- a hitch, crash, or stale result is tied to Godot lifecycle or engine API access

Do not broaden the answer into a general .NET concurrency design unless the .NET detail is necessary to protect the Godot boundary. Keep generic .NET mechanics as supporting notes, not the center of the artifact.

## Use this skill when

Invoke this skill for requests such as:

- reviewing `Task.Run`, `Thread`, `WorkerThreadPool`, or `async/await` in Godot C#
- fixing scene freezes, loading-screen hitches, pathfinding stalls, procedural generation spikes, or heavy parsing that blocks frames
- deciding whether background work should be a thread, frame-sliced loop, Godot threaded resource load, or pure main-thread sequence
- updating UI, nodes, tile maps, spawned scenes, resources, or presentation state after an async operation
- handling `ObjectDisposedException`, invalid instance access, node-freed-after-await, or stale task results after scene changes
- adding cancellation and lifetime safety around long-running node-owned work

### Trigger examples

- "I use `Task.Run` for pathfinding but Godot sometimes crashes"
- "Loading a big scene causes frame hitches; should I use threaded loading?"
- "`WorkerThreadPool` finishes procedural generation and then updates a `TileMap`"
- "After an HTTP await, my UI sometimes updates after the scene is gone"
- "Can this Godot C# code safely run off the main thread?"

## Do not use this skill when

Do not use this skill when:

- the task is ordinary C# concurrency with no Godot engine, scene, resource, or lifecycle boundary
- the request is mainly about `lock`, `Monitor`, `SemaphoreSlim`, `ConcurrentQueue`, `ConcurrentDictionary`, `Channel<T>`, TPL scheduling, memory barriers, or thread-safe collection choice without a Godot main-thread or lifecycle hazard
- the code is a pure .NET service/library used by a Godot project but the question does not affect `Node`, `SceneTree`, `Resource`, `Control`, signals, loading, or main-thread result application
- the main problem is cooldowns, turn order, or gameplay time semantics rather than threading safety
- the issue is a general build, SDK, editor, or package failure with no threading signal; use `runtime-triage`
- the task is primarily scene ownership or UI/UX review without async/thread risk
- the user wants a full custom async framework or global dispatcher generated by default
- the safest answer is one local synchronous operation and no meaningful threading decision is needed

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Tool Wrapper**, **Generator**

Why this fit is better than the alternatives:

- the main job is to evaluate threading and lifetime risk against Godot/.NET-specific constraints
- the skill packages reusable Godot main-thread, async, worker, and loading heuristics
- the output should be a repeatable review or safe execution plan, not loose advice
- a full Pipeline would add ceremony without enough value, because the ordered safety checks can live directly in this workflow

## Core safety model

Default to this model unless the task has a stronger reason not to:

```text
Main thread:
  capture immutable snapshot

Background work:
  compute / parse / load data without live Node or SceneTree mutation

Result boundary:
  return plain DTOs, immutable data, IDs, or value objects

Main thread:
  verify owner still alive and request still current
  apply result to Node / SceneTree / Control / Resource / UI
```

Treat live Godot objects as main-thread-affine unless the project and Godot API documentation prove a narrower exception.

For reusable details, see `references/threading-model.md` and `references/main-thread-marshaling-patterns.md`.

## Inputs

Collect or infer these inputs when available:

- task summary and expected user-visible behavior
- current async/threading code or proposed execution model
- whether work touches `Node`, `SceneTree`, `Control`, `Resource`, signals, autoloads, `PackedScene`, `TileMap`, UI, or live scene state
- work type: CPU-bound calculation, IO, background parsing, resource loading, scene instantiation, UI update, or mixed
- owner lifetime: which node, scene, service, or autoload starts and owns the work
- cancellation expectations and what should happen on `_ExitTree`, scene change, retry, or game quit
- validation evidence: freeze reproduction, crash logs, stack traces, profiler notes, or slow-task scenario
- current Godot version, .NET target, and platform/export constraints if relevant

If inputs are incomplete, do not block on perfect detail. Infer the smallest safe execution model and mark the assumptions that would change the recommendation.

If the available inputs show only generic .NET concurrency with no Godot engine boundary, route away instead of forcing this template.

## Workflow

Follow this sequence every time.

### 1. Classify the work and execution pressure

State what kind of work is being moved or considered for asynchronous execution.

First state the **Godot boundary trigger**. If there is no Godot boundary trigger, stop and say this is a generic .NET threading question rather than a `godot-dotnet-thread` task.

Classify the primary work type as one of:

- CPU-bound pure calculation
- IO-bound read/write or remote call
- resource loading
- scene or node mutation
- UI or presentation update
- mixed work that must be split
- frame hitch that may be better solved by chunking or frame-slicing

Do not start by choosing `Task.Run` or `WorkerThreadPool`. Start from the work shape and the engine boundary.

### 2. Identify Godot main-thread touch points

List every known or likely touch of engine-owned state.

Check especially for:

- `GetNode`, `GetTree`, `AddChild`, `RemoveChild`, `QueueFree`, `Free`, scene instantiation, node property mutation, UI `Control` updates, signal emission used by presentation, live resource mutation, autoload state with scene-facing side effects
- `Task.Run`, `Thread`, or `WorkerThreadPool` callbacks that capture `Node`, `Resource`, `PackedScene`, `SceneTree`, or UI references
- code that reads a live node in a worker instead of reading an immutable snapshot captured on the main thread

If a background path touches these surfaces, classify it as a risk and move the engine interaction back to a main-thread apply step unless there is explicit documented safety.

### 3. Choose the execution model deliberately

Pick the smallest safe execution model:

- **Stay on main thread** when work is cheap or engine mutation dominates
- **Frame-slice / chunk** when work must interact with scene state over time or can yield across frames
- **`Task` / `Task.Run`** when work is CPU-bound or IO/post-processing and can operate on plain managed data
- **`WorkerThreadPool`** when many independent Godot-side jobs can run without touching live scene state and need bounded completion tracking
- **Godot threaded resource loading** when the need is loading large resources or scenes rather than custom CPU work
- **Dedicated `Thread`** only for a long-lived, clearly owned service with explicit shutdown and no scene-tree mutation

Explain why rejected options were riskier or unnecessarily complex.

### 4. Design the safe data flow

Use `Snapshot -> Work -> Result -> Apply` for mixed work.

Define:

- snapshot captured on the main thread
- background inputs that are plain data, IDs, immutable records, or DTOs
- result shape returned from the worker
- main-thread apply method and what it is allowed to mutate
- stale-result rule if a newer request supersedes the old one

Do not let a worker hold a live `Node` reference just because it only "reads" from it. If a read can be snapshotted, snapshot it.

### 5. Define continuation and main-thread marshaling policy

State explicitly:

- which section is guaranteed to run off the main thread
- which section must run on the Godot main thread
- how the result returns: `CallDeferred`, a known main-thread signal or frame boundary, a project-owned dispatcher, or a direct continuation only when the runtime context is verified
- what happens if the owner has exited the tree before apply

Do not assume every `await` continuation is safe for Godot engine calls unless the project has evidence for that execution context.

See `references/main-thread-marshaling-patterns.md` for safe return patterns and dispatcher cautions.

### 6. Define cancellation, lifetime, and stale-result handling

For node-owned work, define:

- cancellation token owner
- cancellation on `_ExitTree` or equivalent owner disposal
- request/version ID for ignoring stale results
- validity checks before apply, such as owner still current and still inside the tree
- cleanup or wait policy that avoids blocking the main thread
- exception handling for background failures

Use `references/cancellation-lifetime-checklist.md` for the full review checklist.

### 7. Identify anti-patterns and minimal refactor seams

Call out anti-patterns only when they are relevant to the task.

High-signal examples:

- Godot API calls inside `Task.Run`
- `async void` lifecycle methods without containment
- `.Wait()` or `.Result` on the main thread
- background worker mutating nodes, UI, or live resources
- await-then-apply with no cancellation or owner validity check
- scene instantiation or `AddChild` from a worker
- resource loading done with generic threading when Godot threaded loading is the better fit

Recommend the smallest safe refactor seam instead of rewriting the whole subsystem.

### 8. Define validation and regression checks

Include checks that prove both safety and user-visible behavior.

At minimum, consider:

- reproduce the original hitch/crash path
- slow-task simulation
- scene exit while work is running
- repeated enter/exit or retry
- cancellation path
- stale-result path
- no main-thread blocking through `.Wait()` or `.Result`
- export/platform smoke check if threading behavior may differ by target

## Output contract

Return the result using `assets/threading-review.md` in this section order:

- `Task classification`
- `Thread-safety risk map`
- `Recommended execution model`
- `Safe flow`
- `Main-thread marshaling policy`
- `Cancellation and lifetime plan`
- `Anti-patterns found`
- `Validation plan`
- `Assumptions and open checks`

Output rules:

- classify before recommending APIs
- distinguish background data work from main-thread engine mutation
- prefer evidence and concrete risk mapping over generic async warnings
- make cancellation and scene-lifetime handling explicit whenever work outlives a frame
- do not generate a global dispatcher, task framework, or scanner unless the user explicitly asks and the project architecture justifies it
- call out when official API naming or thread-safety details still need version-specific verification
- explicitly state when the request is out of scope because it lacks a Godot engine/lifecycle/main-thread boundary

## Godot/.NET threading heuristics

- The Godot boundary is mandatory; generic .NET concurrency is supporting context only.
- `Task.Run` is a high-risk signal, not automatically a bug.
- `WorkerThreadPool` is useful for bounded data jobs, not a free pass to mutate the scene tree.
- Godot threaded resource loading is usually a better starting point for large resource loads than custom `Task.Run(() => ResourceLoader.Load(...))` code.
- If the work must touch live scene state repeatedly, chunking across frames may be safer than threads.
- Main-thread blocking through `.Wait()` or `.Result` is a freeze/deadlock risk until proven otherwise.
- `async void` is especially risky in lifecycle methods because exceptions, cancellation, and owner lifetime are hard to contain.
- Node-owned async work must assume the node may exit the tree before the result returns.

## Related skills and routing notes

- Use `runtime-triage` first when the symptom is a broad crash, build failure, or editor failure and threading is only one possible cause.
- Use `godot-csharp` when the main task is idiomatic C# implementation and threading is only a minor API detail.
- Use `scene-architecture-review` when the main risk is scene ownership or coupling rather than thread safety.
- Use `test-strategy-review` after the threading plan is chosen and the main question becomes coverage selection.
- Use cross-engine `game-development-time-source-and-tick-policy` for cooldowns, ticks, cadence, and pause semantics that are not primarily about .NET threading or Godot main-thread affinity.
- Answer generic .NET threading questions directly or with a general C# route when no Godot engine boundary exists; do not route them here just because the repository name contains `.NET`.

## Companion files

- `assets/threading-review.md` — reusable output template for the final threading review or execution plan
- `references/threading-model.md` — Godot/.NET main-thread, worker, Task, WorkerThreadPool, and resource-loading decision notes
- `references/main-thread-marshaling-patterns.md` — safe return-to-main-thread patterns, snapshot/result/apply guidance, and dispatcher cautions
- `references/cancellation-lifetime-checklist.md` — cancellation, scene-exit, stale-result, exception, and validation checklist
- `references/routing-and-acceptance-cases.md` — trigger, non-trigger, acceptance, and regression cases for future eval or routing checks

## Validation

A good result should satisfy all of the following:

- work type is classified before execution APIs are recommended
- Godot main-thread touch points are named explicitly
- background work is separated from main-thread apply work
- the execution model is the smallest safe model, not the fanciest async surface
- continuation and marshaling policy is explicit
- cancellation, owner lifetime, and stale-result handling are addressed
- anti-patterns are tied to observed code or stated assumptions
- validation includes scene-exit, slow-task, and repeat-run checks when relevant
- the result stays Godot/.NET-specific instead of drifting into generic C# threading advice
- generic .NET concurrency mechanics are included only when they support a Godot boundary decision

## Common pitfalls

- wrapping `GetNode`, `AddChild`, UI updates, or live resource mutation inside `Task.Run`
- assuming `await` automatically returns to a safe Godot main-thread context
- using `.Wait()` or `.Result` on the main thread to wait for workers
- capturing live nodes or resources in worker closures instead of using snapshots
- omitting cancellation because the first test only covers the happy path
- applying a result after scene change, retry, or node free
- treating `WorkerThreadPool` as a universal performance upgrade
- creating a global dispatcher before the project has a clear ownership reason for one
- turning the skill into a `.NET threading` reference that could apply unchanged to a console app or server process

## Completion rule

This skill is complete when the agent has:

- classified the async/threading work and engine touch points
- chosen the safest execution model
- designed a safe snapshot/work/result/apply flow where needed
- defined continuation, marshaling, cancellation, lifetime, and stale-result rules
- called out relevant anti-patterns
- returned a concrete validation plan for hitch/crash prevention and scene-lifetime safety
