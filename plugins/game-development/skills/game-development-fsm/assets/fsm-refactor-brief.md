# FSM refactor brief

## Task summary

- Goal:
- System under review:
- Engine / runtime context:
- Main symptom:
- Why FSM is being considered:

## State boundary

- Concern the machine should own:
- Concerns that should stay outside the machine:
- Why this boundary is the right cut:

## Current-state extraction

| Candidate state / mode | Current evidence in code or behavior | Why it is a real state vs a flag |
| ---------------------- | ------------------------------------ | -------------------------------- |
|                        |                                      |                                  |
|                        |                                      |                                  |
|                        |                                      |                                  |

## State list

| State | Purpose | Entry trigger | Exit trigger | Important side effects |
| ----- | ------- | ------------- | ------------ | ---------------------- |
|       |         |               |              |                        |
|       |         |               |              |                        |
|       |         |               |              |                        |

## State diagram

```text
[StateA] --trigger/guard--> [StateB]
[StateB] --trigger/guard--> [StateC]
[StateC] --trigger/guard--> [StateA]
```

## Transition table

| Source | Destination | Trigger | Guard | Side effects / cleanup |
| ------ | ----------- | ------- | ----- | ---------------------- |
|        |             |         |       |                        |
|        |             |         |       |                        |
|        |             |         |       |                        |

## Recommended FSM shape

- Recommendation: avoid / lightweight / structured
- Implementation shape: enum-based / class-based / node-based / other
- Why this shape fits:
- Simpler non-FSM option considered first:
- Why the next lighter option is insufficient:
- Why the next heavier option is unnecessary:

## Class or interface design

- Owner / context object:
- State interface:
- Transition authority:
- Shared services or data:

### Sketch

```text
Owner / Context
├── CurrentState
├── ChangeState(next)
├── Shared services
└── State implementations
```

## Engine integration plan

### Input

-

### Animation

-

### Gameplay / AI / UI systems

-

### Engine-native boundaries

- What should stay with engine-native tooling:
- What the FSM should own directly:

## Refactor steps

1.
2.
3.
4.
5.

## Verification notes

- Primary behavior to test:
- Transition edge cases to test:
- Regression risks to watch:
- Debug hooks to add:

## Assumptions and unknowns

- Assumption 1:
- Unknown 1:
- Smallest follow-up check if confidence is low:
