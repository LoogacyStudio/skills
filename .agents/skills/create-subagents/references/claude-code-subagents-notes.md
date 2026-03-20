# Claude Code Subagents Notes

Use this note when translating the neutral `create-subagents` blueprint into **Claude Code subagents**.

This file focuses on implementation behavior that should influence the Anthropic / Claude Code overlay without replacing the provider-neutral architecture.

---

## 1. Runtime behavior that matters

Official Claude Code subagents have these practical characteristics:

- each subagent runs in its own context window with its own system prompt
- Claude uses the subagent's `description` field to decide when to delegate automatically
- subagents return results to the main conversation rather than sharing a live context by default
- each new invocation starts fresh unless Claude resumes an existing subagent
- subagents cannot spawn other subagents

Implication:

- description quality is a routing mechanism, not just documentation
- nested topologies must be coordinated by the main conversation, or moved to agent teams if you need more persistent parallel coordination

---

## 2. File scope and precedence

Claude Code subagents can be defined in multiple places, with priority from highest to lowest:

1. `--agents` CLI flag for the current session
2. `.claude/agents/` for the current project
3. `~/.claude/agents/` for the current user
4. plugin `agents/` directories

Implication:

- project-specific specialists should usually live in `.claude/agents/`
- reusable personal specialists belong in `~/.claude/agents/`
- duplicated names are resolved by precedence, so naming collisions should be intentional

---

## 3. Frontmatter fields that matter most

Commonly important fields include:

- `name`
- `description`
- `tools`
- `disallowedTools`
- `model`
- `permissionMode`
- `skills`
- `memory`
- `background`
- `effort`
- `isolation`
- `mcpServers`
- `hooks`
- `maxTurns`

Implication:

- runtime controls are enforceable configuration, not just narrative prompt guidance

---

## 4. Tools and delegation control

By default, subagents inherit all tools from the main conversation if `tools` is omitted.
You can tighten capability boundaries with:

- `tools` as an allowlist
- `disallowedTools` as a denylist

For a main-thread coordinator running with `claude --agent`, the `Agent(...)` tool syntax can restrict which subagents it may spawn.
Examples:

- `Agent` allows any subagent
- `Agent(worker, researcher)` allowlists only those subagents

Important constraint:

- subagents themselves cannot spawn other subagents, so `Agent(...)` controls matter only for the main thread

---

## 5. Skills and memory

Claude Code subagents **do not inherit skills from the parent conversation**.
If a worker needs reusable knowledge, list it explicitly in the subagent's `skills` field.

The `skills` field injects the full skill content into the subagent's context at startup.

Persistent memory can be enabled with:

- `memory: user`
- `memory: project`
- `memory: local`

Notes:

- `project` is usually the best default for project-specific reusable specialists
- enabling memory auto-enables the file tools the subagent needs to manage its memory files
- memory directories and `MEMORY.md` content become part of the runtime behavior

---

## 6. Foreground vs background

Claude Code subagents can run in two modes:

### Foreground

- blocks the main conversation until complete
- permission prompts and clarifying questions can pass through to the user

### Background

- runs concurrently while the main conversation continues
- requires permissions to be approved up front
- auto-denies anything not pre-approved
- clarifying-question tool calls fail rather than prompting interactively

Implication:

- background mode is useful for independent, long-running work
- if the task needs active clarification or incremental approval, prefer foreground execution

---

## 7. Isolation and safety

Use these controls when the runtime should enforce separation:

- `permissionMode` for approval behavior
- `isolation: worktree` when repository-level isolation matters
- `hooks` when tool usage should be validated conditionally
- inline `mcpServers` when a server should exist only in the subagent, not the parent context

Notable details:

- `bypassPermissions` is high risk and should be rare
- plugin-provided subagents do not support `hooks`, `mcpServers`, or `permissionMode`
- if you need those controls, move the agent into `.claude/agents/` or `~/.claude/agents/`

---

## 8. When Claude Code subagents are a strong fit

Prefer Claude Code subagents when:

- the task is self-contained and can return a summary
- the work produces verbose output that should not flood the main conversation
- tool restrictions or permission modes should be enforced per specialist
- a project or user-level specialist should be reused repeatedly
- parallel or chained subagents can reduce cognitive load without requiring shared live context

Prefer the main conversation when:

- the task needs frequent back-and-forth and iterative steering
- multiple phases share substantial context
- latency matters more than isolation
- the work is small and highly targeted

Consider skills instead when the reusable knowledge should stay in the main conversation context rather than move into isolated workers.

---

## 9. Good Claude-specific design cues

- write descriptions that say when to use the subagent, not just what it is
- assume every subagent must be able to succeed with only its own prompt, explicit skills, and tool config
- reserve background mode for work that can succeed without live clarification
- use worktree isolation when parallel edits or risky changes should not touch the main checkout directly
- treat `skills` as explicit preload, not inherited ambiance

---

## 10. Sources

Derived from current Claude Code documentation on custom subagents, tools, hooks, memory, and delegation behavior.
