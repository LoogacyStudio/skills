# Behavior Tree Design Brief

Use this template when the skill returns a BT design or review recommendation.

## Task summary

- **Goal:**
- **System under review:**
- **Engine / runtime context:**
- **Why BT is being considered:**

## Behavior boundary

- **Concern the tree should own:**
- **Concerns that should stay outside the tree:**
- **Why this is the right boundary:**

## Branch hierarchy

| Branch / subtree | Priority | Purpose | Entry condition | Running or instant |
| --- | --- | --- | --- | --- |
| | | | | |
| | | | | |
| | | | | |

## Tree shape recommendation

- **Recommendation:** avoid / lightweight BT / structured BT
- **Top-level shape:**
- **Key selectors / sequences / decorators / services:**
- **Why this shape fits:**
- **Simpler non-BT option considered first:**
- **Why the next lighter option is insufficient:**
- **Why the next heavier option is unnecessary:**

## Blackboard design

| Key / variable | Owner | Readers | Lifetime | Why it belongs on shared context |
| --- | --- | --- | --- | --- |
| | | | | |
| | | | | |
| | | | | |

## Interrupt and running-task model

- **Priority / abort rule:**
- **Reevaluation cadence:**
- **Running-task cleanup behavior:**
- **Main failure mode to guard against:**

## Execution-system boundaries

### Movement / navigation

-

### Animation

-

### Combat / interaction / gameplay systems

-

### Sensing / world-state updates

-

## Implementation plan

1.
2.
3.
4.
5.

## Verification notes

- **Primary behavior to test:**
- **Interrupt edge cases to test:**
- **Blackboard risks to watch:**
- **Tree-growth risks to watch:**
- **Debug hooks to add:**

## Assumptions and unknowns

- **Assumption 1:**
- **Unknown 1:**
- **Smallest follow-up check if confidence is low:**
