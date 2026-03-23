# `godot-dotnet` Plugin

Reusable agent skills for **Godot 4.6**, **.NET 10**, and **C#** workflows.

This plugin packages a focused set of review and planning skills for Godot/.NET projects. It is meant for coding agents that need stronger judgment around troubleshooting, scene architecture, testing strategy, UI/UX quality, and upgrade planning.

> [!NOTE]
> This plugin is **not** a Godot addon, runtime library, or NuGet package.
> It is a repository-scoped bundle of agent skills, reference notes, and output templates.

## What this plugin is for

Use `godot-dotnet` when an agent is working in a Godot project that uses:

- Godot scenes and node hierarchies
- C# gameplay, tools, or editor-side code
- .NET SDK / project / package workflows
- review-heavy tasks where the right next step matters more than immediately editing files

The skills in this plugin are designed to help agents:

- classify failures before making risky fixes
- review scene and system boundaries with Godot-specific concerns in mind
- choose practical, layered test coverage
- evaluate HUD, menus, overlays, and tool UI from a usability perspective
- plan upgrades without doing a single giant “YOLO migration”

## What is included

This plugin now ships with two layers:

1. **Reusable skills** — portable review/planning methods
2. **Internal workers** — read-only plugin-scoped agents that compose those skills into bounded specialist roles

### Internal workers

These are intended for **coordinator-driven subagent use**, not direct end-user invocation.

| Agent | Use when | Composes | Main output |
| :---- | :------- | :------- | :---------- |
| [`runtime-investigator`](./agents/runtime-investigator.agent.md) | A project is broken and the first failing layer is still unclear. | `runtime-triage` + validation-minded support | Evidence-led triage report with ranked hypotheses, evidence gaps, next probe, and verification steps. |
| [`design-reviewer`](./agents/design-reviewer.agent.md) | A scene/system/HUD/menu needs a combined maintainability + UX review. | `scene-architecture-review` + `ui-ux-review` + validation support | Structured design review with architecture-vs-UX split, prioritized recommendations, and validation ideas. |
| [`migration-quality-planner`](./agents/migration-quality-planner.agent.md) | A Godot/.NET/addon/export-chain upgrade needs staged migration planning plus quality verification. | `version-upgrade-review` + `test-strategy-review` + optional triage support | Migration-quality plan with impact summary, risk matrix, staged sequence, smoke/regression plan, and rollback thinking. |

### Reusable skills

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`runtime-triage`](./skills/runtime-triage/) | A Godot/.NET project is broken, noisy, crashing, or behaving incorrectly and the failure layer is still unclear. | A focused triage report with likely layers, ranked causes, missing evidence, and the smallest useful next probe. |
| [`scene-architecture-review`](./skills/scene-architecture-review/) | A scene, UI flow, or gameplay system feels overloaded, tightly coupled, or hard to change safely. | A structured architecture review with findings, risk areas, and concrete refactor directions. |
| [`test-strategy-review`](./skills/test-strategy-review/) | A feature, bug fix, refactor, or migration needs a realistic validation plan. | A layered, cost-aware test matrix that separates pure .NET coverage from Godot runtime checks. |
| [`ui-ux-review`](./skills/ui-ux-review/) | A HUD, menu, overlay, prompt flow, or in-game tool UI needs usability review. | A task-oriented UX review with quick wins, structural improvements, and verification ideas. |
| [`version-upgrade-review`](./skills/version-upgrade-review/) | A Godot, .NET SDK, package, addon, or export pipeline upgrade needs safer sequencing. | A staged upgrade plan with risk areas, validation gates, and rollback thinking. |

## Where should I start?

### If your runtime supports plugin-scoped agents

- **Something is failing and the root cause is unclear** → [`runtime-investigator`](./agents/runtime-investigator.agent.md)
- **A scene/system/UI flow needs maintainability + UX review together** → [`design-reviewer`](./agents/design-reviewer.agent.md)
- **You are planning an upgrade and need verification / rollback thinking too** → [`migration-quality-planner`](./agents/migration-quality-planner.agent.md)

### If your runtime only consumes skills directly

- **Something is failing and the root cause is unclear** → [`runtime-triage`](./skills/runtime-triage/)
- **A scene or system feels structurally messy** → [`scene-architecture-review`](./skills/scene-architecture-review/)
- **You want the smallest useful validation plan** → [`test-strategy-review`](./skills/test-strategy-review/)
- **A screen or interaction flow needs UX feedback** → [`ui-ux-review`](./skills/ui-ux-review/)
- **You are preparing a version or toolchain upgrade** → [`version-upgrade-review`](./skills/version-upgrade-review/)

## How the pieces fit together

- `runtime-investigator` is the **failure-framing** worker.
- `design-reviewer` is the **structure + UX review** worker.
- `migration-quality-planner` is the **upgrade-risk + validation** worker.

The workers are intentionally read-only and bounded. They do not replace implementation agents; they improve decision quality before fixes, refactors, or upgrades begin.

## Skill coverage at a glance

### `runtime-triage`

Primary failure layers:

1. `build / compile`
2. `.NET project / SDK / restore`
3. `Godot editor configuration`
4. `scene / resource loading`
5. `runtime exception / logic bug`
6. `environment / version / tooling mismatch`

### `scene-architecture-review`

Primary review dimensions:

1. `scene split reasonableness`
2. `node hierarchy responsibility load`
3. `script ownership clarity`
4. `signal health and communication style`
5. `autoload / singleton fit vs overuse`
6. `UI and gameplay coupling depth`
7. `scene reusable boundary clarity`

### `test-strategy-review`

Primary testing layers:

1. `pure C# logic tests`
2. `Godot runtime-dependent tests`
3. `scene / integration tests`
4. `UI / flow / interaction validation`
5. `smoke tests`
6. `regression checks`

### `ui-ux-review`

Primary review dimensions:

1. `information hierarchy`
2. `user focus / attention flow`
3. `interaction clarity`
4. `state feedback`
5. `cognitive load`
6. `consistency`
7. `readability / density`
8. `critical action discoverability`

### `version-upgrade-review`

Primary upgrade domains:

1. `Godot engine version`
2. `.NET SDK and project target changes`
3. `C# compatibility implications`
4. `addon / plugin compatibility`
5. `export pipeline implications`
6. `verification strategy`
7. `rollback / branch strategy`

## Plugin structure

```text
godot-dotnet/
├── plugin.json
├── README.md
├── agents/
│   ├── design-reviewer.agent.md
│   ├── migration-quality-planner.agent.md
│   └── runtime-investigator.agent.md
└── skills/
    ├── runtime-triage/
    │   ├── SKILL.md
    │   ├── assets/
    │   │   └── runtime-triage-report.md
    │   └── references/
    │       └── triage-categories.md
    ├── scene-architecture-review/
    │   ├── SKILL.md
    │   ├── assets/
    │   │   └── review-report.md
    │   └── references/
    │       └── godot-architecture-notes.md
    ├── test-strategy-review/
    │   ├── SKILL.md
    │   ├── assets/
    │   │   └── test-matrix.md
    │   └── references/
    │       └── testing-notes.md
    ├── ui-ux-review/
    │   ├── SKILL.md
    │   ├── assets/
    │   │   └── ui-ux-review-template.md
    │   └── references/
    │       └── ui-ux-rubric.md
    └── version-upgrade-review/
        ├── SKILL.md
        ├── assets/
        │   └── upgrade-plan.md
        └── references/
            └── migration-notes.md
```

Each skill typically uses:

- `SKILL.md` for the main operating workflow and triggering guidance
- `references/` for reusable heuristics, notes, and checklists
- `assets/` for report templates, matrices, and reusable output skeletons

## How to use this plugin

This plugin is intended to be consumed **directly from source** by an agent runtime that can discover repository-based skills and, when available, plugin-scoped agents.

Typical usage flow:

1. Make this repository available to the agent.
2. Ensure the runtime can discover skills under `plugins/godot-dotnet/skills/`.
3. Either route the task to a matching skill directly, or delegate to a plugin-scoped internal worker if your runtime supports it.
4. Use the returned artifact to drive follow-up implementation, testing, or release decisions.

Practical rule of thumb:

- use **skills** when one agent can keep the whole task context safely
- use **internal workers** when you want bounded, reusable, read-only specialist output without polluting the main conversation

## Plugin metadata

Current plugin manifest:

- `name`: `godot-dotnet`
- `version`: `0.1.0`
- `description`: `Agent skills for Godot 4.6, .NET 10, and C# coding-agent workflows.`

See [`plugin.json`](./plugin.json) for the source of truth.

## Authoring notes

When adding to this plugin:

- keep each skill narrow, reusable, and trigger-oriented
- prefer review and planning workflows that produce concrete outputs
- encode Godot-specific concerns explicitly instead of falling back to generic clean-code advice
- move bulky reusable material into `references/` or `assets/` rather than overloading `SKILL.md`
- keep filenames and folder names stable so agents can discover them reliably
