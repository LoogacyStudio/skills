# Test Strategy Review

Use this template to return the smallest useful but complete test strategy for a Godot/.NET change.

Rules:

- include only target areas that materially reduce risk
- keep cases minimal and decisive
- say `Yes`, `No`, or `Partial` for runtime need
- use regression priority to show what should be protected first if time is tight
- keep narrative sections short, concrete, and tied to the matrix

## Change summary

- Change type:
- Affected feature, fix, refactor, migration, or UI flow:
- Systems, scenes, scripts, or signals involved:
- Main thing that must keep working:

## Risk and failure surface

- Highest-risk path:
- Most user-visible or player-visible failure:
- Historically fragile or upgrade-sensitive area:
- Cheap high-signal verification opportunity:

## Runtime vs non-runtime split

- **Pure logic**:
- **Runtime-dependent**:
- **Mixed seam**:
- What should be pushed down into cheaper tests:

## Recommended layer coverage

- Pure C# logic tests: `Must have now` / `Nice to have later` / `Skip for now` — Why:
- Godot runtime-dependent tests: `Must have now` / `Nice to have later` / `Skip for now` — Why:
- Scene / integration tests: `Must have now` / `Nice to have later` / `Skip for now` — Why:
- UI / flow / interaction validation: `Must have now` / `Nice to have later` / `Skip for now` — Why:
- Smoke tests: `Must have now` / `Nice to have later` / `Skip for now` — Why:
- Regression checks: `Must have now` / `Nice to have later` / `Skip for now` — Why:

## Priority order

1. First validation to do now:
2. Next highest-signal check:
3. First runtime-heavy check worth paying for:
4. Deferred lower-value coverage:

## Minimal test matrix

| Target area | Risk level | Recommended test type | Requires Godot runtime? | Suggested minimal cases | Regression priority |
| --- | --- | --- | --- | --- | --- |
| Example: damage formula core | High | Pure C# logic test | No | Normal hit, crit hit, invalid modifier | High |
| Example: health bar updates after damage signal | High | Runtime-dependent test | Yes | Signal fires once, UI reflects new value, freed node not referenced | High |
| Example: battle scene startup wiring | Medium | Scene / integration test | Yes | Scene loads, required nodes resolve, first turn begins cleanly | Medium |
| Example: inventory modal interaction flow | Medium | UI / flow validation | Partial | Open, cancel, confirm, state preserved after close | Medium |
| Example: post-migration project launch | High | Smoke test | Yes | Boot project, load main menu, enter one critical scene | High |
| Example: previously fixed save corruption path | High | Regression check | Partial | Reproduce old trigger, verify fix, verify adjacent save/load variant | High |

## Regression strategy

- Exact path to protect from repeat breakage:
- One nearby variant worth protecting too:
- Narrow smoke path after the change:
- What not to broaden yet:

## Assumptions and skips

- Assumption 1:
- Assumption 2:
- Intentionally skipped layer or scenario:
- Why the skip is acceptable right now:
