# `godot-dotnet` Plugin

Reusable agent skills for **Godot 4.6**, **.NET 10**, `.tscn` scene-text, and **C#** workflows.

This plugin collects a focused set of implementation-guidance, review, and planning skills for Godot/.NET projects. It is meant for coding agents that need stronger judgment around idiomatic Godot C# code, direct `.tscn` scene-file work, troubleshooting, scene architecture, testing strategy, UI/UX quality, and upgrade planning.

> [!NOTE]
> This plugin is **not** a Godot addon, runtime library, or NuGet package.
> It is a repository-hosted plugin bundle of reusable skills plus the plugin-scoped internal workers that live under [`./agents/`](./agents/).
> The repo-local benchmark corpus is exposed through the corpus adapter at [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md) and is **not** part of the market-facing plugin surface.
> Shared benchmark framework rules such as capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions live under [`../../.github/skills/benchmark-core/`](../../.github/skills/benchmark-core/).
> Repo-level benchmark orchestration agents such as [`benchmark-director`](../../.github/agents/benchmark-director.agent.md) live under [`../../.github/agents/`](../../.github/agents/) and are **not** part of this plugin's shipped agent surface.

Within the repository's current layered contract, `godot-dotnet` is the **Layer 4 overlay plugin** for Godot/.NET-specific implementation, review, validation, and upgrade work. Its shipped workers are bounded **Layer 3-style** plugin workers inside that overlay surface.

## Boundary map

Use this split when deciding where to start:

- **Shared benchmark framework** → [`../../.github/skills/benchmark-core/`](../../.github/skills/benchmark-core/) for capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions.
- **Corpus context and stored evidence** → [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md) for canonical docs by role, active manifests, bounded slices, and benchmark/run-evidence entry points.
- **Current layer map** → [`./layer-map.md`](./layer-map.md) for the repo-facing Layer 4 / bounded Layer 3 alignment of this plugin.
- **Plugin surface itself** → this README plus [`./agents/`](./agents/) and [`./skills/`](./skills/) for shipped plugin skills, shipped plugin-scoped workers, and market-facing payload boundaries.

If you're new here, the short version is simple: use a **skill** for narrow implementation, review, or planning work, and use a plugin-scoped **worker** when the task genuinely mixes dimensions and benefits from stronger structure.

## What this plugin is for

Use `godot-dotnet` when an agent is working in a Godot project that uses:

- Godot scenes and node hierarchies
- C# gameplay, tools, or editor-side code
- .NET SDK / project / package workflows
- implementation-heavy or review-heavy tasks where the right next step matters as much as the next edit

The skills in this plugin are designed to help agents:

- implement idiomatic Godot C# that respects the engine's binding surface and editor workflow
- read and edit `.tscn` scene files without breaking resource, node-path, or connection integrity
- classify failures before making risky fixes
- review scene and system boundaries with Godot-specific concerns in mind
- choose practical, layered test coverage
- evaluate HUD, menus, overlays, and tool UI from a usability perspective
- plan upgrades without doing a single giant “YOLO migration”

## What is included

This plugin currently aligns to two semantic layers inside the repository model:

1. **Layer 4 overlay skills** — stack-specific implementation/review/planning methods for Godot, .NET, C#, and `.tscn`
2. **Bounded Layer 3-style internal workers** — read-only plugin-scoped agents in [`./agents/`](./agents/) that compose those overlay skills into specialist roles

Cross-engine Layer 1 and Layer 2 ownership stays outside this plugin.

### Internal workers

These are meant for **coordinator-driven subagent use**, not direct end-user invocation.

Inside the repository's layer model, these are **bounded Layer 3-style workers** that live inside a Layer 4 overlay plugin.

These are the only plugin-scoped internal workers currently shipped in `plugins/godot-dotnet/agents/`:

| Agent | Use when | Composes | Main output |
| :---- | :------- | :------- | :---------- |
| [`runtime-investigator`](./agents/runtime-investigator.agent.md) | A project is broken and the first failing layer is still unclear. | `runtime-triage` + validation-minded support | Evidence-led triage report with ranked hypotheses, evidence gaps, next probe, and verification steps. |
| [`design-reviewer`](./agents/design-reviewer.agent.md) | A scene/system/HUD/menu needs a combined maintainability + UX review. | `scene-architecture-review` + `ui-ux-review` + validation support | Structured design review with architecture-vs-UX split, prioritized recommendations, and validation ideas. |
| [`migration-quality-planner`](./agents/migration-quality-planner.agent.md) | A Godot/.NET/addon/export-chain upgrade needs staged migration planning plus quality verification. | `version-upgrade-review` + `test-strategy-review` + optional triage support | Migration-quality plan with impact summary, risk matrix, staged sequence, smoke/regression plan, and rollback thinking. |

> [!IMPORTANT]
> Repo-level benchmark coordinators and eval workers such as [`benchmark-director`](../../.github/agents/benchmark-director.agent.md), [`benchmark-item-runner`](../../.github/agents/benchmark-item-runner.agent.md), [`suite-judge`](../../.github/agents/suite-judge.agent.md), [`variant-lab`](../../.github/agents/variant-lab.agent.md), [`candidate-proposer`](../../.github/agents/candidate-proposer.agent.md), and [`promotion-gatekeeper`](../../.github/agents/promotion-gatekeeper.agent.md) live under [`../../.github/agents/`](../../.github/agents/). They support repo-level benchmark workflow and are not part of this plugin's shipped worker set.

### Reusable skills

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`godot-csharp`](./skills/godot-csharp/) | A task involves writing, refactoring, or translating Godot C# code and the agent must stay idiomatic to Godot's C# API instead of drifting into generic .NET or GDScript habits. | A structured implementation brief covering engine context, recommended patterns, API mapping notes, pitfalls, and validation / rebuild steps. |
| [`godot-tscn`](./skills/godot-tscn/) | A task involves reading, editing, generating, or reviewing `.tscn` scene files directly and the agent must preserve scene-file structure instead of treating it as generic text. | A structured scene-edit brief covering file structure, reference surfaces, safe edit steps, risks, and validation. |
| [`godot-godottest`](./skills/godot-godottest/) | A Godot/.NET project uses GoDotTest and needs concrete suite scaffolding, scene wiring, debug setup, coverage guidance, or GodotTestDriver-based runtime testing patterns. | A framework-specific GoDotTest implementation guide with setup rules, runtime test scaffolds, validation checks, and companion assets for suites and drivers. |
| [`runtime-triage`](./skills/runtime-triage/) | A Godot/.NET project is broken, noisy, crashing, or behaving incorrectly and the failure layer is still unclear. | A focused triage report with likely layers, ranked causes, missing evidence, and the smallest useful next probe. |
| [`scene-architecture-review`](./skills/scene-architecture-review/) | A scene, UI flow, or gameplay system feels overloaded, tightly coupled, or hard to change safely. | A structured architecture review with findings, risk areas, and concrete refactor directions. |
| [`abstraction-integrity-review`](./skills/abstraction-integrity-review/) | A feature extension, touched-code refactor, or in-flight implementation is starting to stretch an abstraction through flags, boundary leakage, compatibility drag, or responsibility drift. | A structured abstraction-health review with decay risks, containment options, and a clear integrity verdict. |
| [`test-strategy-review`](./skills/test-strategy-review/) | A feature, bug fix, refactor, or migration needs a realistic validation plan. | A layered, cost-aware test matrix that separates pure .NET coverage from Godot runtime checks. |
| [`post-change-review`](./skills/post-change-review/) | A large refactor, multi-file implementation, or new feature needs a completion-minded post-change review before the work should be treated as done. | A structured readiness review covering boundaries, engine usage, docs/content/config sync, evidence quality, and next follow-up actions. |
| [`ui-ux-review`](./skills/ui-ux-review/) | A HUD, menu, overlay, prompt flow, or in-game tool UI needs usability review. | A task-oriented UX review with quick wins, structural improvements, and verification ideas. |
| [`version-upgrade-review`](./skills/version-upgrade-review/) | A Godot, .NET SDK, package, addon, or export pipeline upgrade needs safer sequencing. | A staged upgrade plan with risk areas, validation gates, and rollback thinking. |

These skills should be treated as **Layer 4 overlay skills**: they constrain how Godot/.NET reality lands in the stack, but they do not own the lower-layer meaning of cross-engine gameplay semantics.

## Where should I start?

### If your runtime supports plugin-scoped agents

- **Something is failing and the root cause is still messy after a narrow first-response pass** → [`runtime-investigator`](./agents/runtime-investigator.agent.md)
- **A scene/system/UI flow needs maintainability + UX review together, and one axis would be under-served on its own** → [`design-reviewer`](./agents/design-reviewer.agent.md)
- **You are planning an upgrade and need explicit checkpoint / rollback / validation structure, not just a narrower staged plan** → [`migration-quality-planner`](./agents/migration-quality-planner.agent.md)

### If you are doing repo benchmark / eval work

- **You need shared benchmark framework rules or capability ownership** → start from [`../../.github/skills/benchmark-core/`](../../.github/skills/benchmark-core/)
- **You need benchmark orchestration, judging, variants, clustering, or gate review** → start from [`../../.github/agents/`](../../.github/agents/) and then use [`../../.github/skills/README.md`](../../.github/skills/README.md) as the specialized skill index
- **You need the canonical corpus, policy, manifests, or stored evidence** → start from the repo-local corpus adapter at [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md)
- **You need to understand what belongs to this plugin itself** → stay in this README and the shipped plugin folders under [`./agents/`](./agents/) and [`./skills/`](./skills/)

### If your runtime only consumes skills directly

- **You need to implement or refactor Godot C# code without drifting into GDScript-first or generic .NET patterns** → [`godot-csharp`](./skills/godot-csharp/)
- **You need to read, edit, or review a `.tscn` scene file without breaking structure or references** → [`godot-tscn`](./skills/godot-tscn/)
- **You need to write, run, debug, or cover GoDotTest suites, especially with GodotTestDriver-backed integration/UI tests** → [`godot-godottest`](./skills/godot-godottest/)
- **Something is failing and you need a focused first-response diagnosis** → [`runtime-triage`](./skills/runtime-triage/)
- **A scene or system feels structurally messy** → [`scene-architecture-review`](./skills/scene-architecture-review/)
- **A feature or refactor is stretching an abstraction through flags, branching, or compatibility drag** → [`abstraction-integrity-review`](./skills/abstraction-integrity-review/)
- **You want the smallest useful validation plan without turning it into a broader combined review** → [`test-strategy-review`](./skills/test-strategy-review/)
- **A broad implementation is "done" on paper but needs a last completion-minded review** → [`post-change-review`](./skills/post-change-review/)
- **A screen or interaction flow needs UX feedback** → [`ui-ux-review`](./skills/ui-ux-review/)
- **You are preparing a version or toolchain upgrade and one strong staged plan is enough** → [`version-upgrade-review`](./skills/version-upgrade-review/)

## Provisional selective worker escalation heuristic

Use this as a **working routing heuristic**, not immutable policy.

It reflects the current repo evidence for when `godot-dotnet` should stay on a narrower skill route versus escalate to a plugin-scoped worker.

1. **Stay on a skill** when the task is narrow, evidence-led, and one focused artifact can satisfy the ask.
2. **Escalate to a worker** when the task is genuinely mixed or when the artifact needs explicit split/checkpoint structure that a narrower skill would under-deliver.
3. **Do not escalate only for polish.** Extra structure should earn its cost by preserving dimensions, clarifying gates, or materially improving decision quality.
4. **Keep no-plugin / wrong-domain suppression separate for now.** This heuristic only covers `skill` versus plugin-worker routing inside `godot-dotnet`.

### Quick route cues

| Task shape | Usually stronger route | Why |
| :--------- | :--------------------- | :-- |
| idiomatic Godot C# implementation or refactor with engine-facing API choices | skill (`godot-csharp`) | The narrow route is best when the main risk is choosing the wrong binding, lifecycle, export, signal, or collection pattern. |
| direct `.tscn` scene-file edit, merge fix, or file-aware diff review | skill (`godot-tscn`) | The narrow route is best when the main risk is breaking section order, resource IDs, parent paths, `NodePath`s, or connections. |
| narrow first-response failure framing with one small next probe | skill (`runtime-triage`) | The narrow route usually preserves the smallest useful diagnostic move. |
| failure framing where evidence is still messy after first-response triage | worker (`runtime-investigator`) | The worker earns its cost when stronger ambiguity management materially helps. |
| mixed architecture + UX review | worker (`design-reviewer`) | The worker preserves both dimensions instead of under-serving one axis. |
| bounded validation planning for a seam-heavy change | skill (`test-strategy-review`) | The narrower route usually keeps validation-first scope tighter. |
| staged upgrade planning where one strong artifact is enough | skill (`version-upgrade-review`) | A focused staged plan is often sufficient without extra orchestration. |
| migration planning where risk matrix, rollback triggers, and validation gates are core deliverables | worker (`migration-quality-planner`) | The worker earns escalation when checkpoint structure is part of the artifact contract. |

## How the pieces fit together

- `runtime-investigator` is the **failure-framing** worker.
- `design-reviewer` is the **structure + UX review** worker.
- `migration-quality-planner` is the **upgrade-risk + validation** worker.

The workers are intentionally read-only and bounded. They do not replace implementation agents. Their job is to improve decision quality before fixes, refactors, or upgrades begin.

For the current semantic layer split and ownership cautions, see [`./layer-map.md`](./layer-map.md).

## Skill coverage at a glance

### `godot-csharp`

Primary implementation concerns:

1. `script role and lifecycle fit`
2. `Godot C# API mapping and naming`
3. `signals, events, and await usage`
4. `exports, inspector behavior, and tool-mode caveats`
5. `collections and Variant boundaries`
6. `interop and struct-mutation pitfalls`
7. `diagnostics, rebuild steps, and editor visibility`

### `godot-tscn`

Primary scene-file concerns:

1. `file descriptor and section order`
2. `external and internal resource integrity`
3. `root node and parent-path correctness`
4. `NodePath and property-path preservation`
5. `connections and inherited-scene metadata`
6. `save-time normalization and default-value omission`
7. `editor load and runtime smoke validation`

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

### `abstraction-integrity-review`

Primary review dimensions:

1. `change intent and abstraction seam clarity`
2. `flag creep and mode-surface growth`
3. `boundary leakage across layers or scenes`
4. `compatibility creep and legacy-path pressure`
5. `responsibility drift in touched owners`
6. `extension seam quality and future change cost`
7. `verification and containment confidence`

### `test-strategy-review`

Primary testing layers:

1. `pure C# logic tests`
2. `Godot runtime-dependent tests`
3. `scene / integration tests`
4. `UI / flow / interaction validation`
5. `smoke tests`
6. `regression checks`

### `post-change-review`

Primary review dimensions:

1. `change surface clarity`
2. `layer and ownership boundary health`
3. `Godot engine and lifecycle usage`
4. `scene / resource / config / content sync`
5. `docs and operational sync`
6. `verification evidence and regression coverage`
7. `completion risk and readiness verdict`

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
├── layer-map.md
├── agents/
│   ├── design-reviewer.agent.md
│   ├── migration-quality-planner.agent.md
│   └── runtime-investigator.agent.md
└── skills/
    └── <skill>/
        ├── SKILL.md
        ├── assets/
        └── references/
```

For **Market 1 cloneability**, treat the market-facing plugin payload as:

- `plugin.json`
- `README.md`
- `agents/`
- `skills/`

The repo-local benchmark corpus is exposed through the corpus adapter at [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md). It is not part of the long-term plugin payload.

Repo benchmark orchestration agents such as `benchmark-director` and `candidate-proposer` live outside this tree under [`../../.github/agents/`](../../.github/agents/).

Each skill typically uses:

- `SKILL.md` for the main operating workflow and triggering guidance
- `references/` for reusable heuristics, notes, and checklists
- `assets/` for report templates, matrices, and reusable output skeletons

The flat `skills/` and `agents/` directories are a packaging choice, not a claim that this plugin owns Layer 1 or Layer 2 semantics.

## Repo-local corpus adapter

The benchmark/eval corpus behind this repository's black-box assessment work is **repo-local material**, not long-term plugin payload.

Use the repo-local corpus adapter at [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md) when you need:

- canonical document role mapping
- active manifests and bounded slices
- benchmark corpus and run-evidence entry points
- handoff from corpus material back to the shared benchmark framework and specialized benchmark skills

The concrete corpus implementation still lives under `../../evals/godot-dotnet/`, but downstream tooling should prefer the adapter entry rather than assuming internal corpus paths.

For shared benchmark framework rules, use [`../../.github/skills/benchmark-core/`](../../.github/skills/benchmark-core/). For the day-to-day benchmark skill index, use [`../../.github/skills/README.md`](../../.github/skills/README.md). If you need repo-level benchmark orchestration rather than plugin workers, use [`../../.github/agents/`](../../.github/agents/).

This README stays focused on the **plugin surface itself**: shipped skills, shipped plugin-scoped workers, usage guidance, and market-facing payload boundaries.

## How to use this plugin

This plugin is intended to be consumed **directly from source** by an agent runtime that can discover repository-based skills and, when available, plugin-scoped agents.

Typical usage flow:

1. Make this repository available to the agent.
2. Ensure the runtime can discover skills under `plugins/godot-dotnet/skills/`.
3. Either route the task to a matching skill directly, or delegate to a plugin-scoped internal worker if your runtime supports it.
4. Use the returned artifact to drive follow-up implementation, testing, or release decisions.

Practical rule of thumb:

- use **skills** when the task is narrow, evidence-led, and one focused artifact is enough
- use **internal workers** when the task is genuinely mixed or needs stronger split/checkpoint structure
- do **not** escalate only for polish, extra ceremony, or formatting

## Plugin metadata

Current plugin manifest:

- `name`: `godot-dotnet`
- `version`: `0.1.2`
- `description`: `Agent skills for Godot 4.6, .NET 10, and C# coding-agent workflows.`

See [`plugin.json`](./plugin.json) for the source of truth.

## Authoring notes

When adding to this plugin:

- keep each skill narrow, reusable, and trigger-oriented
- prefer review and planning workflows that produce concrete outputs
- encode Godot-specific concerns explicitly instead of falling back to generic clean-code advice
- keep cross-engine gameplay semantics in cross-engine surfaces such as `plugins/game-development/`; this plugin is an overlay, not a foundation owner
- move bulky reusable material into `references/` or `assets/` rather than overloading `SKILL.md`
- keep filenames and folder names stable so agents can discover them reliably
- do **not** add new benchmark corpora, benchmark runs, or other repo-local eval evidence under `plugins/`; keep the long-term market-facing plugin surface limited to the manifest, README, agents, and skills
