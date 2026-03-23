# Research Team Example

This example shows when **parallel research plus synthesis plus critique** is worth the overhead.

---

## Scenario

A lead agent must produce a market and technical landscape brief from multiple sources, then turn it into a decision memo.
The source space is broad, noisy, and easy to overload in one context window.

### Why not single-agent

A single agent could do it, but would accumulate too much noisy evidence gathering, making synthesis and critique weaker.
Parallel collection and context quarantine improve quality and speed.

### Recommended state

- `subagents-recommended`

### Recommended topology

- Coordinator / Dispatcher
- Parallel Fan-out / Fan-in
- Generator / Critic Loop

---

## Roles

### `research-coordinator`

- **Role:** coordinator
- **Purpose:** assign domains, collect findings, and own the final recommendation flow
- **Responsibilities:** scope research threads, distribute tasks, merge findings, trigger synthesis and critique
- **Non-goals:** perform all deep research personally, rewrite every source note
- **Trigger:** new research request with multiple independent dimensions
- **Outputs:** task map, merged evidence pack, final recommendation package

### `market-researcher`

- **Role:** agent-as-tool
- **Purpose:** gather competitive and market evidence
- **Responsibilities:** collect sources, summarize evidence, note uncertainty
- **Non-goals:** final recommendation, editorial polishing

### `technical-researcher`

- **Role:** agent-as-tool
- **Purpose:** gather technical feasibility and implementation evidence
- **Responsibilities:** collect technical risks, integration constraints, and feasibility signals
- **Non-goals:** own final business recommendation

### `synthesizer`

- **Role:** workflow node
- **Purpose:** combine parallel findings into a coherent draft memo
- **Responsibilities:** reconcile evidence, identify patterns, produce draft
- **Non-goals:** collect brand-new research unless a gap is explicit

### `critic`

- **Role:** critic
- **Purpose:** challenge unsupported claims, missing counter-evidence, and weak synthesis
- **Responsibilities:** review draft against evidence completeness and decision quality
- **Non-goals:** rewrite the full memo from scratch

---

## Context policy

- Researchers receive full scoped research questions and output contract, not each other's full scratch notes.
- The synthesizer receives summarized findings plus source references.
- The critic receives the synthesized draft, evidence summary, and review criteria, not raw scratch exploration unless needed.

---

## Why parallel + critic is appropriate here

Use **parallel** because the research domains are independent enough to gather concurrently.
Use **critic** because decision memos are vulnerable to shallow consensus and missing counter-evidence.

### Required controls

- researchers must not overwrite each other's notes directly
- one merge owner must curate the fan-in package
- critic loop should stop after at most 2 rounds
- unresolved disagreement should escalate to human review or coordinator judgment
