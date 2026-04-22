# `game-development` Plugin

Reusable agent skills for cross-engine game-development design, review, and refactor work.

This plugin focuses on a small set of recurring gameplay and systems problems: behavior-architecture choice, communication topology, action flow, bounded coordination, behavior control patterns, and evidence-led object reuse. The surface stays intentionally narrow: one focused skill is better than a plugin that tries to solve every game problem with a single oversized hammer.

> [!NOTE]
> This plugin is **not** a runtime package, asset pack, engine addon, or game framework.
> It is a repository-hosted plugin bundle of reusable agent skills and any future plugin-scoped internal workers that live under [`./agents/`](./agents/).

## What this plugin is for

Use `game-development` when an agent is working on cross-engine or engine-adjacent gameplay problems such as:

- choosing whether a behavior problem should stay simple or move into FSM, behavior tree, Utility AI, or GOAP territory
- defining event/signal topology, command flow, or bounded coordinators for cross-system collaboration
- reviewing state-heavy, tree-shaped, score-driven, or goal-driven behavior before implementation grows messy
- deciding whether hot-path object reuse is justified, safe, and measurable
- keeping solutions portable across more than one engine family unless an engine-specific tradeoff is the point

These skills are meant to stay:

- narrow enough to trigger reliably
- concrete enough to guide implementation choices
- portable enough to avoid needless engine lock-in

## What is included

This plugin currently ships:

- **9 reusable skills** under [`./skills/`](./skills/)
- **0 plugin-scoped internal workers** under [`./agents/`](./agents/)

### Reusable skills

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`game-development-behavior-architecture`](./skills/game-development-behavior-architecture/) | A gameplay, AI, or interaction system is outgrowing ad-hoc rules and the agent must choose between a simpler flow, FSM, behavior tree, Utility AI, or GOAP. | A behavior-architecture brief with candidate comparison, recommended fit, ownership boundaries, data/interruption model, migration steps, and verification notes. |
| [`game-development-events-and-signals`](./skills/game-development-events-and-signals/) | Gameplay, UI, or cross-system flow is accumulating signal spaghetti, hidden event coupling, or unclear direct-call vs event boundaries. | An events/signals brief with communication boundary, publisher/subscriber map, event contract rules, lifecycle policy, migration plan, and verification notes. |
| [`game-development-command-flow`](./skills/game-development-command-flow/) | Action flow is accumulating direct-call coupling, ad-hoc queues, fragile undo/redo, or unclear request-versus-execution boundaries. | A command-flow brief with action boundary, producer/executor model, command contract, execution rules, history/replay notes, migration plan, and verification notes. |
| [`game-development-coordinator`](./skills/game-development-coordinator/) | A scene or subsystem is accumulating brittle reference chains, root-node god scripts, or unclear coordination ownership. | A coordinator brief with coordination boundary, coordinator shape, public surface, internal ownership map, lifecycle policy, migration plan, and verification notes. |
| [`game-development-behavior-tree`](./skills/game-development-behavior-tree/) | A gameplay or AI system is already tree-shaped and needs explicit branch hierarchy, blackboard ownership, and interrupt rules. | A behavior-tree brief with branch hierarchy, tree shape, blackboard design, interrupt model, rollout steps, and verification notes. |
| [`game-development-goap`](./skills/game-development-goap/) | A gameplay or AI problem is goal-driven and needs multi-step planning with explicit facts, actions, costs, and replanning rules. | A GOAP planning brief with planning boundary, fact model, goal model, action library, replanning rules, rollout steps, and verification notes. |
| [`game-development-utility-ai`](./skills/game-development-utility-ai/) | A gameplay or AI problem is about scoring several simultaneously valid options and needs explicit candidates, considerations, and reevaluation rules. | A Utility AI brief with scoring boundary, candidate model, scorer design, score composition, stability rules, rollout steps, and verification notes. |
| [`game-development-fsm`](./skills/game-development-fsm/) | Gameplay, AI, UI, or interaction logic is turning into large branches, repeated enter/exit behavior, or scattered transition rules. | An FSM refactor brief with state boundary, state list, transition model, recommended shape, integration plan, rollout steps, and verification notes. |
| [`game-development-object-pool`](./skills/game-development-object-pool/) | A hot path shows repeated spawn/despawn churn, GC spikes, or frame drops around short-lived reusable objects. | A pooling brief with candidate analysis, pool boundary/API, reset contract, engine integration notes, rollout steps, and benchmark guidance. |

### Internal workers

No plugin-scoped internal workers are shipped yet in `plugins/game-development/agents/`.

That is intentional: the current surface is still narrow enough that the direct skill route is the better default.

## Where should I start?

- **Architecture still unclear** — start with [`game-development-behavior-architecture`](./skills/game-development-behavior-architecture/) when the real question is whether the system should stay simple or move into FSM / behavior tree / Utility AI / GOAP.
- **Notification topology is the problem** — use [`game-development-events-and-signals`](./skills/game-development-events-and-signals/) when the main concern is direct-call vs event boundaries, subscription lifecycle, or signal traceability.
- **Requests are tangled with execution** — use [`game-development-command-flow`](./skills/game-development-command-flow/) when the main concern is request/execution boundaries, action queues, validation, or undo/redo and replay design.
- **One bounded area needs a stable gateway** — use [`game-development-coordinator`](./skills/game-development-coordinator/) when the main concern is scene/subsystem coordination ownership, volatile internals exposure, or god-object drift.
- **State-heavy mode logic is the main issue** — use [`game-development-fsm`](./skills/game-development-fsm/) when the problem is states, transitions, and enter/exit ownership.
- **Hierarchical reactive behavior is the main shape** — use [`game-development-behavior-tree`](./skills/game-development-behavior-tree/) when priorities, fallback branches, running tasks, and interrupts dominate the design.
- **Multi-step goal planning is required** — use [`game-development-goap`](./skills/game-development-goap/) when the system needs goals, world facts, actions, and replanning.
- **Context-sensitive scoring is required** — use [`game-development-utility-ai`](./skills/game-development-utility-ai/) when several options stay valid at once and the problem is scoring, tuning, and observability.
- **Measured spawn/despawn churn is the issue** — use [`game-development-object-pool`](./skills/game-development-object-pool/) when the problem is reuse, reset safety, and benchmarked hot-path churn. For Godot lifecycle cautions, then read [`references/godot-reference.md`](./skills/game-development-object-pool/references/godot-reference.md).

## Plugin structure

```text
game-development/
├── plugin.json
├── README.md
├── agents/
└── skills/
    ├── game-development-behavior-architecture/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-events-and-signals/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-command-flow/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-coordinator/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-behavior-tree/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-goap/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-utility-ai/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    ├── game-development-fsm/
    │   ├── SKILL.md
    │   ├── assets/
    │   └── references/
    └── game-development-object-pool/
        ├── SKILL.md
        ├── assets/
        └── references/
```

For **Market 1 cloneability**, treat the market-facing plugin payload as `plugin.json`, `README.md`, `agents/`, and `skills/`.

## How to use this plugin

This plugin is intended to be consumed **directly from source** by an agent runtime that can discover repository-based skills and, when available later, plugin-scoped agents.

Typical usage flow:

1. Make this repository available to the agent.
2. Ensure the runtime can discover skills under `plugins/game-development/skills/`.
3. Route the task directly to the matching skill.
4. Use the returned artifact to drive follow-up implementation, profiling, or refactor decisions.

Practical rule of thumb:

- use the direct **skill** route when the problem is narrow and evidence-led
- add plugin-scoped workers later only when the task shape becomes genuinely mixed or multi-artifact
- do **not** add abstraction ceremony just because it looks fancy in a diagram at 2 a.m.

## Plugin metadata

Current plugin manifest:

- `name`: `game-development`
- `version`: `0.0.1`
- `description`: `Reusable agent skills for cross-engine game-development design, review, and refactor workflows.`

See [`plugin.json`](./plugin.json) for the source of truth.

## Authoring notes

When adding to this plugin:

- keep skills portable across engine families unless an engine-specific tradeoff is the point
- make trigger wording explicit in each `description`
- prefer concrete performance evidence over instinct-only optimization advice
- keep reusable heuristics in `references/` instead of overloading `SKILL.md`
- add plugin-scoped workers only when one narrow skill clearly under-serves the task shape
