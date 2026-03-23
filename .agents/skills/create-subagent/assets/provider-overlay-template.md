# Provider Overlay Template

Use this template **after** the provider-neutral topology is complete.
Do not let overlay details rewrite the core architecture.

---

## Anthropic / Claude Code

- **Role mapping:**
- **How subagent descriptions affect delegation quality:**
- **Claude Code implementation notes:**
  - map persistent specialists to `.claude/agents/*.md` or `~/.claude/agents/*.md` depending on whether they are project-scoped or user-scoped
  - use strong, trigger-oriented `description` text because Claude uses it for automatic delegation
  - use `tools` and `disallowedTools` for capability boundaries
  - use `Agent(worker-a, worker-b)` in the coordinator's `tools` only when the main thread should spawn a restricted worker set
  - remember that subagents cannot spawn other subagents
  - preload reusable knowledge with the `skills` field because subagents do not inherit parent-loaded skills
  - use `memory`, `permissionMode`, `background`, `effort`, and `isolation` when the runtime behavior should be enforced, not just suggested
- **Tools / permissions separation approach:**
- **Skill preload strategy:**
- **Local vs user-level subagent packaging notes:**
- **Background / foreground behavior notes:**
  - foreground subagents can pass clarifying questions and permission prompts through to the user
  - background subagents run concurrently but need approvals up front and auto-deny anything not pre-approved
- **Context / resume notes:**
  - each invocation starts fresh unless Claude resumes an existing subagent
  - resumed subagents keep their own history and transcript, separate from the main conversation
- **Traceability / review notes:**
- **Provider-specific cautions:**

## OpenAI Agents

- **Role mapping:**
- **Where to use handoff vs tool calling:**
- **Specialized agent delegation notes:**
- **Traceability and orchestration notes:**
- **Provider-specific cautions:**

## Microsoft Agent Framework

- **Role mapping:**
- **Sequential / concurrent / handoff / group chat / magentic pattern mapping:**
- **Workflow-as-agent abstraction notes:**
- **Traceability / approval notes:**
- **Provider-specific cautions:**

## VS Code / GitHub Copilot

- **Role mapping:**
- **VS Code / GitHub Copilot custom-agent implementation notes:**
  - map reusable roles to `.agent.md` files when persistent personas, tools, model preferences, or handoffs are needed
  - use `tools` for least-privilege tool scope
  - use `agents` to whitelist which subagents a coordinator may invoke
  - use `user-invocable: false` for internal-only worker agents
  - use `disable-model-invocation: true` for agents that must not be used as subagents by default
  - remember that custom agents used as subagents can override inherited model, tools, and instructions
  - note that prompt file `tools` can take precedence over a custom agent's tool list
- **VS Code subagent runtime behavior notes:**
  - subagents run in isolated context windows
  - they typically receive only the delegated task prompt
  - the main agent usually receives only the final result or summary back
  - subagents can be executed synchronously or in parallel
  - expanded subagent tool calls are visible in chat for traceability
- **Traceability / approval notes:**
- **Provider-specific cautions:**

## LangChain / Deep Agents

- **Role mapping:**
- **Context quarantine approach:**
- **Progressive disclosure approach:**
- **When this task should stay single-agent instead:**
- **Provider-specific cautions:**

---

## Overlay rules

- keep the core topology unchanged
- adapt terminology only where the platform requires it
- note any platform mismatch explicitly
- avoid turning platform syntax into architecture rationale
