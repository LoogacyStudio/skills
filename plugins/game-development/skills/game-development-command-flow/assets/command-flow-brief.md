# Command Flow Brief

Use this template when the skill returns a command-flow design or review recommendation.

## Task summary

- **Goal:**
- **Systems under review:**
- **Engine / runtime context:**
- **Why command flow is being considered:**

## Action boundary

- **What requests belong in the command flow:**
- **What should stay as direct collaboration:**
- **Why this boundary is the right one:**

## Producer / invoker model

| Producer | Trigger source | Commands issued | Why command flow is justified here |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |

## Receiver / executor model

| Executor | What it owns | Commands it handles | Notes |
| --- | --- | --- | --- |
| | | | |
| | | | |
| | | | |

## Command contract design

| Command | Intent | Required data | Reusable vs historical | Notes |
| --- | --- | --- | --- | --- |
| | | | | |
| | | | | |
| | | | | |

## Immediate vs queue vs history decision

- **Recommended execution model:**
- **Why immediate execution was accepted or rejected:**
- **Why queued or buffered execution was accepted or rejected:**
- **Why history / replay was accepted or rejected:**
- **Main design risk if the wrong model is chosen:**

## Validation / cancellation / failure model

- **Validation location:**
- **Main preconditions:**
- **Invalid command behavior:**
- **Cancellation or retry policy:**
- **What happens if target or context disappears:**

## Undo / redo / replay model

- **Undo / redo requirement:**
- **Replay or serialization requirement:**
- **What data must be stored:**
- **When history should be discarded or branched:**
- **Main reversibility or determinism risk:**

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

- **Main action-flow behavior to test:**
- **Validation edge cases to test:**
- **Queue or pending-command edge cases to test:**
- **Undo / replay edge cases to test:**
- **Command-growth risks to watch:**

## Assumptions and unknowns

- **Assumption 1:**
- **Unknown 1:**
- **Smallest follow-up check if confidence is low:**
