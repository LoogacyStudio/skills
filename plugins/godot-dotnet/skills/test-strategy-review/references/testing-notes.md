# Testing Notes for Godot/.NET Strategy Review

Use this reference to decide where a behavior should be validated, how broad the coverage should be, and which checks deserve priority when time is limited.

## 1. Pure logic vs runtime-dependent: how to split them

### Prefer pure logic coverage when the behavior is mainly

- deterministic calculation or rule evaluation
- input validation or normalization
- mapping, transformation, serialization rules, or state transitions
- decision logic that does not need a live scene tree
- branching behavior that can be expressed with plain data and expected outputs

These cases usually give the cheapest, fastest, and most stable confidence.

### Treat behavior as runtime-dependent when it relies on

- `Node` lifecycle timing such as enter tree, ready, exit tree, or free/dispose order
- signals and connection wiring
- scene tree lookup and dependency presence
- resource loading, packed scenes, or import state
- input routing, focus, animation timing, physics timing, or frame ordering
- engine-managed callbacks or object lifetime

These are the places where pure tests can lie to you if they ignore real engine behavior.

### Runtime test cleanup reminder

If a test or fixture creates Godot `Node` instances that never enter the `SceneTree`, tear them down with `Free()`.

Do not rely on `QueueFree()` alone for off-tree test nodes. Without scene-tree-driven deferred processing, cleanup timing may never happen when the test expects it.

### Mixed cases

Many systems are mixed.

Common pattern:

- keep core rules in pure tests
- keep orchestration and lifecycle validation in runtime or scene tests

If a system can be split this way, recommend the split. It usually lowers cost and raises confidence.

## 2. Scene test vs integration test boundary

### Scene test

Use when the main question is:

- does this specific scene load correctly?
- are required child nodes/resources wired correctly?
- do attached scripts initialize and connect as expected?
- does the scene reach a sane baseline state?

A scene test is usually narrow and local to one scene or prefab-like composition.

### Integration test

Use when the main question is:

- do multiple systems cooperate correctly?
- does data move correctly across boundaries?
- does a scene transition preserve expected state?
- does one subsystem trigger the next subsystem correctly?

Integration coverage should focus on important seams, not every internal detail.

### Practical rule

If the failure would mainly come from one scene's setup, start with a scene test.

If the failure would mainly come from multiple collaborating parts crossing boundaries, use integration coverage.

## 3. How to validate UI / UX changes

UI changes should not be treated as "just visual" if they affect player behavior, confirmation flow, or state transitions.

Prioritize:

- the primary happy path
- one cancellation or interruption path
- one persistence or return-path check
- obvious invalid or disabled-state behavior when relevant

Examples of high-value UI validation:

- menu opens, selection applies, and expected next state is visible
- confirmation dialog cancel path does not commit changes
- focus/input routing still works after a scene or modal transition
- a settings change persists after reopen or reload

Avoid broad screenshot-style coverage unless the change is mostly presentational and visual regressions are the real risk.

## 4. Smoke testing after migration or upgrade

After migration, do not start by testing edge cases. Start by proving the floor is still there.

Good smoke targets:

- project/editor startup
- main menu or first reachable scene
- one critical gameplay or tool flow
- one save/load or config path if the project depends on it
- one path that uses recently changed engine or framework features

Goal: detect catastrophic breakage early, cheaply, and in the right order.

## 5. Regression thinking after migration, bug fix, or refactor

### For bug fixes

Protect:

- the exact failure case
- one nearby variant that could fail for the same reason
- one assertion that proves the old bug does not silently reappear

### For refactors

Protect:

- public seams or externally observable behavior
- the most frequently used path
- one path that exercises the new internal wiring

### For migrations or upgrades

Protect:

- startup and loading
- critical scenes or flows
- compatibility-sensitive runtime interactions
- any area that broke during the upgrade process

## 6. Cost-aware prioritization rules

When time is limited, favor this order:

1. cheap tests that protect core rules
2. high-impact runtime or scene wiring checks
3. smoke tests for critical entry paths
4. regression checks for known fragile or recently broken areas
5. lower-impact UI polish or edge-case coverage later

Ask these questions:

- if this breaks, who notices first and how badly?
- what is the smallest check that would catch the break?
- can the risky part be isolated below runtime level?
- is this path historically fragile or newly volatile?
- are we paying runtime cost for a problem that pure logic can already cover?

## 7. What not to do

- do not recommend every layer as must-have by default
- do not collapse scene, runtime, smoke, and regression into one vague bucket
- do not push all confidence onto manual playtesting when a small deterministic check would help
- do not push all confidence onto pure logic tests when the real risk is engine wiring or lifecycle
- do not ignore migration-sensitive startup and load paths
- do not recommend `QueueFree()` as sufficient cleanup for test nodes that never enter the `SceneTree`; use `Free()` in teardown
