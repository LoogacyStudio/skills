# Workflow-first Example

This example demonstrates a case where **subagents are not the right answer**.

---

## Scenario

An agent must produce a small implementation plan and then execute a modest code change with a quick validation pass.
The task has clear stages, but it stays within one specialty and does not need tool isolation, review loops, or specialist reuse.

### Recommended state

- `workflow-first`

### Why not subagents

- the work is still within one coherent skill set
- context volume is manageable
- additional role boundaries would add ceremony without reducing risk
- a simple ordered workflow is enough

### Recommended approach

Use one capable agent with a fixed pipeline such as:

1. clarify goal and assumptions
2. inspect relevant files
3. propose the minimal change
4. implement
5. validate
6. summarize risks and follow-ups

### Reusable skills still help

This is not anti-structure.
It simply means the specialization should live in **skills and workflow steps**, not in separate subagents.

Examples:

- load a testing skill during validation
- load a repo-specific architecture review skill if design questions arise
- use a reusable output template for the implementation summary

### VS Code / Copilot note

This is also a strong fit when a single local agent session in VS Code benefits from keeping the full conversational context together.
If isolated subagents would only bounce back short summaries while the main agent still needs all the detailed context, subagents are probably not buying enough.

### Claude Code note

This is also a strong fit in Claude Code when:

- the work needs frequent back-and-forth and iterative steering
- planning, implementation, and validation share a lot of context
- the latency cost of starting fresh subagents would outweigh the isolation benefit

In that case, reusable skills or a well-structured main conversation are a better fit than splitting into multiple isolated subagents.

---

## Takeaway

If the main problem is sequencing rather than specialization, prefer **workflow-first**.
Build fewer agents.
Your future self will send a thank-you card, or at least fewer annoyed log lines.
