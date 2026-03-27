---
name: plan-design-grill
description: Use when a user wants a plan, proposal, architecture, rollout, or design stress-tested through relentless branch-by-branch questioning that exposes assumptions, resolves forks, and ends with a shared understanding of decisions, risks, and next steps.
---

# Plan/Design Grill

Use this skill when a user wants an agent to **grill a plan or design until the fuzzy parts become explicit**.

This skill is for pressure-testing a proposal through **targeted questions, branch resolution, trade-off exposure, and proof-oriented follow-up**.

It is not a generic brainstorming buddy, a one-pass architecture review, or a polite nod machine. Its job is to keep asking the next sharp question until the plan is either defensible, explicitly risky, or clearly incomplete.

## Purpose

This skill is used to:

- clarify what decision is actually being made
- surface hidden assumptions, branch points, and contradictions
- force explicit trade-offs, owners, sequencing, rollback, and validation thinking
- convert vague confidence into concrete decisions, open questions, and next proof steps
- produce a structured grill summary that another agent or teammate can act on

## Use this skill when

Invoke this skill for requests such as:

- stress-testing a feature plan, architecture proposal, rollout sequence, migration path, or system design
- challenging a design before implementation starts
- resolving branch decisions instead of collecting loose opinions
- pressure-testing whether a proposal is ready for approval or execution
- responding to a user who explicitly wants to be questioned hard

### Trigger examples

- "grill me on this design"
- "stress-test this migration plan"
- "keep questioning this proposal until the weak parts show up"
- "interview me until this architecture is solid"
- "poke holes in my rollout plan"

## Do not use this skill when

Do not use this skill when:

- the user mainly wants direct implementation, not interrogation
- the request is a quick review with no appetite for back-and-forth questioning
- the task is mainly to write a plan from scratch rather than pressure-test an existing or proposed one
- a narrower domain-specific review skill already fits and the user is not asking to be challenged interactively
- the conversation cannot support iterative questioning **and** a one-shot fallback summary would still be too weak to help

## Pattern

- Primary pattern: **Inversion**
- Secondary pattern: **Reviewer**, **Generator**

Why this fit is better than the alternatives:

- the skill must ask clarifying and adversarial questions before it can safely conclude anything
- the plan must be evaluated against explicit decision branches, not just admired or paraphrased
- the result benefits from a stable structured summary of what was resolved, what remains open, and what proof is still needed
- a full Pipeline would add ceremony without enough value, because the ordered flow can live directly in this file

## Decision branches this skill must push toward resolution

Every run must push toward resolution across these branches, even if some stay open:

1. **decision and objective**
2. **scope and exclusions**
3. **constraints and non-negotiables**
4. **alternatives and trade-offs**
5. **assumptions and supporting evidence**
6. **dependencies and sequencing**
7. **owners and coordination surface**
8. **failure modes and rollback**
9. **validation and exit criteria**
10. **remaining open branches**

If a branch stays unresolved, say so explicitly instead of pretending shared understanding exists.

## Inputs

Collect or infer these inputs when available:

- the plan or design summary in one or two sentences
- the decision the user is trying to make or defend
- the intended outcome and what success should look like
- current state versus proposed state
- constraints, non-negotiables, and deadlines if relevant
- stakeholders, owners, and affected systems
- known unknowns, risks, and areas the user already worries about
- evidence, experiments, benchmarks, or prior incidents already available

If the request is too vague to interrogate safely, start with `assets/intake-questionnaire.md` and gather only the highest-signal answers first.

## Workflow

Follow this sequence every time.

### 1. Frame the proposal in one sentence

State the plan or design under review in plain language.

Examples:

- migrating the game from one loading flow to another without breaking save compatibility
- introducing a scene coordinator to reduce signal sprawl
- rolling out a new editor tool workflow with minimal disruption

Do not start with generic critique. First make sure everyone is talking about the same proposal.

### 2. Identify the real decision

Ask what decision is actually on the table.

Examples:

- approve versus reject the current design
- choose between two implementation paths
- decide whether the plan is ready for execution or still needs proof
- determine which branch should happen first

If the user presents a blur of ideas, force it into a decision statement before moving on.

### 3. Interrogate the highest-signal branches first

Start with the branches most likely to change the decision:

- objective
- scope
- non-negotiables
- biggest assumption
- main risk

Rules:

- ask only **1 to 5** high-signal questions per round
- if the runtime supports batched interactive questioning, prefer that for the current branch
- otherwise ask the questions conversationally
- do not shotgun every possible question at once
- do not leave the critical branch just because another branch is more interesting

### 3A. Use a one-shot fallback when iteration is unavailable

If the runtime or task shape only allows one response, do **not** abandon the skill immediately.

Simulate one strong grilling round by:

1. restating the proposal and the real decision in plain language
2. identifying the **3 to 5** highest-risk unresolved branches
3. turning those branches into the next required questions
4. stating the provisional risks and assumptions that make those questions matter
5. returning the best next proof step or artifact needed before approval

In one-shot mode, be explicit that the result is a **pressure-test snapshot**, not full convergence.

### 4. Expand the decision tree branch by branch

Use `references/grill-dimensions.md` to choose the next line of pressure.

For each branch, push until you can state all of the following or explicitly mark them missing:

- the current choice
- why it is preferred right now
- which alternative was considered or rejected
- what evidence supports it
- what would overturn the decision

If a branch remains fuzzy, keep drilling there instead of skipping ahead.

### 5. Pressure-test assumptions, trade-offs, and failure paths

Challenge the proposal where confidence is cheapest to fake.

Ask questions such as:

- what breaks if this assumption is false?
- what is the cheapest experiment that could disprove this?
- what are we paying to get this benefit?
- who gets hurt first if this goes wrong?
- what is the rollback trigger?

The goal is not to win an argument. The goal is to make weak reasoning visible before reality does it for you.

### 6. Convert vague confidence into explicit commitments

A branch is only meaningfully resolved when you can restate it in one or two lines with:

- the decision
- the reason it currently holds
- the main risk or caveat
- the owner, next proof step, or follow-up condition

If you cannot restate the branch that clearly, it is not resolved yet.

### 7. Stop only when shared understanding is real

Shared understanding exists when:

- the current proposal is stated clearly
- the key branches are either resolved or openly unresolved
- the biggest assumptions and risks are named plainly
- the next action is obvious enough for someone else to continue

Shared understanding does **not** mean every issue is solved. It means the uncertainty is now explicit instead of hidden.

### 8. Return the grill summary

Return the result using `assets/grill-summary.md`.

The summary should separate:

- what is decided
- what is still open
- what assumptions are fragile
- what risks matter most
- what evidence or experiment should happen next

## Output contract

Return the result using `assets/grill-summary.md` in this section order:

- `Plan or design under review`
- `Shared objective`
- `Current proposal snapshot`
- `Resolved decisions`
- `Open branches`
- `Fragile assumptions`
- `Main risks and failure modes`
- `Validation or experiments needed`
- `Recommended next step`
- `Notes on shared understanding`

Output rules:

- separate resolved versus unresolved branches clearly
- quote contradictions or uncertainty plainly instead of smoothing them away
- prefer decision language over abstract commentary
- do not flatten open questions into fake certainty
- keep the summary concrete enough that another agent can continue the conversation or execution
- end with the best next action, not only criticism

## Interrogation stance

- Ask the next best question, not every possible question.
- Press on branches that change the decision, cost, risk, or sequence.
- If the user answers vaguely, tighten the question rather than accepting blur.
- If the plan is sound on one branch, move on instead of over-grilling it.
- Stop drilling a branch when the next question would no longer change the decision, cost, risk, or sequencing.
- If two consecutive answers add wording but not new decision information, summarize the branch and move on.
- If a branch depends on missing evidence, name the cheapest proof step.
- Be demanding without becoming hostile.

## Companion files

- `references/grill-dimensions.md` — branch map, probing questions, and signs that an answer is still weak
- `assets/intake-questionnaire.md` — first-pass questions for under-specified plans or designs
- `assets/grill-summary.md` — reusable structure for the final shared-understanding summary

## Validation

A good result should satisfy all of the following:

- the main decision is stated clearly
- the highest-signal branches are interrogated first
- resolved branches and open branches are separated explicitly
- assumptions are linked to evidence or explicit lack of evidence
- trade-offs and alternatives are surfaced
- failure, rollback, and validation thinking appear when relevant
- one-shot mode still returns a useful pressure-test snapshot when iteration is unavailable
- branch questioning stops once additional questions stop changing the decision quality
- the summary gives another agent enough context to continue intelligently
- the result does not mistake relentless questioning for random questioning

## Common pitfalls

- asking a giant unfocused questionnaire
- accepting words like "clean", "scalable", or "simple" without asking what they mean here
- confusing brainstorming with decision pressure-testing
- abandoning the skill entirely just because only one-shot interaction is available
- moving to new branches before the critical one is resolved
- over-grilling a branch after it has stopped producing new decision information
- summarizing open risk as if it were settled
- playing gotcha instead of improving clarity

## Completion rule

This skill is complete when the agent has:

- identified the real decision under review
- questioned the plan branch by branch until the major forks are resolved or explicitly left open
- surfaced the main assumptions, trade-offs, risks, and proof needs
- returned a structured grill summary with shared understanding of what is decided, what is not, and what should happen next
