# State-change brief

## Change boundary

- Primary change question:
- Why this boundary is the right one:
- What stays outside this notification model:

## Local callback vs shared notification model decision

- Simpler alternative considered:
- Why a shared notification model is or is not justified:
- Scope of reuse:

## Notification timing and emission rules

| Change family | Emission timing | Batch or immediate | Ordering notes | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Payload shape and diff-vs-snapshot policy

| Notification family | Payload type | Consumer guarantee | Re-read needed | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Batching, suppression, and invalidation rules

| Change family | Batching rule | Suppression rule | Invalidation behavior | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Consumer expectations and debugging notes

- Visible notification metadata:
- How reviewers inspect diff vs snapshot vs invalidation behavior:
- How dropped, coalesced, or noisy updates are classified:
- What evidence would show consumers are following the same change semantics:

## Related foundations and handoff notes

- Adjacent foundations already assumed by this design:
- If this brief starts absorbing the wrong concern, revisit:
- Most likely follow-on skill or specialization after this brief:

## Engine integration notes

- Engine-specific constraints, if any:
- Authoring surface notes, if any:
- Lifecycle cautions, if any:

## Migration plan

1.
2.
3.
4.

## Verification notes

- What should be checked first:
- What regressions are most likely:
- What evidence would show the notification model is improving change consistency rather than hiding one local callback behind new vocabulary:
