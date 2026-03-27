# Benchmark author rerun manifest — source docs

These are the canonical source roles this skill should follow from the **active benchmark corpus**.

- active benchmark corpus taxonomy doc
  - candidate classes
  - route taxonomy
  - mutation-surface rules
  - suite and robustness philosophy
- active benchmark corpus promotion checklist
  - rerun gate expectations
  - target/protected suite discipline
  - candidate-specific checks for `C1`, `C2`, `C3`, and `C5`
- active benchmark corpus workflow doc
  - operational fit inside the benchmark lifecycle
  - role boundaries between rerun planning, execution, judging, and gate review
- active benchmark corpus run-evidence index
  - storage conventions for rerun evidence
- this skill's rerun-manifest working asset
  - working rerun-manifest structure used by this skill
- any current filled rerun manifest example from the active corpus
  - example of a bounded rerun manifest when one exists

Use [`../../benchmark-core/references/benchmark-corpus-discovery.md`](../../benchmark-core/references/benchmark-corpus-discovery.md) to resolve the current corpus without hardcoding a corpus name or path.

Authoring rule:

- treat the repo-level eval docs as the canonical policy source
- use this repo skill to package the rerun-planning workflow and working asset
- if the asset diverges from the canonical policy docs, update the asset to match the policy source
