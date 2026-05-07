# Cancellation and Lifetime Checklist

Use this checklist when async or background work may outlive a frame, node, scene, request, or loading flow.

## Ownership

- [ ] The owner that starts the work is named.
- [ ] The owner lifetime is clear: scene-local node, autoload, service, tool, or one-shot operation.
- [ ] The owner is not accidentally a UI node for work that should be owned by a gameplay or loading coordinator.
- [ ] The work has a clear completion target and does not update whichever scene happens to exist later.

## Cancellation

- [ ] A `CancellationToken` or equivalent cancellation signal exists when the work can outlive the owner.
- [ ] Cancellation is triggered on `_ExitTree`, owner disposal, scene change, retry, or explicit cancel as appropriate.
- [ ] Cancellation is checked inside long-running loops or chunked work.
- [ ] Cancellation does not block the main thread while waiting for a worker.
- [ ] The result path distinguishes cancellation from failure when the user experience needs different handling.

## Stale results

- [ ] Repeated or overlapping requests have a request ID, version ID, or equivalent guard.
- [ ] Older completions are ignored when a newer request supersedes them.
- [ ] Scene/resource/path identity is rechecked before apply.
- [ ] UI progress or loading state cannot be overwritten by an old task finishing late.

## Main-thread apply safety

- [ ] The owner is still valid before applying results.
- [ ] The owner is still in the expected tree/state before scene or UI mutation.
- [ ] `Node`, `Control`, `SceneTree`, `PackedScene`, and live `Resource` interactions happen in the apply step.
- [ ] Worker exceptions do not bypass the owner validity check.
- [ ] Freed or exited nodes are not updated after `await`.

## Blocking and deadlock hazards

- [ ] The main thread does not call `.Wait()` or `.Result` on worker tasks.
- [ ] Completion waits are asynchronous, deferred, or moved outside frame-sensitive paths.
- [ ] Worker shutdown does not freeze scene transition or editor exit.
- [ ] Long-running service threads have explicit stop/cleanup behavior.

## Exception handling

- [ ] Background exceptions are observed and routed to a safe reporting path.
- [ ] Exceptions do not disappear inside `async void` lifecycle methods.
- [ ] User-facing failure state is updated only if the owner/request is still current.
- [ ] Debug logs avoid noisy repeated failure loops.

## Validation scenarios

Run or plan these checks when relevant:

- [ ] Original hitch/crash path no longer reproduces.
- [ ] Slow worker finishes after scene exit and does not update freed nodes.
- [ ] User retries work before the first request completes; stale result is ignored.
- [ ] Cancellation path leaves no stuck progress UI or leaked worker state.
- [ ] Repeated enter/exit does not duplicate callbacks, continuations, or queued applies.
- [ ] Export/platform smoke check passes if threading behavior is platform-sensitive.
