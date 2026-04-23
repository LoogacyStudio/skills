# Condition-model brief

## Rule boundary

- Primary question the rule system must answer:
- Why this boundary is the right one:
- What stays outside this rule layer:

## Local check vs reusable rule decision

- Simpler alternative considered:
- Why a reusable rule model is or is not justified:
- Scope of reuse:

## Atomic rule set

| Atomic rule | Question answered | Required inputs | Owner |
| --- | --- | --- | --- |
| | | | |

## Composite condition design

| Composite condition | Atomic rules used | Composition logic | Notes |
| --- | --- | --- | --- |
| | | | |

## Input and ownership model

- Input sources:
- Input lifetime or freshness assumptions:
- Ambient state risks:
- Caller, evaluator, and consumer boundaries:

## Evaluation timing and caching model

- Evaluation timing:
- Reevaluation trigger:
- Polling policy:
- Cache or memoization policy:
- Invalidation notes:

## Failure semantics and observability

- What failure means:
- Failure reason model:
- Debug or trace visibility:
- Review-time observability notes:

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
- What evidence would show the rule layer is helping rather than hiding the truth:
