# Loogacy Agent Skills

Reusable agent skills for coding agents working on Godot 4.6, .NET 10, and C# projects.

For the broader skill format and ecosystem, see [agentskills.io](https://agentskills.io/).

> [!NOTE]
> This repository is not a runtime gameplay library, addon, or NuGet package.
> It is a versioned collection of reusable agent instructions, reference notes, report templates, and plugin-scoped internal workers.

## Quick start

This repository is meant to be consumed directly from source.

1. Make the repository available to your coding agent.
2. Ensure the agent can discover skill folders under `.agents/skills/` and `plugins/*/skills/`.
3. If your runtime supports plugin-scoped agents, also expose `plugins/*/agents/`.
4. Route the task to the right skill or internal worker for the job.
5. When adding new material, place standalone authoring skills under `.agents/skills/<skill-name>/` and plugin-specific material under `plugins/<plugin-name>/`.

Practical rule of thumb:

- use **skills** when one agent can safely keep the whole task context
- use **internal workers** when you want bounded, reusable, read-only specialist output without polluting the main conversation

## What this repo is for

This repo does two jobs.

- It keeps a small set of **authoring skills** for building new skills and designing subagent topologies.
- It packages a **Godot/.NET plugin set** for investigation, review, validation, and upgrade planning.

In practice, this is for agent-assisted work like:

- Godot gameplay and systems programming
- Godot editor tooling and project maintenance
- C# architecture and review work
- reusable conventions for agent-driven development

## What is included

### Core authoring skills

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`create-reusable-skill`](.agents/skills/create-reusable-skill/) | You want to create a new skill or tighten up an existing one without overbuilding it. | A right-sized skill structure, drafted `SKILL.md`, and support files only when they are actually justified. |
| [`create-subagents`](.agents/skills/create-subagents/) | You need to decide whether a task should stay single-agent or be split into a bounded subagent topology. | A recommendation state, topology blueprint, subagent specs, shared-state plan, evaluation checklist, and provider overlays. |

### Plugin: `godot-dotnet`

Source of truth: [`plugins/godot-dotnet/plugin.json`](plugins/godot-dotnet/plugin.json)

This plugin has two layers of its own:

1. reusable skills
2. plugin-scoped internal workers

If you want the deeper breakdown, read [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md). The root README is the front desk; the plugin README is where the real tour starts.

#### Plugin-scoped internal workers

These are read-only internal workers meant for coordinator-driven delegation.

| Agent | Use when | Composes | Main output |
| :---- | :------- | :------- | :---------- |
| [`runtime-investigator`](plugins/godot-dotnet/agents/runtime-investigator.agent.md) | A project is broken and the first failing layer is still unclear. | `runtime-triage` plus validation-minded support | An evidence-led triage report with ranked hypotheses, evidence gaps, next probe, and verification steps. |
| [`design-reviewer`](plugins/godot-dotnet/agents/design-reviewer.agent.md) | A scene, system, HUD, menu, or flow needs a combined maintainability and UX review. | `scene-architecture-review`, `ui-ux-review`, and validation support | A structured design review with an architecture-vs-UX split, prioritized recommendations, and validation ideas. |
| [`migration-quality-planner`](plugins/godot-dotnet/agents/migration-quality-planner.agent.md) | A Godot/.NET/addon/export-chain upgrade needs staged migration planning plus quality validation. | `version-upgrade-review`, `test-strategy-review`, and optional triage support | A migration-quality plan with impact summary, risk matrix, staged sequence, smoke/regression planning, and rollback thinking. |

#### Plugin skills

| Skill | Start here when | Main focus |
| :---- | :-------------- | :--------- |
| [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/) | The project is failing, crashing, misbehaving, or the failure layer is still unclear. | Classify the issue, ask for the minimum missing evidence, rank likely causes, and suggest the smallest next probe. |
| [`scene-architecture-review`](plugins/godot-dotnet/skills/scene-architecture-review/) | A Godot scene or system feels messy, overloaded, or hard to change safely. | Review scene composition, ownership boundaries, signals, autoload fit, reuse boundaries, and refactor options. |
| [`test-strategy-review`](plugins/godot-dotnet/skills/test-strategy-review/) | You need a cost-aware validation plan before or alongside implementation. | Separate pure .NET tests from Godot runtime coverage and produce a minimal test matrix with priorities. |
| [`ui-ux-review`](plugins/godot-dotnet/skills/ui-ux-review/) | A HUD, menu, overlay, or interaction flow needs usability review. | Evaluate hierarchy, clarity, feedback, readability, and cognitive load with practical improvements. |
| [`version-upgrade-review`](plugins/godot-dotnet/skills/version-upgrade-review/) | You are planning a Godot/.NET upgrade and want to sequence it safely. | Identify risk areas, stage the migration, define validation checkpoints, and think through rollback early. |

## Where to start

### If you are working on authoring the agent system itself

- **You want to create or upgrade a reusable skill** → [`create-reusable-skill`](.agents/skills/create-reusable-skill/)
- **You want to decide whether and how to split work into subagents** → [`create-subagents`](.agents/skills/create-subagents/)

### If you are using the `godot-dotnet` plugin set

If your runtime supports plugin-scoped agents:

- **Something is broken and the root cause is unclear** → [`runtime-investigator`](plugins/godot-dotnet/agents/runtime-investigator.agent.md)
- **A scene/system/UI flow needs maintainability plus UX review together** → [`design-reviewer`](plugins/godot-dotnet/agents/design-reviewer.agent.md)
- **You are planning an upgrade and need smoke, regression, and rollback thinking too** → [`migration-quality-planner`](plugins/godot-dotnet/agents/migration-quality-planner.agent.md)

If your runtime only consumes skills directly:

- **Something is broken and the root cause is unclear** → [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/)
- **A scene or system needs structural review before refactoring** → [`scene-architecture-review`](plugins/godot-dotnet/skills/scene-architecture-review/)
- **You need the smallest useful test plan** → [`test-strategy-review`](plugins/godot-dotnet/skills/test-strategy-review/)
- **You want UI/UX feedback on a flow, menu, HUD, or tool surface** → [`ui-ux-review`](plugins/godot-dotnet/skills/ui-ux-review/)
- **You are changing Godot, .NET, SDK, addon, or export pipeline versions** → [`version-upgrade-review`](plugins/godot-dotnet/skills/version-upgrade-review/)

## How the pieces fit together

The three plugin workers each have a clear job:

- `runtime-investigator` handles failure framing.
- `design-reviewer` handles structure and UX review together.
- `migration-quality-planner` handles upgrade risk and validation planning.

They are intentionally read-only. They do not replace implementation agents. Their job is to improve decisions before fixes, refactors, or upgrades begin.

The underlying skills stay useful on their own when a runtime does not support subagents or when one agent can safely keep the whole task context. If you want the full review dimensions, templates, or plugin-specific structure, use the plugin README and the individual skill folders instead of treating this page like the entire manual.

## Repository layout

```text
.agents/
└── skills/                 # repo-wide authoring skills

plugins/
└── godot-dotnet/
    ├── plugin.json         # plugin metadata
    ├── README.md           # plugin-specific usage guide
    ├── agents/             # internal workers
    └── skills/             # Godot/.NET reusable skills
```

Inside a typical skill folder, you will usually see:

- `SKILL.md` for the main operating instructions
- `references/` for reusable guidance, heuristics, and checklists
- `assets/` for templates, examples, and report skeletons

## Authoring guidelines

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
