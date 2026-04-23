# `game-development` Layer 1 foundation skill candidates

This document turns the Layer 1 idea for the `game-development` plugin into a concrete shortlist that can be implemented incrementally.

It now also serves as the closeout record for that initial shortlist pass.

It is intentionally biased toward the current plugin surface:

- behavior architecture choice
- FSM / behavior tree / Utility AI / GOAP
- events and signals
- command flow
- bounded coordinators
- object pooling

The goal is **not** to build a full gameplay ontology museum on day one.
The goal is to identify the smallest set of foundation skills that would make the current Layer 2 surface more coherent, more reusable, and less likely to smuggle hidden assumptions into later skills.

## Closeout status

The initial `3 + 2 + 2` Layer 1 candidate rollout can now be considered **closed out for its first implementation pass**.

Closeout basis:

- all seven candidate skills now exist under [`./skills/`](./skills/)
- the seven foundation skills have scaffolded `SKILL.md`, `references/`, and `assets/` surfaces
- routing notes now exist across both the foundation skills and the higher-level `game-development` skills that depend on them
- the foundation `references/` files now include deeper boundary and handoff guidance instead of only first-pass checklists
- the foundation `assets/` templates now share a comparable handoff section and synced output contracts
- plugin-facing README material is already synchronized to the current 16-skill surface

What closeout means here:

- keep this file as the archived selection rationale and rollout record for the initial Layer 1 candidate pass
- make future refinements primarily inside the individual skill directories and [`README.md`](./README.md)
- reopen this document only if the candidate set, phase boundaries, or rollout rationale materially changes

## Decision summary

The `game-development` plugin should not try to add ten foundations at once.

The recommended plan is:

- **Phase 1: build 3 core foundations first**
- **Phase 2: add 2 adjacent foundations when reuse pressure appears**
- **Phase 3: keep 2 more candidates in reserve, not as mandatory starting scope**

### Phase 1 core set

1. `game-development-condition-rule-engine` *(initial scaffold created)*
2. `game-development-resource-transaction-system` *(initial scaffold created)*
3. `game-development-time-source-and-tick-policy` *(initial scaffold created)*

### Phase 2 adjacent set

1. `game-development-world-state-facts` *(initial scaffold created)*
2. `game-development-entity-reference-boundary` *(initial scaffold created)*

### Phase 3 reserve set

1. `game-development-gameplay-tags-and-query` *(initial scaffold created)*
2. `game-development-state-change-notification` *(initial scaffold created)*

That sequence is narrow enough to stay buildable and broad enough to support the plugin's current Layer 2 skills without pretending the repo already needs a universal gameplay constitution.

### Current implementation and closeout note

The three Phase 1 candidates, both Phase 2 adjacent candidates, and both Phase 3 reserve candidates now have shipped initial scaffolds at:

- [`skills/game-development-condition-rule-engine/`](./skills/game-development-condition-rule-engine/)
- [`skills/game-development-resource-transaction-system/`](./skills/game-development-resource-transaction-system/)
- [`skills/game-development-time-source-and-tick-policy/`](./skills/game-development-time-source-and-tick-policy/)
- [`skills/game-development-world-state-facts/`](./skills/game-development-world-state-facts/)
- [`skills/game-development-entity-reference-boundary/`](./skills/game-development-entity-reference-boundary/)
- [`skills/game-development-gameplay-tags-and-query/`](./skills/game-development-gameplay-tags-and-query/)
- [`skills/game-development-state-change-notification/`](./skills/game-development-state-change-notification/)

Those skills should still be treated as living starting points for iteration, not proof that the entire foundation layer is forever finished.
What is complete enough to close is the **candidate-selection and first implementation pass** for this `3 + 2 + 2` roadmap.

## Design goals for Layer 1 in this plugin

Every Layer 1 candidate should satisfy these goals.

### 1. Stay cross-engine

A Layer 1 foundation should describe concepts that can survive translation across:

- Godot
- Unity
- Unreal-adjacent design discussions
- engine-agnostic architecture work

### 2. Support existing Layer 2 skills directly

A new foundation should clearly strengthen one or more existing skills such as:

- `game-development-fsm`
- `game-development-behavior-tree`
- `game-development-goap`
- `game-development-utility-ai`8
- `game-development-command-flow`
- `game-development-events-and-signals`
- `game-development-coordinator`

### 3. Define shared semantics, not framework policy

A Layer 1 foundation should establish:

- vocabulary
- boundaries
- invariants
- contracts
- failure modes

It should **not** try to become an engine adapter, an implementation tutorial, or a full planner.

### 4. Trigger reliably

Each candidate must have a problem shape that an agent can recognize from task wording.

If a proposed foundation is too abstract to trigger reliably, it should either:

- become a reference file inside another skill, or
- wait until the plugin has enough evidence to justify it

## Candidate overview table

| Candidate skill | Priority | Main purpose | Most directly strengthens | Why now |
| :-------------- | :------- | :----------- | :------------------------ | :------ |
| `game-development-condition-rule-engine` | Phase 1 | Define reusable condition semantics, evaluation boundaries, and rule composition | FSM, behavior tree, GOAP, Utility AI, command flow | Current skills repeatedly depend on conditions but define them ad hoc |
| `game-development-resource-transaction-system` | Phase 1 | Define how gameplay costs, gains, reservations, and commit or rollback semantics should work | command flow, GOAP, Utility AI, coordinator | Costs and resource checks show up across action systems and planners |
| `game-development-time-source-and-tick-policy` | Phase 1 | Define timing semantics, update cadence, cooldown clocks, reevaluation timing, and drift policy | FSM, Utility AI, behavior tree, object pool | Many runtime systems quietly depend on timing rules but rarely name them clearly |
| `game-development-world-state-facts` | Phase 2 | Define how world facts, blackboard-style facts, and planner-readable state should be modeled | GOAP, behavior tree, Utility AI | GOAP and tree logic both need shared discipline around facts and observations |
| `game-development-entity-reference-boundary` | Phase 2 | Define identity, handles, references, targeting surfaces, and lifetime-safe lookups | coordinator, command flow, events and signals, object pool | Cross-system collaboration gets messy when reference ownership is implicit |
| `game-development-gameplay-tags-and-query` | Phase 3 | Define tag semantics, query boundaries, and when tags are better than hard-coded branches | behavior tree, Utility AI, coordinator | Useful, but not the first bottleneck unless the plugin starts handling richer classification logic |
| `game-development-state-change-notification` | Phase 3 | Define diff, notification, subscription, and invalidation semantics around state changes | events and signals, coordinator, Utility AI | Valuable once the plugin needs more consistency across events, watchers, and reevaluation |

## Recommended build order

## Phase 1: establish the minimum viable foundation layer

### 1. `game-development-condition-rule-engine`

Build first because it strengthens the largest number of existing skills.

Without a condition foundation, these higher-layer skills tend to reinvent:

- boolean checks
- predicate ownership
- evaluation timing assumptions
- composite rule grouping
- condition readability
- failure and fallback semantics

### 2. `game-development-resource-transaction-system`

Build second because action systems and planners need a stable way to talk about:

- costs
- affordability
- consumption timing
- reservation
- commit
- rollback

This reduces the chance that command flow, GOAP, and future ability systems all invent incompatible cost semantics.

### 3. `game-development-time-source-and-tick-policy`

Build third because timing assumptions quietly infect almost every gameplay system.

This skill should clarify:

- who owns time
- who samples time
- what tick cadence matters
- when reevaluation happens
- what counts as cooldown time
- what should remain frame-rate independent

That foundation keeps later designs from smuggling `just check every frame` in as if it were a law of nature.

## Phase 2: strengthen fact and reference discipline

### 4. `game-development-world-state-facts`

Build when the plugin begins to see repeated questions about:

- blackboards
- sensors
- world facts
- planner state
- observation freshness
- truth source ownership

This candidate becomes especially important if GOAP and behavior-tree work both continue to expand.

### 5. `game-development-entity-reference-boundary`

Build when cross-system ownership problems appear repeatedly in:

- target selection
- scene or subsystem collaboration
- pooled object reuse
- delayed commands
- event payloads carrying stale references

This foundation becomes more urgent as soon as the plugin starts formalizing targeting or identity-heavy systems.

## Phase 3: only add when evidence justifies them

### 6. `game-development-gameplay-tags-and-query`

Useful for richer composition and classification, but not a mandatory first-wave foundation.

Only prioritize this early if the plugin begins to see recurring tasks around:

- faction tags
- status tags
- damage or resistance categories
- content-driven query routing
- tag explosion versus enum explosion trade-offs

### 7. `game-development-state-change-notification`

Also valuable, but easier to overbuild too early.

Prioritize when repeated tasks begin to ask for:

- state diff emission
- invalidation and cache refresh rules
- observer update policy
- change batching
- event flood suppression
- reevaluation triggers for score or planner systems

## Detailed candidate specs

## `game-development-condition-rule-engine`

### Why this should exist

Many current plugin skills rely on conditions but handle them implicitly.
A foundation skill should make those semantics explicit before each higher-level skill invents its own local dialect.

### Use when

Use when a gameplay system needs shared rules for:

- preconditions
- guard clauses
- transition checks
- branch eligibility
- action gating
- composite conditions
- reusable predicates

### Main output

A condition-rules brief covering:

- rule boundary
- atomic versus composite conditions
- evaluation ownership
- input data contract
- readability rules
- caching or memoization cautions
- validation and debugging guidance

### Most directly supports

- `game-development-fsm`
- `game-development-behavior-tree`
- `game-development-goap`
- `game-development-utility-ai`
- `game-development-command-flow`

### Non-goals

This skill should **not**:

- define an entire event system
- define planner facts in full
- become a scripting language tutorial
- prescribe one engine's signal or inspector setup

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Reviewer**

### Minimum file structure

```text
game-development-condition-rule-engine/
├── SKILL.md
├── references/
│   ├── condition-shapes.md
│   └── rule-review-checklist.md
└── assets/
    └── condition-brief-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-condition-rule-engine/`](./skills/game-development-condition-rule-engine/).
It currently includes:

- `SKILL.md`
- `references/condition-shapes.md`
- `references/rule-review-checklist.md`
- `assets/condition-brief-template.md`

## `game-development-resource-transaction-system`

### Why this should exist

Resource costs appear in commands, actions, planners, cooldown systems, and economy-facing mechanics.
Without a foundation, each higher-level skill tends to improvise around when a resource is checked, reserved, spent, refunded, or rolled back.

### Use when

Use when a gameplay or action system needs explicit semantics for:

- costs
- charges
- stamina or mana-like spend rules
- reservation versus immediate consumption
- refunds
- failed spend attempts
- commit or rollback behavior

### Main output

A resource-transaction brief covering:

- resource boundary
- affordability check timing
- reservation rules
- commit rules
- rollback or refund policy
- auditability and UI exposure notes
- validation edge cases

### Most directly supports

- `game-development-command-flow`
- `game-development-goap`
- `game-development-utility-ai`
- future ability or interaction pipelines

### Non-goals

This skill should **not**:

- become a full inventory system
- define balancing formulas for every game economy
- prescribe concrete UI widgets for displaying resources

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Generator**

### Minimum file structure

```text
game-development-resource-transaction-system/
├── SKILL.md
├── references/
│   ├── transaction-models.md
│   └── failure-cases.md
└── assets/
    └── transaction-brief-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-resource-transaction-system/`](./skills/game-development-resource-transaction-system/).
It currently includes:

- `SKILL.md`
- `references/transaction-models.md`
- `references/failure-cases.md`
- `assets/transaction-brief-template.md`

## `game-development-time-source-and-tick-policy`

### Why this should exist

Cooldowns, reevaluation, timers, state polling, pooling resets, and behavior updates all depend on time.
Teams often bury those decisions inside implementation details, which makes later design discussions muddier than they need to be.

### Use when

Use when the real problem includes:

- tick cadence
- update frequency
- timer ownership
- cooldown semantics
- frame-based versus fixed-step logic
- reevaluation intervals
- time scaling or pause policy

### Main output

A time-policy brief covering:

- time source boundary
- frame, fixed-step, and event-driven trade-offs
- cooldown clock semantics
- reevaluation cadence
- drift or desync cautions
- pause and slowdown policy
- validation and observability notes

### Most directly supports

- `game-development-fsm`
- `game-development-utility-ai`
- `game-development-behavior-tree`
- `game-development-object-pool`

### Non-goals

This skill should **not**:

- become a physics-step tutorial
- prescribe one engine scheduler API
- define replay synchronization in full

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Reviewer**

### Minimum file structure

```text
game-development-time-source-and-tick-policy/
├── SKILL.md
├── references/
│   ├── timing-shapes.md
│   └── cooldown-and-reevaluation-guide.md
└── assets/
    └── time-policy-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-time-source-and-tick-policy/`](./skills/game-development-time-source-and-tick-policy/).
It currently includes:

- `SKILL.md`
- `references/timing-shapes.md`
- `references/cooldown-and-reevaluation-guide.md`
- `assets/time-policy-template.md`

## `game-development-world-state-facts`

### Why this should exist

GOAP, behavior trees, and Utility AI all need some disciplined way to talk about what is true, what was observed, what is stale, and what may be inferred.
A shared foundation here prevents every planner or blackboard design from drifting into a private ontology.

### Use when

Use when the task revolves around:

- world facts
- blackboard entries
- planner-readable state
- observed versus derived truth
- sensor freshness
- fact invalidation

### Main output

A world-facts brief covering:

- fact boundary
- source ownership
- freshness policy
- observed versus inferred facts
- write permissions
- planner and blackboard integration notes
- debugging and inspection notes

### Most directly supports

- `game-development-goap`
- `game-development-behavior-tree`
- `game-development-utility-ai`

### Non-goals

This skill should **not**:

- define an entire AI architecture
- prescribe a specific blackboard implementation framework
- duplicate condition-rule semantics wholesale

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Generator**

### Minimum file structure

```text
game-development-world-state-facts/
├── SKILL.md
├── references/
│   ├── fact-model-guide.md
│   └── freshness-and-ownership.md
└── assets/
    └── world-facts-brief-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-world-state-facts/`](./skills/game-development-world-state-facts/).
It currently includes:

- `SKILL.md`
- `references/fact-model-guide.md`
- `references/freshness-and-ownership.md`
- `assets/world-facts-brief-template.md`

## `game-development-entity-reference-boundary`

### Why this should exist

A lot of cross-system bugs come from unclear ownership of:

- entity identity
- target handles
- scene references
- payload references
- delayed command pointers
- pooled object handles

A foundation skill should define safe reference boundaries before higher-level routing and coordination skills compensate ad hoc.

### Use when

Use when the task involves:

- target references
- object handles
- ownership and lifetime safety
- stale references in commands or events
- identifier versus direct pointer trade-offs
- pooled object identity reuse

### Main output

An entity-reference brief covering:

- identity boundary
- lookup strategy
- stable handle versus direct reference trade-offs
- lifetime policy
- targeting and payload cautions
- validation and debugging rules

### Most directly supports

- `game-development-coordinator`
- `game-development-command-flow`
- `game-development-events-and-signals`
- `game-development-object-pool`

### Non-goals

This skill should **not**:

- prescribe one engine's scene-tree lookup API
- become a networking identity standard by default
- define targeting heuristics in full

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Reviewer**

### Minimum file structure

```text
game-development-entity-reference-boundary/
├── SKILL.md
├── references/
│   ├── identity-vs-reference.md
│   └── stale-reference-checklist.md
└── assets/
    └── reference-boundary-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-entity-reference-boundary/`](./skills/game-development-entity-reference-boundary/).
It currently includes:

- `SKILL.md`
- `references/identity-vs-reference.md`
- `references/stale-reference-checklist.md`
- `assets/reference-boundary-template.md`

## `game-development-gameplay-tags-and-query`

### Why this exists as a reserve candidate

Tag systems can unlock flexible composition, but they are also notorious for becoming ungoverned label soup.
That makes them a useful foundation candidate, but not automatically a first-wave necessity.

### Use when

Use when repeated design problems involve:

- tag taxonomies
- tag queries
- capability classification
- content-driven filtering
- faction or affinity markers
- branch reduction through declarative labels

### Main output

A tag-query brief covering:

- tag boundary
- taxonomy rules
- query semantics
- ownership and mutation cautions
- over-tagging risks
- validation guidance

### Most directly supports

- `game-development-behavior-tree`
- `game-development-utility-ai`
- `game-development-coordinator`

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Reviewer**

### Minimum file structure

```text
game-development-gameplay-tags-and-query/
├── SKILL.md
├── references/
│   ├── tag-taxonomy-guide.md
│   └── query-shape-checklist.md
└── assets/
    └── tag-query-brief-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-gameplay-tags-and-query/`](./skills/game-development-gameplay-tags-and-query/).
It currently includes:

- `SKILL.md`
- `references/tag-taxonomy-guide.md`
- `references/query-shape-checklist.md`
- `assets/tag-query-brief-template.md`

## `game-development-state-change-notification`

### Why this exists as a reserve candidate

This candidate becomes more useful once the plugin needs stronger consistency around:

- notification timing
- diff emission
- invalidation
- watcher updates
- state-driven reevaluation

It should be introduced after the core foundations unless repeated evidence shows notification semantics are already a dominant pain point.

### Use when

Use when a system needs shared discipline around:

- state diffs
- change notifications
- invalidation events
- observer updates
- batching or flood control
- reevaluation triggers

### Main output

A state-change brief covering:

- change boundary
- notification timing
- payload shape
- diff versus snapshot trade-offs
- batching policy
- invalidation rules
- validation cautions

### Most directly supports

- `game-development-events-and-signals`
- `game-development-coordinator`
- `game-development-utility-ai`

### Recommended pattern

- Primary: **Tool Wrapper**
- Secondary: **Generator**

### Minimum file structure

```text
game-development-state-change-notification/
├── SKILL.md
├── references/
│   ├── notification-shapes.md
│   └── invalidation-and-batching.md
└── assets/
    └── state-change-brief-template.md
```

### Current scaffold status

An initial scaffold now exists under [`skills/game-development-state-change-notification/`](./skills/game-development-state-change-notification/).
It currently includes:

- `SKILL.md`
- `references/notification-shapes.md`
- `references/invalidation-and-batching.md`
- `assets/state-change-brief-template.md`

## What should not be Layer 1 yet

To avoid building a cathedral before the first brick is dry, the following should **not** be first-wave Layer 1 skills in this plugin:

- generic save or load architecture
- universal ability systems
- global combat formulas
- broad inventory systems
- broad quest systems
- engine adapter guidance
- high-level planners that mostly route to other skills

Those either belong to later Layer 2 or Layer 3 work, or they need stronger evidence first.

## Recommended adoption path

## Short version

If only three Layer 1 skills are approved now, build these:

1. `game-development-condition-rule-engine`
2. `game-development-resource-transaction-system`
3. `game-development-time-source-and-tick-policy`

## Why this trio first

This trio covers the deepest shared seams behind the current Layer 2 plugin surface:

- **conditions** explain when things may happen
- **resources** explain whether things may happen economically or mechanically
- **time** explains when and how often things are evaluated or consumed

That combination gives the existing plugin a stronger conceptual floor without forcing an immediate expansion into a full AI or simulation doctrine.

## Success criteria for the first wave

The first Layer 1 wave should be considered successful if it:

- clearly strengthens at least three existing Layer 2 skills
- reduces duplicated semantics across behavior and action-flow skills
- stays cross-engine
- remains narrow enough to trigger reliably
- avoids pushing true orchestration down into foundations

## Final recommendation

Treat the current Layer 1 plan as a **3 + 2 + 2** roadmap, not a mandatory seven-skill launch.

- build **3 core** foundations first
- add **2 adjacent** foundations when evidence accumulates
- keep **2 reserve** candidates documented but unapologetically unscheduled

That gives `game-development` a believable foundation layer instead of a speculative ontology explosion.
