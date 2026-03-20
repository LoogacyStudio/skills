# Design / Writing Team Example

This example shows when drafting, editing, fact-checking, and human approval should remain distinct.

---

## Scenario

An agent system must prepare a product announcement, design proposal, or policy draft that needs stylistic polish, factual accuracy, and explicit human sign-off before publication.

### Recommended state

- `subagents-recommended`

### Recommended topology

- Sequential Pipeline
- Human-in-the-loop
- Optional Generator / Critic Loop

---

## Roles

### `drafter`

- **Role:** generator
- **Purpose:** produce the first coherent draft
- **Responsibilities:** structure the message, cover required sections, create readable prose
- **Non-goals:** final factual assurance or publication approval

### `editor`

- **Role:** critic or reviewer
- **Purpose:** improve clarity, tone, and readability
- **Responsibilities:** tighten structure, remove redundancy, improve flow
- **Non-goals:** invent unsupported facts

### `fact-checker`

- **Role:** reviewer
- **Purpose:** verify claims, numbers, references, and source alignment
- **Responsibilities:** flag unsupported assertions, missing citations, or stale facts
- **Non-goals:** rewrite style unless it affects accuracy

### `approver`

- **Role:** human gate
- **Purpose:** accept, reject, or request revision before publication
- **Responsibilities:** final brand, policy, or stakeholder judgment
- **Non-goals:** perform low-level copy editing in place of the editor

---

## When to use a human approval gate

Use a human gate when any of these apply:

- publication or external communication is involved
- policy, legal, or brand judgment is required
- the cost of factual or reputational error is high
- the approval decision is inherently subjective or organizational

Do not hide this gate inside the critic loop.
Make it an explicit checkpoint.

---

## Context policy

- The drafter receives the brief and required claims.
- The editor receives the draft and style goals, not the drafter's entire ideation history.
- The fact-checker receives the near-final draft plus authoritative references.
- The human approver receives the final draft, material changes summary, and unresolved risks.
