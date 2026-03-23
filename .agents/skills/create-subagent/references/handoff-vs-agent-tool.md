# Handoff vs Agent-as-Tool

Use this guide to decide whether a specialist should be called as a **tool-style delegate** or become a **handoff target** with temporary or permanent ownership.

This distinction matters because ownership ambiguity is one of the fastest ways to break a multi-agent design.

---

## Agent-as-Tool

Use this when the calling agent stays in charge.
The specialist performs a bounded task and returns control.

### Signals

- the coordinator still owns the end-to-end outcome
- the specialist is performing a scoped subtask
- the caller will integrate, interpret, or approve the result
- the specialist does not need long-running autonomy
- the delegation can be expressed as an input/output contract

### Typical examples

- ask a researcher to gather evidence
- ask a reviewer to critique a draft
- ask a tester to run checks and report findings
- ask a summarizer to compress context

### Benefits

- simpler control flow
- easier traceability
- less ownership ambiguity
- safer for small bounded work

### Risks

- overuse can create micromanagement
- the coordinator may become overloaded if every small step routes through it

---

## Handoff

Use this when ownership truly transfers.
The downstream specialist becomes responsible for the next phase until completion, escalation, or explicit return.

### Signals

- the upstream role should stop directing the details
- the downstream role owns execution choices within a defined scope
- trust, permissions, or domain specialization justify the transfer
- the specialist may need to manage a longer-running workflow
- the transfer boundary is meaningful to the system design

### Typical examples

- escalate from triage to deep implementation specialist
- transfer from planner to delivery owner for full execution
- pass from coordinator to incident commander in a long investigation

### Benefits

- clearer ownership after escalation
- lower coordinator overhead
- better fit for domain-heavy or persistent specialist work

### Risks

- handoff payloads can be under-specified
- upstream/downstream ownership can become blurry
- recovery is harder if the handoff boundary is vague

---

## Decision checklist

Prefer **agent-as-tool** when most are true:

- the task is bounded
- the caller still owns the result
- the delegate does not need autonomy
- the output is a report, draft, or recommendation
- the caller will decide next steps

Prefer **handoff** when most are true:

- ownership should change hands explicitly
- the specialist should decide the next detailed steps
- the caller should not continue directing the phase
- the phase has its own lifecycle
- permissions or trust boundaries differ materially

---

## What a good handoff must include

Every handoff should define:

- current owner
- new owner
- scope of transferred responsibility
- exact artifacts and context payload
- allowed tools and permissions
- escalation conditions back to the caller or to a human
- completion or return conditions

If these are missing, it is probably not a real handoff yet.

---

## Anti-patterns

### Fake handoff

The coordinator says ownership transferred, but keeps prescribing every next step.

Better:

- keep it agent-as-tool, or
- transfer ownership for real

### Ownership vacuum

The task is handed off, but nobody clearly owns final acceptance.

Better:

- define the final owner and acceptance gate explicitly

### Handoff for style only

A handoff is introduced because it sounds sophisticated, not because the boundary is real.

Better:

- use tool-style delegation for bounded specialist work

---

## Final rule

If the caller still wants to orchestrate every material choice, use **agent-as-tool**.
If the caller wants the specialist to take responsibility for the phase, use **handoff**.
