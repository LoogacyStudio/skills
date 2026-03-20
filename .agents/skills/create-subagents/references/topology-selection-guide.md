# Topology Selection Guide

Use this guide to decide **whether subagents are needed**, then choose the smallest collaboration pattern that fits.

A good topology is not the one with the most roles.
It is the one that removes the most risk with the least orchestration cost.

---

## Part 1: First decide whether you need subagents at all

Choose one primary recommendation state.

### `no-subagents`

Choose this when most of the following are true:

- the task is short
- the task is single-stage or nearly so
- one specialist can handle it cleanly
- intermediate work will not flood context
- there is no need for tool or permission isolation
- there is no critic, reviewer, or approval chain
- parallelism would not materially reduce time or risk

Typical answer shape:

- one capable agent
- one clear workflow
- reusable skills if needed
- no formal subagent package

### `workflow-first`

Choose this when the main problem is **control flow**, not role specialization.

Signals:

- phases are sequential and predictable
- one agent can execute each phase with different reusable skills
- what matters is ordering, approval, or guardrails
- context can remain in one place safely

Typical answer shape:

- one agent
- explicit pipeline stages
- optional human approval gate
- no formal specialist subagents

This is especially strong in VS Code / Copilot when the work benefits from one persistent conversation and the intermediate steps do not justify separate isolated context windows.

### `subagents-recommended`

Choose this when specialization and isolation create real value.

Signals:

- work splits into different kinds of expertise
- some subtasks produce lots of noisy intermediate output
- context quarantine would reduce confusion
- different phases want different tools or model tiers
- specialist reuse is likely in future tasks

### `handoff-required`

Choose this when ownership should formally transfer.

Signals:

- one specialist should take over end-to-end after a boundary
- upstream coordination should stop once the handoff happens
- downstream work needs a distinct trust boundary or persistent autonomy

### `compound-agent-recommended`

Choose this when a multi-step internal workflow should be packaged as one reusable higher-level unit.

Signals:

- the same pattern recurs often
- callers should not need to manage each internal role manually
- the internal topology is stable enough to encapsulate

---

## Part 2: Topology patterns

Select one or more of these patterns after the primary recommendation state is chosen.

### 1. Sequential Pipeline

Use when:

- work moves through clear ordered stages
- later steps depend on earlier outputs
- control flow matters more than concurrency

Best for:

- plan -> implement -> review -> test
- research -> synthesize -> publish
- intake -> draft -> approve

Avoid when:

- stages are weakly dependent and could run in parallel
- you are adding stages only for appearances

### 2. Parallel Fan-out / Fan-in

Use when:

- subtasks are independent
- workers can run simultaneously
- outputs merge cleanly

Best for:

- multi-source research
- parallel code impact scans
- parallel document section drafting

Avoid when:

- workers write the same shared state
- the merge step is vague or expensive
- outputs are highly interdependent
- the platform only returns summarized worker output and the merge step depends on raw worker scratch context

### 3. Coordinator / Dispatcher

Use when:

- one controller should assign tasks to specialists
- routing decisions depend on task shape
- execution branches are dynamic

Best for:

- mixed request queues
- classification and dispatch systems
- reusable orchestration hubs

Avoid when:

- the flow is fixed and simple
- a sequential pipeline already covers the need

### 4. Hierarchical Decomposition

Use when:

- the task can be decomposed recursively
- one planner must break work into nested subproblems
- child tasks need scoped autonomy

Best for:

- large implementation plans
- system-wide refactors
- complex investigations with branches

Avoid when:

- decomposition overhead exceeds task value
- the task only has two or three simple phases

### 5. Generator / Critic Loop

Use when:

- output quality matters enough to justify a review cycle
- review criteria are explicit
- iteration limits can be enforced

Best for:

- design documents
- code patches requiring review feedback
- editorial or compliance-sensitive content

Required controls:

- maximum iteration count
- clear acceptance criteria
- clear escalation path if the critic rejects repeatedly

Avoid when:

- feedback is subjective but unspecified
- there is no owner for final acceptance

### 6. Handoff

Use when:

- one role should fully take ownership after transfer
- the prior coordinator should stop micromanaging
- state transfer can be explicit and bounded

Best for:

- escalation from generalist to specialist
- trust-boundary transitions
- long-running specialist execution

Avoid when:

- the upstream agent still wants tight control
- a simple tool-style delegation would do

In VS Code / Copilot, distinguish carefully between:

- **subagent delegation**, where the main agent waits and then continues, and
- **session handoff**, where the user or workflow transitions into another agent/session with carried context.

They are not the same control primitive.

### 7. Human-in-the-loop

Use when:

- policy, safety, or business approval is required
- subjective judgment must remain with a human
- irreversible or high-risk actions are involved

Best for:

- final publishing decisions
- production deployment gates
- legal, brand, or product approval

Avoid when:

- the gate adds no real decision value
- the approval criteria are undefined

### 8. Workflow-as-Agent / Compound Agent

Use when:

- a stable internal topology should be exposed as one reusable entry point
- callers should not manage internal steps directly
- portability and repeatability matter

Best for:

- standardized code review flows
- standardized design review flows
- repeated research pipelines

Avoid when:

- the internal process is still volatile
- consumers actually need direct role-level control

---

## Part 3: Quick selector by symptom

- **The task is just long but still one specialty**
  - Usually prefer: `workflow-first` or Sequential Pipeline
  - Why: sequencing helps more than specialization

- **Research can split into independent threads**
  - Usually prefer: Parallel Fan-out / Fan-in
  - Why: speed and context isolation

- **Draft quality needs review and revision**
  - Usually prefer: Generator / Critic Loop
  - Why: explicit quality loop

- **One role must fully take over after escalation**
  - Usually prefer: Handoff
  - Why: ownership transfer is real

- **Different tools and permissions are required**
  - Usually prefer: `subagents-recommended` + Coordinator or Pipeline
  - Why: boundary and safety reasons

- **A stable internal multi-step system will be reused often**
  - Usually prefer: Compound Agent
  - Why: encapsulation value

---

## Part 4: Rejection discipline

When choosing a topology, explicitly reject at least one alternative.

Examples:

- Reject Parallel because workers would contend for the same mutable state.
- Reject Handoff because the coordinator still needs fine-grained control.
- Reject Compound Agent because the workflow is still changing too quickly.
- Reject Hierarchical Decomposition because the task only has a shallow split.

If you cannot explain why alternatives are worse, your topology choice is probably under-justified.

---

## Part 5: Final rule

Choose the topology that minimizes:

- unnecessary roles
- context duplication
- permission exposure
- merge complexity
- undefined ownership
- portability loss

If two options are both viable, prefer the simpler one.
