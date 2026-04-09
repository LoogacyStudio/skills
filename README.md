# Loogacy Agent Skills

Reusable agent skills for coding agents working on Godot 4.6, .NET 10, and C# projects.

For the broader skill format and ecosystem, see [agentskills.io](https://agentskills.io/).

> [!NOTE]
> This repository is not a runtime gameplay library, addon, or NuGet package.
> It is a versioned collection of reusable agent instructions, reference notes, report templates, and plugin-scoped internal workers.

## Quick start

Use this repository straight from source.

1. Make the repository available to your coding agent.
2. Ensure the agent can discover skill folders under `.agents/skills/`, `.github/skills/`, and `plugins/*/skills/`.
3. If your runtime supports internal workers or custom agents, also expose `.github/agents/` and `plugins/*/agents/`.
4. Route the task to the right skill or internal worker for the job.
5. When adding new material, place standalone authoring skills under `.agents/skills/<skill-name>/`, repo-shared benchmark/eval skills under `.github/skills/<skill-name>/`, repo-level benchmark orchestration agents under `.github/agents/`, repo-level benchmark corpus / run evidence outside `plugins/`, and plugin-specific material under `plugins/<plugin-name>/`.

Practical rule of thumb:

- use **skills** when one agent can safely keep the whole task context
- use **internal workers** when you want bounded, reusable, read-only specialist output without polluting the main conversation

## What this repo is for

This repo does three related jobs.

- It keeps a small set of **authoring skills** for building new skills and designing subagent topologies.
- It keeps a **repo-level benchmark/eval skill layer and corpus** for benchmark authoring, judging, variants, clustering, and gate review.
- It packages a **Godot/.NET plugin set** for implementation guidance, investigation, review, validation, and upgrade planning.

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
| [`create-subagent`](.agents/skills/create-subagent/) | You need to decide whether a task should stay single-agent or be split into a bounded subagent topology. | A recommendation state, topology blueprint, subagent specs, shared-state plan, evaluation checklist, and provider overlays. |
| [`plan-design-grill`](.agents/skills/plan-design-grill/) | You want an agent to interrogate a plan or design until assumptions, branch decisions, risks, and proof points are explicit. | A structured grill summary with resolved decisions, open branches, fragile assumptions, and recommended next steps. |
| [`session-handoff`](.agents/skills/session-handoff/) | You need a continuation-ready handoff document so a fresh agent or later session can resume work without re-discovery. | A structured handoff package with verified state, evidence, constraints, and exact next steps. |

### Repo benchmark skills

These are repo-shared benchmark and eval workflow skills that sit above the `godot-dotnet` canonical corpus in [`evals/godot-dotnet/`](evals/godot-dotnet/README.md) and below full agent orchestration.

If you want the corpus index first, start from [`evals/README.md`](evals/README.md).

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`benchmark-core`](.github/skills/benchmark-core/) | You want the shared benchmark framework rules before choosing a narrower benchmark skill or agent route. | Capability, corpus-discovery, lifecycle, and portability guidance. |
| [`benchmark-author-item`](.github/skills/benchmark-author-item/) | You want to turn a benchmark idea or ad hoc eval case into the repository's canonical benchmark-item format. | A reusable benchmark item draft with route, artifact, scoring, and variant hooks. |
| [`benchmark-author-rerun-manifest`](.github/skills/benchmark-author-rerun-manifest/) | You want to turn a bounded candidate revision into a concrete rerun slice with target suites, protected anchors, and conditional follow-up checks. | A candidate rerun manifest ready for offline execution and judging. |
| [`benchmark-judge-run`](.github/skills/benchmark-judge-run/) | You want to convert an execution result into a route-first judged run record. | A scored benchmark run record with failure tags and invariance / robustness notes. |
| [`benchmark-review-candidate`](.github/skills/benchmark-review-candidate/) | You want to review whether a candidate revision can be promoted under the repo's gate rules. | A canonical candidate review record with explicit promotion decision. |
| [`benchmark-author-variants`](.github/skills/benchmark-author-variants/) | You want to author metamorphic or adversarial variant packs from the shared family catalog. | A reusable `variant_bundle` with invariants, drift budget, and transformed inputs. |
| [`benchmark-cluster-failures`](.github/skills/benchmark-cluster-failures/) | You want to cluster repeated judged failures into reusable repair-oriented patterns. | A canonical failure cluster record with taxonomy-aligned failure patterns. |

### Repo benchmark orchestration agents

These repo-level internal workers live under [`.github/agents/`](.github/agents/) and handle multi-stage benchmark orchestration that sits above a single benchmark skill.

| Agent | Use when | Main output |
| :---- | :------- | :---------- |
| [`benchmark-director`](.github/agents/benchmark-director.agent.md) | You want one coordinator to run a benchmark cycle across planning, execution, judging, variants, clustering, candidate reruns, and final gate review. | A consolidated benchmark coordination package with phase and suite status. |
| [`benchmark-item-runner`](.github/agents/benchmark-item-runner.agent.md) | You want to execute one benchmark item across `baseline`, `skill`, and/or `worker` paths without judging it inline. | A per-path execution record ready for downstream judging or variant work. |
| [`suite-judge`](.github/agents/suite-judge.agent.md) | You want an independent route-first judge for an execution package or variant run. | A judged run package with rubric scores, failure tags, and invariance / robustness notes. |
| [`variant-lab`](.github/agents/variant-lab.agent.md) | You want metamorphic or adversarial stress variants authored and packaged for rerun. | A `variant_bundle` with explicit families, invariants, and transformed inputs. |
| [`failure-clusterer`](.github/agents/failure-clusterer.agent.md) | You want repeated judged failures grouped into reusable failure-pattern clusters. | A `failure_cluster_report` with repeated weakness framing and next-step guidance. |
| [`candidate-proposer`](.github/agents/candidate-proposer.agent.md) | You want a bounded wording, routing, rubric, or template candidate proposed from clustered evidence. | A `candidate_revision` package prepared for rerun planning and later gate review. |
| [`promotion-gatekeeper`](.github/agents/promotion-gatekeeper.agent.md) | You want a final benchmark promotion decision grounded in target gain, protected-suite regressions, invariance, robustness, and governance checks. | A `promotion_decision` package with explicit gate reasoning. |

### Plugin: `godot-dotnet`

Source of truth: [`plugins/godot-dotnet/plugin.json`](plugins/godot-dotnet/plugin.json)

This plugin has two layers:

1. reusable skills for narrow implementation, review, and planning work
2. plugin-scoped internal workers for mixed or higher-structure tasks

If you want the full breakdown, read [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md). This root README is only the front desk.

Quick picks:

- **Plugin-scoped workers:** [`runtime-investigator`](plugins/godot-dotnet/agents/runtime-investigator.agent.md), [`design-reviewer`](plugins/godot-dotnet/agents/design-reviewer.agent.md), [`migration-quality-planner`](plugins/godot-dotnet/agents/migration-quality-planner.agent.md)
- **Direct skills:** [`godot-csharp`](plugins/godot-dotnet/skills/godot-csharp/), [`godot-tscn`](plugins/godot-dotnet/skills/godot-tscn/), [`godot-godottest`](plugins/godot-dotnet/skills/godot-godottest/), [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/), [`scene-architecture-review`](plugins/godot-dotnet/skills/scene-architecture-review/), [`abstraction-integrity-review`](plugins/godot-dotnet/skills/abstraction-integrity-review/), [`test-strategy-review`](plugins/godot-dotnet/skills/test-strategy-review/), [`post-change-review`](plugins/godot-dotnet/skills/post-change-review/), [`ui-ux-review`](plugins/godot-dotnet/skills/ui-ux-review/), [`version-upgrade-review`](plugins/godot-dotnet/skills/version-upgrade-review/)

## Where to start

### If you are working on authoring the agent system itself

- **You want to create or upgrade a reusable skill** → [`create-reusable-skill`](.agents/skills/create-reusable-skill/)
- **You want to decide whether and how to split work into subagents** → [`create-subagent`](.agents/skills/create-subagent/)
- **You want an agent to stress-test a plan or design by grilling it branch by branch** → [`plan-design-grill`](.agents/skills/plan-design-grill/)
- **You want to package the current session for a fresh agent or later continuation** → [`session-handoff`](.agents/skills/session-handoff/)

### If you are working on benchmark authoring, judging, or eval governance in this repo

- **You want the shared benchmark framework rules or routing map first** → [`benchmark-core`](.github/skills/benchmark-core/)
- **You want to author or normalize a benchmark item** → [`benchmark-author-item`](.github/skills/benchmark-author-item/)
- **You want to plan a bounded candidate rerun slice** → [`benchmark-author-rerun-manifest`](.github/skills/benchmark-author-rerun-manifest/)
- **You want to judge an execution record into the canonical run-review format** → [`benchmark-judge-run`](.github/skills/benchmark-judge-run/)
- **You want to author a metamorphic or adversarial variant pack** → [`benchmark-author-variants`](.github/skills/benchmark-author-variants/)
- **You want to cluster repeated judged failures** → [`benchmark-cluster-failures`](.github/skills/benchmark-cluster-failures/)
- **You want to review whether a candidate revision should be promoted** → [`benchmark-review-candidate`](.github/skills/benchmark-review-candidate/)
- **You want multi-stage benchmark orchestration rather than one narrow artifact** → [`.github/agents/`](.github/agents/)

### If you are using the `godot-dotnet` plugin set

Start with [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md) if the repo task is mainly about Godot/.NET review, validation, or upgrade planning.

If you already know the route you want:

- mixed or higher-structure work → one of the plugin-scoped workers
- narrow review or planning work → one of the plugin skills

## Repository layout

```text
.github/
├── agents/                 # repo-level benchmark orchestration workers
└── skills/                 # repo-shared benchmark/eval workflow skills

.agents/
└── skills/                 # repo-wide authoring skills

evals/
└── godot-dotnet/           # repo-level canonical eval corpus

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

Going forward, treat `plugins/` as the market-facing surface only. Benchmark corpora, run evidence, and other repo-local eval material should live outside plugin folders; the `godot-dotnet` eval corpus now lives under [`evals/godot-dotnet/`](evals/godot-dotnet/README.md).

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
