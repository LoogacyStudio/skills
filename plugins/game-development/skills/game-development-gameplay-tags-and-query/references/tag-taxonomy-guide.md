# Tag taxonomy guide

Use this reference when the main skill needs sharper language for deciding what deserves a gameplay tag, how tag families should be named, or how to stop a tag system from turning into ungoverned label sprawl.

## Start with the smallest honest question

A gameplay-tag model should answer a focused question such as:

- what should be classified by shared tags at all?
- what belongs in a tag instead of an enum, fact, or state?
- how are tags named and grouped?
- who may create or mutate tags?
- what queries do consumers actually need?

If the real question is only "should this one branch use an enum?", a shared tag model may be unnecessary.

## Common tag shapes

### 1. Local enum or fixed branch

Use when:

- the classification is small and stable
- one subsystem owns the choice entirely
- there is no need for shared query semantics across consumers

Good fit:

- one local interaction mode
- one small finite state choice
- one feature-private category switch

Do not extract this into a shared tag layer unless reuse pressure is real.

### 2. Stable classification tag

Use when:

- several systems need the same high-level category vocabulary
- the label is meaningful across more than one consumer
- the classification is more composable than one central enum should reasonably become

Examples:

- faction tags
- damage-type tags
- ability-role tags
- environment category tags

### 3. Hierarchical tag family

Use when:

- the taxonomy benefits from parent-child grouping
- queries may need ancestor or family matching
- naming discipline is strong enough to keep hierarchy understandable

Use carefully.
If hierarchy adds ceremony without clear query value, keep the taxonomy flatter.

### 4. Authored versus runtime-applied tags

Be explicit about whether a tag is:

- authored in data or content
- assigned at runtime
- both authored and runtime-derivable

Consumers should not have to guess whether a tag is stable content vocabulary or transient runtime decoration.

## Boundary stress tests

Use these tests when a tag proposal sounds flexible but may really be hiding a different data type.

### Test 1. Is this really a tag, or one fixed choice?

Ask:

- does more than one consumer need this vocabulary?
- would a small enum or branch stay clearer because the concept is fixed and local?

If yes, keep it local.

### Test 2. Is this really classification, or current truth?

Ask:

- does the label describe a stable category, or a runtime fact that may change with freshness or observation?
- would a consumer care whether the answer is currently true versus merely categorized this way?

If yes, the concept may belong closer to world-state facts than taxonomy.

### Test 3. Is hierarchy earning its keep?

Ask:

- do consumers actually need family or ancestor matching?
- would a flatter namespace preserve the same query value with less governance cost?

If not, skip the hierarchy and keep the taxonomy plain.

### Test 4. Is runtime mutation part of the design or a convenience leak?

Ask:

- are tags changing at runtime because the domain genuinely needs transient labels?
- or are they changing because facts, states, or notifications were never modeled cleanly?

If the second answer is closer, the tag system is being asked to absorb unrelated design debt.

## Boundary guidelines

## Separate tags from adjacent concepts

Avoid confusing:

- tags
- facts
- states
- references or IDs
- free-form metadata

A tag is usually a classification vocabulary, not the entire truth model.

## Name tag families explicitly

For each tag family, be able to answer:

- what domain concept does this family classify?
- who owns the family?
- how broad or narrow should it stay?
- what tags should not be added to this family?
- what query value does the family provide?

If those answers are fuzzy, the taxonomy is not ready.

## Ownership and growth control

Many tag systems fail because everyone can invent labels whenever branching gets annoying.

A usable tag model should make it possible to answer:

- who creates new tags?
- who may assign or remove them?
- what review exists before new tags spread widely?
- how are redundant or obsolete tags retired?

## Query value first

A tag should earn its existence by making queries or composition clearer.

If a proposed tag does not improve:

- filtering
- branching clarity
- shared vocabulary
- data-driven composition
- reviewability

then it may not deserve to exist.

## Relationship to adjacent foundations

### Not the same as world-state facts

A fact model explains what is true or observed.
A tag model explains how systems classify things consistently.

### Not the same as entity-reference boundaries

A reference boundary explains who or what an entity is and how it is safely resolved.
A tag model explains category vocabulary layered on top of that.

### Not the same as condition rules

A condition rule may query tags as one input.
The tag model defines what those tags mean and how they are queried.

### Not the same as full content tooling

A tag system may support content-driven workflows.
It should not automatically become a full authoring-pipeline doctrine.

## Smells that justify review

Run a review when you see patterns such as:

- enum explosion driving people to invent labels with no governance
- AI, content rules, and coordinators all using different classification vocabularies
- tags standing in for mutable runtime facts
- deep hierarchies that nobody can explain or query consistently
- new tags added casually because they were easier than naming a proper concept
- disagreement about whether a query should match exact tags, any family member, or full hierarchy
- labels that no one can say how they are supposed to be removed or retired

## Decision shortcuts

If in doubt, use this shortcut:

- **small fixed choice, one owner** -> local enum or branch
- **same classification needed across several systems** -> stable gameplay tags
- **family matching actually matters** -> carefully governed hierarchy
- **tag exists but no query benefits** -> probably should not be a tag
- **people argue whether something is a tag or a fact** -> clarify truth model first
