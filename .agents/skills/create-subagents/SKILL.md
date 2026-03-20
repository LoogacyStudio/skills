---
name: create-subagents
description: Use when an agent must decide whether a task should stay single-agent or be compiled into a reusable multi-agent topology with explicit subagent roles, context boundaries, orchestration contracts, and provider-specific implementation overlays.
---

# Create Subagents

Compile an agent task into the **right collaboration topology**, not into a pre-baked pile of agent files.

This skill is for designing **subagent / workflow / handoff architectures** that are explainable, bounded, portable, and implementable.
Its job is to decide whether subagents are warranted at all, then specify the smallest viable structure that preserves clarity, context hygiene, tool safety, and validation.

This skill is **not** a blind subagent generator.
It should be comfortable returning **do not create subagents** when that is the better design.

---

## Design Intent

This skill must apply these product principles every time:

### 1. Pattern-first, not file-first

Decide the collaboration pattern before proposing any subagent structure.
Do not assume a fixed number of roles.

### 2. Context-first, not prompt-first

Define context boundaries, handoff payloads, memory scope, tool scope, and isolation rules before writing role descriptions.

### 3. Skill / Subagent / Workflow separation

Treat these as separate layers:

- **Skill** = reusable method, workflow, knowledge, templates, references
- **Subagent** = role-specialized execution unit
- **Workflow / Orchestration** = control flow and collaboration logic

Do not stuff all reusable knowledge into subagent prompts.
If guidance is stable and reusable, put it into skills or references.

### 4. Portable core + provider overlays

Produce a provider-neutral architecture first.
Add Anthropic / OpenAI / Microsoft / LangChain guidance as overlays, not as the core design itself.

When a target runtime has concrete delegation behavior, keep the **core reasoning neutral** and push the runtime specifics into overlays and runtime notes.

At minimum, the overlay layer should explain:

- what context a subagent actually receives
- what comes back to the coordinator
- how tools, permissions, and model selection are enforced
- whether skills or memory are inherited or must be preloaded explicitly
- whether workers can spawn other workers
- what execution modes or handoff affordances the runtime supports

### 5. Build less agents

If a single agent plus reusable skills plus a clear workflow is enough, say so explicitly.
Subagents are a cost center unless they reduce real risk.

---

## Purpose

Use this skill to:

- analyze a task and decide whether subagents are justified
- choose the right orchestration or topology pattern
- define subagent roles, boundaries, and validation contracts
- separate reusable skills from role-specific instructions
- design context, memory, tool, and permission boundaries before implementation
- produce a reusable topology blueprint that can be translated into platform-specific agent configurations
- map the neutral design into concrete runtime-specific agent settings when the target platform is VS Code / GitHub Copilot, Claude Code, or another supported runtime

---

## When to Use

Use this skill when:

- the task is long enough that the main agent context may bloat
- the work naturally splits into different specialist roles
- some subtasks can run in parallel and later merge cleanly
- the flow needs generator / critic or reviewer iterations
- different roles should have different tools, permissions, or model tiers
- one phase should be a formal handoff to a specialist
- a stable workflow may be worth packaging as a compound agent
- the design should remain portable across multiple agent platforms

### Trigger examples

- "Should this workflow use subagents or stay single-agent?"
- "Design a multi-agent topology for this coding workflow"
- "Break this task into planner / implementer / reviewer safely"
- "We need handoff, reviewer loops, and tool isolation"
- "Create a subagent architecture that can later move across providers"

## When Not to Use

Do not use this skill when:

- the task is short, single-step, and handled by one specialist cleanly
- the user already has a validated subagent architecture and only needs file syntax changes
- the request is only to edit one existing agent file without architectural redesign
- the problem is a narrow code bug with no orchestration or role-boundary question
- the task can be handled with a simple workflow and one agent without material context or permission risk

---

## Inputs

Extract or infer these inputs from the request. If some are missing, proceed with explicit assumptions instead of blocking immediately.

| Input | Required | Description |
|---|---|---|
| Task goal | Yes | What the overall agent system must achieve |
| Output type | Yes | Code, document, research, analysis, workflow, PM artifact, QA artifact, or mixed output |
| Task stages | Recommended | Whether the work is single-stage or multi-stage |
| Domain spread | Recommended | Whether the work spans one or multiple specialties |
| Parallelism potential | Recommended | Whether subtasks are independent enough to fan out |
| Review or approval needs | Recommended | Critic loops, reviewer gates, or human approval requirements |
| Tool and permission boundaries | Recommended | Whether some work needs different tools, isolation, or risk limits |
| Specialist durability | Recommended | Whether a long-running or reusable specialist should exist |
| Portability target | Recommended | Whether the design must remain provider-neutral or framework-portable |
| Known constraints | Recommended | Cost, speed, model tier, trust boundaries, traceability, or sandbox rules |

---

## Operating Mode

Primary pattern:

- **Pipeline**

Secondary pattern(s):

- **Generator**
- **Reviewer**
- **Tool Wrapper**

Why this structure:

- this skill must enforce a real design sequence rather than jump directly to role drafting
- it must generate a structured architecture package
- it must validate overlap, context hygiene, and orchestration risks before returning
- it must package reusable guidance for topology selection, context boundaries, and anti-pattern avoidance

This skill can absorb ambiguity through explicit assumptions.
It does **not** require a full Inversion-first stop unless the missing information makes any topology recommendation unsafe.

---

## Decision Rules

Always apply these rules before proposing subagents.

### Prefer `no-subagents` when multiple conditions hold

- the task is short
- the task is single-step or nearly so
- one specialist can do it cleanly
- there is no context pollution risk
- there is no meaningful tool or permission isolation need
- there is no review loop or approval chain
- parallelism adds little benefit

### Prefer `subagents-recommended` when multiple conditions hold

- work splits into distinct specialist roles
- one or more phases produce lots of intermediate noise
- context quarantine would reduce confusion
- some phases can use cheaper or faster models safely
- different phases need different tools or permissions
- reusable specialists would be valuable later

### Prefer `workflow-first` when

- the main problem is sequencing or gating, not role specialization
- one capable agent can execute the phases safely
- reusable skills already provide the specialization

### Prefer `handoff-required` when

- ownership must fully transfer to a specialist after a boundary
- the upstream agent should stop controlling implementation details
- downstream work needs persistent autonomy or a distinct trust boundary

Otherwise prefer **agent-as-tool** over handoff.

### Prefer `compound-agent-recommended` when

- the workflow is stable, repeatable, and worth packaging behind one entry point
- the internal roles are useful repeatedly but should stay hidden behind a cleaner interface

### Add `Generator / Critic Loop` only when

- output quality requires draft-and-review iteration
- there is a clear critic role or review standard
- there is a maximum loop count and an exit condition

### Add `Parallel Fan-out / Fan-in` only when

- subtasks are independent
- workers can operate concurrently
- outputs can be merged without fragile shared state collisions

---

## Workflow

Follow this sequence every time.

### Step 1: Read the task as a topology problem

Normalize the request into:

- task goal
- output type
- complexity level
- number of stages
- number of specialties involved
- parallelism potential
- review or human approval needs
- tool / permission differences
- need for durable specialist roles
- portability expectations

If details are missing, record assumptions explicitly.
Do not stop unless the ambiguity makes the design unsafe or meaningless.

### Step 2: Decide whether subagents are justified

Return one primary decision state:

- `no-subagents`
- `subagents-recommended`
- `workflow-first`
- `handoff-required`
- `compound-agent-recommended`

Explain:

- why a single agent is or is not sufficient
- what cost subagents would introduce
- what concrete risk or benefit justifies the choice

### Step 3: Select the topology

Choose one or more of these patterns:

- Sequential Pipeline
- Parallel Fan-out / Fan-in
- Coordinator / Dispatcher
- Hierarchical Decomposition
- Generator / Critic Loop
- Handoff
- Human-in-the-loop
- Workflow-as-Agent / Compound Agent

For each selected pattern, explain:

- why it fits the task
- why the main alternatives were rejected
- where control flow starts and ends

Use `references/topology-selection-guide.md` when choosing.

### Step 4: Design boundaries before roles

Before drafting subagents, define:

- full context that must pass through untouched
- context that should be summarized only
- context that must be quarantined or withheld
- memory scope and whether shared state is writable
- isolation requirements
- tool and permission boundaries
- ownership boundaries for any handoff

Use `references/context-boundary-checklist.md` and `references/handoff-vs-agent-tool.md`.

If the target runtime is platform-specific, explicitly account for:

- what the worker inherits versus what must be passed explicitly
- whether the coordinator receives full outputs or only summaries
- how runtime configuration enforces tools, permissions, model tier, memory, and isolation
- whether nested delegation is supported or forbidden

Use the runtime notes in `references/vscode-copilot-subagents-notes.md` and `references/claude-code-subagents-notes.md` for concrete platform behavior.

### Step 5: Define roles and orchestration contracts

For each subagent or workflow node, specify:

- name
- purpose
- responsibilities
- non-goals
- trigger conditions
- inputs
- outputs
- completion criteria
- allowed tools
- forbidden tools
- permission risk level
- model tier recommendation
- preload skills
- optional skills
- orchestration contract type
- runtime packaging notes when relevant, such as `.agent.md` fields, `.claude/agents/*.md` frontmatter, allowed worker sets, invocation visibility, or runtime-specific permission settings

Every role must have a crisp boundary.
No decorative roles.

### Step 6: Produce the architecture package

Return the package in this order:

1. Recommendation Summary
2. Assumptions
3. Topology Blueprint
4. Subagent Specs
5. Shared State / Memory Plan
6. Orchestration Contract
7. Evaluation Checklist
8. Provider Overlays

Use the templates under `assets/` when useful.

### Step 7: Validate the design

Check the design against at least these failure modes:

- role overlap
- missing ownership
- excessive context propagation
- unnecessary subagents
- undefined critic stopping conditions
- unsafe parallel write conflicts
- unclear handoff ownership
- missing human approval gates where required
- provider-specific details leaking into the core design

Use `references/evaluation-checklist.md` and `references/anti-patterns.md`.

### Step 8: Return the smallest viable recommendation

If the best answer is:

- no subagents -> return a workflow-first or single-agent design
- a limited topology -> return only the minimal necessary roles
- a portable blueprint -> keep provider details in overlays only

Do not inflate the architecture just to look sophisticated.

---

## Output Contract

Return a design package with these sections.

## A. Recommendation Summary

Include:

- whether subagents are recommended
- the recommended topology
- why not a single agent
- why the rejected topology options are worse here

## B. Assumptions

Include:

- current assumptions
- unconfirmed risks
- information worth clarifying later

## C. Topology Blueprint

Include:

- chosen pattern(s)
- control flow
- parallel vs sequential relationships
- escalation or handoff rules
- human approval gates

## D. Subagent Specs

For each subagent, use this shape:

### `<subagent-name>`

- Role:
- Purpose:
- Responsibilities:
- Non-goals:
- Trigger:
- Inputs:
- Outputs:
- Completion criteria:
- Allowed tools:
- Forbidden tools:
- Context in:
- Context out:
- Memory policy:
- Permissions:
- Model tier:
- Preloaded skills:
- Optional skills:
- Risks:

## E. Shared State / Memory Plan

Include:

- what is shared fully
- what is shared as summary only
- what must not be shared
- whether durable memory is needed
- whether ephemeral task state is enough

## F. Orchestration Contract

Include:

- which roles are agent-as-tool
- which are handoff targets
- which are workflow nodes
- which are critics or reviewers
- whether a coordinator exists
- whether a compound agent is worth building

## G. Evaluation Checklist

Check:

- architecture fit
- context hygiene
- role clarity
- permission minimization
- failure handling
- portability
- testability

## H. Provider Overlays

Provide appendices for:

- Anthropic / Claude Code
- OpenAI Agents
- Microsoft Agent Framework
- VS Code / GitHub Copilot
- LangChain / Deep Agents

These overlays must adapt the same core design.
They must not redefine the topology itself.

For Microsoft ecosystems, keep the **Microsoft Agent Framework abstraction layer** separate from the **VS Code / GitHub Copilot runtime layer** when both are relevant. The former maps orchestration concepts; the latter explains how those concepts are actually enforced in editor-facing custom-agent and subagent configurations.

---

## Companion Files

Use these supporting files when present:

### References

- `references/topology-selection-guide.md` - choose decision state and topology pattern with trade-offs
- `references/context-boundary-checklist.md` - define context, memory, isolation, and summary rules
- `references/handoff-vs-agent-tool.md` - decide between tool-style delegation and ownership transfer
- `references/anti-patterns.md` - detect and avoid common multi-agent design failures
- `references/evaluation-checklist.md` - review whether the proposed topology is minimal, clear, and safe
- `references/claude-code-subagents-notes.md` - concrete Claude Code subagent behavior, file structure, delegation, tools, memory, and isolation controls
- `references/vscode-copilot-subagents-notes.md` - concrete VS Code / Copilot subagent behavior, file structure, and frontmatter controls for implementation overlays

### Assets

- `assets/subagent-spec-template.md` - reusable spec scaffold for each subagent
- `assets/topology-blueprint-template.md` - reusable structure for topology selection and control flow
- `assets/provider-overlay-template.md` - overlay template for provider-specific implementation notes
- `assets/orchestration-contract-template.md` - reusable contract scaffold for orchestration semantics

### Examples

- `examples/research-team-example.md` - shows coordinator + parallel researchers + critic loop
- `examples/coding-team-example.md` - shows planner / implementer / reviewer / test-specialist boundaries
- `examples/design-review-example.md` - shows drafter / editor / fact-checker with human approval gate
- `examples/workflow-first-example.md` - shows when a single agent plus reusable skills is better than subagents
- `examples/vscode-claude-side-by-side.md` - shows one neutral topology blueprint mapped side-by-side into VS Code / Copilot custom agents and Claude Code subagents

---

## Validation

A good result should satisfy all of the following:

- [ ] One primary recommendation state is chosen explicitly
- [ ] The chosen topology is justified against alternatives
- [ ] The design avoids creating unnecessary subagents
- [ ] Each role has clear responsibilities and non-goals
- [ ] Context-in, context-out, and memory rules are explicit
- [ ] Tool and permission boundaries are defined per role
- [ ] Handoff ownership is explicit when handoff is used
- [ ] Critic loops have a maximum iteration count and exit condition
- [ ] Parallel workers do not create unmanaged state conflicts
- [ ] Human approval gates are included when required by risk or quality
- [ ] Provider overlays remain an appendix layer, not the core logic
- [ ] The final package is implementable by a downstream agent

---

## Common Pitfalls

| Pitfall | Better Approach |
|---|---|
| Creating subagents because multi-agent sounds advanced | Start by proving why one agent is insufficient |
| Drafting role prompts before context and tool boundaries | Define context, memory, and permission policy first |
| Giving every subagent the full background dump | Split context into full, summary-only, and no-share buckets |
| Using handoff when simple delegation is enough | Reserve handoff for true ownership transfer |
| Adding a critic loop with no stop condition | Define max iterations and clear accept / reject criteria |
| Running parallel workers against shared writable state casually | Add merge rules, ownership, or isolate writes |
| Repeating common knowledge in every subagent prompt | Move stable guidance into reusable skills or references |
| Letting provider syntax dictate the architecture | Keep the core design neutral; add overlays afterward |
| Creating reviewer and critic roles with the same job | Merge or separate them with explicit boundary and trigger |
| Returning only file templates with no reasoning | Show decision basis, trade-offs, boundaries, and validation |

---

## Completion Rule

This skill is complete when the agent has:

- determined whether subagents are actually needed
- selected the smallest viable topology
- defined role, context, tool, permission, and memory boundaries
- specified orchestration semantics clearly enough to implement
- documented assumptions, risks, and fallback paths
- validated the design against overlap, context leakage, and orchestration failure modes
- returned a portable core design with provider overlays as appendices only
