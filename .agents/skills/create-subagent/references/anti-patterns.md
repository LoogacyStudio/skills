# Multi-Agent Anti-Patterns

Use this checklist to catch bad topology ideas before they solidify into config files.

A multi-agent design can fail while still looking impressively diagrammed.
This guide focuses on the failure modes that create noise, cost, and ambiguity.

---

## 1. Architecture vanity

### Smell

Subagents are created because the system should look advanced, not because they reduce real risk.

### Why it hurts

- more orchestration cost
- more failure points
- more context duplication
- harder debugging

### Better approach

Prove why one agent is insufficient before adding specialist roles.

---

## 2. Role cloning

### Smell

Two or more subagents have different names but almost the same responsibilities.

Examples:

- reviewer and critic both doing broad quality review
- planner and coordinator both deciding next tasks without a boundary
- researcher and analyst both gathering and summarizing the same material

### Better approach

Merge roles or give each one a clear trigger and non-goal.

---

## 3. Context firehose

### Smell

Every subagent receives the full prompt, full history, full notes, and all intermediate outputs.

### Why it hurts

- destroys context isolation benefits
- increases confusion and cost
- leaks irrelevant or sensitive data

### Better approach

Use full / summary / no-share context classes.

---

## 4. Prompt as permission boundary

### Smell

A role is given risky tools but told in the prompt not to misuse them.

### Better approach

Enforce boundaries through actual tool scope, sandboxing, and permission policy.
Do not rely on prompt wording as the only guardrail.

---

## 5. Undefined handoff ownership

### Smell

The architecture says a handoff occurs, but nobody can answer who owns the task afterward.

### Better approach

Define owner before handoff, owner after handoff, return conditions, and escalation rules.

---

## 6. Endless critic loop

### Smell

Generator and critic can bounce forever.

### Better approach

Define:

- maximum iterations
- acceptance criteria
- fallback if unresolved after the limit

---

## 7. Parallel write collision

### Smell

Parallel workers can all modify the same canonical state.

### Better approach

Use one of these:

- isolated branches plus merge owner
- partitioned ownership by section or file
- read-only workers with a dedicated integrator

---

## 8. Repeated knowledge stuffing

### Smell

Stable domain knowledge is copied into every role prompt.

### Better approach

Move reusable guidance into skills, references, or shared documents that can be loaded intentionally.

---

## 9. Provider lock-in in the core design

### Smell

The topology only makes sense in one framework's syntax or abstraction model.

### Better approach

Design the provider-neutral architecture first, then map it into overlays.

---

## 10. Template without reasoning

### Smell

The result contains tidy agent specs but no explanation of why this topology was chosen.

### Better approach

Show:

- complexity assessment
- topology choice
- rejected alternatives
- boundary design rationale
- risk review

---

## 11. No fallback path

### Smell

The architecture assumes all specialist roles and loops always succeed.

### Better approach

Define:

- escalation path
- stop conditions
- human approval points where needed
- reduced-mode fallback such as workflow-first or single-agent execution

---

## Final rule

If the topology cannot explain:

- why each role exists,
- what each role must not do,
- what context each role gets,
- who owns the result,
- how failure is handled,

then it is not ready.
