---
name: benchmark-author-item
description: Use when a new benchmark item, seed draft, or ad hoc eval case needs to be turned into the repository's canonical benchmark-item format with clear task family, route expectation, artifact contract, scoring focus, and variant hooks.
---

# Benchmark Author Item

Use this skill when a benchmark idea needs to become a stable, reusable benchmark item in the repository's eval corpus.

It covers **benchmark definition authoring**. It does not cover execution, judging, or promotion.

Downstream handoff is typically: execute -> `benchmark-judge-run` -> optional clustering or candidate review.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- draft new benchmark items in the repository's standard format
- convert repeated ad hoc eval prompts into reusable benchmark definitions
- make route expectations, artifact expectations, and scoring focus explicit
- add metamorphic and adversarial hooks without leaking a gold answer

## Use this skill when

Typical requests:

- creating a new `seed` benchmark item
- normalizing a rough benchmark concept into the repo format
- refining an ambiguous item so route expectations and artifact contracts become explicit
- preparing a benchmark definition before later execution or judging work

### Trigger examples

- "幫我起一個新 benchmark item"
- "將呢個 eval case 寫成 benchmark 定義"
- "補齊 route expectation 同 scoring focus"
- "將 ad hoc prompt 升格成 seed benchmark"

## Do not use this skill when

Do not use this skill when:

- the benchmark item already exists and only needs a tiny typo fix
- the user wants to run or judge a benchmark rather than define one
- the task is to propose a candidate wording change to an existing benchmark policy
- the request is really about benchmark execution evidence, not benchmark authoring

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**

Why this fit works:

- the skill must produce a repeatable structured artifact
- it also packages repository-specific eval rules, route vocabulary, and benchmark hygiene
- a full Pipeline would add ceremony without enough value because the authoring sequence can live directly in this file

## Inputs

Collect or infer these inputs when you can:

- benchmark scenario summary
- task family or likely task family
- intended suite coverage
- capability under test
- preferred execution paths
- route expectation
- expected artifact type
- main scoring focus
- metamorphic and adversarial priorities
- trust caveats or intentionally omitted evidence

If some inputs are missing, make the smallest safe assumptions and call them out explicitly instead of fabricating certainty.

## Workflow

Use the same sequence each time.

### 1. Frame the benchmark intent

State what the benchmark is trying to reveal.

Examples:

- whether route selection between `skill` and `worker` is correct
- whether a migration-planning artifact stays validation-aware
- whether a UX review remains specific instead of generic

Do not start by filling a template. Start from the diagnostic value of the item.

### 2. Set the benchmark identity and route contract

Determine:

- benchmark ID and short title
- task family
- suite coverage
- capability under test
- preferred execution path(s)
- route expectation and any acceptable alternate route

If route ambiguity is intentional, say so explicitly instead of leaving it fuzzy.

### 3. Define the artifact contract and success signals

Make the item scoreable by specifying:

- expected artifact type
- main scoring focus
- must-include sections or qualities
- what a successful output should reveal

Do not leak a hidden gold answer into the prompt-facing parts.

### 4. Add failure and scoring hooks

Specify:

- the likely failure tags
- the rubric dimensions that matter most
- what good route correctness, completeness, judgment, actionability, and validation look like for this case

Failure tags are diagnostics, not penalty math.

### 5. Add variant hooks only when justified

For metamorphic or adversarial expansion:

- declare whether it is worth the cost
- define hard invariants, soft invariants, and drift budget where relevant
- define safe-failure expectations for adversarial stress where relevant

Do not add variant sections as decoration.

### 6. Return the benchmark item in repo format

Use `assets/benchmark-item-template.md` as the output skeleton.

Keep the result black-box, route-aware, and ready for later execution.

## Output contract

Return the result using `assets/benchmark-item-template.md` in the same section order.

Output rules:

- keep route expectation explicit
- keep expected artifact type explicit
- keep benchmark input black-box oriented
- keep success signals observable from outputs
- keep metamorphic and adversarial hooks intentional rather than automatic
- keep benchmark wording stable enough for repeated reuse

## Companion files

- `assets/benchmark-item-template.md` — final benchmark item skeleton
- `references/source-docs.md` — canonical repo docs that govern taxonomy, routing, scoring, and inventory fit
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- the item has a clear benchmark purpose
- route expectation is explicit
- expected artifact type is explicit
- scoring focus is observable
- likely failure tags are aligned with shared taxonomy
- the benchmark remains black-box enough to avoid answer leakage
- metamorphic and adversarial hooks are included only when they add diagnostic value

## Common pitfalls

- writing a prompt instead of a reusable benchmark definition
- leaving route expectation vague
- describing success in terms too subjective to judge later
- leaking a preferred answer into the benchmark text
- adding every possible variant hook with no diagnostic reason

## Completion rule

This skill is complete when the agent has:

- framed the benchmark's diagnostic purpose
- authored the item in canonical benchmark format
- made route and artifact expectations explicit
- defined success signals and likely failure tags
- added only the justified variant hooks
- returned a reusable benchmark item ready for execution