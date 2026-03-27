---
name: session-handoff
description: Use when work must continue in a fresh AI agent or later session and a continuation-ready handoff document is needed to preserve goals, decisions, evidence, and exact next steps without ambiguity.
---

# Session Handoff

Create a **continuation-ready handoff package** for a new AI agent or a later session.
The goal is not to write a nostalgic summary of the conversation. The goal is to make the next agent productive immediately, with clear scope, verified state, concrete evidence, and an exact place to resume.

This skill exists for moments when context is getting long, ownership is changing, or the current agent should stop and leave behind a precise trail instead of hoping the next session can reconstruct the story.

---

## What this skill solves

Long-running agent work often fails at the transition point, not because the work itself is impossible, but because the next agent inherits:

- partial context,
- missing decisions,
- vague "continue from here" notes,
- no trustworthy evidence trail,
- and no clear first move.

This skill converts messy session state into a structured handoff document that a fresh agent can use with minimal re-discovery.

---

## When to Use

Use this skill when:

- the current task will continue in a fresh AI session or a different agent
- the conversation is getting long enough that context loss is becoming a real risk
- the user asks for a handoff, resume brief, continuation pack, transfer note, or restart-safe summary
- work has already produced decisions, file changes, commands, tests, or artifacts that must be preserved accurately
- ownership is moving from one phase to another and the downstream agent should begin with explicit context rather than re-investigating everything

### Trigger phrases

Examples that should strongly suggest this skill:

- "create a handoff"
- "prepare this for the next agent"
- "I need to continue this later"
- "summarize so another agent can pick it up"
- "make a context-transfer document"
- "the session is getting too long"

## When Not to Use

Do not use this skill when:

- the task can simply be finished in the current session without meaningful context risk
- the user only wants a short status update rather than a continuation-ready document
- the work has not been investigated enough to describe current state honestly
- the real need is subagent delegation inside the same session rather than a session-to-session handoff

---

## Inputs

Extract or infer these inputs from the current work. Ask targeted follow-up questions only when a missing item would materially reduce handoff quality.

| Input | Required | Description |
|---|---|---|
| Task goal | Yes | The concrete outcome the next agent is expected to continue toward |
| Current status | Yes | What is done, in progress, blocked, or not started |
| Completed work | Yes | Changes made, findings gathered, and decisions already taken |
| Critical files and symbols | Yes | Files, components, commands, tests, or artifacts the next agent must inspect first |
| Evidence trail | Yes | Verification results, command outputs, errors, screenshots, links, or citations that support the state described |
| Open questions or blockers | Recommended | Risks, uncertainties, missing approvals, or unresolved failures |
| Constraints and preferences | Recommended | User instructions, repo rules, tool limits, style constraints, or environment facts that still matter |
| Recommended next step | Recommended | The exact first action the next agent should take |
| Suggested starter prompt | Optional | A ready-to-send kickoff prompt for the next agent |

---

## Operating Mode

Primary pattern:

- **Generator**

Secondary pattern(s):

- **Reviewer**
- **Inversion**

Why this structure:

- the core job is to generate a repeatable artifact: a handoff document
- zero-ambiguity handoff quality requires an explicit review pass before returning the result
- when crucial context is missing, the skill should ask only the highest-signal questions instead of silently guessing

---

## Workflow

Follow this sequence every time.

### Step 1: Confirm that a real handoff is needed

Decide whether the output should be:

- a **full session handoff** for a fresh agent,
- a **phase handoff** between workflow stages,
- or just a short status note.

If a lightweight status note is sufficient, do not overproduce a giant dossier.
If another agent must continue independently, produce the full handoff package.

Also distinguish two different ideas clearly:

- **subagent delegation** = the current coordinator still owns the task and continues after a worker returns
- **session handoff** = ownership or active working context moves forward to a new agent or later session

This skill is for the second case.

### Step 2: Gather continuation-critical context

Collect the smallest set of details that lets the next agent continue safely:

- target outcome
- current phase and status
- what has already been completed
- important decisions and why they were made
- files, symbols, branches, artifacts, URLs, or docs that matter
- commands run, tests executed, and their results
- blockers, risks, assumptions, and missing information
- the exact next recommended action

Use current workspace context, recent work, and verified evidence first.
Ask follow-up questions only if a missing detail would change the next agent's path materially.
Use `assets/session-handoff-template.md` as the structure baseline.

### Step 3: Separate facts from assumptions

Before drafting, classify information into three buckets:

- **Verified facts** - supported by files, commands, output, or explicit user statements
- **Inferred assumptions** - likely true, but not directly verified in the current session
- **Unknowns / gaps** - missing details the next agent should not treat as settled

Do not blur these categories.
A handoff that sounds confident but hides uncertainty is worse than a handoff that explicitly says what is still unknown.

### Step 4: Draft the handoff package

Produce a handoff document that is optimized for continuation, not narration.
It should help a new agent answer all of these quickly:

- What is the job?
- What already happened?
- What evidence supports that?
- What constraints still apply?
- Where should I look first?
- What should I do next?

At minimum, cover:

1. scope and objective
2. current status
3. completed work and key findings
4. decisions and constraints
5. important files, symbols, and artifacts
6. evidence and verification
7. blockers, risks, and unknowns
8. recommended next steps
9. optional starter prompt for the next agent

Do not dump raw transcript fragments unless they are themselves important evidence.
Prefer compact, explicit bullets over vague prose.

### Step 5: Review for zero-ambiguity continuation

Review the draft using `references/handoff-quality-checklist.md`.
A fresh agent should be able to continue without asking basic recovery questions such as:

- "What was I supposed to build?"
- "Which files matter?"
- "Was anything already tested?"
- "What is blocked versus merely unfinished?"
- "Which parts are facts and which are guesses?"

If the draft fails those tests, tighten it before returning it.

### Step 6: Return the smallest handoff that is still complete

The best result is not the longest result.
Return the minimum document that still lets the next agent resume accurately and quickly.
If there are unresolved gaps, name them explicitly instead of padding the document with speculative filler.

---

## Output Contract

Return a handoff package with these sections.

## A. Handoff Type

Include:

- handoff type: full session handoff / phase handoff / lightweight status note
- intended next owner or next-agent context, if known
- one-sentence resume objective

## B. Current State

Include:

- overall task status
- what is completed
- what is in progress
- what is blocked or pending

## C. Work Already Done

Include:

- important findings
- code or content changes made
- decisions taken and why they matter

## D. Critical Context

Include:

- important files and symbols
- environment facts
- user instructions or repo constraints that still govern the work
- relevant links or artifacts

## E. Evidence and Verification

Include:

- commands run
- tests, builds, or checks performed
- results, failures, or warnings
- citations or paths that support the claims above

## F. Risks, Unknowns, and Blockers

Include:

- unresolved issues
- assumptions that still need validation
- missing information or approvals

## G. Recommended Next Actions

Include:

- the exact next step to take first
- follow-up sequence if more than one step is obvious
- any cautionary note for the next agent

## H. Suggested Starter Prompt

Provide a ready-to-use prompt for the next agent when helpful.
It should reference the handoff artifact, the resume objective, and the first action to take.

Output requirements:

- clearly label verified facts, assumptions, and unknowns where relevant
- prefer concrete references to files, symbols, commands, outputs, and artifacts
- keep the handoff continuation-oriented rather than retrospective only
- avoid claims that are not supported by the current session evidence

---

## Validation

A good result should satisfy all of the following:

- [ ] The next agent can state the goal without reading the full old transcript
- [ ] Current status is explicit: done, in progress, blocked, and pending are separated clearly
- [ ] Important files, symbols, commands, and artifacts are named concretely
- [ ] Evidence is included for meaningful claims about implementation or verification
- [ ] Decisions and constraints are preserved, not implied
- [ ] Verified facts, assumptions, and unknowns are not mixed together carelessly
- [ ] The first next step is actionable and specific
- [ ] The handoff is concise enough to scan, but complete enough to resume work safely

---

## Common Pitfalls

| Pitfall | Better Approach |
|---|---|
| Writing a retrospective summary with no resume path | Write a forward-looking continuation package with exact next actions |
| Saying "continue from here" without naming files or symbols | Name the files, symbols, artifacts, and evidence the next agent should inspect first |
| Presenting guesses as settled facts | Label assumptions and unknowns explicitly |
| Omitting failed tests, blockers, or warnings | Preserve negative evidence so the next agent does not repeat dead ends |
| Dumping the entire transcript into the handoff | Distill only the continuation-critical context and keep raw details as citations or references |
| Creating a giant handoff for a tiny task | Match the handoff size to the real continuation risk |

---

## Companion Files

Use these supporting files when present:

- `references/handoff-quality-checklist.md` - review whether the handoff is continuation-ready, evidence-backed, and ambiguity-resistant
- `assets/session-handoff-template.md` - reusable scaffold for drafting the handoff document

---

## Completion Rule

This skill is complete when the agent has:

- determined that a real handoff artifact is warranted,
- gathered the continuation-critical context,
- drafted the handoff using a stable structure,
- reviewed it for ambiguity, evidence gaps, and missing next steps,
- and returned a compact document that a fresh agent can use immediately.
