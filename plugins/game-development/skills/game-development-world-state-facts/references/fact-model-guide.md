# Fact model guide

Use this reference when the main skill needs sharper language for deciding what counts as a world fact, separating observed truth from derived conclusions, or preventing blackboards and planners from becoming unlabeled state soup.

## Start with the smallest honest question

A fact model should answer a focused question such as:

- what does this system treat as true?
- where does that truth come from?
- when does the answer become stale?
- who is allowed to write or invalidate it?
- do consumers need a shared fact surface at all?

If the real question is only "should this one system cache a value locally?", a shared fact model may be unnecessary.

## Common fact shapes

### 1. Local private state

Use when:

- one subsystem needs one private answer
- no planner, blackboard, or cross-system consumer needs the same value
- abstraction would mostly rename one local field or cache

Good fit:

- one local cooldown helper state
- one subsystem-private temporary observation
- one feature-owned cached query result

Do not extract this into a shared fact layer unless reuse pressure is real.

### 2. Observed fact

Use when:

- the value comes from direct sensing, measurement, or explicit data collection
- consumers need to know what was actually observed
- freshness matters materially

Examples:

- target last seen at location X
- door observed as open at time T
- path currently blocked according to a navigation check

Observed facts should stay honest about source and age.

### 3. Derived fact

Use when:

- the value is computed from other facts or data
- the design benefits from separating conclusions from raw observations
- consumers must know they are reading an inference, not a direct measurement

Examples:

- area considered unsafe because several threat observations overlap
- target considered unreachable because last known location plus nav state imply failure
- cover point considered viable because line-of-sight and distance checks both pass

### 4. Shared blackboard fact

Use when:

- several decision systems need a shared readable state surface
- behavior trees, utility systems, or coordinators all benefit from the same named answers
- the cost of disagreement between consumers is high enough to justify explicit structure

A blackboard is useful only if fact provenance and freshness remain understandable.

### 5. Planner-facing world fact

Use when:

- a planner needs a stable vocabulary for world conditions
- facts must be readable in a goal or action model
- write authority and refresh rules can still be explained clearly

Planner-facing facts are not automatically the same as raw runtime observations.
Often they are curated projections.

### 6. Request or intention is not automatically a fact

Be careful not to confuse:

- what an agent wants
- what an action requested
- what the world currently supports as true

A queued intent may be important state, but it is not the same thing as a world fact.

## Boundary stress tests

Use these tests when a shared fact surface seems attractive but may still be mixing unlike things together.

### Test 1. Is this really a fact, or just one local cache?

Ask:

- does more than one meaningful consumer need the same answer?
- would the value become simpler if it stayed private to one subsystem?

If yes, a shared fact layer may be overkill.

### Test 2. Is this observation, derivation, or intention?

Ask:

- did the system directly observe this, infer it from other inputs, or merely request that it become true?
- would a consumer behave differently if it knew which of those three it was reading?

If the answer is yes, provenance has to be made explicit.

### Test 3. Is stale truth the real risk, or unsafe identity?

Ask:

- does the problem come from outdated observations, or from fact entries pointing at dead or reused entities?
- would the same fact still be meaningful if the target had to be re-resolved safely?

If entity lifetime changes the answer, pair the fact model with the entity-reference boundary instead of hiding stale handles inside facts.

### Test 4. Is this fact surface secretly becoming a notification or condition layer?

Ask:

- are people storing values mainly so they can trigger reevaluation or emit updates?
- are shared entries really being used as ad-hoc predicates instead of truth records?

If yes, split the concern: keep the fact model about truth ownership and let conditions or notifications do their own jobs.

## Truth source guidelines

## Name the source of truth

For each fact family, be able to answer:

- where does this fact ultimately come from?
- who is allowed to write it?
- who may only read it?
- does the stored value represent direct observation, derivation, or projection?
- what makes it stale or invalid?

If those answers are fuzzy, the fact model is not ready.

## Separate provenance from convenience

Avoid confusing:

- raw observations
- derived facts
- planner projections
- cached copies
- defaults standing in for unknown state

Consumers should not have to guess whether a value is current truth, last-known truth, or a conclusion from other inputs.

## Freshness and staleness

Many world-state bugs come from silently treating old observations as permanent truth.

A usable fact model should make it possible to answer:

- when was this fact updated?
- what kind of staleness matters here?
- who invalidates it?
- what should consumers do when the answer is stale or unknown?

If the team cannot answer those questions, the model is not stable yet.

## Fact metadata that may matter

Depending on the domain, useful metadata may include:

- timestamp or tick
- source tag
- confidence or certainty marker
- scope, such as entity or zone
- provenance, such as observed vs derived
- invalidation reason

Do not add all of this by default.
Use only what materially improves correctness or reviewability.

## Relationship to adjacent foundations

### Not the same as condition rules

A condition rule may read facts to decide whether something is allowed.
The fact model decides what data is available, where it comes from, and how trustworthy it is.

### Not the same as time policy

A time policy explains when reevaluation happens and which clock matters.
The fact model explains what becomes stale, how freshness is represented, and who owns invalidation.

### Not the same as entity-reference boundaries

An entity-reference foundation explains identity, handles, and lifetime safety.
A fact model may refer to entities, but it should not silently define reference-lifetime policy in full.

### Not the same as event topology

Events may notify consumers that facts changed.
The fact model explains what the facts mean and who owns them.

## Smells that justify review

Run a review when you see patterns such as:

- GOAP facts and behavior-tree blackboard entries disagreeing on basic state
- several systems all caching the same observation differently
- facts with no visible source or timestamp
- direct observations and derived conclusions mixed in one unlabeled map
- stale targets or locations being treated as current truth
- disagreement about who is allowed to write planner-visible facts
- `false`, `unknown`, and `missing` collapsing into the same outcome silently

## Decision shortcuts

If in doubt, use this shortcut:

- **one value, one owner, one consumer** -> keep it local
- **direct sensing result shared across consumers** -> observed fact
- **computed conclusion from other state** -> derived fact
- **several decision systems need the same readable surface** -> shared blackboard fact model
- **planners need stable vocabulary** -> planner-facing fact projection
- **people argue about whether an answer is still current** -> make freshness and invalidation explicit first
