# Resource-transaction brief

## Transaction boundary

- Primary transaction question:
- Why this boundary is the right one:
- What stays outside this transaction layer:

## Local spend vs shared transaction decision

- Simpler alternative considered:
- Why a shared transaction model is or is not justified:
- Scope of reuse:

## Resource ownership model

| Resource family | Source of truth | Mutation owner | Preview readers | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Affordability, reservation, and commit design

| Action family | Affordability check | Reservation policy | Commit policy | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Failure, cancellation, and refund model

| Failure or cancellation case | Outcome | Refund or rollback rule | Notes |
| --- | --- | --- | --- |
| | | | |

## Auditability and UI exposure notes

- Visible transaction states:
- Debug or trace visibility:
- Preview versus commit alignment notes:
- Review-time auditability notes:

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
- What evidence would show the transaction layer is improving consistency rather than hiding simple cost logic:
