# Repo skill asset — Failure Cluster Record Template

Canonical policy context: the active benchmark corpus taxonomy doc, workflow doc, and promotion checklist.

Use this asset as the final output skeleton when clustering judged benchmark failures.

```md
## Failure cluster — <cluster name>

- **Cluster ID:** <FC-001>
- **Date:** <YYYY-MM-DD>
- **Curator:** <name or role>
- **Category:** <route | output-quality | metamorphic | adversarial | regression>
- **Status:** <open | monitored | candidate-proposed | resolved | retired>

### Summary

<2-5 sentences describing the shared weakness.>

### Affected runs

- <benchmark ID / execution path / date>
- <benchmark ID / execution path / date>
- <benchmark ID / execution path / date>

### Shared failure pattern

- **Primary failure tags:** <F1, F2, ...>
- **Observed weakness:** <one paragraph>
- **Likely root cause:** <one paragraph>
- **Confidence:** <low | medium | high>

### Evidence

- **What repeated:**
  - <pattern>
  - <pattern>
- **What varied:**
  - <pattern>
  - <pattern>
- **What is still unclear:**
  - <unknown>
  - <unknown>

### Impact assessment

- **Task families affected:** <T1-T5>
- **Execution paths affected:** <baseline | skill | worker>
- **Severity:** <low | medium | high>
- **Regression risk:** <low | medium | high>

### Candidate actions

- <candidate action 1>
- <candidate action 2>
- <candidate action 3>

### Recommendation

- **Recommended next step:** <observe more | propose candidate | add benchmark | adjust rubric | no action>
- **Owner:** <name or role>
- **Notes:**
  - <note>
  - <note>
```
