# Context Boundary Checklist

Use this checklist before writing any subagent prompt.
The goal is to control **what each role sees, remembers, writes, and ignores**.

Context hygiene is architecture, not decoration.
If every role receives everything, the topology is not buying you much.

---

## 1. Classify context into three buckets

For every role, place each information type into one of these buckets.

### Full pass-through

Use when the role needs the original material verbatim.

Examples:

- the authoritative task statement
- exact error text or source snippets under review
- policy text that must not be paraphrased
- exact acceptance criteria

### Summary only

Use when the role needs awareness, not the raw detail.

Examples:

- upstream investigation notes
- long research findings
- intermediate rationale that is useful but noisy
- prior draft history that does not need exact wording

### Do not pass

Use when the information would distract, bias, leak, or create unnecessary context bloat.

Examples:

- raw scratch work irrelevant to the role
- privileged implementation details not needed for the task
- unrelated earlier branches of reasoning
- noisy failed attempts that should stay quarantined

---

## 2. Define context-in for each role

Check:

- What must be passed verbatim?
- What should be summarized?
- What should be withheld entirely?
- Does the role need conversation history, or only a scoped handoff payload?
- Would extra context improve output, or merely increase confusion?

If you cannot answer these cleanly, the role boundary is probably weak.

---

## 3. Define context-out for each role

Check:

- What output should be returned in full?
- What should be returned as a summary only?
- What scratch reasoning should remain local?
- What artifacts should be formal outputs versus transient notes?

Do not automatically forward all internal reasoning to downstream roles.
Downstream agents usually need **results**, not the entire cognitive exhaust plume.

---

## 4. Decide memory scope

### Shared durable memory

Use only when facts should outlive the task and be reused later.

Good examples:

- verified repository conventions
- stable workflow policies
- persistent specialist settings

### Shared ephemeral task state

Use when roles must collaborate during one task but the state should expire afterward.

Good examples:

- current topology decision
- active plan state
- task-local artifacts and summaries

### Isolated local memory

Use when work should not pollute shared state.

Good examples:

- noisy exploration
- speculative alternatives
- critic scratch notes
- parallel worker internals

---

## 5. Decide whether the role can read history

Possible settings:

- **No history**: role gets only the scoped payload
- **Summary history only**: role gets a curated recap
- **Selective history**: role may inspect relevant prior turns
- **Full history**: only when continuity really matters

Default to the smallest useful level.
Full transcript access should be the exception, not the default.

---

## 6. Decide whether the role can write shared state

Ask:

- Does this role create canonical outputs?
- Could concurrent writes create conflicts?
- Should the role only propose changes for the coordinator to commit?
- Is write access necessary, or merely convenient?

If multiple parallel roles can write the same state, define:

- ownership
- merge rules
- collision handling
- approval requirements

---

## 7. Isolation rules

Use isolated execution when:

- the role produces lots of noisy intermediate output
- the role should not bias later reviewers
- the role uses risky tools or broader permissions
- the role runs speculative branches that should not contaminate shared state

Use shared execution only when the collaboration benefit outweighs the contamination risk.

---

## 8. Summary handoff template

For roles that should receive summary-only context, the handoff should usually include:

- task goal
- current stage
- key decisions already made
- relevant constraints
- accepted facts
- unresolved risks
- exact input artifact references
- required output shape

Keep the payload crisp.
A good summary handoff should reduce context, not replicate it.

---

## 9. Red flags

Treat these as design warnings:

- every role receives the full original prompt plus all prior output
- the critic sees the generator's hidden scratch work unnecessarily
- parallel workers write to the same canonical state with no merge owner
- sensitive or privileged context is passed to low-trust roles by default
- handoffs contain vague prose instead of explicit payloads

---

## Final rule

For each role, be able to answer:

- What does it need to know?
- What must it not know?
- What can it write?
- What must stay local?
- What survives after the task?

If those answers are fuzzy, tighten the boundary before proceeding.
