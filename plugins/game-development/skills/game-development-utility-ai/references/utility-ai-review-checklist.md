# Utility-AI review checklist

Use this checklist to review a proposed Utility AI system before the scoring layer drifts into score soup, tuning folklore, or rapid-fire reevaluation that looks intelligent only from very far away.

## Utility-AI necessity and fit

- [ ] Was a simpler non-Utility alternative considered first?
- [ ] Are multiple options genuinely valid at the same time?
- [ ] Is contextual desirability the real problem shape rather than fixed transitions, explicit hierarchy, or multi-step planning?
- [ ] Does the recommendation explain why scoring earns its complexity here?

## Candidate and consideration discipline

- [ ] Are candidates comparable at the same abstraction level?
- [ ] Is it explicit when each candidate is available?
- [ ] Are considerations named, interpretable, and owned clearly?
- [ ] Does the scorer set avoid duplicated or semantically conflicting inputs?

## Score composition and tuning clarity

- [ ] Are normalization ranges and score mappings explicit enough to review?
- [ ] Is the composition rule documented and auditable?
- [ ] Are caps, floors, bias terms, tie-break rules, or randomness named where relevant?
- [ ] Can reviewers explain why a winning candidate won without reverse-engineering a mythology?

## Reevaluation and stability

- [ ] Are rescoring triggers explicit?
- [ ] Are interruption rules, cooldowns, hysteresis, or lockouts defined where needed?
- [ ] Can reviewers explain what prevents jitter between close candidates?
- [ ] Does the design separate score math from timing policy clearly enough to debug?

## Execution boundaries and observability

- [ ] Does the scoring layer stay separate from movement, animation, combat, sensing, and presentation execution?
- [ ] Are per-candidate score breakdowns or equivalent diagnostics planned?
- [ ] Is the rollout small enough that tuning remains inspectable?
- [ ] Does the proposal avoid adding many scorers before observability exists?

## Cross-foundation handoff prompts

Use these prompts when a Utility AI review keeps surfacing friction that belongs in adjacent foundations instead of more score math.

- If candidate gating keeps repeating reusable eligibility rules, pair with `game-development-condition-rule-engine`.
- If score inputs are really arguments about truth, freshness, or shared observations, pair with `game-development-world-state-facts`.
- If jitter mostly comes from cadence, cooldown, invalidation, or interrupt windows, pair with `game-development-time-source-and-tick-policy` or `game-development-state-change-notification`.
- If resource-aware decisions are really about reservation, spend, or rollback stages, pair with `game-development-resource-transaction-system`.
- If candidate sets depend on noisy grouping, tags, or unstable targets, pair with `game-development-gameplay-tags-and-query` or `game-development-entity-reference-boundary`.

## Rollout safety

- [ ] Can one bounded candidate set migrate first?
- [ ] Are old and new choice paths comparable during rollout?
- [ ] Are score logs available before the scorer set expands?
- [ ] Are verification notes strong enough to catch opaque scoring, stale inputs, or oscillation early?

## Final reviewer question

If this scoring layer were removed tomorrow, would the team still say the real problem was contextual desirability rather than reusable conditions, fact ownership, or timing stability?

- If **no**, Utility AI may still be compensating for a different unresolved seam.
- If **yes**, the scoring layer is more likely justified.
