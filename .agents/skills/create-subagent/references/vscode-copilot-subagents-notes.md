# VS Code / GitHub Copilot Subagents Notes

Use this note when translating the neutral `create-subagents` blueprint into **VS Code custom agents, prompt files, and subagent orchestration**.

This file is intentionally implementation-focused.
It should inform the Microsoft overlay without redefining the provider-neutral architecture.

---

## 1. Runtime behavior that matters

Official VS Code / Copilot subagents have these practical characteristics:

- each subagent runs in its own isolated context window
- the subagent does not automatically inherit the full conversation history or main-agent instructions
- the delegated task prompt is the key payload, so the coordinator must send a scoped task and expected output shape
- the main agent typically receives only the final result or summary back
- subagents can run synchronously or in parallel
- in chat, subagent runs appear as collapsible tool calls, and expanded view shows tool usage, prompt, and returned result

Implication:

- context design is not optional; it is enforced by the runtime model
- summary quality matters because the coordinator often sees only the returned result

---

## 2. Inheritance and override rules

By default, a subagent inherits the main chat session's active agent, model, and tools.
To override that behavior, use a custom agent.

Custom agents can define their own:

- instructions
- tools
- model
- handoffs
- subagent availability rules

Implication:

- if a worker needs distinct tools or a cheaper model tier, prefer a custom agent instead of relying on prompt wording alone

---

## 3. Custom agent packaging

In VS Code, persistent agent personas are usually packaged as `.agent.md` files.
Relevant frontmatter fields include:

- `name`
- `description`
- `tools`
- `agents`
- `model`
- `user-invocable`
- `disable-model-invocation`
- `handoffs`
- `target`

Useful controls:

- `user-invocable: false` hides internal workers from the picker while still allowing subagent use
- `disable-model-invocation: true` prevents general subagent invocation unless explicitly allowed
- `agents` whitelists which subagents a coordinator may use

If `agents` is specified, ensure the `agent` tool is also available.

---

## 4. Tool and prompt precedence

Custom agents define a tool list, but prompt files can also define `tools`.
When both are present, the prompt file tool list takes precedence.

Implication:

- do not assume the custom agent's tool restrictions are always the effective final tool list if prompt files participate in orchestration

---

## 5. Distinguish two different handoff ideas

### Subagent delegation

The coordinator calls a subagent, waits for the result, and continues in the same overall conversation flow.

### Agent/session handoff

The workflow transitions the user into another agent or session, often carrying context and optionally auto-sending a prompt.

Implication:

- do not confuse subagent invocation with agent handoff
- use agent/session handoff when the user should review and approve before moving into the next specialist context

---

## 6. Good VS Code patterns

### Coordinator + explicit worker allowlist

Use when you want predictable orchestration and role control.

Typical shape:

- coordinator has `tools: ['agent', ...]`
- coordinator limits `agents` to named workers
- workers get least-privilege `tools`
- internal workers are often `user-invocable: false`

### Multi-perspective review in parallel

Use when review perspectives should stay independent.

Typical shape:

- one coordinator or review orchestrator
- parallel subagents for correctness, security, architecture, or quality
- final synthesized report after all subagents complete

### Workflow-first single session

Use when one agent benefits from retaining the full detailed conversational context.

Typical shape:

- one local agent session
- reusable skills and prompt files
- no separate subagents unless isolation clearly helps

---

## 7. Common VS Code design mistakes

- creating subagents when one local agent session should simply keep the full working context
- forgetting that workers mostly receive only the delegated prompt, then expecting them to know upstream nuance automatically
- giving all workers edit-capable tools instead of least privilege
- failing to restrict `agents`, causing the coordinator to choose the wrong similarly named worker
- using session handoff and subagent invocation interchangeably in documentation or architecture diagrams

---

## 8. Decision cues

Prefer VS Code subagents when:

- isolated research or analysis would otherwise bloat the main context
- workers need different tools or model settings
- review perspectives should stay independent
- the coordinator benefits from receiving compressed findings only

Prefer one local agent session when:

- the same detailed context needs to stay visible throughout the task
- intermediate details are too important to collapse into summaries
- orchestration overhead would outweigh isolation benefits

---

## Sources

Derived from current VS Code documentation on:

- subagents
- custom agents
- agent concepts and sessions
