# `godot-dotnet` layer map

This document records the **current semantic layer alignment** for the `godot-dotnet` plugin.

It exists to make the plugin's overlay role explicit **without confusing plugin packaging with runtime dependency resolution**.

## Status

- **State:** current alignment note
- **Plugin role:** Godot/.NET overlay surface
- **Current semantic layers:** Layer 4 + bounded Layer 3-style internal workers
- **Layer 1 ownership:** not owned here
- **Layer 2 ownership:** not owned here except where stack-specific review or implementation guidance constrains their landing shape

## Current layer mapping

| Layer | Current ownership in this plugin | Current surface |
| :---- | :------------------------------- | :-------------- |
| Layer 4 | Godot/.NET/C#/.tscn implementation, review, testing, and upgrade overlays | `godot-csharp`, `godot-tscn`, `godot-godottest`, `runtime-triage`, `scene-architecture-review`, `abstraction-integrity-review`, `test-strategy-review`, `post-change-review`, `ui-ux-review`, `version-upgrade-review` |
| Layer 3-style internal workers | bounded plugin-scoped orchestration inside the overlay plugin | `runtime-investigator`, `design-reviewer`, `migration-quality-planner` |
| Layer 1 | cross-engine shared semantics | not owned here; prefer cross-engine surfaces such as `plugins/game-development/` when the task is really about gameplay semantics rather than Godot/.NET landing constraints |
| Layer 2 | cross-engine runtime-pattern workflows | not owned here as primary capability; this plugin constrains or reviews how those patterns land in Godot/.NET stacks |

## Structural decision

The current plugin keeps **flat `skills/` and `agents/` directories**.

That is acceptable for now because:

- the overlay role is clearer in documentation than it would be from directory nesting alone
- the shipped workers are already bounded and few in number
- the repository contract allows semantic alignment to be documented before any broad folder reshaping

## Current constraints

- do not move cross-engine gameplay semantics into this plugin just because the implementation stack is Godot/.NET
- do not let Layer 4 overlay guidance silently redefine lower-layer meanings
- keep plugin-scoped workers bounded to mixed overlay tasks that genuinely benefit from stronger structure

## Supporting references

- Repository contract: [`../../layered-skills-vscode-model.md`](../../layered-skills-vscode-model.md)
- Cross-engine gameplay plugin: [`../game-development/README.md`](../game-development/README.md)
- Repo-local benchmark corpus adapter: [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md)

## Revisit triggers

Revisit this mapping only if one of these becomes true:

- a currently shipped worker can be simplified back into one narrower overlay skill
- the plugin begins owning a larger family of stack-specific orchestration workers that deserve a more explicit directory split
- cross-engine semantics start leaking into overlay skills strongly enough that the ownership boundary becomes blurry
