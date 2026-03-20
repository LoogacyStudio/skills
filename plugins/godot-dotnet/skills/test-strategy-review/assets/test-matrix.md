# Minimal Test Matrix

Use this template to return the smallest useful set of tests or validation checks for a Godot/.NET change.

Rules:

- include only target areas that materially reduce risk
- keep cases minimal and decisive
- say `Yes`, `No`, or `Partial` for runtime need
- use regression priority to show what should be protected first if time is tight

| Target area | Risk level | Recommended test type | Requires Godot runtime? | Suggested minimal cases | Regression priority |
| --- | --- | --- | --- | --- | --- |
| Example: damage formula core | High | Pure C# logic test | No | Normal hit, crit hit, invalid modifier | High |
| Example: health bar updates after damage signal | High | Runtime-dependent test | Yes | Signal fires once, UI reflects new value, freed node not referenced | High |
| Example: battle scene startup wiring | Medium | Scene / integration test | Yes | Scene loads, required nodes resolve, first turn begins cleanly | Medium |
| Example: inventory modal interaction flow | Medium | UI / flow validation | Partial | Open, cancel, confirm, state preserved after close | Medium |
| Example: post-migration project launch | High | Smoke test | Yes | Boot project, load main menu, enter one critical scene | High |
| Example: previously fixed save corruption path | High | Regression check | Partial | Reproduce old trigger, verify fix, verify adjacent save/load variant | High |

## Recommended summary after the table

- `First tests to do now:`
- `Runtime-heavy items to keep narrow:`
- `Deferred coverage:`
- `Regression focus:`
