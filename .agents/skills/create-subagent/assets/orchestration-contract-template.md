# Orchestration Contract Template

Use this template to document how roles collaborate, who owns what, and how control flows.

---

## 1. Entry point

- **Caller / entry role:**
- **Task intake shape:**
- **Initial recommendation state:**

## 2. Control flow

1.
2.
3.

## 3. Role contract map

Repeat this block for each role that participates in the orchestration.

- **Role:**
- **Contract type:** agent-as-tool / handoff / workflow node / critic / coordinator / remote specialist candidate
- **Trigger:**
- **Returns control to:**
- **Notes:**

## 4. Ownership

- **Coordinator / primary owner:**
- **Canonical output owner:**
- **Shared state owner:**
- **Approval owner:**

## 5. Handoffs and escalations

- **Handoff boundaries:**
- **Escalation conditions:**
- **Return conditions after handoff:**

## 6. Parallelism rules

- **Parallel roles:**
- **Read/write permissions during parallel execution:**
- **Merge owner:**
- **Conflict resolution rule:**

## 7. Critic or review loop rules

- **Generator role(s):**
- **Critic / reviewer role(s):**
- **Maximum loop count:**
- **Exit conditions:**
- **Escalation after failed loop:**

## 8. Human gates

- **Approval checkpoints:**
- **What must be approved:**
- **What happens on rejection:**

## 9. Failure handling

- **Fallback mode:**
- **Reduced-mode execution path:**
- **Recovery owner:**

---

## Contract rules

A valid orchestration contract should make it easy to answer:

- who currently owns the task,
- who can mutate shared state,
- who approves quality,
- who merges parallel outputs,
- how the system exits loops or recovers from failure.
