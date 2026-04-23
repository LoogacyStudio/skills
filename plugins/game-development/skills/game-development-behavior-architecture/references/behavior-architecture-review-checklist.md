# Behavior-architecture review checklist

Use this checklist to review a proposed behavior architecture before the codebase commits to a control shape that is heavier, blurrier, or more magical than the problem actually needs.

## Architecture necessity and fit

- [ ] Was a simpler alternative considered first, such as a local rule flow, small enum, rule table, or event-driven controller?
- [ ] Does the chosen architecture match the actual failure mode rather than architecture fashion?
- [ ] Were at least the closest two alternatives compared explicitly?
- [ ] Is the recommendation clear about why this is an architecture problem instead of a smaller boundary problem?

## Candidate comparison discipline

- [ ] Are rejected candidates named with concrete reasons instead of vague discomfort?
- [ ] Does the recommendation distinguish reactive switching, hierarchical fallback, contextual scoring, and multi-step planning clearly?
- [ ] Is the migration cost discussed alongside the technical fit?
- [ ] Are engine-native tools accepted or rejected intentionally rather than by habit?

## Ownership and shared-context clarity

- [ ] Is it explicit what the architecture owns versus what stays in movement, animation, combat, sensing, presentation, or orchestration?
- [ ] Is shared context ownership named clearly?
- [ ] Is mutation authority for blackboard, facts, scores, or planner memory explicit?
- [ ] Does the design avoid turning shared context into a junk drawer with unclear writers?

## Interruption and reevaluation model

- [ ] Are transition, interruption, abort, or replanning rules explicit?
- [ ] Is cadence or reevaluation timing named clearly enough to review?
- [ ] Can reviewers explain what happens when the world changes mid-action?
- [ ] Does the architecture avoid hiding timing policy inside vague "reactivity" language?

## Observability and authoring safety

- [ ] Are debugging hooks, traces, or visualizations planned for the selected architecture?
- [ ] Can reviewers explain how they would inspect transitions, scores, or plans at runtime?
- [ ] Is the authoring surface small enough to remain understandable?
- [ ] Does the design improve inspectability rather than simply relocating complexity?

## Cross-foundation handoff prompts

Use these prompts when an architecture review keeps finding friction that probably belongs in a lower or adjacent layer.

- If the dispute is really about reusable guards, transition criteria, or repeated eligibility logic, pair with `game-development-condition-rule-engine`.
- If the dispute is really about truth source, sensing, freshness, or planner-readable state, pair with `game-development-world-state-facts`.
- If the dispute is really about cadence, cooldown windows, polling, or invalidation timing, pair with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification`.
- If the dispute is really about action requests, execution boundaries, queueing, or cancellation semantics, pair with `game-development-command-flow`.
- If the dispute is really about stale targets, unstable handles, or identity-vs-reference survival across evaluation and execution, pair with `game-development-entity-reference-boundary`.

## Rollout safety

- [ ] Can one bounded slice migrate first before the architecture spreads everywhere?
- [ ] Are old and new control paths comparable during rollout?
- [ ] Are verification notes strong enough to catch blackboard drift, score opacity, or planner churn early?
- [ ] Is there a plan for removing duplicated authority after the new slice proves itself?

## Final reviewer question

If this architecture were removed tomorrow, would the team still say the real problem was control shape rather than missing condition, fact, timing, or command boundaries?

- If **no**, the architecture choice may be compensating for unresolved lower layers.
- If **yes**, the recommendation is more likely earning its complexity.
