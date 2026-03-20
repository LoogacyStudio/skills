# Topology Blueprint Template

Use this template to describe the provider-neutral architecture before any platform-specific implementation details are added.

---

## A. Recommendation Summary

- **Recommendation state:** `no-subagents` / `workflow-first` / `subagents-recommended` / `handoff-required` / `compound-agent-recommended`
- **Chosen topology:**
- **Why not single-agent:**

- **Why rejected alternatives are worse:**
  -

  -

## B. Assumptions

- **Current assumptions:**
  -

  -

- **Unconfirmed risks:**
  -

  -

- **Useful follow-up clarifications:**
  -

  -

## C. Topology Blueprint

- **Selected pattern(s):**
- **Control flow:**
- **Sequential stages:**
  1.
  2.
  3.

- **Parallel branches:**
  -

  -
- **Fan-in / merge rule:**
- **Escalation or handoff rules:**
- **Human approval gates:**
- **Fallback path if topology underperforms:**

## D. Subagent Specs

Repeat `assets/subagent-spec-template.md` for each subagent.

## E. Shared State / Memory Plan

- **Shared fully:**
  -

- **Shared as summary only:**
  -

- **Do not share:**
  -

- **Durable memory needed:**
- **Ephemeral task state needed:**
- **Canonical state owner:**
- **Parallel write conflict handling:**

## F. Orchestration Contract

- **Coordinator present:**
- **Agent-as-tool roles:**
- **Handoff targets:**
- **Workflow nodes:**
- **Critic / reviewer roles:**
- **Remote specialist candidates:**
- **Compound agent worth building:**

## G. Evaluation Checklist

- [ ] Recommendation state matches task shape
- [ ] Role boundaries are crisp
- [ ] Context is minimized deliberately
- [ ] Tool permissions are minimized
- [ ] Parallel branches are merge-safe
- [ ] Handoff ownership is explicit
- [ ] Critic loops have stop conditions
- [ ] Human gates exist where needed
- [ ] Portability is preserved

## H. Provider Overlays

Append provider notes using `assets/provider-overlay-template.md`.
If both Microsoft Agent Framework concepts and VS Code / GitHub Copilot runtime details are relevant, keep them in separate subsections.
