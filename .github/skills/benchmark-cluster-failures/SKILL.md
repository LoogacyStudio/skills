---
name: benchmark-cluster-failures
description: Use when multiple judged benchmark runs need to be grouped into reusable failure-pattern records with taxonomy-aligned tags, root-weakness hypotheses, severity and regression framing, and bounded next-action guidance for downstream proposal or gate work.
---

# Benchmark Cluster Failures

Use this skill when judged benchmark evidence needs to be turned into reusable failure-pattern records instead of staying as noisy isolated run notes.

It covers **failure clustering**. It does not rewrite prompts, merge candidates, rerun suites, or make the final promotion decision.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- group repeated judged failures into repair-oriented patterns
- use the shared `F1–F10` taxonomy as the clustering vocabulary
- distinguish route, output-quality, invariance, robustness, and regression-related weaknesses
- prefer finalized judged run records over placeholder scaffolds when clustering evidence
- produce reusable cluster records for downstream candidate and gate work

## Use this skill when

Typical requests:

- turning multiple judged run notes into a cluster summary
- grouping repeated route or evidence-discipline failures
- clustering metamorphic drift or adversarial fragility patterns
- preparing failure evidence for candidate proposal work

### Trigger examples

- "Help me cluster this batch of judged runs"
- "Organize the repeated F1-F10 patterns"
- "Group the route-wrong and drift-under-invariance cases"
- "Draft a failure cluster report"

## Do not use this skill when

Do not use this skill when:

- the task is to judge one run rather than compare many judged runs
- the request is to propose the candidate revision itself
- the request is to rerun the benchmark suite
- the request is a final promotion decision rather than a clustering pass

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Generator**

Why this fit works:

- the job is to evaluate repeated evidence and group it against explicit criteria
- the result still needs to be returned as a structured reusable cluster record
- a Tool Wrapper alone would not enforce evidence-based grouping strongly enough

## Inputs

Collect or infer these inputs when you can:

- judged run records or summaries
- route reviews and quality reviews
- failure tags attached after scoring
- invariance and robustness notes
- benchmark IDs, task families, and execution paths involved
- known candidate-action ideas if they already exist

If the evidence set is thin, say so explicitly and prefer a narrow or low-confidence cluster over fake pattern strength.

## Workflow

Use the same sequence each time.

### 1. Read the judged evidence set first

Confirm:

- what runs are in scope
- what task families and execution paths recur
- what failure tags appear repeatedly
- whether invariance or robustness notes materially affect the clustering story

Do not cluster from vague memory or one-line summaries if the actual judged evidence is available.

If the same run still exists as both a scaffold placeholder and a finalized judged record, cluster from the finalized record only.

### 2. Group by repeated weakness, not by wording coincidence

Use the shared `F1–F10` taxonomy as the first grouping lens.

Examples:

- `F1` route wrong
- `F2` too generic
- `F3` weak evidence discipline
- `F5` missing validation
- `F6` hallucinated detail
- `F9` drift under invariance
- `F10` fragile under noise

Do not flatten unrelated symptoms into one fuzzy mega-cluster.

### 3. Separate the cluster core from one-off noise

For each cluster, distinguish:

- what repeated
- what varied
- what is still unclear

Only repeated patterns should define the cluster core.

### 4. Add repair-oriented framing

For each cluster, specify:

- affected runs
- primary failure tags
- observed weakness
- likely root cause hypothesis
- confidence
- task-family impact
- execution-path impact
- severity and regression risk

Keep root-cause language bounded. A cluster may support a hypothesis without proving it completely.

### 5. Return the cluster report

Use `assets/failure-cluster-record-template.md` as the final output skeleton.

Candidate actions may be suggested as directions, but do not author the actual modification.

## Output contract

Return the result using `assets/failure-cluster-record-template.md` in the same section order.

Output rules:

- use `F1–F10` as the main clustering vocabulary
- keep repeated patterns separate from one-off notes
- keep confidence explicit
- include severity and regression framing
- keep candidate actions bounded and non-implementation-specific

## Companion files

- `assets/failure-cluster-record-template.md` — final clustering output structure
- `references/clustering-sources.md` — canonical taxonomy and workflow sources
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- the cluster is built from repeated judged evidence
- the main failure tags are taxonomy-aligned
- route, output, invariance, and robustness weaknesses are separated when materially different
- uncertainty is preserved where evidence is incomplete
- candidate-action directions stay bounded and non-implementation-specific
- the report is reusable for downstream proposal or gate work

## Common pitfalls

- clustering from vibes instead of repeated evidence
- merging unrelated weaknesses into one giant cluster
- treating a likely root cause as proven fact
- confusing candidate-action directions with actual proposed edits
- forgetting to carry severity or regression risk forward

## Completion rule

This skill is complete when the agent has:

- grouped the judged evidence into repeated failure patterns
- aligned the cluster vocabulary to `F1–F10`
- documented the cluster core, uncertainty, severity, and regression risk
- suggested bounded next-action directions
- returned a reusable failure cluster record