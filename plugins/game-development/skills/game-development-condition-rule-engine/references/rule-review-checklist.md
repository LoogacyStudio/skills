# Rule review checklist

Use this checklist to review a proposed condition model before it spreads across the codebase.

## Boundary and necessity

- [ ] Was a simpler local-check alternative considered first?
- [ ] Does each reusable rule answer one focused question?
- [ ] Is the condition model solving real reuse pressure rather than renaming one local `if` statement?
- [ ] Is the rule layer distinct from behavior architecture, world facts, event topology, and resource transactions?

## Atomic versus composite structure

- [ ] Are atomic predicates separated from higher-level composite checks?
- [ ] Do composite conditions have meaningful names?
- [ ] Is composition logic understandable without reading several unrelated files?
- [ ] If evaluation order matters, is that order documented explicitly?

## Inputs and ownership

- [ ] Are required inputs explicit?
- [ ] Is it clear who owns those inputs?
- [ ] Do rules avoid hidden ambient state where practical?
- [ ] Are callers, evaluators, and consumers identifiable?
- [ ] Are stale or missing inputs handled explicitly?

## Timing and reevaluation

- [ ] Is it clear when conditions are evaluated?
- [ ] If conditions are polled repeatedly, is that choice intentional?
- [ ] If caching or memoization is used, are invalidation rules explicit?
- [ ] Are timing assumptions separated from unrelated rule semantics?

## Failure semantics and observability

- [ ] Can reviewers explain what a failed rule means?
- [ ] Where needed, do failures expose actionable reasons or diagnostics?
- [ ] Is the model debuggable without stepping through half the game loop?
- [ ] Are opaque `false` outcomes limited to cases where they are actually sufficient?

## Scope discipline

- [ ] Does the model avoid turning into a mini scripting language too early?
- [ ] Does the model avoid owning world-state freshness policy in full?
- [ ] Does the model avoid owning commit or rollback semantics in full?
- [ ] Does the model avoid pretending every check deserves a reusable abstraction?

## Cross-foundation handoff prompts

Use these prompts when a condition review keeps finding the same friction and the real problem may live elsewhere.

- If the rule cannot be reviewed without arguing about truth source, observation age, or stale data, pair with `game-development-world-state-facts`.
- If the rule says more about reservation, spend, refund, or rollback than about eligibility, pair with `game-development-resource-transaction-system`.
- If evaluation correctness changes materially with cadence, cooldown clocks, or polling policy, pair with `game-development-time-source-and-tick-policy`.
- If reevaluation is really waiting on meaningful dirty-state or invalidation triggers, pair with `game-development-state-change-notification`.

## Rollout safety

- [ ] Can one repeated condition family be migrated first?
- [ ] Is the migration plan incremental?
- [ ] Can old and new checks be compared during rollout if needed?
- [ ] Are there verification notes for confirming that the extracted rules still match gameplay intent?

## Final reviewer question

If the model were removed tomorrow, could the team still explain the gameplay truth more clearly with smaller local checks?

- If **yes**, the abstraction may still be too heavy.
- If **no**, the reusable condition model is likely earning its keep.
