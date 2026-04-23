# Entity-reference brief

## Identity boundary

- Primary identity question:
- Why this boundary is the right one:
- What stays outside this reference model:

## Local reference vs shared reference model decision

- Simpler alternative considered:
- Why a shared reference boundary is or is not justified:
- Scope of reuse:

## Reference forms and lookup strategy

| Entity family | Stable identity form | Direct reference allowed | Lookup strategy | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Ownership and lifetime policy

| Entity family | Identity owner | Lookup owner | Lifetime rule | Invalidation triggers | Notes |
| --- | --- | --- | --- | --- | --- |
| | | | | | |

## Payload safety and stale-reference handling

| Payload or flow | Allowed reference form | Stale failure behavior | Cleanup or fallback rule | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Observability and debugging notes

- Visible reference metadata:
- How reviewers inspect direct vs handle-based usage:
- How stale or misresolved references are classified:
- What evidence would show several systems are following the same reference policy:

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
- What evidence would show the reference boundary is improving safety rather than hiding one local pointer behind new vocabulary:
