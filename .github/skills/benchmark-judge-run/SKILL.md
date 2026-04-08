---
name: benchmark-judge-run
description: Use when a benchmark execution record or variant run needs a canonical judged record with route-first classification, five-dimension rubric scoring, post-score failure tags, separate invariance or robustness notes, and optional scaffold-to-completed finalization.
---

# Benchmark Judge Run

Use this skill when a benchmark execution result needs a judged record that another agent or reviewer can compare, cluster, or gate later.

It covers **judging existing outputs**. It does not generate the benchmark answer, rerun the task, or decide final promotion.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- classify route correctness first
- score the canonical five-dimension rubric
- attach `1–3` primary failure tags after scoring
- keep invariance and robustness notes separate from the base score
- finalize scaffold-backed run records into canonical completed records when the judged evidence is complete
- return a run review in canonical record form

## Use this skill when

Typical requests:

- reviewing a fresh execution record
- judging a `baseline`, `skill`, or `worker` run
- scoring a metamorphic or adversarial variant run
- standardizing benchmark evidence before clustering or gate review

### Trigger examples

- "Help me judge this benchmark run"
- "Turn this execution record into a scored record"
- "Do a route-first rubric review"
- "Add failure tags and invariance notes"

## Do not use this skill when

Do not use this skill when:

- the task is to execute the benchmark rather than judge it
- the benchmark answer still needs to be generated
- the request is to cluster multiple judged failures together
- the request is a final promotion decision rather than a run-level judgment

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Generator**

Why this fit works:

- the core job is evaluation against explicit criteria
- the result must still be returned as a stable structured artifact
- a Tool Wrapper alone would not enforce route-first judgment order strongly enough

## Inputs

Collect or infer these inputs when you can:

- benchmark ID and title
- execution path
- capability invoked
- benchmark route expectation
- expected artifact type
- output snapshot or raw output summary
- suite coverage and variant context
- operational notes if latency or cost matter
- whether the source record is a reserved scaffold slot that now needs finalization
- any in-scope direct citations or paired links that would break if the filename changes

If evidence is incomplete, score only what is observable and call the gap out explicitly.

## Workflow

Use the same sequence each time.

### 1. Read the benchmark contract first

Confirm:

- benchmark identity
- route expectation
- expected artifact type
- whether this is a base, metamorphic, or adversarial run

Do not score before you understand the contract.

### 2. Classify route first

Use the shared route taxonomy to decide whether the run is:

- correct single-skill route
- correct worker route
- under-escalated
- over-escalated
- wrong-domain
- correct no-escalation

Do not turn this into a general vibe score.

### 3. Score the canonical five dimensions

Score only these dimensions:

- route correctness
- structural completeness
- judgment quality
- actionability
- validation quality

Use the output taxonomy only as explanation support for the four output-facing dimensions.

### 4. Attach failure tags after scoring

Choose `1–3` primary failure tags only after the rubric is set.

Failure tags explain score loss. They do not create separate penalty math.

### 5. Record invariance or robustness notes separately

For variant runs:

- record metamorphic drift observations separately
- record adversarial safe-failure observations separately
- keep those notes distinct from the base rubric unless the judged run itself visibly warrants score impact

### 6. Return the judged run record

Use `assets/benchmark-run-record-template.md` for the final output skeleton and `assets/benchmark-run-record-example.md` as a style reference.

### 7. Finalize scaffold-backed records when the run is complete

If the judged record came from a reserved `-scaffold.md` slot and the run is now genuinely complete:

- replace placeholder status with the completed judged record
- promote the filename from `RUN-...-scaffold.md` to the canonical completed `RUN-....md` form
- update paired run links and the smallest in-scope citations needed to keep the evidence chain coherent
- remove the obsolete scaffold copy after the finalized record exists

Use `../benchmark-core/references/run-record-finalization-checklist.md` to keep this step bounded.

Do not let this step expand into a broad corpus rewrite.

## Output contract

Return the result using `assets/benchmark-run-record-template.md` in the same section order.

Output rules:

- route classification first
- five-dimension rubric second
- failure tags after scoring
- invariance and robustness notes separate from the base score story
- acceptance notes distinct from raw output-quality scoring
- if the source record was scaffold-backed and the judgment is complete, finalize it into the canonical completed filename and update direct in-scope citations

## Companion files

- `assets/benchmark-run-record-template.md` — final judged-run structure
- `assets/benchmark-run-record-example.md` — style reference
- `references/judging-sources.md` — canonical scoring and taxonomy sources
- `../benchmark-core/references/run-record-finalization-checklist.md` — bounded checklist for scaffold-to-completed record promotion
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- route result is explicit
- all five rubric dimensions are scored
- failure tags are attached after scoring
- invariance and robustness notes are separate when relevant
- acceptance comments do not replace the rubric
- scaffold-backed records are finalized only when the judgment is actually complete
- the record is reusable for clustering and gate review

## Common pitfalls

- scoring from failure tags first
- mixing route fit and artifact quality into one fuzzy comment
- letting acceptance reasoning replace output-quality scoring
- inventing certainty from incomplete evidence
- treating metamorphic drift as base-score collapse without showing why
- leaving a completed judged record trapped in a scaffold filename when downstream evidence should now cite the finalized record

## Completion rule

This skill is complete when the agent has:

- classified the route result
- scored the five canonical dimensions
- attached the primary failure tags
- recorded invariance or robustness notes where relevant
- finalized the record if it was scaffold-backed and ready for promotion
- returned a reusable judged run record in canonical format