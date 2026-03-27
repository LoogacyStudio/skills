# Benchmark capability registry

Use this registry when benchmark agents, benchmark skills, corpus adapters, or repo docs need the stable capability names for the shared benchmark system.

## Purpose

This registry defines the stable capability IDs for the benchmark framework.

Use these IDs instead of depending on:

- concrete skill folder names
- concrete asset paths
- repo-specific benchmark workflow wording

If a skill is renamed, moved, split, or replaced, update this registry rather than teaching every agent, skill, README, or corpus adapter a new path.

## Stable capability map

| Capability ID | What it means | Current skill |
| --- | --- | --- |
| `benchmark.item-authoring` | Turn a benchmark idea or seed draft into a reusable benchmark item. | [`../benchmark-author-item/`](../benchmark-author-item/) |
| `benchmark.rerun-planning` | Turn bounded candidate evidence into a rerun slice with target/protected anchors and follow-up rules. | [`../benchmark-author-rerun-manifest/`](../benchmark-author-rerun-manifest/) |
| `benchmark.run-judging` | Turn execution output into a judged run record and finalize scaffold-backed records when complete. | [`../benchmark-judge-run/`](../benchmark-judge-run/) |
| `benchmark.candidate-review` | Review promotion readiness against target gain, protected regressions, invariance, robustness, and governance. | [`../benchmark-review-candidate/`](../benchmark-review-candidate/) |
| `benchmark.variant-authoring` | Author metamorphic or adversarial variant bundles with explicit invariants and safe-failure rules. | [`../benchmark-author-variants/`](../benchmark-author-variants/) |
| `benchmark.failure-clustering` | Group repeated judged weaknesses into reusable failure-pattern records. | [`../benchmark-cluster-failures/`](../benchmark-cluster-failures/) |

## Usage rule

When another doc says "prefer capability `benchmark.run-judging`", it means "use whichever current skill owns that capability", even if the concrete skill name or path changes later.

## Maintenance rule

Update this file when:

- a benchmark skill is renamed
- one capability moves to a different skill
- one capability is split into multiple first-class capabilities
- a new stable benchmark capability is introduced

Do not duplicate this full registry into general index pages when a link to this registry is sufficient.
