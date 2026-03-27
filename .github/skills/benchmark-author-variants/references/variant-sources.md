# Benchmark author variants — source docs

These are the canonical source roles this skill should follow from the **active benchmark corpus**.

- active benchmark corpus variant-family catalog
  - canonical `M1–M5` and `A1–A6` family definitions
  - hard invariants, soft invariants, and drift-budget guidance
  - safe-failure expectations for adversarial stress
- active benchmark corpus taxonomy doc
  - task-family fit
  - route taxonomy
  - invariance and robustness expectations
- capability `benchmark.item-authoring`
  - base benchmark contract shape exposed by the item-authoring workflow
- active benchmark corpus workflow doc
  - how variants fit into the benchmark lifecycle

Use [`../../benchmark-core/references/benchmark-corpus-discovery.md`](../../benchmark-core/references/benchmark-corpus-discovery.md) to resolve the current corpus without hardcoding a corpus name or path.

Variant authoring rule:

- variants must reveal a diagnostic property, not inflate benchmark count
- one main stressor per variant unless compound stress is explicitly justified
- transformed inputs should be execution-ready and route-aware
