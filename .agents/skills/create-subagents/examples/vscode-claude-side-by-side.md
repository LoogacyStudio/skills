# VS Code / Claude Code Side-by-Side Example

This example shows how to take **one provider-neutral topology blueprint** and map it into:

- **VS Code / GitHub Copilot custom agents**
- **Claude Code subagents**

The goal is not to prove the platforms are identical.
The goal is to show how the **same architecture intent** can survive translation across runtimes.

---

## Scenario

A feature request needs:

1. planning
2. implementation
3. review
4. focused testing

The task is moderately complex, touches multiple files, and benefits from tool separation:

- planning and review should be read-only
- implementation needs edit tools
- testing needs terminal access and validation focus

---

## Provider-neutral blueprint

### Recommendation state

- `subagents-recommended`

### Chosen topology

- Sequential Pipeline
- Coordinator / Worker
- Optional Generator / Critic Loop between implementer and reviewer

### Why not single-agent

- planning, implementation, review, and testing have meaningfully different tool and context needs
- review quality improves when the reviewer does not inherit the implementer's full scratch context
- testing can produce noisy output that is better summarized than streamed into the main planning context

### Roles

#### `planner`

- **Role:** workflow node
- **Purpose:** turn the request into scoped tasks and validation criteria
- **Tools:** read-only
- **Context rule:** broad requirement context allowed

#### `implementer`

- **Role:** agent-as-tool or handoff target
- **Purpose:** perform code changes and return a patch summary
- **Tools:** edit + read + validation tools as needed
- **Context rule:** receive only the plan slice relevant to the current task

#### `reviewer`

- **Role:** critic or reviewer
- **Purpose:** review the changed surface for correctness, maintainability, and spec fit
- **Tools:** read-only by default
- **Context rule:** see patch + rationale summary, not full implementation scratch history

#### `test-specialist`

- **Role:** agent-as-tool
- **Purpose:** run or design focused validation steps
- **Tools:** terminal + read tools
- **Context rule:** receive changed-surface summary and expected behavior

### Shared state rule

- plan and acceptance criteria are canonical shared artifacts
- implementation scratch notes are summary-only downstream
- reviewer findings return as structured feedback, not raw internal reasoning dump

---

## Mapping to VS Code / GitHub Copilot

### Best-fit runtime interpretation

Use **custom agents** when you want persistent personas with explicit tool lists and optional subagent whitelisting.
The coordinator can remain user-visible, while workers can be hidden as internal-only agents.

### Why this maps well

- VS Code subagents run in isolated context windows
- workers can override inherited model, tools, and instructions with `.agent.md` files
- `agents` lets the coordinator restrict which workers it may invoke
- `user-invocable: false` cleanly hides internal workers from the picker

### Coordinator example

```md
---
name: Feature Builder
description: Coordinate planning, implementation, review, and testing for medium-complexity feature work.
tools: ['agent', 'read', 'search', 'edit', 'terminal']
agents: ['Planner', 'Implementer', 'Reviewer', 'Test Specialist']
---

You are a feature-delivery coordinator.

For each request:
1. Use Planner to break the work into scoped tasks.
2. Use Implementer to complete the current task.
3. Use Reviewer to assess the result.
4. If issues are found, loop back to Implementer.
5. Use Test Specialist to validate the changed surface.
6. Return a concise summary with risks and follow-ups.
```

### Worker examples

#### `Planner.agent.md`

```md
---
name: Planner
user-invocable: false
tools: ['read', 'search']
---

Break feature requests into implementation tasks, constraints, and validation steps.
```

#### `Implementer.agent.md`

```md
---
name: Implementer
user-invocable: false
tools: ['read', 'search', 'edit', 'terminal']
model: ['Claude Haiku 4.5 (copilot)', 'GPT-5.4 (copilot)']
---

Implement the assigned task. Keep changes minimal, validate them, and return a concise execution summary.
```

#### `Reviewer.agent.md`

```md
---
name: Reviewer
user-invocable: false
tools: ['read', 'search']
---

Review changed code for correctness, maintainability, and spec fit. Return prioritized findings only.
```

#### `Test Specialist.agent.md`

```md
---
name: Test Specialist
user-invocable: false
tools: ['read', 'search', 'terminal']
---

Run or design focused validation for the changed surface. Report failures, gaps, and regression risks.
```

### VS Code-specific cautions

- if a prompt file also declares `tools`, that list can override the custom agent's tool set
- subagents usually return only the final result or summary, so the coordinator must request the right output shape explicitly
- if the workflow should move the user into another agent/session with explicit approval, use session handoff rather than ordinary subagent delegation

---

## Mapping to Claude Code

### Best-fit runtime interpretation

Use **project-scoped subagents in `.claude/agents/`** when the workflow is repository-specific and should be shared by the team.
Keep the main thread as the orchestrator, because Claude Code subagents cannot spawn other subagents themselves.

### Why this maps well

- each subagent gets its own system prompt and isolated context window
- `description` strongly influences automatic delegation
- `tools` and `disallowedTools` enforce capability boundaries
- `skills`, `memory`, `permissionMode`, `background`, and `isolation` can encode runtime behavior directly

### Coordinator example

```md
---
name: feature-builder
description: Coordinate planning, implementation, review, and testing for medium-complexity feature work.
tools: Agent(planner, implementer, reviewer, test-specialist), Read, Grep, Glob, Edit, Bash
model: inherit
---

You are a feature-delivery coordinator.

For each request:
1. Use planner to break down the task and define validation criteria.
2. Use implementer to make the code changes.
3. Use reviewer to critique the result.
4. If issues are found, loop back to implementer.
5. Use test-specialist to run or design focused validation.
6. Return a concise summary with risks and follow-ups.
```

### Worker examples

#### `.claude/agents/planner.md`

```md
---
name: planner
description: Break down feature requests into scoped implementation tasks and validation steps. Use proactively before code changes.
tools: Read, Grep, Glob
model: haiku
---

You are a planning specialist. Produce a task breakdown, constraints, and validation approach.
```

#### `.claude/agents/implementer.md`

```md
---
name: implementer
description: Implement assigned feature tasks and return a concise execution summary. Use when code changes are needed.
tools: Read, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: acceptEdits
isolation: worktree
---

You are an implementation specialist. Make the smallest viable change, validate it, and summarize what changed.
```

#### `.claude/agents/reviewer.md`

```md
---
name: reviewer
description: Review changed code for correctness, maintainability, and spec fit. Use immediately after implementation.
tools: Read, Grep, Glob, Bash
model: inherit
memory: project
---

You are a review specialist. Return prioritized findings and note what is already strong.
```

#### `.claude/agents/test-specialist.md`

```md
---
name: test-specialist
description: Run or design focused validation for changed code. Use when verifying features, fixes, or regressions.
tools: Read, Bash, Grep, Glob
background: false
maxTurns: 10
---

You are a testing specialist. Report failing checks, validation coverage, and regression risks.
```

### Claude-specific cautions

- subagents do not inherit parent-loaded skills, so preload them explicitly when needed
- if a worker should run concurrently, background mode is available, but it needs permissions approved up front and cannot ask clarifying questions interactively
- subagents cannot recursively spawn more subagents, so multi-step chaining must be controlled by the main conversation
- if you need long-lived multi-agent collaboration across parallel threads, consider agent teams rather than trying to fake nested subagents

---

## What stays the same across both platforms

These parts should remain stable if your architecture is healthy:

- the role boundaries
- the control flow
- the shared-state policy
- the reason for each tool boundary
- the reason the reviewer is separated from the implementer
- the stop condition for any review loop

If those drift wildly between platforms, the blueprint was probably too provider-shaped to begin with.

---

## What changes across platforms

These parts are expected to differ:

- file format and location
- allowlist syntax for subagent invocation
- model naming and selection syntax
- whether hidden/internal workers use `user-invocable: false` or file-scope conventions
- whether handoff is modeled as session transition, main-thread orchestration, or platform-native affordances
- background execution semantics and permission prompting behavior

---

## Takeaway

A good `create-subagents` output should let you say:

- "Here is the neutral architecture."
- "Here is how it maps into VS Code / Copilot custom agents."
- "Here is how it maps into Claude Code subagents."
- "Here is what changed because of runtime behavior, not because the topology itself changed."

That is the sweet spot: portable core, honest overlay, no magical thinking, and no ritual agent inflation.
