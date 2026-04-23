---
name: game-development-gameplay-tags-and-query
description: "Use when a cross-engine gameplay task needs a Layer 1 foundation for tag taxonomies, query semantics, label sprawl, or enum explosion pressure, and the agent must define or review a reusable gameplay-tag and query model with explicit taxonomy rules, ownership, mutation policy, query semantics, and over-tagging safeguards."
---

# Game Development Gameplay Tags and Query

Use this skill when the hard part is not behavior architecture or event routing alone, but **how systems classify gameplay meaning and query it consistently without every subsystem inventing its own private label soup**.

This skill is for designing, reviewing, or refactoring a reusable gameplay-tag and query model in gameplay, AI, content, filtering, and coordination-heavy systems. Its job is to define what deserves a tag at all, how tags are named and grouped, who is allowed to assign or mutate them, how query semantics work, and how the system avoids turning one useful classification tool into an ungoverned pile of labels that nobody trusts.

If the engine is unspecified, keep the recommendation engine-agnostic first. Only use engine-native guidance when the task explicitly depends on runtime features such as Godot groups or metadata, Unity tag-like content schemes, or equivalent framework constraints.

For reusable taxonomy shapes, tag-boundary heuristics, and abstraction cautions, see `references/tag-taxonomy-guide.md`.

## Purpose

This skill is used to:

- determine whether a reusable gameplay-tag model is justified at all
- define the boundary between one local branch and shared tag semantics
- choose taxonomy, ownership, and query rules deliberately
- make mutation policy, query meaning, and over-tagging risks explicit enough to review
- return a structured tag-query design or review artifact another agent can implement incrementally

## Use this skill when

Invoke this skill for requests such as:

- content or gameplay logic keeps growing one-off label fields and special-case filters
- several systems need to classify the same entities or abilities but use different vocabularies
- the team needs to distinguish what should be a tag versus an enum, flag, state, or fact
- queries like "has tag", "any of", or hierarchical category checks keep drifting across systems
- requests that explicitly mention `gameplay tags`, `tag taxonomy`, `query`, `content filtering`, `category labels`, `status tags`, `faction tags`, or `enum explosion`

### Trigger examples

- "Should this be a gameplay tag or just an enum?"
- "Our AI, content rules, and coordinator all classify units differently"
- "How do we keep tags from turning into ungoverned label soup?"
- "We need stable query semantics instead of every caller inventing its own tag filter"

## Do not use this skill when

Do not use this skill when:

- the hard problem is still choosing behavior architecture, command flow, or event topology; use the narrower skill first
- one local branch or enum is already sufficient and no shared classification contract is needed
- the task is primarily world-fact truth ownership rather than classification vocabulary
- the task is primarily identity or reference lifetime rather than tag semantics
- the task is a localized runtime bug investigation rather than tag-model design or review

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Reviewer**

## Related skills and routing notes

- Start with `game-development-condition-rule-engine` if the real issue is eligibility logic rather than shared classification vocabulary.
- Pair with `game-development-world-state-facts` when tags are starting to smuggle runtime truth, freshness, or observed state that should stay in a fact model.
- Pair with `game-development-entity-reference-boundary` when labels are being misused as identity, target handles, or indirect reference surrogates.
- Pair with `game-development-state-change-notification` when runtime tag mutation needs explicit invalidation or observer update semantics.
- Hand off to `game-development-behavior-tree`, `game-development-utility-ai`, or `game-development-coordinator` once taxonomy and query rules are clear and the next question is behavior or routing logic.

## Diagnostic checklist

Evaluate these questions before recommending or refining a gameplay-tag model:

| Question | Healthy sign | Warning sign |
| --- | --- | --- |
| Is there real shared classification pressure? | Several systems need the same vocabulary | One local label is being over-abstracted |
| Does the tag boundary make sense? | The team can explain why this belongs in a tag system at all | Tags are becoming a dumping ground for unrelated data |
| Is taxonomy explicit? | Tag names and grouping rules are deliberate | Labels grow ad hoc with no naming discipline |
| Are ownership and mutation clear? | The system can name who assigns and changes tags | Any caller can add or remove tags casually |
| Are query semantics stable? | `has`, `any`, `all`, hierarchy, and exclusion checks mean the same thing everywhere | Each caller invents its own filter logic |
| Is over-tagging controlled? | Tags stay sparse, meaningful, and reviewable | Tags are replacing facts, states, enums, and references indiscriminately |

## Decision rules

Before recommending a reusable gameplay-tag model, ask whether the smaller honest answer is:

- one local branch or enum at a legitimate call site
- one fixed state field rather than shared classification vocabulary
- one fact-model or truth-ownership problem rather than a tag problem
- one reference or targeting problem rather than classification semantics
- one engine-specific grouping feature rather than a cross-system tag model

Reject a shared tag layer if it mostly renames obvious booleans or enums without improving shared vocabulary, query stability, or content-driven composition.

### Prefer a local enum or branch when

- the classification is small, fixed, and used in one place
- there is no need for shared query semantics across systems
- abstraction would mostly hide one obvious branch decision

### Prefer gameplay tags when

- several systems need to classify entities, actions, or content with the same vocabulary
- the system benefits from composable queries rather than repeated hard-coded branches
- the classification surface must grow gradually without exploding one central enum irresponsibly

### Prefer sparse, meaningful tags when

- tags communicate stable categories or traits rather than transient runtime trivia
- the team can explain the query value of each tag family
- reviewability improves because tags stay interpretable instead of encyclopedic

### Prefer explicit query rules when

- several consumers filter on the same labels
- hierarchy, exclusion, or combination semantics materially affect behavior
- callers need to know whether `any`, `all`, or ancestor matching is allowed

### Escalate to adjacent foundations when

- the real issue is world-fact truth rather than classification vocabulary
- the real issue is stale references or target resolution rather than tag filtering
- the real issue is condition composition rather than shared labels
- the real issue is notification topology rather than tag assignment or querying

## Workflow

Follow this sequence every time.

### 1. Identify the tag boundary

State what classification question the system is trying to answer before naming registries, databases, or editor tooling.

Examples:

- whether an entity belongs to a faction or role category
- whether a skill carries a damage or utility classification
- whether a query needs composable labels instead of hard-coded branches
- whether a content-driven rule system needs shared category vocabulary

### 2. Separate tags from adjacent data types

List what should and should not be a tag.

Typical contrasts:

- tag versus enum
- tag versus fact
- tag versus state
- tag versus reference or ID
- tag versus free-form metadata

### 3. Define taxonomy and naming rules

Specify:

- tag families or namespaces
- naming conventions
- hierarchy rules, if any
- what counts as a valid new tag
- which tag families must stay small and controlled

### 4. Define ownership and mutation policy

Specify:

- who may assign or remove tags
- whether tags are authored, runtime-generated, or both
- which tags are stable versus transient
- what reviews or controls exist before new tags spread broadly

### 5. Define query semantics

Specify:

- whether queries support `has`, `any`, `all`, exclusion, or hierarchical matching
- whether ancestor or namespace matching is legal
- how consumers combine tags with facts, states, or scores
- what happens when queries become too broad or ambiguous

### 6. Define observability and over-tagging safeguards

Specify:

- how reviewers inspect taxonomy health
- what minimum debugging surface is needed for tag-based decisions
- how the team detects redundant, unused, or misleading tags
- what evidence shows tags are reducing branch sprawl instead of creating label debt

### 7. Separate gameplay tags from adjacent concerns

Clarify what stays outside the tag model, such as:

- world-fact truth ownership
- identity and reference lifetime policy
- condition composition in full
- behavior architecture selection
- full editor tooling doctrine

### 8. Plan the rollout

Migrate incrementally: isolate one drifting label family, define taxonomy and ownership rules, tighten query semantics, replace duplicated filters gradually, add inspection visibility, and verify before widening the tag surface.

## Output contract

Return the result using `assets/tag-query-brief-template.md` in this section order.

If the best answer is **not** a reusable gameplay-tag model, still use the template and say that explicitly instead of wrapping one honest enum in tag theater.

Return the result in these sections:

1. **Tag boundary**
2. **Local branch vs shared tag model decision**
3. **Taxonomy and naming design**
4. **Tag ownership and mutation policy**
5. **Query semantics and composition rules**
6. **Observability and over-tagging notes**
7. **Related foundations and handoff notes**
8. **Engine integration notes**
9. **Migration plan**
10. **Verification notes**

Keep the section order stable so gameplay-tag recommendations are easy to compare across reviews and refactor passes.

## Engine-specific notes

### Godot / .NET

- Be explicit about whether the design uses engine-native groups, custom gameplay tags, or both.
- Do not let editor-friendly grouping features silently become the whole gameplay taxonomy without naming the trade-offs.
- Be careful when runtime groups or metadata are too transient or too engine-bound to serve as the stable cross-system vocabulary.

### Unity

- Distinguish clearly between built-in engine tagging surfaces, custom gameplay tags, and content-authored classification data.
- Avoid assuming one editor-visible tag field is enough when the runtime query semantics are more nuanced.
- Keep taxonomy ownership explicit so content growth does not turn tag authoring into label drift.

### Generic C# / engine-neutral

- Prefer named tag families and query rules over generic string bags.
- Keep runtime mutation narrow unless dynamic tagging is a deliberate part of the design.
- Use structured tag-query diagnostics only where they materially improve debugging or reviewability.

## Common pitfalls

- abstracting one local enum into a full tag system with no reuse benefit
- mixing tags, facts, states, and references in one undifferentiated label layer
- letting any caller invent new tags casually
- treating tags as universal truth instead of classification vocabulary
- allowing query semantics to drift between systems
- creating deep hierarchies nobody can explain or govern
- using tags to avoid naming actual domain concepts cleanly
- accidentally expanding a tag skill into full content pipeline or data-authoring doctrine

## Companion files

- `references/tag-taxonomy-guide.md` — reusable heuristics for taxonomy boundaries, naming rules, hierarchy choices, and abstraction cautions
- `references/query-shape-checklist.md` — reusable review checklist for query semantics, ownership, mutation rules, and over-tagging risks
- `assets/tag-query-brief-template.md` — reusable output template for returning the gameplay-tag design or review artifact

## Validation

A good result should satisfy all of the following:

- a simpler local-branch alternative was considered first
- the tag boundary is explicit
- tags are distinguished clearly from facts, states, enums, and references
- taxonomy and naming rules are concrete enough to review
- ownership, mutation, and query semantics are stated explicitly
- over-tagging risks and debugging expectations are addressed where needed
- rollout steps are incremental enough to verify safely
- the design does not quietly expand into world-facts, reference policy, or full content-pipeline doctrine by accident

## Completion rule

This skill is complete when the agent has:

- decided whether a reusable gameplay-tag model is justified at all
- identified the tag boundary and taxonomy shape
- defined ownership, mutation, and query semantics
- specified over-tagging safeguards and debugging expectations
- described engine integration notes where relevant
- returned a concrete migration and verification brief
