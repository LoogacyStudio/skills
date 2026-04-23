# `game-development` Plugin

Reusable agent skills for cross-engine game-development design, review, and refactor work.

This plugin covers the gameplay seams that usually get messy first: behavior-architecture choice, communication topology, action flow, bounded coordination, stateful AI patterns, object reuse, and the current `3 + 2 + 2` shared-semantics rollout for conditions, resources, time, world facts, references, tags, and state-change notifications.

The intent is still restraint. These skills are supposed to help an agent make better design calls without turning the plugin into a pretend engine framework.

> [!NOTE]
> This plugin is **not** a runtime package, asset pack, engine addon, or game framework.
> It is a repository-hosted plugin bundle of reusable agent skills and any future plugin-scoped internal workers that live under [`./agents/`](./agents/).

Within the repository's current layered contract, `game-development` is the **cross-engine gameplay plugin** that currently owns **Layer 1 foundations** and **Layer 2 shared-runtime workflows**. It does **not** currently ship Layer 3 workers.

## Boundary map

Use this split when deciding where to start:

- **Plugin surface itself** -> this README plus [`./skills/`](./skills/) and, later if needed, [`./agents/`](./agents/) for shipped plugin material.
- **Current layer map** -> [`./layer-map.md`](./layer-map.md) for the repo-facing Layer 1 / Layer 2 / Layer 3 alignment of this plugin.
- **Repo-local eval corpus** -> [`../../evals/game-development/README.md`](../../evals/game-development/README.md) for the benchmark corpus, manifests, scoring guide, and run-evidence layout that validate this plugin's routing and boundary behavior.
- **Layer 1 foundation rollout** -> [`../layer-1-foundation-candidates.md`](../layer-1-foundation-candidates.md) for the current `3 + 2 + 2` foundation plan and rationale.
- **Repo-wide authoring workflows** -> [`../../.agents/skills/`](../../.agents/skills/) when the real task is skill creation, agent splitting, plan grilling, or session handoff.
- **Repo-wide benchmark and eval workflow** -> [`../../.github/skills/`](../../.github/skills/) and [`../../.github/agents/`](../../.github/agents/) when the work is benchmark authoring, judging, clustering, reruns, or promotion review.

If you're new here, the short version is simple: use a direct skill when one bounded gameplay design artifact is enough, and only add plugin-scoped workers later if the task genuinely mixes several dimensions.

The plugin payload and the eval surface stay separate on purpose: plugin-facing material lives here under `plugins/game-development/`, while repeatable routing and boundary evidence lives under [`../../evals/game-development/`](../../evals/game-development/README.md).

## What this plugin is for

Use `game-development` when an agent is working on cross-engine or engine-adjacent gameplay problems such as:

- choosing whether a behavior problem should stay simple or move into FSM, behavior tree, Utility AI, or GOAP territory
- defining event or signal topology, command flow, or bounded coordinators for cross-system collaboration
- reviewing state-heavy, tree-shaped, score-driven, or goal-driven behavior before implementation grows messy
- defining shared semantics for conditions, resource spending, cooldowns, and reevaluation cadence before higher-level skills drift apart
- deciding whether hot-path object reuse is justified, safe, and measurable
- keeping solutions portable across more than one engine family unless an engine-specific tradeoff is the point

These skills are meant to stay:

- narrow enough to trigger reliably
- concrete enough to guide implementation choices
- portable enough to avoid needless engine lock-in

## What is included

This plugin currently ships:

- **16 reusable skills** under [`./skills/`](./skills/)
- **0 plugin-scoped internal workers** under [`./agents/`](./agents/)

### Layer 1 — Foundation and shared-semantics skills

These skills give the higher-level behavior and action-flow work a shared floor. They now cover the full initial `3 + 2 + 2` rollout, not just the first three core seams.

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`game-development-condition-rule-engine`](./skills/game-development-condition-rule-engine/) | Gameplay, AI, interaction, or action systems are accumulating ad-hoc preconditions, guard clauses, transition checks, or composite eligibility rules. | A condition-model brief with rule boundary, atomic and composite rule design, input ownership, evaluation timing, observability, migration steps, and verification notes. |
| [`game-development-resource-transaction-system`](./skills/game-development-resource-transaction-system/) | Gameplay actions, planners, or UI paths are drifting on cost checks, spend timing, reservations, refunds, or commit and rollback rules. | A resource-transaction brief with transaction boundary, ownership model, affordability and reservation semantics, failure and refund policy, migration steps, and verification notes. |
| [`game-development-time-source-and-tick-policy`](./skills/game-development-time-source-and-tick-policy/) | Timers, cooldowns, reevaluation cadence, pause behavior, or frame-vs-fixed-step assumptions are spreading without a named clock policy. | A time-policy brief with timing boundary, clock ownership, cadence model, cooldown and reevaluation rules, pause and drift policy, migration steps, and verification notes. |
| [`game-development-world-state-facts`](./skills/game-development-world-state-facts/) | Blackboard entries, planner state, observed facts, freshness rules, or truth ownership are drifting between systems. | A world-facts brief with fact boundary, source ownership, freshness policy, observed vs inferred state, integration notes, migration steps, and verification notes. |
| [`game-development-entity-reference-boundary`](./skills/game-development-entity-reference-boundary/) | Targeting, object handles, payload references, pooled identity reuse, or lifetime-safe lookups are getting muddy. | An entity-reference brief with identity boundary, lookup strategy, stable-handle vs direct-reference rules, lifetime policy, migration steps, and verification notes. |
| [`game-development-gameplay-tags-and-query`](./skills/game-development-gameplay-tags-and-query/) | Tag taxonomies, tag-driven filtering, or query semantics are starting to sprawl into label soup. | A tag-query brief with tag boundary, taxonomy rules, query semantics, ownership cautions, migration steps, and verification notes. |
| [`game-development-state-change-notification`](./skills/game-development-state-change-notification/) | Observers, UI, AI, or caches need consistent change boundaries, payload semantics, invalidation rules, or notification batching. | A state-change brief with notification boundary, timing rules, payload policy, invalidation and batching rules, migration steps, and verification notes. |

### Layer 2 — Higher-level gameplay and architecture skills

These are the more visible design and review skills that route gameplay structure decisions.

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`game-development-behavior-architecture`](./skills/game-development-behavior-architecture/) | A gameplay, AI, or interaction system is outgrowing ad-hoc rules and the agent must choose between a simpler flow, FSM, behavior tree, Utility AI, or GOAP. | A behavior-architecture brief with candidate comparison, recommended fit, ownership boundaries, data and interruption model, migration steps, and verification notes. |
| [`game-development-events-and-signals`](./skills/game-development-events-and-signals/) | Gameplay, UI, or cross-system flow is accumulating signal spaghetti, hidden event coupling, or unclear direct-call vs event boundaries. | An events-and-signals brief with communication boundary, publisher/subscriber map, event contract rules, lifecycle policy, migration plan, and verification notes. |
| [`game-development-command-flow`](./skills/game-development-command-flow/) | Action flow is accumulating direct-call coupling, ad-hoc queues, fragile undo/redo, or unclear request-versus-execution boundaries. | A command-flow brief with action boundary, producer/executor model, command contract, execution rules, history and replay notes, migration plan, and verification notes. |
| [`game-development-coordinator`](./skills/game-development-coordinator/) | A scene or subsystem is accumulating brittle reference chains, root-node god scripts, or unclear coordination ownership. | A coordinator brief with coordination boundary, coordinator shape, public surface, internal ownership map, lifecycle policy, migration plan, and verification notes. |
| [`game-development-behavior-tree`](./skills/game-development-behavior-tree/) | A gameplay or AI system is already tree-shaped and needs explicit branch hierarchy, blackboard ownership, and interrupt rules. | A behavior-tree brief with branch hierarchy, tree shape, blackboard design, interrupt model, rollout steps, and verification notes. |
| [`game-development-goap`](./skills/game-development-goap/) | A gameplay or AI problem is goal-driven and needs multi-step planning with explicit facts, actions, costs, and replanning rules. | A GOAP planning brief with planning boundary, fact model, goal model, action library, replanning rules, rollout steps, and verification notes. |
| [`game-development-utility-ai`](./skills/game-development-utility-ai/) | A gameplay or AI problem is about scoring several simultaneously valid options and needs explicit candidates, considerations, and reevaluation rules. | A Utility AI brief with scoring boundary, candidate model, scorer design, score composition, stability rules, rollout steps, and verification notes. |
| [`game-development-fsm`](./skills/game-development-fsm/) | Gameplay, AI, UI, or interaction logic is turning into large branches, repeated enter and exit behavior, or scattered transition rules. | An FSM refactor brief with state boundary, state list, transition model, recommended shape, integration plan, rollout steps, and verification notes. |
| [`game-development-object-pool`](./skills/game-development-object-pool/) | A hot path shows repeated spawn/despawn churn, GC spikes, or frame drops around short-lived reusable objects. | A pooling brief with candidate analysis, pool boundary and API, reset contract, engine integration notes, rollout steps, and benchmark guidance. |

### Layer 3 — Internal workers

No plugin-scoped internal workers are shipped yet in `plugins/game-development/agents/`.

That is deliberate. Stage C worker review is now complete, and the current recommendation is still **workflow-first / no plugin-scoped workers yet**.

Supporting review:

- [`./evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md`](./evidence/layer-1-foundation-candidates-stage-c/stage-c-worker-justification-review.md)

Until fresh evidence says otherwise, the current surface is still narrow enough that the direct skill route is usually the better default.

See [`./layer-map.md`](./layer-map.md) for the current semantic layer mapping and why the plugin still keeps a flat `skills/` directory for now.

## How the pieces fit together

The current plugin shape is easiest to read as two layers.

### Foundation and shared-semantics layer

- `condition-rule-engine` answers how reusable rules are defined, composed, and evaluated.
- `resource-transaction-system` answers how gameplay value is checked, reserved, committed, refunded, or rolled back.
- `time-source-and-tick-policy` answers which clock matters, how cadence works, and what pause or drift means.
- `world-state-facts` answers what is considered true, observed, inferred, or stale.
- `entity-reference-boundary` answers how identities, handles, references, and lifetime rules stay sane across systems.
- `gameplay-tags-and-query` answers when labels help and how tag queries stay governed.
- `state-change-notification` answers which changes matter, what payload they carry, and when invalidation or batching is enough.

These are not engine adapters and not full gameplay frameworks. They give the higher-level skills a shared floor to stand on.

Stage D reconsideration is also complete: the current seven foundations remain the stable working set, and no additional Layer 1 expansion or merge/split reshaping is justified yet.

Supporting review:

- [`./evidence/layer-1-foundation-candidates-stage-d/stage-d-layer-1-reconsideration-review.md`](./evidence/layer-1-foundation-candidates-stage-d/stage-d-layer-1-reconsideration-review.md)

### Higher-level routing and design skills

- `behavior-architecture` decides whether the shape should stay simple or move into FSM, behavior tree, Utility AI, or GOAP.
- `events-and-signals`, `command-flow`, and `coordinator` handle cross-system collaboration boundaries.
- `fsm`, `behavior-tree`, `goap`, and `utility-ai` handle the stronger behavior-control patterns once the route is chosen.
- `object-pool` handles one specific performance seam where evidence matters more than instinct.

## Where should I start?

- **The architecture choice is still unclear** -> start with [`game-development-behavior-architecture`](./skills/game-development-behavior-architecture/) when the real question is whether the system should stay simple or move into FSM, behavior tree, Utility AI, or GOAP.
- **The main pain is duplicated conditions or rule sprawl** -> use [`game-development-condition-rule-engine`](./skills/game-development-condition-rule-engine/) when the problem is preconditions, guard clauses, eligibility, or composite rule ownership.
- **The main pain is cost, spend timing, or reservation drift** -> use [`game-development-resource-transaction-system`](./skills/game-development-resource-transaction-system/) when the problem is affordability, reservation, refund, or commit semantics.
- **The main pain is cooldowns, timers, or reevaluation cadence** -> use [`game-development-time-source-and-tick-policy`](./skills/game-development-time-source-and-tick-policy/) when the problem is clock choice, cadence, pause, time scaling, or drift handling.
- **The main pain is world facts, blackboards, or freshness drift** -> use [`game-development-world-state-facts`](./skills/game-development-world-state-facts/) when the problem is observed truth, inferred state, freshness, or planner-readable facts.
- **The main pain is stale references or identity confusion** -> use [`game-development-entity-reference-boundary`](./skills/game-development-entity-reference-boundary/) when the problem is handles, direct references, lifetime safety, or pooled identity reuse.
- **The main pain is label sprawl or tag queries** -> use [`game-development-gameplay-tags-and-query`](./skills/game-development-gameplay-tags-and-query/) when the problem is taxonomy, filtering, or tag-driven branching.
- **The main pain is change payloads or invalidation drift** -> use [`game-development-state-change-notification`](./skills/game-development-state-change-notification/) when the problem is diff vs snapshot semantics, observer updates, batching, or cache invalidation.
- **Notification topology is the problem** -> use [`game-development-events-and-signals`](./skills/game-development-events-and-signals/) when the main concern is direct-call vs event boundaries, subscription lifecycle, or signal traceability.
- **Requests are tangled with execution** -> use [`game-development-command-flow`](./skills/game-development-command-flow/) when the main concern is request/execution boundaries, action queues, validation, or undo/redo and replay design.
- **One bounded area needs a stable gateway** -> use [`game-development-coordinator`](./skills/game-development-coordinator/) when the main concern is scene or subsystem coordination ownership, volatile internals exposure, or god-object drift.
- **State-heavy mode logic is the main issue** -> use [`game-development-fsm`](./skills/game-development-fsm/) when the problem is states, transitions, and enter/exit ownership.
- **Hierarchical reactive behavior is the main shape** -> use [`game-development-behavior-tree`](./skills/game-development-behavior-tree/) when priorities, fallback branches, running tasks, and interrupts dominate the design.
- **Multi-step goal planning is required** -> use [`game-development-goap`](./skills/game-development-goap/) when the system needs goals, world facts, actions, and replanning.
- **Context-sensitive scoring is required** -> use [`game-development-utility-ai`](./skills/game-development-utility-ai/) when several options stay valid at once and the problem is scoring, tuning, and observability.
- **Measured spawn/despawn churn is the issue** -> use [`game-development-object-pool`](./skills/game-development-object-pool/) when the problem is reuse, reset safety, and benchmarked hot-path churn. For Godot lifecycle cautions, then read [`references/godot-reference.md`](./skills/game-development-object-pool/references/godot-reference.md).

## Plugin structure

```text
game-development/
├── plugin.json
├── README.md
├── layer-map.md
├── evidence/
│   ├── layer-1-foundation-candidates-stage-b/
│   ├── layer-1-foundation-candidates-stage-c/
│   └── layer-1-foundation-candidates-stage-d/
├── agents/
│   └── README.md
└── skills/
    ├── game-development-behavior-architecture/
    ├── game-development-behavior-tree/
    ├── game-development-command-flow/
    ├── game-development-condition-rule-engine/
    ├── game-development-coordinator/
    ├── game-development-entity-reference-boundary/
    ├── game-development-events-and-signals/
    ├── game-development-fsm/
    ├── game-development-gameplay-tags-and-query/
    ├── game-development-goap/
    ├── game-development-object-pool/
    ├── game-development-resource-transaction-system/
    ├── game-development-state-change-notification/
    ├── game-development-time-source-and-tick-policy/
    ├── game-development-utility-ai/
    └── game-development-world-state-facts/
```

For Market 1 cloneability, treat the market-facing plugin payload as:

- `plugin.json`
- `README.md`
- `agents/`
- `skills/`

The foundation roadmap document is repo-facing planning material that helps explain the current rollout shape, but the long-term shipped plugin surface still centers on the manifest, README, agents, and skills.

That roadmap document lives adjacent to this plugin at [`../layer-1-foundation-candidates.md`](../layer-1-foundation-candidates.md), not inside the `game-development/` folder itself.

The retained `evidence/` tree is repository-facing support material for practical-pass and workflow decisions. It is useful for plugin maintenance, but it is not the main plugin-facing interaction surface.

The current retained evidence directories are named after the roadmap document that produced them so Stage B, Stage C, and Stage D closeout material stays visibly tied to the same Layer 1 review thread.

The current flat manifest path and flat `skills/` folder are a packaging choice, not a claim that every skill belongs to the same semantic layer or participates in a runtime dependency graph.

## How to use this plugin

This plugin is intended to be consumed directly from source by an agent runtime that can discover repository-based skills and, when available later, plugin-scoped agents.

Typical usage flow:

1. Make this repository available to the agent.
2. Ensure the runtime can discover skills under `plugins/game-development/skills/`.
3. Route the task to the narrowest skill that honestly matches the problem.
4. Use the returned artifact to drive follow-up implementation, profiling, or refactor decisions.

Practical rule of thumb:

- use a direct skill when the problem is narrow and evidence-led
- add plugin-scoped workers later only when the task shape becomes genuinely mixed or multi-artifact
- do not add abstraction ceremony just because it looks tidy in a diagram

## Plugin metadata

Current plugin manifest:

- `name`: `game-development`
- `version`: `0.1.0`
- `description`: `Reusable agent skills for cross-engine game-development design, review, and refactor workflows.`

See [`plugin.json`](./plugin.json) for the source of truth.

## Authoring notes

When adding to this plugin:

- keep skills portable across engine families unless an engine-specific tradeoff is the point
- make trigger wording explicit in each `description`
- keep Layer 1 foundations focused on shared semantics rather than orchestration or framework policy
- preserve the semantic split: Layer 1 foundations, Layer 2 shared-runtime skills, and Layer 3 only when true orchestration is justified
- prefer concrete performance evidence over instinct-only optimization advice
- keep reusable heuristics in `references/` instead of overloading `SKILL.md`
- add plugin-scoped workers only when one narrow skill clearly under-serves the task shape
