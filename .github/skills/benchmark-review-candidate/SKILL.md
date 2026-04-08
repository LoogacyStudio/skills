---
name: benchmark-review-candidate
description: Use when a wording, routing-policy, rubric, template, or other candidate revision needs a formal promotion review against target-suite gain, protected-suite regressions, invariance, robustness, mutation-surface rules, and official-adoption governance requirements.
---

# Benchmark Review Candidate

Use this skill when a candidate revision needs a formal promotion review record rather than a casual thumbs-up.

It covers **promotion-readiness review**. It does not invent the candidate, rerun the evaluation, or silently upgrade a change because it sounds smart.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- review candidate changes against the repository's promotion gate
- compare target-suite gain against protected-suite regression risk
- check invariance and robustness stability
- verify mutation-surface compliance
- block official adoption when governance evidence is missing
- require finalized rerun evidence when direct run-record citations are part of the package
- return a canonical candidate review record

## Use this skill when

Typical requests:

- reviewing a `candidate_revision` before promotion
- deciding whether a candidate should be `hold`, `reject`, `revert`, `promote-to-candidate`, or `promote-to-official`
- formalizing a promotion review after offline reruns are complete
- checking whether a new benchmark case can be adopted officially

### Trigger examples

- "Help me review whether this candidate should be promoted"
- "Write a candidate gate review"
- "Check whether the protected suites regressed"
- "Assess whether this new benchmark case is ready for official adoption"

## Do not use this skill when

Do not use this skill when:

- the candidate itself still needs to be proposed
- benchmark reruns have not happened and the evidence package is empty
- the evidence still exists only as half-finished scaffold placeholders that should first be finalized by `benchmark-judge-run`
- the task is to cluster failures or propose a wording fix
- the request is only to summarize a change informally with no gate decision

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Tool Wrapper**

Why this fit works:

- the core job is to evaluate evidence against explicit gate criteria
- it packages repository-specific mutation-surface and promotion rules
- a Generator-only framing would weaken the gate posture and make it too easy to drift into advocacy

## Inputs

Collect or infer these inputs when you can:

- candidate ID and candidate class
- mutation-surface classification
- intended gain and observed gain
- target suite and protected suites
- judged run evidence and rerun evidence
- related failure clusters
- invariance and robustness notes
- hallucination / unsafe-compliance observations
- curator or human review state for new benchmark cases when relevant

If the package is incomplete, prefer an explicit `hold` posture over speculative approval.

## Workflow

Use the same sequence each time.

### 1. Confirm candidate identity and mutation surface

Before anything else, confirm:

- candidate class
- mutation surface
- whether the surface is allowed, conditionally allowed, or disallowed

Do not review a candidate as promotable if it is quietly rewriting a disallowed surface.

### 2. Review the evidence package

Gather:

- target-suite results
- protected-suite results
- invariance evidence
- robustness evidence
- cluster context when relevant
- governance evidence for official adoption

Do not treat missing evidence as implied success.

If direct rerun citations still point to scaffold placeholders instead of finalized records from `benchmark-judge-run`, treat them as incomplete evidence and request finalization before relying on them as gate evidence.

### 3. Run the gate sequence

Review in this order:

- mutation-surface sanity
- scope sanity
- acceptance value
- regression protection
- invariance stability
- robustness safety
- governance fit

If one gate fails clearly, do not bury it under nicer notes from another gate.

### 4. Decide the outcome explicitly

Choose exactly one:

- `promote-to-candidate`
- `promote-to-official`
- `hold`
- `reject`
- `revert`

Local improvement is not enough if protected suites, invariance, or robustness degrade materially.

### 5. Return the canonical review record

Use `assets/candidate-review-record-template.md` for the final output skeleton.

## Output contract

Return the result using `assets/candidate-review-record-template.md` in the same section order.

Output rules:

- intended gain and observed gain must both be explicit
- mutation-surface classification must be explicit
- target and protected suites must both be named
- acceptance, regression, invariance, robustness, and governance must all be visible
- new benchmark-case official adoption must be blocked when curator or human review is missing

## Companion files

- `assets/candidate-review-record-template.md` — final promotion-review output structure
- `references/gate-sources.md` — canonical gate rules and decision guidance
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- one explicit decision is made
- mutation-surface classification is present
- target-suite gain is assessed explicitly
- protected-suite regression risk is assessed explicitly
- invariance and robustness are reviewed separately
- governance status for official adoption is explicit
- follow-up actions are concrete enough for another role to continue
- direct evidence citations are stable enough that another role can follow them without reconstructing scaffold state

## Common pitfalls

- approving a candidate because one benchmark improved
- ignoring protected-suite regressions
- collapsing robustness and invariance into a vague "seems okay"
- forgetting the governance requirement for new benchmark cases
- treating a blocked mutation surface as a minor technicality

## Completion rule

This skill is complete when the agent has:

- reviewed the candidate against the repository gate criteria
- recorded an explicit promotion decision
- documented target and protected suite outcomes
- documented invariance, robustness, and governance findings
- returned a reusable candidate review record