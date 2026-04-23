# Events and Signals Brief

Use this template when the skill returns an events/signals topology design or review recommendation.

## Task summary

- **Goal:**
- **Systems under review:**
- **Engine / runtime context:**
- **Why events or signals are being considered:**

## Communication boundary

- **What is notifying what:**
- **What should stay as direct collaboration:**
- **Why this boundary is the right one:**

## Direct call vs event vs queue decision

- **Recommended delivery model:**
- **Why direct call was accepted or rejected:**
- **Why queue/deferred handling was accepted or rejected:**
- **Main design risk if the wrong model is chosen:**

## Publisher / subscriber matrix

| Publisher | Event / signal | Subscriber(s) | Scope | Why the decoupling is justified |
| --- | --- | --- | --- | --- |
| | | | | |
| | | | | |
| | | | | |

## Event contract design

| Event / signal | Meaning / tense | Payload | Delivery style | Ordering assumption | Notes |
| --- | --- | --- | --- | --- | --- |
| | | | | | |
| | | | | | |
| | | | | | |

## Lifecycle and subscription model

- **Connect timing:**
- **Disconnect timing:**
- **Duplicate-subscription guard:**
- **Pooled / freed / disabled object handling:**
- **Lambda / anonymous handler policy:**

## Related foundations and handoff notes

- **Foundation or adjacent skills already assumed by this design:**
- **If this brief starts absorbing the wrong concern, revisit:**
- **Review checklist or boundary checks to apply before implementation:**
- **Most likely follow-on skill or specialization after this brief:**

## Engine integration notes

### Godot / .NET

-

### Unity

-

### Generic / engine-neutral

-

## Migration plan

1.
2.
3.
4.
5.

## Verification notes

- **Main delivery behavior to test:**
- **Lifecycle edge cases to test:**
- **Traceability / logging hooks to add:**
- **Over-broadcast or event-soup risks to watch:**
- **Reasons to roll back to a simpler direct dependency if needed:**

## Assumptions and unknowns

- **Assumption 1:**
- **Unknown 1:**
- **Smallest follow-up check if confidence is low:**
