# Godot .NET Threading Review

Use this template to return a safe threading review or execution plan for a Godot/.NET task.

Rules:

- classify the work before choosing an API
- separate background data work from main-thread engine mutation
- keep cancellation and owner lifetime visible
- prefer the smallest safe model over thread-shaped ceremony
- say when version-specific Godot API names or thread-safety details still need verification

## Task classification

- Work type: `CPU-bound` / `IO-bound` / `resource loading` / `scene mutation` / `UI update` / `mixed` / `frame hitch`
- Current or proposed async/threading surface:
- Touches `Node`, `SceneTree`, `Control`, `Resource`, `PackedScene`, signals, autoloads, or live scene state: `Yes` / `No` / `Unknown`
- Owner of the work:
- Expected user-visible behavior:

## Thread-safety risk map

| Area | Risk | Reason | Fix or containment |
| --- | --- | --- | --- |
| Example: `Task.Run` body | High | Captures a live node and calls `GetNode` | Capture snapshot on main thread, return DTO, apply on main thread |
| Example: result apply | Medium | Scene may change before task completes | Cancel on `_ExitTree` and ignore stale request ID |

## Recommended execution model

- Recommended model: `main thread` / `frame-sliced` / `Task` / `WorkerThreadPool` / `Godot threaded resource loading` / `dedicated Thread` / `no threading`
- Why this model fits:
- Rejected option:
- Why the rejected option is riskier or unnecessarily complex:

## Safe flow

1. Main-thread snapshot:
2. Background work input:
3. Background work body:
4. Result shape:
5. Main-thread apply step:
6. Stale-result rule:

## Main-thread marshaling policy

- Code that must run on the main thread:
- Code that may run off the main thread:
- Marshaling method: `CallDeferred` / main-thread signal or frame boundary / project dispatcher / verified direct continuation / other
- Owner validity check before apply:
- Resource or scene instantiation rule:

## Cancellation and lifetime plan

- CancellationToken owner:
- Cancel on `_ExitTree` or owner disposal: `Yes` / `No` / `N/A`
- Request/version ID needed: `Yes` / `No`
- Exception handling path:
- Cleanup/wait policy:
- What happens if the node or scene is gone:

## Anti-patterns found

- Anti-pattern:
  - Evidence:
  - Why it matters:
  - Safer replacement:

## Validation plan

- Original hitch/crash/repro path:
- Slow-task simulation:
- Scene exit during work:
- Repeated enter/exit or retry:
- Cancellation path:
- Stale-result path:
- Main-thread blocking check:
- Export/platform smoke check:

## Assumptions and open checks

- Assumption:
- Version-specific API or documentation check still needed:
- Project architecture decision still open:
- What would change the recommendation:
