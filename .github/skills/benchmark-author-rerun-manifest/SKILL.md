---
name: benchmark-author-rerun-manifest
description: Use when a bounded candidate revision needs a concrete rerun manifest with target suites, protected suites, benchmark anchors, execution paths, judging focus, and conditional follow-up checks before promotion review.
---

# Benchmark Author Rerun Manifest

Use this skill when an already-defined candidate bundle needs to become a concrete rerun slice for offline evaluation.

It covers **rerun planning**. It does not invent the candidate, execute the reruns, judge them, or promote them.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- draft rerun manifests for bounded candidate bundles
- make target suites and protected suites explicit before rerun work starts
- choose the smallest benchmark slice that can measure intended gain without losing regression protection
- define execution paths, judging focus, and trigger conditions for follow-up metamorphic or adversarial checks
- keep rerun planning inside the current mutation surface instead of letting the rerun scope sprawl
- reserve rerun slots cleanly while leaving run-record finalization to downstream judging work

## Use this skill when

Typical requests:

- creating a rerun manifest for a `C1` wording candidate
- creating a rerun manifest for a `C2` routing-policy candidate
- turning candidate follow-up notes into an execution-ready rerun slice
- defining protected anchors before a candidate is rerun
- deciding which follow-up stress checks are conditional rather than automatic

### Trigger examples

- "Help me draft a candidate rerun manifest"
- "Turn this C1/C2 draft into a rerun slice"
- "List the target suites and protected anchors before rerun"
- "Add a rerun manifest without rerunning the full stress set"

## Do not use this skill when

Do not use this skill when:

- the candidate itself still needs to be proposed
- the task is to review promotion readiness after reruns are already complete
- the user wants judged run evidence rather than rerun planning
- the task is really benchmark mutation authoring rather than candidate rerun scoping
- a tiny typo fix is needed in an existing manifest with no structural change

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**

Why this fit works:

- the skill must produce a repeatable structured artifact
- it also packages repository-specific rerun-planning rules, suite vocabulary, and mutation-surface discipline
- a full Pipeline would add ceremony without enough value because the ordered rerun-planning sequence can live directly in this file

## Inputs

Collect or infer these inputs when you can:

- candidate ID and class
- mutation-surface classification
- target suites and protected suites
- intended gain and protected behaviors
- affected files or route rules
- current evidence records that justify rerunning the candidate
- target anchors and protected anchors
- execution paths that matter for each anchor
- follow-up metamorphic or adversarial checks that should stay conditional

If some inputs are missing, make the smallest safe assumptions and call them out explicitly instead of pretending the rerun slice is already well-defined.

## Workflow

Use the same sequence each time.

### 1. Frame the candidate and rerun question

State what the candidate is trying to improve and what the rerun needs to resolve.

Examples:

- whether wording changes improve route clarity without inflating scope
- whether a routing-policy draft preserves narrow anchors while still rewarding justified escalation
- whether protected ambiguity cases remain stable after a bounded candidate change

Do not start by filling a table. Start from the rerun question.

### 2. Confirm mutation surface and suite scope

Determine:

- candidate ID and class
- mutation surface classification
- target suites
- protected suites
- baseline for comparison

If the rerun would silently expand the mutation surface, say so explicitly and narrow it before proceeding.

### 3. Select anchors intentionally

Separate rerun anchors into these buckets when relevant:

- target rerun anchors
- protected narrow anchors
- protected ambiguity anchors

For each anchor, explain what it protects or what intended gain it measures.

Do not throw every related benchmark into the rerun slice just because it exists.

### 4. Define the execution matrix and judging focus

Specify:

- which execution paths matter per benchmark (`baseline`, `skill`, `worker`)
- recommended run order
- what to watch for during judging
- which follow-up metamorphic or adversarial checks are conditional rather than automatic

Protect expensive or already-complete stress families from habitual reruns unless fresh drift appears.

### 5. Return the rerun manifest in repo format

Use `assets/candidate-rerun-manifest-template.md` as the output skeleton.

If the manifest pre-creates scaffold run slots, treat them as placeholders only. Final filename promotion belongs to `benchmark-judge-run` after real judging is complete.

Keep the result narrow, anchor-aware, and ready for later execution and judging.

## Output contract

Return the result using `assets/candidate-rerun-manifest-template.md` in the same section order.

Output rules:

- keep candidate identity, class, and mutation surface explicit
- keep target suites and protected suites explicit
- keep target and protected anchors separated clearly
- keep execution paths and judging focus observable
- keep metamorphic and adversarial follow-ups conditional when possible
- keep the rerun scope narrow enough that later promotion review remains interpretable

## Companion files

- `assets/candidate-rerun-manifest-template.md` — final rerun-manifest skeleton
- `references/source-docs.md` — canonical repo docs that govern rerun planning, suite scope, mutation surface, and promotion fit
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- the rerun question is explicit
- candidate identity and mutation surface are explicit
- target and protected suites are explicit
- target anchors and protected anchors are separated clearly
- the execution matrix is concrete enough to run
- judging focus is visible before reruns begin
- expensive or already-complete follow-up families are not rerun by default
- the rerun slice stays within the claimed mutation surface

## Common pitfalls

- using rerun planning as disguised candidate invention
- expanding the slice until it becomes a benchmark campaign instead of a bounded rerun
- forgetting protected anchors while chasing target gains
- treating all metamorphic or adversarial checks as mandatory by default
- reinterpreting benchmark intent instead of comparing against completed evidence
- rerunning a full held-out stress family when only one ambiguity anchor drifted

## Completion rule

This skill is complete when the agent has:

- framed the candidate rerun question
- identified the mutation surface and suite scope
- selected target and protected anchors intentionally
- defined the execution matrix and judging focus
- declared conditional follow-up rules
- returned a reusable rerun manifest ready for execution
