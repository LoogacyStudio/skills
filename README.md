# Loogacy Agent Skills

Reusable **Agent Skills** for coding agents working on **Godot 4.6**, **.NET 10**, and **C#** projects.

For the broader skill format and ecosystem, see [agentskills.io](https://agentskills.io/).

> [!NOTE]
> This repository is **not** a runtime gameplay library, addon, or NuGet package.
> It is a source-controlled collection of reusable agent instructions, reference material, and report templates.

## Overview

This repository currently includes:

- **authoring skills** for creating and maintaining reusable skills
- **plugin-scoped skills** for Godot/.NET investigation, review, validation, and upgrade planning
- a layout designed for agents that discover skills directly from the repository

These skills are intended for agent-assisted workflows such as:

- Godot gameplay and systems programming
- Godot editor tooling and project maintenance
- C# architecture and review workflows
- reusable conventions for agent-driven development

## Skill Catalog

### Core authoring skills

| Skill | Use when | Output |
| :---- | :------- | :----- |
| [`create-reusable-skill`](.agents/skills/create-reusable-skill/) | You want to create a new skill or upgrade an existing one without overbuilding it. | A right-sized skill structure, drafted `SKILL.md`, and supporting assets/references when justified. |

### Plugin: `godot-dotnet`

`plugins/godot-dotnet/plugin.json`

Description: Agent skills for Godot 4.6, .NET 10, and C# coding-agent workflows.

| Skill | Start here when | Main focus |
| :---- | :-------------- | :--------- |
| [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/) | The project is failing, crashing, misbehaving, or the failure layer is still unclear. | Classify the issue, ask for the minimum missing evidence, rank likely causes, and suggest the smallest next probe. |
| [`scene-architecture-review`](plugins/godot-dotnet/skills/scene-architecture-review/) | A Godot scene or system feels messy, overloaded, or hard to change safely. | Review scene composition, ownership boundaries, signals, autoload fit, reuse boundaries, and refactor options. |
| [`test-strategy-review`](plugins/godot-dotnet/skills/test-strategy-review/) | You need a cost-aware validation plan before or alongside implementation. | Separate pure .NET tests from Godot runtime coverage and produce a minimal test matrix with priorities. |
| [`ui-ux-review`](plugins/godot-dotnet/skills/ui-ux-review/) | A HUD, menu, overlay, or interaction flow needs usability review. | Evaluate hierarchy, clarity, feedback, readability, and cognitive load with practical improvements. |
| [`version-upgrade-review`](plugins/godot-dotnet/skills/version-upgrade-review/) | You are planning a Godot/.NET upgrade and want to sequence it safely. | Identify risk areas, stage the migration, define validation checkpoints, and think through rollback early. |

## Quick Start

This repository is intended to be consumed **directly from source**.

1. Make the repository available to your coding agent.
2. Ensure the agent can discover skill folders under `.agents/skills/` and `plugins/*/skills/`.
3. Reference or invoke the relevant skill for the task at hand.
4. For new skills, add standalone skills under `.agents/skills/<skill-name>/` or plugin-specific skills under `plugins/<plugin-name>/skills/<skill-name>/`.

If your agent platform supports workspace or repository-based skill discovery, this structure should fit naturally.

## Which skill should I start with?

If you are using the `godot-dotnet` plugin set, use this rough routing guide:

- **Something is broken and the root cause is unclear** → [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/)
- **A scene or system needs structural review before refactoring** → [`scene-architecture-review`](plugins/godot-dotnet/skills/scene-architecture-review/)
- **You need the smallest useful test plan** → [`test-strategy-review`](plugins/godot-dotnet/skills/test-strategy-review/)
- **You want UI/UX feedback on a flow, menu, HUD, or tool surface** → [`ui-ux-review`](plugins/godot-dotnet/skills/ui-ux-review/)
- **You are changing Godot, .NET, SDK, addon, or export pipeline versions** → [`version-upgrade-review`](plugins/godot-dotnet/skills/version-upgrade-review/)

## What each Godot/.NET skill covers

### `runtime-triage`

Primary problem layers:

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

## Repository Layout

```text
.agents/
└── skills/
    └── create-reusable-skill/
        ├── SKILL.md
        ├── assets/
        │   ├── intake-questionnaire.md
        │   ├── review-template.md
        │   └── skill-template.md
        └── references/
            ├── pattern-decision-guide.md
            └── skill-review-checklist.md

plugins/
└── godot-dotnet/
    ├── plugin.json
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

- `SKILL.md` for the main operating instructions
- `references/` for reusable guidance, heuristics, and checklists
- `assets/` for templates, examples, and report skeletons

## Authoring Guidelines

When adding or updating skills:

- keep skills narrowly scoped and reusable
- make descriptions trigger-oriented so agents know when to load them
- prefer concrete, ordered workflows over vague advice
- keep validation criteria observable
- move bulky reusable material out of `SKILL.md` when possible
- place reusable rules in `references/`
- place templates and examples in `assets/`
- avoid unsupported runtime assumptions

## License

See [LICENSE](LICENSE) for details.
