# `game-development` layer map

This document records the **current semantic layer alignment** for the `game-development` plugin.

It exists to make the plugin's layer intent explicit **without pretending the current folder layout is a runtime execution graph**.

## Status

- **State:** current alignment note
- **Plugin role:** cross-engine gameplay surface
- **Current semantic layers:** Layer 1 + Layer 2
- **Layer 3 status:** reserved, not currently shipped
- **Layer 4 status:** out of scope for this plugin

## Current layer mapping

| Layer | Current ownership in this plugin | Current surface |
| :---- | :------------------------------- | :-------------- |
| Layer 1 | shared gameplay semantics and foundations | `game-development-condition-rule-engine`, `game-development-resource-transaction-system`, `game-development-time-source-and-tick-policy`, `game-development-world-state-facts`, `game-development-entity-reference-boundary`, `game-development-gameplay-tags-and-query`, `game-development-state-change-notification` |
| Layer 2 | cross-engine runtime-pattern and design workflows | `game-development-behavior-architecture`, `game-development-events-and-signals`, `game-development-command-flow`, `game-development-coordinator`, `game-development-fsm`, `game-development-behavior-tree`, `game-development-goap`, `game-development-utility-ai`, `game-development-object-pool` |
| Layer 3 | family planning / orchestration | no shipped plugin-scoped workers yet; `agents/` is currently a documented reserve surface only |
| Layer 4 | engine or project overlays | not owned here; this belongs in stack-specific plugins such as `godot-dotnet` |

## Structural decision

The current plugin keeps a **flat `skills/` directory** and a flat manifest path on purpose.

That is acceptable for now because:

- the layer mapping is already documented clearly enough in the plugin README and Layer 1 closeout material
- the plugin currently ships no Layer 3 workers, so extra directory ceremony would add more structure than value
- the repository contract treats plugins as packaging surfaces, not execution graphs

## Current constraints

- do not treat Layer 2 workflows as if they own or redefine Layer 1 semantics
- do not treat the flat `skills/` folder as proof that all skills belong to the same semantic layer
- do not populate `agents/` until fresh evidence materially reopens the Stage C worker decision

## Supporting evidence

- Layer 1 closeout and post-closeout stages: [`../layer-1-foundation-candidates.md`](../layer-1-foundation-candidates.md)
- Repo-local eval corpus adapter: [`../../evals/game-development/README.md`](../../evals/game-development/README.md)
- Stage C worker review: [`./evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md`](./evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md)
- Stage D reconsideration review: [`./evidence/layer-1-foundation-candidates-stage-d/stage-d-layer-1-reconsideration-review.md`](./evidence/layer-1-foundation-candidates-stage-d/stage-d-layer-1-reconsideration-review.md)

## Revisit triggers

Revisit this mapping only if one of these becomes true:

- repeated routing confusion makes the flat `skills/` surface harder to maintain than a layer-aware split
- `game-development` gains evidence-backed Layer 3 workers that should be reflected more explicitly in the directory model
- the plugin begins owning engine-aware overlay semantics that no longer fit a pure Layer 1 + Layer 2 cross-engine role
