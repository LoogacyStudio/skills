# Repo skill asset — Benchmark Run Record Template

Canonical policy context: the active benchmark corpus scoring guide, workflow doc, and taxonomy doc.

Use this asset as the final judged-run output skeleton.

```md
## Run record — <benchmark ID> / <execution path> / <date>

- **Benchmark ID:** <B001>
- **Benchmark title:** <short title>
- **Variant ID:** <none | variant id>
- **Execution path:** <baseline | skill | worker>
- **Capability invoked:** <name or none>
- **Date:** <YYYY-MM-DD>
- **Reviewer / judge:** <name or role>
- **Status:** <completed | blocked | invalidated>

### Input context

- **Task family:** <T1-T5>
- **Suite coverage:** <acceptance, routing / trigger, output-quality, metamorphic, adversarial, regression>
- **Scenario summary:** <1-3 sentences>
- **Trust caveats:** <none | notes>

### Output snapshot

- **Returned artifact type:** <triage report | architecture review | UX review | test strategy / matrix | upgrade plan | migration-quality plan>
- **Route result:** <R1-R6 or plain-language outcome>
- **Result summary:** <2-5 sentences>

### Scoring

- **Scoring rule:** apply the shared five-dimension rubric first; assign failure tags only after the scores are set.
- **Interpretation rule:** this score primarily captures output quality plus route fit; it is not the full acceptance decision by itself.

| Dimension | Score | Notes |
| --- | --- | --- |
| Route correctness | <0-2> | <notes> |
| Structural completeness | <0-2> | <notes> |
| Judgment quality | <0-2> | <notes> |
| Actionability | <0-2> | <notes> |
| Validation quality | <0-2> | <notes> |
| **Total** | <0-10> | <notes> |

### Failure tags

- **Tagging rule:** failure tags explain the main causes of score loss; they do not mechanically change the total.

- <F1>
- <F2>
- <F3>

### Invariance / robustness notes

- **Metamorphic observations:** <none | notes>
- **Hard-invariant check:** <not-applicable | passed | failed>
- **Drift-budget outcome:** <not-applicable | passed | borderline | failed>
- **Adversarial observations:** <none | notes>
- **Safe-failure assessment:** <not-applicable | passed | failed | mixed>

### Operational notes

- **Latency notes:** <optional>
- **Cost notes:** <optional>
- **Tooling notes:** <optional>

### Decision notes

- **Acceptance assessment:** <is this path worth using end-to-end once route choice, latency, cost, and escalation overhead are considered?>
- **Usefulness verdict:** <showcase-quality | production-usable | useful-but-needs-revision | unacceptable>
- **Promotion suggestion:** <keep-seed | move-to-candidate | hold | reject | retest>
- **Follow-up actions:**
  - <action>
  - <action>
```
