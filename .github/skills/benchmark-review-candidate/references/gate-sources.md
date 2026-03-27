# Benchmark review candidate — source docs

These are the canonical source roles this skill should follow from the **active benchmark corpus**.

- active benchmark corpus promotion checklist
  - gate sequence
  - candidate classes
  - mutation-surface rules
  - promotion / hold / reject / revert logic
- this skill's candidate-review working asset
  - working promotion-review output structure used by this skill
- active benchmark corpus taxonomy doc
  - allowed versus disallowed phase-one surfaces
  - invariance, robustness, and safety expectations
- active benchmark corpus workflow doc
  - where candidate review sits in the benchmark lifecycle

Use [`../../benchmark-core/references/benchmark-corpus-discovery.md`](../../benchmark-core/references/benchmark-corpus-discovery.md) to resolve the current corpus without hardcoding a corpus name or path.

Gate review rule:

- require measurable target-suite gain
- protect protected suites from material regression
- keep invariance, robustness, and hallucination / unsafe-compliance checks visible
- block official adoption when curator or human review is required but absent
