---
name: game-development-condition-rule-engine
description: Use when gameplay, AI, interaction, or action systems are accumulating ad-hoc preconditions, guard clauses, transition checks, or composite eligibility rules, and the agent must define or review a reusable condition model with explicit rule ownership, inputs, evaluation timing, composition, observability, and failure semantics.
---

# Game Development Condition Rule Engine

Use this skill when the hard part is not behavior architecture or event topology, but **how conditions are defined, composed, owned, and evaluated without every subsystem inventing its own private rule dialect**.

This skill is for designing, reviewing, or refactoring a reusable condition model in gameplay, AI, interaction, and action-heavy systems. Its job is to define where conditions belong, what data they read, how atomic and composite rules are composed, when evaluation happens, and how rule outcomes stay understandable enough to debug and review.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot resources or inspectors, Unity ScriptableObject authoring, or equivalent framework constraints.

For reusable condition shapes, composition heuristics, and abstraction cautions, see `references/condition-shapes.md`.

## Purpose

This skill is used to:

- determine whether a reusable condition model is justified at all
- define the boundary between one-off inline checks and shared reusable rules
- choose atomic versus composite condition shapes deliberately
- make rule inputs, ownership, evaluation timing, and failure semantics explicit enough to review
- return a structured condition-model design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- transition checks, action gates, or interaction requirements are being repeated across systems with small variations
- gameplay logic is full of scattered `if` statements whose meaning is no longer obvious from the call site
- multiple systems need to ask the same kinds of questions, such as whether an action is legal, whether a target is valid, or whether a state change is allowed
- a team needs to separate atomic predicates from composite eligibility rules instead of burying both in procedural flow
- requests that explicitly mention `conditions`, `preconditions`, `guard clauses`, `eligibility`, `rule engine`, `predicate`, `transition check`, or `composite rules`

### Trigger examples

- "We keep duplicating action preconditions across input, AI, and UI"
- "Should these transition checks become reusable rules instead of scattered conditionals?"
- "How do we structure composite gameplay conditions without making them unreadable?"
- "Our eligibility logic works, but nobody can explain where the rules actually live"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing between FSM, behavior tree, Utility AI, or GOAP; use `game-development-behavior-architecture` first
- the task is primarily world-fact ownership, blackboards, or planner-readable state; that belongs closer to a world-facts foundation
- the task is primarily event delivery or signal lifecycle rather than rule evaluation
- one direct inline check is already clearer and sufficiently local
- the task is a localized runtime bug investigation rather than condition-model design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Reviewer**

## Related skills and routing notes

- Start with `game-development-behavior-architecture` if the real question is still whether the system should stay simple or move into FSM, behavior tree, Utility AI, or GOAP.
- Pair with `game-development-world-state-facts` when conditions read shared observations, planner facts, or stale-vs-current truth.
- Pair with `game-development-resource-transaction-system` when rules are actually deciding affordability, reservation, or commit eligibility.
- Pair with `game-development-time-source-and-tick-policy` when the important disagreement is reevaluation cadence, cooldown clocks, or polling policy.
- Hand off to `game-development-fsm`, `game-development-behavior-tree`, `game-development-goap`, or `game-development-utility-ai` once the reusable rule boundary is clear and the next question is control structure.

## Diagnostic checklist

Evaluate these questions before recommending or refining a condition-rule design:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real reuse pressure? | The same decision shape appears in multiple systems | The rule exists in one place and abstraction would only rename it |
| Is the boundary clear? | The rule answers one focused question | A single rule object tries to decide half the feature |
| Are inputs explicit? | The required data can be named without hidden global state | Rules depend on ambient context or deep object graphs |
| Is composition justified? | Atomic rules combine into a clearly named higher-level check | Nested composition mostly hides confusing logic |
| Is timing part of the design? | It matters when and how often the rule is evaluated | Timing is implicit and changes across call sites |
| Is observability good enough? | You can explain why a rule passed or failed | Failures are opaque booleans with no traceability |

## Decision rules

Before recommending a reusable condition model, ask whether the smaller honest answer is:

- one direct inline check at a legitimate call site
- a local helper that stays private to one feature boundary
- a state transition rule already owned by an FSM or tree node
- a world-fact or sensing problem rather than a condition-model problem
- a command validation boundary rather than a generic rule engine

Reject a reusable rule layer if it mainly adds indirection without improving reuse, readability, or consistency.

### Prefer a local inline check when

- the condition is simple and used in one place
- the call site becomes clearer by keeping the logic nearby
- there is no practical need to share the rule elsewhere
- abstraction would mostly hide a straightforward truth

### Prefer a reusable atomic rule when

- one focused question is asked in several places
- the inputs are explicit and stable enough to pass cleanly
- the rule can be named clearly without leaking unrelated context
- reuse matters more than one-call-site convenience

### Prefer a composite condition when

- multiple atomic rules need a stable shared composition
- the composed check has a meaningful domain name
- the evaluation order or short-circuit behavior matters explicitly
- reviewability improves because the composition is easier to discuss than scattered duplicated checks

### Escalate to adjacent foundations when

- the real issue is stale or observed world facts rather than predicate composition
- the real issue is timing or reevaluation cadence rather than rule structure
- the rule depends on resource reservation or commit semantics that should live in a resource-transaction model

## Workflow

Follow this sequence every time.

### 1. Identify the rule boundary

State what question the system is trying to answer before naming classes, evaluators, or engines.

Examples:

- whether an action may start now
- whether a state transition is allowed
- whether a target is currently eligible
- whether a branch may continue executing

### 2. Separate atomic rules from composite checks

List the smallest reusable predicates first, then identify which higher-level conditions should compose them.

### 3. Define the input contract

For each important rule, specify:

- required inputs
- who owns those inputs
- whether data is passed directly, looked up, or read through a context object
- what should happen if required inputs are missing or stale

### 4. Choose the evaluation model

For each rule family, decide whether evaluation is:

- one-shot at request time
- polled repeatedly
- triggered by state change
- cached or memoized only under explicit conditions

### 5. Define failure semantics and observability

Specify:

- what a failed condition means
- whether failures should expose reasons, tags, or diagnostics
- how a caller can distinguish not-eligible from invalid-input or stale-data cases
- what minimum tracing or debug visibility is needed

### 6. Define composition rules

Specify:

- whether composition uses `all`, `any`, `not`, threshold, or ordered checks
- whether short-circuit behavior matters
- which compositions deserve domain names instead of anonymous nested logic
- where composition ownership lives

### 7. Separate condition rules from adjacent concerns

Clarify what stays outside the condition model, such as:

- event delivery topology
- world-fact freshness policy in full
- resource spending or rollback policy
- behavior architecture choice
- engine-specific inspector or editor tooling details

### 8. Plan the rollout

Migrate incrementally: isolate one repeated condition family, define atomic predicates, name the meaningful composite checks, add observability, replace duplicated call sites gradually, and verify before widening the rule surface.

## Output contract

Return the result using `assets/condition-brief-template.md` in this section order.

If the best answer is **not** a reusable condition model, still use the template and say that explicitly instead of wrapping one honest `if` statement in ceremonial architecture.

Return the result in these sections:

1. **Rule boundary**
2. **Local check vs reusable rule decision**
3. **Atomic rule set**
4. **Composite condition design**
5. **Input and ownership model**
6. **Evaluation timing and caching model**
7. **Failure semantics and observability**
8. **Related foundations and handoff notes**
9. **Engine integration notes**
10. **Migration plan**
11. **Verification notes**

Keep the section order stable so condition-model recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Prefer naming rules around gameplay meaning, not scene-tree traversal details.
- If rules are authored as resources or data assets, keep the runtime input contract explicit instead of relying on ambient node lookups.
- Be careful when conditions depend on transient nodes, timers, or scene-lifetime assumptions; pass stable data where possible.

### Unity

- Keep ScriptableObject-authored conditions honest about what runtime context they require.
- Avoid mixing inspector-friendly rule assets with hidden scene-only dependencies that make the asset impossible to reason about in isolation.
- Keep composition ownership explicit rather than scattering rule lists across unrelated behaviours.

### Generic C# / engine-neutral

- Prefer focused predicates with explicit names over huge evaluators with mode flags.
- Keep condition input contracts narrow enough that another system can call them without reconstructing the whole world.
- Use structured diagnostics only where they materially improve debugging or design review.

## Common pitfalls

- abstracting one local check into a reusable framework with no reuse benefit
- building giant condition objects that hide several unrelated concerns
- letting conditions read deep ambient state instead of explicit inputs
- composing anonymous nested rules until nobody can explain what failed
- hiding timing assumptions such as polling, reevaluation, or caching inside implementation details
- confusing rule evaluation with resource consumption, event delivery, or world-fact ownership
- returning opaque booleans when the team clearly needs actionable failure reasons
- turning a condition model into a mini scripting language too early

## Companion files

- `references/condition-shapes.md` — reusable heuristics for atomic versus composite rules, rule ownership, evaluation timing, observability, and abstraction cautions
- `references/rule-review-checklist.md` — reusable checklist for reviewing a proposed condition model before it spreads
- `assets/condition-brief-template.md` — reusable output template for returning the condition-model design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-check alternative was considered first
- the rule boundary is explicit
- atomic versus composite rules are distinguished clearly
- inputs and ownership are concrete enough to review
- evaluation timing and caching assumptions are stated explicitly
- failure semantics are reviewable and not hand-waved behind booleans
- rollout steps are incremental enough to verify safely
- the design does not quietly expand into world-facts, event topology, or resource semantics by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable condition model is justified at all
- identified the rule boundary and key atomic predicates
- defined the composite condition model and input contract
- specified evaluation timing, failure semantics, and observability
- described engine integration notes where relevant
- returned a concrete migration and verification brief
