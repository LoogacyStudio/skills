---
name: game-development-world-state-facts
description: "Use when a cross-engine gameplay task needs a Layer 1 foundation for world facts, blackboard state, stale observations, or freshness rules, and the agent must define or review a reusable world-state fact model with explicit source ownership, observed-vs-derived boundaries, freshness policy, write permissions, invalidation behavior, and inspection surfaces."
---

# Game Development World State Facts

Use this skill when the hard part is not behavior architecture or event routing alone, but **how gameplay systems represent what is true, what was observed, what may be inferred, and when those answers become stale without every subsystem inventing its own private blackboard folklore**.

This skill is for designing, reviewing, or refactoring a reusable world-fact model in gameplay, AI, sensing, planner, and blackboard-heavy systems. Its job is to define what counts as a fact, where facts come from, who is allowed to write them, how observed facts differ from derived facts, when freshness matters, and how consumers can reason about truth without guessing which cache, node, or subsystem last touched the data.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot resources and scene-tree observation patterns, Unity ScriptableObject-authored blackboards, or equivalent framework constraints.

For reusable fact shapes, truth-source heuristics, and abstraction cautions, see `references/fact-model-guide.md`.

## Purpose

This skill is used to:

- determine whether a reusable world-fact model is justified at all
- define the boundary between one local state read and shared fact semantics
- choose observed, derived, cached, or planner-facing fact shapes deliberately
- make source ownership, freshness, invalidation, and write permissions explicit enough to review
- return a structured world-facts design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- planner, blackboard, or sensing systems keep disagreeing about what is currently true
- several systems need to read the same world-state answers but currently cache them differently
- a team needs to separate direct observations from inferred or derived facts
- freshness, invalidation, or truth ownership keeps causing AI or gameplay drift
- requests that explicitly mention `world facts`, `blackboard`, `observed state`, `derived state`, `sensors`, `fact freshness`, `truth source`, or `planner-readable state`

### Trigger examples

- "Our GOAP facts and behavior-tree blackboard keep drifting out of sync"
- "Should this be stored as a fact, derived on demand, or treated as a local observation?"
- "How do we model stale observations without every AI system guessing freshness differently?"
- "Nobody can explain who is allowed to write these world-state facts anymore"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing FSM, behavior tree, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- one local state read or cache is already sufficient and no shared fact contract is needed
- the task is primarily condition composition rather than truth ownership or freshness policy
- the task is primarily timing cadence rather than world-state semantics
- the task is a localized runtime bug investigation rather than world-fact design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if the bigger uncertainty is still whether the system should use behavior trees, GOAP, Utility AI, or a simpler route.
- Pair with `game-development-condition-rule-engine` when consumers must turn facts into reusable predicates instead of only storing truth.
- Pair with `game-development-entity-reference-boundary` when facts include entity handles, target references, or stale object identities.
- Pair with `game-development-state-change-notification` when consumers need explicit invalidation, fact updates, or meaningful change emission instead of silent freshness drift.
- Hand off to `game-development-goap`, `game-development-behavior-tree`, or `game-development-utility-ai` once the fact surface is clear and the next question is decision logic.

## Diagnostic checklist

Evaluate these questions before recommending or refining a world-fact model:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared fact pressure? | Several systems need the same world-state answers | One local read is being over-abstracted |
| Is the truth source explicit? | The system can name where each fact ultimately comes from | Several systems all claim to know the truth |
| Does freshness matter? | The team can explain when an observation becomes stale | Consumers treat every cached answer as timeless |
| Are observed and derived facts separated? | Direct observations and inferred conclusions are distinguishable | A single bag of facts mixes source types without labels |
| Are write permissions clear? | Fact writers and read-only consumers are easy to name | Any caller can mutate the fact store casually |
| Is inspection possible? | Reviewers can see why a fact exists and how old it is | Fact state hides inside unrelated logic or transient objects |

## Decision rules

Before recommending a reusable world-fact model, ask whether the smaller honest answer is:

- one local state read at a legitimate call site
- one private cache owned by one subsystem
- one condition rule rather than a fact-ownership problem
- one timing or freshness issue that belongs in a time policy
- one reference-lifetime problem rather than a fact-model problem

Reject a shared fact layer if it mostly renames a single dictionary or cache without improving truth ownership, freshness clarity, or cross-system consistency.

### Prefer a local state read when

- the answer is simple and used in one place
- there is no need for shared freshness or blackboard semantics
- abstraction would mostly hide an obvious read from an obvious owner

### Prefer observed facts when

- the system records something that was directly sensed or measured
- consumers need to know the observation source or timestamp
- stale observations must be distinguishable from current truth

### Prefer derived facts when

- the answer depends on combining other inputs or observations
- the system benefits from keeping inference separate from raw observations
- reviewers need to know that the value is a conclusion, not a direct measurement

### Prefer a shared fact model when

- several systems need planner-readable or blackboard-style access to the same state answers
- ownership and freshness are currently drifting across subsystems
- the cost of disagreement between consumers is higher than the cost of explicit structure

### Escalate to adjacent foundations when

- the real issue is rule composition rather than fact ownership
- the real issue is reevaluation cadence rather than truth-source design
- the real issue is stale entity handles or disappearing targets rather than fact semantics
- the real issue is notification topology rather than fact storage or derivation

## Workflow

Follow this sequence every time.

### 1. Identify the fact boundary

State what world-state question the system is trying to answer before naming blackboards, planners, or data stores.

Examples:

- whether a target is currently visible
- whether a location is believed to be safe
- whether a planner may treat a resource source as reachable
- whether an observation is current enough to trust

### 2. Separate observed, derived, and local-only state

List the important state families explicitly.

Typical categories:

- direct observations
- derived or inferred facts
- transient local state that should stay private
- planner-facing or blackboard-facing shared facts

### 3. Define truth sources and write permissions

For each important fact family, specify:

- source of truth
- who may write or update it
- who may only read it
- whether derived facts may be persisted or must be recomputed
- what happens if the source disappears or becomes invalid

### 4. Define freshness, staleness, and invalidation rules

Specify:

- when a fact becomes stale
- whether freshness is time-based, event-based, or source-based
- whether stale facts are removed, marked, downgraded, or left visible with metadata
- how invalidation is triggered and who owns it

### 5. Define fact shape and lookup strategy

Specify:

- naming or keying strategy
- whether facts are entity-scoped, world-scoped, zone-scoped, or request-scoped
- what metadata is needed, such as timestamps, confidence, source tags, or provenance
- how consumers distinguish absent, false, stale, and unknown states

### 6. Define planner and blackboard integration

Specify:

- which consumers need shared fact access
- whether planners and behavior trees read the same fact surface or projections of it
- what facts are safe to expose broadly versus keep private to a subsystem
- whether writes from decision systems are allowed or read-only by default

### 7. Define observability and debugging expectations

Specify:

- what minimum fact inspection or traceability is needed
- whether freshness metadata must be visible
- how reviewers can tell which facts are observed versus derived
- what evidence helps confirm that consumers are using the same truth model

### 8. Separate world facts from adjacent concerns

Clarify what stays outside the fact model, such as:

- condition composition in full
- timing policy in full
- event delivery topology
- reference-lifetime guarantees
- full AI architecture selection

### 9. Plan the rollout

Migrate incrementally: isolate one repeated fact family, define truth ownership, add freshness and invalidation rules, separate derived from observed values, replace drifting consumers gradually, and verify before widening the fact surface.

## Output contract

Return the result using `assets/world-facts-brief-template.md` in this section order.

If the best answer is **not** a reusable fact model, still use the template and say that explicitly instead of wrapping one honest state read in blackboard mythology.

Return the result in these sections:

1. **Fact boundary**
2. **Local state vs shared fact model decision**
3. **Fact types and truth sources**
4. **Ownership and write permissions**
5. **Freshness, invalidation, and derivation model**
6. **Planner and blackboard integration notes**
7. **Observability and debugging notes**
8. **Related foundations and handoff notes**
9. **Engine integration notes**
10. **Migration plan**
11. **Verification notes**

Keep the section order stable so world-fact recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Keep fact ownership separate from whichever node happens to sense or consume the value first.
- If observations come from scene-tree queries, make provenance and lifetime explicit instead of treating node existence as timeless truth.
- Be careful when pooled or transient nodes appear inside observations; stale references should not silently masquerade as current facts.

### Unity

- Keep ScriptableObject-authored blackboard schemas separate from runtime truth ownership unless the mutation story is genuinely clear.
- Avoid inspector-friendly fact surfaces that hide whether a value is observed, derived, stale, or merely defaulted.
- Distinguish clearly between authoring-time data shape and runtime sensing or inference ownership.

### Generic C# / engine-neutral

- Prefer named fact families with explicit provenance over generic bags of `object` values.
- Keep read-only consumer access separate from write authority wherever practical.
- Use freshness metadata only where it materially improves correctness, debugging, or design review.

## Common pitfalls

- abstracting one local cache into a shared fact framework with no reuse benefit
- mixing observed, derived, and guessed values in one unlabeled state bag
- letting any caller write to the fact surface without ownership rules
- treating stale observations as if they were current truth
- hiding provenance and freshness metadata when consumers clearly need them
- turning a fact model into a full planner, event bus, or AI architecture by accident
- duplicating entity-reference or timing semantics instead of delegating to adjacent foundations
- making it impossible to tell the difference between `false`, `unknown`, `absent`, and `stale`

## Companion files

- `references/fact-model-guide.md` — reusable heuristics for fact types, truth sources, provenance, ownership, and abstraction cautions
- `references/freshness-and-ownership.md` — reusable review guide for freshness policy, invalidation, write permissions, and stale-observation handling
- `assets/world-facts-brief-template.md` — reusable output template for returning the world-facts design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-state alternative was considered first
- the fact boundary is explicit
- observed, derived, and local-only state are distinguished clearly
- truth sources and write permissions are concrete enough to review
- freshness, invalidation, and staleness behavior are stated explicitly
- planner and blackboard integration notes are clear where relevant
- observability and debugging expectations are addressed where needed
- the design does not quietly expand into condition logic, timing doctrine, or reference-lifetime policy by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable world-fact model is justified at all
- identified the fact boundary and key fact families
- defined truth sources, write permissions, and freshness rules
- specified planner and blackboard integration expectations
- described observability and engine integration notes where relevant
- returned a concrete migration and verification brief
