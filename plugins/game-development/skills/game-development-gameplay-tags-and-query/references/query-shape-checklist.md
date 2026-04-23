# Query-shape checklist

Use this reference when reviewing a proposed gameplay-tag model and you need sharper language around query semantics, mutation control, hierarchy matching, or over-tagging risk.

## Core principle

A tag model is weak when every query is effectively "string contains some label we hope means the same thing everywhere".

A useful review should distinguish at least the choices that change:

- query correctness
- taxonomy clarity
- ownership discipline
- mutation safety
- debug visibility
- label-sprawl risk

## Review questions

### 1. What deserves a tag here?

Question:

- why is this concept a tag instead of an enum, state field, fact, or metadata entry?

Expected design clarity:

- tag boundary
- alternatives considered
- query value that justifies the tag

### 2. What are the query semantics?

Question:

- do consumers use exact match, `any`, `all`, exclusion, hierarchy, or family matching?

Expected design clarity:

- supported query operations
- whether ancestor matching exists
- consistency across callers

### 3. Who owns taxonomy growth?

Question:

- who creates new tags and prevents redundant or conflicting labels?

Expected design clarity:

- taxonomy owner
- naming rules
- review or approval expectations

### 4. Who may assign or remove tags at runtime?

Question:

- are tags authored only, runtime-mutable, or both?

Expected design clarity:

- mutation authority
- stable versus transient tag families
- constraints on runtime drift

### 5. What does hierarchy mean, if it exists?

Question:

- does parent-child structure change query behavior, ownership, or discoverability?

Expected design clarity:

- hierarchy rules
- exact vs family-match behavior
- avoidance of deep unexplained trees

### 6. How does the system avoid over-tagging?

Question:

- what stops tags from absorbing facts, states, and references indiscriminately?

Expected design clarity:

- boundary rules
- redundant tag detection
- guidance for rejecting bad new tags

### 7. Is tag-based reasoning inspectable enough?

Question:

- can a reviewer explain why a query matched or did not match?

Expected design clarity:

- debug visibility for tag sets and query shape
- meaningful diagnostics for hierarchy or exclusion logic
- visibility into redundant or stale tags where relevant

## Cross-foundation handoff prompts

Use these prompts when a tag review keeps finding concepts that do not actually belong in the taxonomy.

- If the label is really current truth, observation freshness, or planner-readable state, pair with `game-development-world-state-facts`.
- If the query is really reusable eligibility logic rather than shared vocabulary, pair with `game-development-condition-rule-engine`.
- If tags are being used as identity surrogates, targeting tokens, or indirect lookup handles, pair with `game-development-entity-reference-boundary`.
- If runtime tag mutation mostly exists to wake listeners or refresh caches, pair with `game-development-state-change-notification`.

## Minimum acceptable clarity

A gameplay-tag design should be considered under-specified if you cannot answer all of the following:

- what deserves a tag in this model
- how tags are named and grouped
- who owns taxonomy growth
- what query operations are supported
- whether tags may change at runtime
- how the team prevents label sprawl or semantic drift

## Smells

These are strong warning signs:

- "we can always add a tag later"
- several systems using the same tag names with different meanings
- exact-match and family-match behavior drifting between callers
- transient runtime truths encoded as stable taxonomy labels
- tags replacing cleaner domain concepts because naming got hard
- no way to tell whether a failed query means missing tag, wrong family, or wrong semantics
