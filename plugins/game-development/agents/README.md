# `game-development` internal workers

No plugin-scoped internal workers are shipped yet.

## Current status

- **Stage C worker-justification review:** completed `2026-04-23`
- **Current decision:** keep the plugin on the direct-skill route and ship **0** internal workers for now

## Why this directory is still present

This directory remains the reserved extension point for future plugin-scoped workers **only if** repeated evidence shows that the direct-skill route is materially under-serving `game-development` tasks.

Current supporting review:

- [`../evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md`](../evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md)

## Reopen criteria

Reopen the worker question only when future evidence repeatedly shows one or more of these pressures:

- one routing step plus one deeper plugin-local specialization step keeps recurring
- tighter context boundaries are needed than the calling agent can maintain directly
- multi-artifact output packaging becomes awkward enough that a reusable worker boundary would reduce real confusion

Until then, keep this directory documentation-only.
