# Coding Team Example

This example shows a practical coding topology with planning, implementation, review, and targeted testing.

---

## Scenario

A coding agent must deliver a moderately complex feature across several files with implementation risk, regression risk, and a need for review before merge.

### Recommended state

- `subagents-recommended`

### Recommended topology

- Sequential Pipeline
- Optional Generator / Critic Loop

### VS Code / Copilot packaging hint

If this topology is implemented with custom agents in VS Code:

- the coordinator agent should include the `agent` tool and explicitly restrict `agents` to the approved worker set
- `planner`, `reviewer`, and `test-specialist` are good candidates for `user-invocable: false`
- the `implementer` can either stay hidden as an internal worker or remain user-invocable if developers sometimes want to run it directly
- read-only workers should not inherit edit tools accidentally; give them explicit tool lists

### Claude Code packaging hint

If this topology is implemented with Claude Code subagents:

- the coordinator should use `Agent(planner, implementer, reviewer, test-specialist)` only if the main thread must spawn a restricted worker set
- `planner` and `reviewer` should usually be read-only with explicit `tools` or a restrictive `disallowedTools` policy
- each worker needs a strong `description` field because Claude uses descriptions for automatic delegation
- if a worker needs reusable domain knowledge, list it under `skills`; Claude subagents do not inherit parent-loaded skills
- if implementation work should be isolated from the main checkout, consider `isolation: worktree` for the `implementer`

---

## Roles

### `planner`

- **Role:** workflow node
- **Purpose:** understand the requirement, map dependencies, and define a minimal execution plan
- **Responsibilities:** scope the work, identify impacted files, define validation steps
- **Non-goals:** write final code patches unless the task is trivial

### `implementer`

- **Role:** agent-as-tool or handoff target depending on ownership model
- **Purpose:** perform the code changes
- **Responsibilities:** edit files, run focused validation, report results and risks
- **Non-goals:** redefine scope mid-flight without escalation

### `reviewer`

- **Role:** critic or reviewer
- **Purpose:** inspect the patch for correctness, maintainability, and spec fit
- **Responsibilities:** review diffs, identify defects, call out missing cases
- **Non-goals:** become a second implementer by default

### `test-specialist`

- **Role:** agent-as-tool
- **Purpose:** execute or design verification steps with sharper testing focus
- **Responsibilities:** run tests, interpret failures, identify regression gaps
- **Non-goals:** broad architecture review unless requested

---

## When to avoid reviewer / critic overlap

Do not create both a `reviewer` and a `critic` if both would simply inspect the same patch for general quality.
That is role cloning.

Use one review role unless you can define a clear boundary such as:

- `reviewer` checks code quality and correctness
- `critic` checks spec fit or architectural consistency only

If that boundary is not crisp, merge the roles.

---

## Context policy

- The planner can see broader requirement context.
- The implementer gets exact file targets, acceptance criteria, and tool permissions.
- The reviewer gets the patch, rationale summary, and acceptance criteria, not the implementer's entire scratch process.
- The test-specialist gets the changed-surface summary, intended behavior, and test entry points.

---

## Variant guidance

Use **handoff** from planner to implementer only if the implementer should own the execution phase end-to-end.
Otherwise keep implementer as **agent-as-tool** under the planner or coordinator.

In VS Code / Copilot terms, a coordinator-triggered subagent run is different from a user-visible session handoff between agents.
Use session handoff when the workflow should move the user into the next agent with carried context and explicit approval.

In Claude Code terms, keep in mind that subagents cannot spawn further subagents.
If you want planner -> reviewer -> implementer chaining, the main conversation must orchestrate that chain.
