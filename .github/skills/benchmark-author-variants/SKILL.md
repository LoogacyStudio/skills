---
name: benchmark-author-variants
description: Use when a benchmark item or judged run needs a reusable variant pack from the repository's canonical metamorphic and adversarial families, with explicit invariants, drift budget, safe-failure rules, and execution-ready transformed input packages.
---

# Benchmark Author Variants

Use this skill when a benchmark needs metamorphic or adversarial expansion that can be rerun and judged consistently.

It covers **variant-pack authoring**. It does not execute variants, score them, or decide whether observed drift is acceptable.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- author metamorphic variants from the shared `M1–M5` families
- author adversarial variants from the shared `A1–A6` families
- keep hard invariants, soft invariants, drift budget, and safe-failure rules explicit
- package transformed inputs so they are ready for execution and later judging
- hand off the executed variant runs to `benchmark-judge-run` instead of judging them inline

## Use this skill when

Typical requests:

- creating the first variant pack for a benchmark item
- expanding a route-sensitive item with invariance checks
- expanding a fragile item with adversarial stress cases
- translating a judged weakness into a bounded variant bundle

### Trigger examples

- "幫我為 B006 起 metamorphic variants"
- "做一個 adversarial variant pack"
- "將呢個 benchmark 補 hard invariants 同 drift budget"
- "針對 route drift 補 variant bundle"

## Do not use this skill when

Do not use this skill when:

- the task is to execute the variant rather than author it
- the request is to judge observed drift rather than create the variant
- the variant idea is actually a benchmark mutation proposal for promotion review
- the request is only for a tiny wording correction in an existing variant file

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**

Why this fit works:

- the main job is to generate a structured variant bundle
- it also packages the repository's shared family rules, invariance expectations, and stress discipline
- a full Pipeline would add ceremony without enough value because execution and judging remain downstream roles

## Inputs

Collect or infer these inputs when you can:

- base benchmark ID and title
- task family
- base route expectation
- expected artifact type
- why variant work is being requested now
- whether metamorphic, adversarial, or both modes are in scope
- known fragile findings or failure modes from prior judged runs

If some inputs are missing, make the smallest safe assumptions and mark them explicitly.

## Workflow

Use the same sequence each time.

### 1. Frame the variant goal

State what the variant pack should reveal.

Examples:

- route stability under paraphrase
- robustness under misleading evidence
- validation-plan persistence under presentation change
- safe-failure behavior under partial visibility

Do not start from random transformations. Start from the diagnostic purpose.

### 2. Choose the variant mode and family set

Select only the smallest useful family or families:

- metamorphic: `M1` paraphrase, `M2` context-order, `M3` noise tolerance, `M4` terminology substitution, `M5` presentation-style
- adversarial: `A1` injection-in-artifact, `A2` conflicting constraints, `A3` misleading evidence, `A4` partial visibility, `A5` tool degradation, `A6` stale-context contamination

Keep one main stressor per variant unless a compound test is explicitly justified.

### 3. Define the contract for each variant

For every variant, specify:

- variant type and family
- purpose
- main transformation or stressor
- route expectation
- expected invariant or safe-failure rule
- hard invariants
- soft invariants
- allowed drift budget

Do not leave drift interpretation implicit.

### 4. Package the transformed input cleanly

Create an execution-ready transformed input package.

It should be usable by a runner without reconstructing the scenario from scratch.

### 5. Return the variant bundle

Use `assets/variant-bundle-template.md` as the final output skeleton.

## Output contract

Return the result using `assets/variant-bundle-template.md` in the same section order.

Output rules:

- choose only justified variant families
- keep hard invariants and soft invariants explicit
- keep drift budget explicit for metamorphic variants
- keep safe-failure expectation explicit for adversarial variants
- keep transformed input packages execution-ready
- avoid random prompt churn dressed up as evaluation rigor

## Companion files

- `assets/variant-bundle-template.md` — final variant-bundle output structure
- `references/variant-sources.md` — canonical family and workflow sources
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- each variant has a clear diagnostic purpose
- family choice is explicit and justified
- invariants and safe-failure rules are explicit
- drift budget is stated where metamorphic behavior matters
- transformed inputs are runnable without reconstruction theater
- one main stressor is preserved per variant unless compound stress is explicitly intended

## Common pitfalls

- generating random paraphrases with no diagnostic value
- omitting hard invariants and then calling the result an invariance check
- mixing multiple stressors into one muddy variant
- leaving route expectation implicit on route-sensitive items
- writing a judge note instead of an execution-ready variant pack

## Completion rule

This skill is complete when the agent has:

- defined the diagnostic goal of the variant work
- selected the right family or families
- authored explicit variant contracts with invariants or safe-failure rules
- packaged execution-ready transformed inputs
- returned a reusable variant bundle for downstream execution and judging