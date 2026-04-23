---
name: game-development-entity-reference-boundary
description: Use when gameplay, AI, UI, or cross-system flows are accumulating brittle direct references, stale event payload pointers, unclear ownership of entity identity, or unsafe handle-versus-pointer trade-offs, and the agent must define or review a reusable entity-reference boundary with explicit identity rules, lookup strategy, lifetime policy, payload safety, and debugging expectations.
---

# Game Development Entity Reference Boundary

Use this skill when the hard part is not behavior architecture or event topology alone, but **how systems refer to gameplay entities safely over time without every subsystem inventing its own accidental pointer policy**.

This skill is for designing, reviewing, or refactoring a reusable entity-reference boundary in gameplay, AI, interaction, event, command, and coordination-heavy systems. Its job is to define what counts as stable identity, when direct references are safe, when handles or IDs are safer, how lookup and ownership should work, how stale references are detected, and how cross-system payloads avoid carrying dead or misleading pointers.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot node paths and instance lifetimes, Unity scene-object references, or equivalent framework constraints.

For reusable identity shapes, handle-versus-reference trade-offs, and lifetime cautions, see `references/identity-vs-reference.md`.

## Purpose

This skill is used to:

- determine whether a reusable entity-reference boundary is justified at all
- define the boundary between one local direct reference and shared reference semantics
- choose stable identity, direct reference, or handle-based lookup deliberately
- make lifetime policy, payload safety, lookup rules, and stale-reference behavior explicit enough to review
- return a structured entity-reference design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- commands, events, or coordinators keep carrying references that may be stale by the time they are consumed
- several systems refer to the same entities but disagree on whether IDs, handles, or direct pointers are allowed
- pooled objects, delayed actions, or scene transitions keep breaking reference assumptions
- a team needs clearer rules for what may be stored long-term versus resolved on demand
- requests that explicitly mention `entity identity`, `handle`, `reference boundary`, `stale reference`, `target handle`, `NodePath`, `instance ID`, `lookup`, or `payload safety`

### Trigger examples

- "Should this event carry a direct object reference or a stable handle?"
- "Our delayed commands keep firing on dead targets"
- "How do we prevent pooled objects from reusing identity in unsafe ways?"
- "Nobody can explain which systems are allowed to store raw references anymore"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing behavior architecture, command flow, or event topology; use the narrower skill first
- one local direct reference is already sufficient and no shared lifetime contract is needed
- the task is primarily truth ownership or blackboard freshness rather than reference safety
- the task is primarily timing cadence rather than reference invalidation or lookup policy
- the task is a localized runtime bug investigation rather than reference-boundary design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Reviewer**

## Related skills and routing notes

- Start with `game-development-command-flow` or `game-development-coordinator` if the main problem is ownership of cross-system handoff rather than reference form itself.
- Pair with `game-development-world-state-facts` when the supposed stale-reference issue is really stale observed truth or blackboard freshness.
- Pair with `game-development-state-change-notification` when payloads need safe identity forms instead of raw references and consumers must react after delayed delivery.
- Pair with `game-development-object-pool` when pooled reuse is the main reason direct references or instance identities keep becoming unsafe.
- Hand off to `game-development-events-and-signals` or `game-development-coordinator` once identity, handle, and lifetime rules are clear and the next question is system collaboration structure.

## Diagnostic checklist

Evaluate these questions before recommending or refining an entity-reference boundary:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared reference pressure? | Several systems need the same identity semantics | One local field is being over-abstracted |
| Is identity explicit? | The system can name what makes an entity stable across consumers | Identity is whatever object happens to be nearby |
| Does lifetime matter? | Delayed use, pooling, or scene changes can invalidate references | Consumers assume references live forever |
| Are payload rules clear? | Events and commands know what may be carried safely | Cross-system messages casually ship raw pointers |
| Is lookup ownership defined? | Systems know where and how handles resolve | Every consumer performs ad-hoc global lookups |
| Is stale detection reviewable? | The team can explain how dead or reused references are handled | Stale references fail as vague nulls or ghost behavior |

## Decision rules

Before recommending a reusable entity-reference boundary, ask whether the smaller honest answer is:

- one local direct reference at a legitimate call site
- one subsystem-private handle rule
- one fact-model or freshness problem rather than a reference-boundary problem
- one timing or delayed-execution issue rather than an identity-policy issue
- one engine-specific editor hookup rather than a shared runtime reference contract

Reject a shared reference layer if it mostly renames obvious object fields without improving safety, lifetime clarity, or cross-system consistency.

### Prefer a local direct reference when

- the reference is used immediately and locally
- there is no delayed execution, pooling, or cross-system handoff risk
- abstraction would mostly hide an obvious owner and lifetime

### Prefer stable identity or handles when

- references may outlive the current frame or call stack
- commands, events, or queues cross subsystem boundaries
- pooled objects or scene reloads can invalidate direct references
- the design needs lookup or reacquisition rather than pointer persistence

### Prefer read-time lookup when

- consumers need current truth about whether the target still exists
- direct reference retention would create stale payload risk
- the system benefits from explicit failure handling when resolution fails

### Prefer payload-safe projections when

- messages only need identity or lightweight targeting data, not full object access
- several consumers need to decide independently whether and how to resolve the target
- reviewability improves when payloads stop smuggling full object authority

### Escalate to adjacent foundations when

- the real issue is stale world facts rather than stale references
- the real issue is reevaluation cadence rather than reference invalidation policy
- the real issue is notification topology rather than payload safety semantics
- the real issue is condition or target eligibility logic rather than identity boundaries

## Workflow

Follow this sequence every time.

### 1. Identify the reference boundary

State what entity-reference question the system is trying to answer before naming registries, lookups, or payload classes.

Examples:

- whether an event may carry a direct target reference
- whether queued commands should store IDs or handles instead of pointers
- whether pooled entities need stable identity separate from object instances
- how consumers detect that a referenced entity no longer exists

### 2. Separate identity, direct references, and handles

List the important reference forms explicitly.

Typical categories:

- stable identity or ID
- direct runtime reference
- handle or lookup token
- path-based lookup or locator
- local-only transient reference

### 3. Define ownership and lookup strategy

For each important entity family, specify:

- what counts as stable identity
- who issues or owns that identity
- how handles resolve
- who is allowed to perform lookup
- what happens when resolution fails or returns a reused entity unexpectedly

### 4. Define lifetime and invalidation rules

Specify:

- how long each reference form may be retained
- what scene changes, pooling, despawn, or reload events invalidate it
- whether invalid references become null, unresolved, rejected, or explicitly stale
- who owns cleanup for stale handles or dead payloads

### 5. Define payload safety rules

Specify:

- what events, commands, blackboards, or queues may carry
- whether cross-system messages may include direct references, IDs, or only projections
- what minimum data is needed to re-resolve safely
- how payloads avoid accidentally granting too much access or lifetime assumption

### 6. Define observability and debugging expectations

Specify:

- how reviewers can tell whether a reference is direct, stable, or lookup-based
- what logs, tags, or diagnostics help classify stale-reference failures
- whether pooled identity reuse must be visible in debug tools
- what evidence shows consumers are following the same reference policy

### 7. Separate entity-reference policy from adjacent concerns

Clarify what stays outside the reference model, such as:

- event delivery topology in full
- world-fact truth ownership
- timing policy in full
- full networking identity doctrine by default
- behavior architecture selection

### 8. Plan the rollout

Migrate incrementally: isolate one drifting reference family, define stable identity and lookup rules, tighten payload policy, replace unsafe direct references gradually, add stale-detection visibility, and verify before widening the boundary.

## Output contract

Return the result using `assets/reference-boundary-template.md` in this section order.

If the best answer is **not** a reusable reference boundary, still use the template and say that explicitly instead of wrapping one honest local pointer in ceremonial handle theater.

Return the result in these sections:

1. **Identity boundary**
2. **Local reference vs shared reference model decision**
3. **Reference forms and lookup strategy**
4. **Ownership and lifetime policy**
5. **Payload safety and stale-reference handling**
6. **Observability and debugging notes**
7. **Related foundations and handoff notes**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so entity-reference recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Be explicit about whether systems rely on direct node references, `NodePath`, instance IDs, or custom gameplay IDs.
- Do not let scene-tree convenience become an accidental lifetime guarantee across queues, autoloads, or pooled nodes.
- Be careful when pooled or reparented nodes can make a once-valid reference look alive while meaningfully pointing at the wrong gameplay identity.

### Unity

- Distinguish clearly between serialized scene references, runtime object references, and stable gameplay identity.
- Avoid assuming inspector references remain the right runtime boundary for delayed or cross-system payloads.
- Be explicit when pooled object reuse or scene reloads make direct references unsafe outside narrow local use.

### Generic C# / engine-neutral

- Prefer named identity types and lookup rules over generic `object` references passed everywhere.
- Keep direct-reference retention narrow when delayed execution or object reuse exists.
- Use structured stale-reference diagnostics only where they materially improve debugging or reviewability.

## Common pitfalls

- abstracting one local direct reference into a shared identity framework with no reuse benefit
- treating object existence as stable gameplay identity without saying so
- letting events or commands carry raw references long after their safe lifetime
- mixing stable IDs, handles, and direct pointers without naming which one a consumer has
- relying on global lookups with no ownership or failure policy
- ignoring pooled-object reuse when designing supposedly stable references
- hiding stale-reference failure as vague null checks or silent no-ops
- accidentally expanding a reference-boundary skill into full networking, save/load, or targeting doctrine

## Companion files

- `references/identity-vs-reference.md` — reusable heuristics for stable identity, handles, direct references, lookup strategies, and abstraction cautions
- `references/stale-reference-checklist.md` — reusable review checklist for lifetime policy, payload safety, pooling, delayed commands, and stale-reference handling
- `assets/reference-boundary-template.md` — reusable output template for returning the entity-reference design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-reference alternative was considered first
- the identity boundary is explicit
- stable identity, direct references, and handle forms are distinguished clearly
- lookup and ownership rules are concrete enough to review
- lifetime, invalidation, and stale-reference behavior are stated explicitly
- payload safety expectations are clear where cross-system messages exist
- observability and debugging expectations are addressed where needed
- the design does not quietly expand into world-facts, timing doctrine, or full networking identity policy by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable entity-reference boundary is justified at all
- identified the identity boundary and key reference forms
- defined lookup, ownership, lifetime, and payload-safety rules
- specified stale-reference handling and debugging expectations
- described engine integration notes where relevant
- returned a concrete migration and verification brief
