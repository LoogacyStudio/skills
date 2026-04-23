# Time-policy brief

## Timing boundary

- Primary timing question:
- Why this boundary is the right one:
- What stays outside this time policy:

## Local timer vs shared time policy decision

- Simpler alternative considered:
- Why a shared time policy is or is not justified:
- Scope of reuse:

## Time source and ownership model

| Timing family | Authoritative clock | Owner or advancer | Read-only consumers | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Cadence and sampling design

| System or action family | Cadence type | Sampling rule | Why this cadence fits | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Cooldown, delay, and reevaluation model

| Concern | Clock used | Reevaluation rule | Pause or scale rule | Notes |
| --- | --- | --- | --- | --- |
| | | | | |

## Pause, scaling, and drift policy

- What pauses:
- What ignores pause:
- What uses scaled time:
- What uses unscaled time:
- Drift, skip, clamp, or catch-up rule:

## Observability and debugging notes

- Visible timing states:
- Cooldown or timer inspection notes:
- How callers know which clock they are using:
- Review-time evidence for cadence consistency:

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
- What evidence would show the time policy is improving consistency rather than hiding simple timer choices:
