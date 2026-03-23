# Evaluation Checklist

Use this checklist to validate a proposed subagent architecture before implementation.

The design should be minimal, explicit, and testable.

---

## Review Outcome Scale

Use one of these for each category:

- **Pass** = sound enough to implement
- **Warn** = usable but needs tightening
- **Fail** = materially unsafe or unclear

Optional severity:

- **Critical**
- **Major**
- **Minor**

---

## 1. Recommendation fit

### Check

- [ ] One primary recommendation state is chosen explicitly
- [ ] The recommendation is justified by task shape, not style preference
- [ ] A single-agent alternative was considered
- [ ] At least one rejected topology is explained

### Common failures

- multi-agent chosen without proving the need
- recommendation language is vague or mixed
- no explanation of why alternatives are worse

---

## 2. Role clarity

### Check

- [ ] Each role has explicit responsibilities
- [ ] Each role has explicit non-goals
- [ ] Trigger conditions are clear
- [ ] Completion criteria are observable
- [ ] No two roles substantially duplicate each other

### Common failures

- reviewer and critic overlap
- planner and coordinator both own task routing
- generic roles with fuzzy responsibility lines

---

## 3. Context hygiene

### Check

- [ ] Context in is defined per role
- [ ] Context out is defined per role
- [ ] Summary-only and no-share boundaries exist where needed
- [ ] History access level is deliberate
- [ ] No unnecessary context flooding occurs

### Common failures

- every role gets full transcript access
- critics see irrelevant scratch work
- summary handoffs are missing or too vague

---

## 4. Tool and permission minimization

### Check

- [ ] Allowed tools are defined per role
- [ ] Forbidden tools are defined where relevant
- [ ] Permission risk is classified per role
- [ ] High-risk tools are limited to the smallest set of roles
- [ ] Prompt text is not the only safety boundary

### Common failures

- all roles inherit all tools
- no distinction between read-only and mutating roles
- risky actions are not gated

---

## 5. Orchestration quality

### Check

- [ ] Control flow is explicit
- [ ] Parallel and sequential relationships are clear
- [ ] Handoff boundaries are explicit where used
- [ ] Critic loops have a maximum iteration count
- [ ] Human approval gates exist where required

### Common failures

- hidden coordinator logic
- undefined merge points for parallel branches
- handoff without new-owner definition
- endless review loops

---

## 6. Shared state safety

### Check

- [ ] Shared state is identified explicitly
- [ ] Roles that can write shared state are identified
- [ ] Parallel writes are controlled or avoided
- [ ] Durable vs ephemeral memory is distinguished
- [ ] Sensitive state is not over-shared

### Common failures

- no owner for canonical state
- all roles can write task memory freely
- merge conflicts are left implicit

---

## 7. Portability

### Check

- [ ] Core design is provider-neutral
- [ ] Provider-specific guidance is isolated to overlays
- [ ] The architecture still makes sense without one vendor's syntax
- [ ] The core terminology is not framework-bound

### Common failures

- topology only described in one provider's abstractions
- provider config pollutes role design

---

## 8. Testability and failure handling

### Check

- [ ] The design can be simulated or reviewed role by role
- [ ] Failure modes and escalation paths are defined
- [ ] A reduced-mode fallback exists when useful
- [ ] Output acceptance criteria are observable

### Common failures

- no failure recovery path
- no clear stop condition after repeated critic rejection
- no practical way to verify the topology works

---

## Review report template

### Summary

- Overall result: Pass / Warn / Fail
- Primary recommendation state:
- Selected topology:
- Key risks:
- Recommended next action:

### Findings

- **Severity:** Critical / Major / Minor
- **Area:** e.g. Role clarity, Context hygiene
- **Finding:**
- **Recommendation:**

### Strengths

- ...
- ...

### Required fixes before implementation

- ...
- ...

### Optional improvements

- ...
- ...

---

## Final approval rule

A topology is ready when:

- there is a clear reason it exists,
- role boundaries are crisp,
- context boundaries are deliberate,
- permissions are minimized,
- failure handling is explicit,
- provider overlays remain secondary.
