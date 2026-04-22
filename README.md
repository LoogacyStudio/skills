# Loogacy agent skills

This repository stores reusable agent skills, repo level benchmark workflow material, and plugin bundles for coding agents.

The current focus is practical agent work around Godot, .NET, C#, benchmark authoring, and game development patterns that can stay portable across more than one engine.

For the broader skill format and ecosystem, see [agentskills.io](https://agentskills.io/).

> [!NOTE]
> This repo is not a gameplay library, engine addon, or NuGet package.
> It is a source repository for skill instructions, references, templates, benchmark assets, and workers that belong to a specific plugin.

## Start here

Use the repo straight from source.

1. Make the repository available to your agent runtime.
2. Expose the skill folders under `.agents/skills/`, `.github/skills/`, and `plugins/*/skills/`.
3. If your runtime supports internal workers, also expose `.github/agents/` and `plugins/*/agents/`.
4. Start from the section below that matches the work you are doing.

If you only need one rule of thumb: use a direct skill when one focused artifact is enough, and use an internal worker when the task is genuinely mixed and benefits from tighter context boundaries.

## What lives in this repo

The repo has six main surfaces.

| Area | What it holds | Start here |
| :--- | :------------ | :--------- |
| [`.agents/skills/`](.agents/skills/) | Authoring skills for the whole repo: creating skills, splitting work into subagents, grilling plans, and session handoff | [Core authoring skills](#core-authoring-skills) |
| [`.github/skills/`](.github/skills/) | Shared benchmark and eval workflow skills | [Repo benchmark skills](#repo-benchmark-skills) |
| [`.github/agents/`](.github/agents/) | Benchmark orchestration workers for the whole repo | [Repo benchmark workers](#repo-benchmark-workers) |
| [`evals/godot-dotnet/`](evals/godot-dotnet/README.md) | The canonical repo local corpus for the `godot-dotnet` benchmark and evaluation flow | [`evals/godot-dotnet/README.md`](evals/godot-dotnet/README.md) |
| [`plugins/godot-dotnet/`](plugins/godot-dotnet/README.md) | Godot and .NET implementation, review, validation, and upgrade guidance | [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md) |
| [`plugins/game-development/`](plugins/game-development/README.md) | Portable game development patterns that are not tied to one engine family | [`plugins/game-development/README.md`](plugins/game-development/README.md) |

There is also a practical fixture layer under [`tests/`](tests/README.md) for hands on plugin trials in tracked Godot projects.

## Core authoring skills

These are the skills you use when you are building or improving the agent system itself.

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`create-reusable-skill`](.agents/skills/create-reusable-skill/) | You want to create a new skill or tighten up an existing one without overbuilding it. | A right sized skill structure, drafted `SKILL.md`, and support files only when they are justified. |
| [`create-subagent`](.agents/skills/create-subagent/) | You need to decide whether a task should stay single agent or be split into a bounded subagent topology. | A recommendation state, topology blueprint, subagent specs, shared state plan, and evaluation checklist. |
| [`plan-design-grill`](.agents/skills/plan-design-grill/) | You want a plan or architecture pushed until its assumptions and branch choices are explicit. | A grill summary with resolved decisions, open branches, and recommended next steps. |
| [`session-handoff`](.agents/skills/session-handoff/) | Work needs to continue in a later session or a fresh agent. | A continuation ready handoff package with verified state and exact next steps. |

## Repo benchmark skills

These sit above the `godot-dotnet` corpus and below full orchestration.

If you want the corpus index first, start from [`evals/README.md`](evals/README.md).

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`benchmark-core`](.github/skills/benchmark-core/) | You need the shared benchmark framework rules before choosing a narrower route. | Capability, corpus discovery, lifecycle, and portability guidance. |
| [`benchmark-author-item`](.github/skills/benchmark-author-item/) | You want to turn a benchmark idea into the repo's canonical item format. | A reusable benchmark item draft with route, artifact, scoring, and variant hooks. |
| [`benchmark-author-rerun-manifest`](.github/skills/benchmark-author-rerun-manifest/) | You need a bounded rerun slice for a candidate revision. | A rerun manifest ready for offline execution and judging. |
| [`benchmark-judge-run`](.github/skills/benchmark-judge-run/) | You want to convert an execution result into the canonical judged format. | A scored run record with failure tags and invariance or robustness notes. |
| [`benchmark-review-candidate`](.github/skills/benchmark-review-candidate/) | You want to review whether a candidate revision should be promoted. | A candidate review record with an explicit promotion decision. |
| [`benchmark-author-variants`](.github/skills/benchmark-author-variants/) | You want metamorphic or adversarial variant packs from the shared family catalog. | A reusable `variant_bundle` with invariants, drift budget, and transformed inputs. |
| [`benchmark-cluster-failures`](.github/skills/benchmark-cluster-failures/) | You want repeated judged failures grouped into reusable patterns. | A canonical failure cluster record with actionable weakness framing. |

## Repo benchmark workers

These workers live under [`.github/agents/`](.github/agents/) and handle multi stage benchmark work.

| Agent | Use when | Main output |
| :---- | :------- | :---------- |
| [`benchmark-director`](.github/agents/benchmark-director.agent.md) | You want one coordinator to run a benchmark cycle end to end. | A consolidated benchmark coordination package with phase and suite status. |
| [`benchmark-item-runner`](.github/agents/benchmark-item-runner.agent.md) | You want to execute one benchmark item across `baseline`, `skill`, and or `worker` paths. | A per path execution record for downstream judging or variant work. |
| [`suite-judge`](.github/agents/suite-judge.agent.md) | You want an independent route first judge for an execution package or variant run. | A judged run package with rubric scores, failure tags, and invariance or robustness notes. |
| [`variant-lab`](.github/agents/variant-lab.agent.md) | You want metamorphic or adversarial stress variants authored and packaged for rerun. | A `variant_bundle` with explicit families, invariants, and transformed inputs. |
| [`failure-clusterer`](.github/agents/failure-clusterer.agent.md) | You want repeated judged failures grouped into reusable failure clusters. | A `failure_cluster_report` with repeated weakness framing and next step guidance. |
| [`candidate-proposer`](.github/agents/candidate-proposer.agent.md) | You want a bounded wording, routing, rubric, or template candidate proposed from clustered evidence. | A `candidate_revision` package prepared for rerun planning. |
| [`promotion-gatekeeper`](.github/agents/promotion-gatekeeper.agent.md) | You want the final promotion decision grounded in gain, regressions, invariance, robustness, and governance checks. | A `promotion_decision` package with explicit gate reasoning. |

## Plugin catalog

The plugin layer is the market facing part of this repository.

| Plugin | Focus | Current shape | Start here |
| :----- | :---- | :------------ | :--------- |
| [`godot-dotnet`](plugins/godot-dotnet/README.md) | Godot 4.6, .NET 10, C#, `.tscn`, review, validation, and upgrade planning | 10 reusable skills, 3 internal workers | [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md) |
| [`game-development`](plugins/game-development/README.md) | Portable game development patterns across engines, starting with object reuse and pooling decisions | 1 reusable skill, no internal workers yet | [`plugins/game-development/README.md`](plugins/game-development/README.md) |

### Quick picks from `godot-dotnet`

- C# implementation or refactor work → [`godot-csharp`](plugins/godot-dotnet/skills/godot-csharp/)
- Direct scene file work → [`godot-tscn`](plugins/godot-dotnet/skills/godot-tscn/)
- GoDotTest setup or runtime test coverage → [`godot-godottest`](plugins/godot-dotnet/skills/godot-godottest/)
- First pass runtime diagnosis → [`runtime-triage`](plugins/godot-dotnet/skills/runtime-triage/)
- Mixed architecture and UX review → [`design-reviewer`](plugins/godot-dotnet/agents/design-reviewer.agent.md)
- Upgrade planning with rollback and validation structure → [`migration-quality-planner`](plugins/godot-dotnet/agents/migration-quality-planner.agent.md)

### Quick picks from `game-development`

- Spawn and despawn churn, pooling, or GC spike work → [`game-development-object-pool`](plugins/game-development/skills/game-development-object-pool/)

## Where to start by task

If you already know what kind of work you are doing, use this map.

| I need to... | Open this first |
| :----------- | :-------------- |
| Create or improve a reusable skill | [`.agents/skills/create-reusable-skill/`](.agents/skills/create-reusable-skill/) |
| Decide whether a task should be split into subagents | [`.agents/skills/create-subagent/`](.agents/skills/create-subagent/) |
| Stress test a plan or architecture before implementation | [`.agents/skills/plan-design-grill/`](.agents/skills/plan-design-grill/) |
| Continue work in a fresh session | [`.agents/skills/session-handoff/`](.agents/skills/session-handoff/) |
| Work on benchmark framework rules or routing | [`.github/skills/benchmark-core/`](.github/skills/benchmark-core/) |
| Work on the canonical eval corpus | [`evals/godot-dotnet/README.md`](evals/godot-dotnet/README.md) |
| Use Godot and .NET implementation or review skills | [`plugins/godot-dotnet/README.md`](plugins/godot-dotnet/README.md) |
| Use cross engine gameplay optimization patterns | [`plugins/game-development/README.md`](plugins/game-development/README.md) |
| Run practical fixture trials in tracked projects | [`tests/README.md`](tests/README.md) |

## Repository layout

```text
.agents/
└── skills/                 # repo wide authoring skills

.github/
├── agents/                 # repo level benchmark workers
└── skills/                 # repo shared benchmark workflow skills

evals/
└── godot-dotnet/           # canonical repo local corpus for godot-dotnet

plugins/
├── game-development/
│   ├── plugin.json
│   ├── README.md
│   ├── agents/
│   └── skills/
└── godot-dotnet/
    ├── plugin.json
    ├── README.md
    ├── agents/
    └── skills/

tests/
├── plugin-snapshots/       # shared staging copies for fixture trials
├── runs/                   # generated working copies, gitignored
├── scripts/                # trial automation helpers
└── <FixtureName>/          # tracked template projects
```

Inside a typical skill folder you will usually see:

- `SKILL.md` for the main workflow and triggering guidance
- `references/` for reusable heuristics and checklists
- `assets/` for templates, examples, or output skeletons

## Adding new material

Keep the split clean when you add or move content.

- Put repo wide authoring skills under `.agents/skills/`
- Put shared benchmark workflow skills under `.github/skills/`
- Put repo level benchmark workers under `.github/agents/`
- Put benchmark corpora and run evidence outside `plugins/`
- Put market facing plugin material under `plugins/<plugin-name>/`

For plugins in particular, keep the long term shipped surface limited to:

- `plugin.json`
- `README.md`
- `agents/`
- `skills/`

## License

See [LICENSE](LICENSE) for details.
