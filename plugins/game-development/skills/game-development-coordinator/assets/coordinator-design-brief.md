# Coordinator Design Brief

Use this template when the skill returns a coordinator design or review recommendation.

## Task summary

- **Goal:**
- **Systems under review:**
- **Engine / runtime context:**
- **Why a coordinator is being considered:**

## Coordination boundary

- **Bounded scene / subsystem seam:**
- **What stays inside the boundary:**
- **What stays outside the boundary:**
- **Why this is the right boundary:**

## Why coordinator is justified

- **What direct references or forwarding chains are hurting today:**
- **Why direct calls alone were accepted or rejected:**
- **Why events/signals were accepted or rejected:**
- **Why command flow was accepted or rejected:**
- **Main risk if no bounded coordinator exists:**

## Coordinator shape recommendation

- **Recommended shape:**
- **Why this shape fits best:**
- **What lighter alternative was considered first:**
- **When this coordinator should be split later:**

## Public surface design

| Surface element | Type (getter/helper/signal/event/registration/action) | Why it belongs at the boundary | Notes |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |

## Internal ownership map

| Internal collaborator | Owns what | What the coordinator may do with it | What should stay internal |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |

## Direct vs event vs command split

- **Direct flows that should stay direct:**
- **Signals / events that should stay notification-based:**
- **Command-style entry points that should stay request-based:**
- **What the coordinator should *not* absorb:**

## Lifecycle and reference policy

- **How internal references are acquired:**
- **Registration / unregistration rules:**
- **Scene reload / enable-disable / runtime instance handling:**
- **Refactor-resilience notes:**
- **God-object guardrails:**

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

- **Main collaboration paths to test:**
- **Boundary leakage risks to test:**
- **Lifecycle / registration edge cases to test:**
- **Signals / commands / direct-call drift to watch:**
- **Signs the coordinator should be split later:**

## Assumptions and unknowns

- **Assumption 1:**
- **Unknown 1:**
- **Smallest follow-up check if confidence is low:**
