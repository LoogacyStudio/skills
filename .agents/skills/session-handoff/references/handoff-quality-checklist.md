# Handoff Quality Checklist

Use this checklist to validate a handoff before returning it, saving it, or giving it to another agent.

The standard is simple:
**a fresh agent should be able to continue the work safely without reconstructing the whole prior session from scratch.**

---

## Review Outcome Scale

Use one of these for each category:

- **Pass** = ready for continuation
- **Warn** = usable, but the next agent may need recovery work
- **Fail** = too ambiguous or too weak to rely on

Optional severity for findings:

- **Critical**
- **Major**
- **Minor**

---

## 1. Resume clarity

### Check

- [ ] The handoff states the main objective clearly
- [ ] The intended continuation scope is clear
- [ ] The current status is explicit
- [ ] The exact first next step is included
- [ ] The next agent does not need to guess where to start

### Common failures

- the objective is implied rather than stated
- "continue later" appears with no concrete resume point
- the first next step is vague or missing

---

## 2. State accuracy

### Check

- [ ] Completed work is separated from in-progress work
- [ ] Blockers or pending approvals are named explicitly
- [ ] Unknowns are not presented as settled outcomes
- [ ] Assumptions are labeled when relevant

### Common failures

- done and planned work are blended together
- unresolved failures are omitted
- assumptions are written as facts

---

## 3. Evidence discipline

### Check

- [ ] Meaningful claims are backed by evidence
- [ ] Commands, tests, outputs, or artifact paths are cited where relevant
- [ ] Negative results are preserved when they matter
- [ ] File paths and symbol names are concrete

### Common failures

- "tests passed" with no indication of which tests
- no command or artifact references
- file descriptions with no actual file names

---

## 4. Decision traceability

### Check

- [ ] Important decisions are captured
- [ ] Constraints and instructions that still matter are included
- [ ] The next agent can tell which choices are intentional versus temporary
- [ ] Repo or user rules that affect future work are preserved

### Common failures

- the handoff lists outcomes but not why decisions were made
- important constraints are missing
- next agent may unknowingly undo an intentional choice

---

## 5. Scope hygiene

### Check

- [ ] The handoff contains continuation-critical context, not transcript bloat
- [ ] Raw details appear only when they are evidence or necessary context
- [ ] The document is skimmable
- [ ] The length matches the complexity of the task

### Common failures

- transcript dumping replaces synthesis
- too much low-value chronology
- tiny task, huge handoff

---

## 6. Continuation readiness

### Check

- [ ] The next agent can identify the relevant files, symbols, or artifacts quickly
- [ ] A recommended execution order or follow-up sequence is provided when useful
- [ ] Risks, blockers, and caution notes are explicit
- [ ] The handoff avoids requiring the old session to remain open

### Common failures

- no file or symbol index
- no recommended order of attack
- continuation still depends on hidden context from the old session

---

## Review report template

### Summary

- Overall result: Pass / Warn / Fail
- Resume objective:
- Key risk areas:
- Recommended next action:

### Findings

| Severity                 | Area                      | Finding     | Recommendation |
| ------------------------ | ------------------------- | ----------- | -------------- |
| Critical / Major / Minor | e.g. Evidence discipline  | Brief issue | Concrete fix   |

### Strengths

- ...
- ...

### Required fixes before handoff

- ...
- ...

### Optional improvements

- ...
- ...

---

## Final approval rule

A handoff is ready when:

- the next agent can explain the job,
- the current state is trustworthy,
- evidence supports meaningful claims,
- important decisions and constraints are preserved,
- and the next move is obvious.
