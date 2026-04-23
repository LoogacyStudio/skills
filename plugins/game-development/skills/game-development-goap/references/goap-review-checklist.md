# GOAP review checklist

Use this checklist to review a proposed GOAP system before a planner grows around vague facts, noisy action libraries, or replanning behavior that feels adaptive only because nobody can predict it.

## GOAP necessity and planning fit

- [ ] Was a simpler non-GOAP alternative considered first?
- [ ] Does the problem truly need multi-step planning rather than next-choice selection or explicit reactive switching?
- [ ] Are goals, facts, and reusable actions concrete enough to justify planning?
- [ ] Does the recommendation explain why GOAP earns its complexity here?

## Fact model and ownership

- [ ] Are planner-readable facts named, owned, and sourced clearly?
- [ ] Is it explicit which facts are sensed, queried, or derived?
- [ ] Does planner memory stay meaningfully smaller than total subsystem state?
- [ ] Are fact freshness, invalidation, or update cadence reviewable rather than implied?

## Goal and action-library clarity

- [ ] Do goals have explicit success states and selection rules?
- [ ] Are actions reusable enough to justify being in a planner library?
- [ ] Are action preconditions, effects, and costs concrete enough to review?
- [ ] Is action granularity sane rather than explosively tiny or hand-wavingly huge?

## Replanning and execution boundaries

- [ ] Are planning and replanning triggers explicit?
- [ ] Can reviewers explain what invalidates a plan and what does not?
- [ ] Does the planner stay separate from movement, animation, combat, sensing, and presentation execution?
- [ ] Are running-action status signals back into the planner explicit enough to debug?

## Traceability and debugging

- [ ] Are goal selection, plan creation, action start, and action failure hooks planned?
- [ ] Can reviewers inspect why a plan changed or was discarded?
- [ ] Is deterministic or at least reproducible debugging considered where practical?
- [ ] Does the proposed rollout prioritize traceability before large action-library growth?

## Cross-foundation handoff prompts

Use these prompts when a GOAP review keeps surfacing problems that belong to supporting semantics rather than planning alone.

- If the real fight is about truth ownership, sensing boundaries, or stale planner memory, pair with `game-development-world-state-facts`.
- If action preconditions keep duplicating eligibility logic, pair with `game-development-condition-rule-engine`.
- If action viability or costs mostly revolve around reservation, commit, rollback, or refund stages, pair with `game-development-resource-transaction-system`.
- If replanning churn is really a cadence, invalidation, or change-trigger problem, pair with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification`.
- If plans depend on targets or objects that may vanish before execution, pair with `game-development-entity-reference-boundary`.

## Rollout safety

- [ ] Can one small goal set and action slice ship first?
- [ ] Are old and new behaviors comparable during rollout?
- [ ] Is fact logging available before the planner surface widens?
- [ ] Are verification notes strong enough to catch planner thrash, fact drift, or action-library misuse early?

## Final reviewer question

If this planner were removed tomorrow, would the team still say the real problem was goal-driven sequencing rather than fact ownership, condition reuse, or timing policy?

- If **no**, the planner may still be standing in for unresolved support semantics.
- If **yes**, the GOAP layer is more likely justified.
