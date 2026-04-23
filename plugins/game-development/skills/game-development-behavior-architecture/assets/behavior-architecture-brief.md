# Behavior Architecture Brief

Use this template when the skill returns a recommendation.

## Behavior problem summary

- **Behavior unit:**
- **Current pain:**
- **Success criteria:**

## Current failure shape

- **Observed failure mode:**
- **Why the current structure is straining:**

## Simpler alternative considered first

- **Candidate:**
- **Why it was considered first:**
- **Why it was accepted or rejected:**

## Candidate comparison matrix

| Candidate | Fit | Why it fits | Why it may fail |
| --- | --- | --- | --- |
| Simpler alternative | | | |
| FSM | | | |
| Behavior tree | | | |
| Utility AI | | | |
| GOAP | | | |

## Recommended architecture

- **Chosen approach:**
- **Why it fits best:**
- **Why the closest alternatives were not chosen:**

## Ownership and boundary design

- **Owned by the architecture:**
- **Kept outside the architecture:**
- **Boundary risks to watch:**

## Shared context and data model

- **Primary context model:**
- **Who owns updates:**
- **Mutation rules:**
- **Observability hooks:**

## Interrupt / reevaluation / replanning model

- **When behavior is reevaluated:**
- **How in-progress work is interrupted or preserved:**
- **Failure mode to guard against:**

## Related foundations and handoff notes

- **Foundation or adjacent skills already assumed by this design:**
- **If this brief starts absorbing the wrong concern, revisit:**
- **Review checklist or boundary checks to apply before implementation:**
- **Most likely follow-on skill or specialization after this brief:**

## Migration steps

1.
2.
3.
4.

## Verification notes

- **What to test:**
- **What regressions to watch:**
- **What signals would mean the architecture is still too heavy or too light:**

## Assumptions and unknowns

- **Assumption 1:**
- **Unknown 1:**
- **Smallest follow-up check if confidence is low:**
