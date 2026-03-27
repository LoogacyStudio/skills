# Repo skill asset — Benchmark Run Record Example

Canonical policy context: the active benchmark corpus scoring guide and workflow doc.

Use this as a style reference only. Do not treat it as real benchmark evidence.

```md
## Run record — `B001` / `skill` / `2026-03-24`

- **Benchmark ID:** `B001`
- **Benchmark title:** `Startup build failure after SDK change`
- **Variant ID:** `none`
- **Execution path:** `skill`
- **Capability invoked:** `runtime-triage`
- **Date:** `2026-03-24`
- **Reviewer / judge:** `example only`
- **Status:** `completed`

## Input context

- **Task family:** `T1`
- **Suite coverage:** `acceptance`, `routing / trigger`, `output-quality`, `regression`
- **Scenario summary:** A Godot project stopped opening after a recent .NET SDK change. The available evidence includes partial restore/build output and one note about the changed environment.
- **Trust caveats:** The user report assumes the SDK update is the cause, but the logs are incomplete.

## Output snapshot

- **Returned artifact type:** `triage report`
- **Route result:** `R1`
- **Result summary:** The response identifies `.NET project / SDK / restore` as the most likely first failing layer, ranks one or two alternatives, asks for the smallest useful additional evidence, and suggests a concrete verification step after the probe.

## Scoring

| Dimension | Score | Notes |
| --- | --- | --- |
| Route correctness | `2` | `runtime-triage` is an appropriate narrow route for a partial startup/build failure report. |
| Structural completeness | `2` | Includes failing layer, ranked causes, next probe, and verification guidance. |
| Judgment quality | `1` | The main diagnosis is plausible, but the wording is slightly too certain given incomplete logs. |
| Actionability | `2` | The next step is small, concrete, and sequenced well. |
| Validation quality | `2` | Includes a clear way to confirm or falsify the suspected failing layer. |
| **Total** | `9` | Strong example of a production-usable triage artifact with only minor evidence-discipline weakness. |

## Failure tags

- `F3`

## Invariance / robustness notes

- **Metamorphic observations:** `not-applicable`
- **Adversarial observations:** `not-applicable`
- **Safe-failure assessment:** `not-applicable`

## Operational notes

- **Latency notes:** `not tracked in this example`
- **Cost notes:** `not tracked in this example`
- **Tooling notes:** This example is illustrative and does not correspond to an actual stored run.

## Decision notes

- **Acceptance assessment:** This path is worth using end-to-end because the narrow skill route stays cheap and fast while still producing a bounded, actionable triage artifact.
- **Usefulness verdict:** `production-usable`
- **Promotion suggestion:** `keep-seed`
- **Follow-up actions:**
  - Use this file as a formatting reference for the first real smoke-pass records.
  - Compare real `skill` and `worker` outputs against this note quality, not against the exact wording here.
```
