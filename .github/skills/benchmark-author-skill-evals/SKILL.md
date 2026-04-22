---
name: benchmark-author-skill-evals
description: Use when a reusable agent skill needs a small, scoreable eval pack with explicit success criteria, trigger prompts, deterministic checks, rubric-based qualitative grading, and extension hooks for regressions, thrashing, or permission drift.
---

# Benchmark Author Skill Evals

Use this skill when a reusable agent skill needs a measurable eval loop instead of ad hoc manual smoke testing.

It covers **skill-eval pack authoring**. It does not execute the evals, judge benchmark evidence, or package the skill as a plugin.

For shared benchmark framework rules — capability registry, corpus discovery, corpus adapter contract, lifecycle boundaries, and run-record finalization conventions — defer to `benchmark-core`.

## Purpose

Use it to:

- turn a reusable skill into a small, scoreable eval pack
- define observable success criteria before polishing the skill wording
- cover both **should trigger** and **should not trigger** prompts
- specify deterministic checks over traces, commands, artifacts, ordering, and repo cleanliness
- add a structured qualitative rubric for conventions or style that deterministic checks cannot fully capture
- leave bounded extension hooks for token budget, build checks, runtime smoke, and permission regressions

## Use this skill when

Typical requests:

- creating the first eval loop for a new or revised skill
- turning repeated manual fixes into locked-in checks
- tightening a skill's trigger description with positive and negative controls
- defining how to capture JSONL traces and structured rubric output for a skill run
- drafting a small eval pack before scaling to CI or a larger benchmark corpus

### Trigger examples

- "Help me make this skill measurable"
- "Turn this skill into a small eval suite"
- "Add deterministic checks and a rubric for this skill"
- "Draft a prompt set to catch trigger regressions"

## Do not use this skill when

Do not use this skill when:

- the request is to write the skill itself from scratch with no eval focus
- the task is to execute the evals rather than author the pack
- the task is to judge an already executed benchmark run
- the request is to create or revise a benchmark item for the corpus rather than a skill eval loop
- the user only needs a tiny wording fix in an existing eval file with no structural change

## Pattern

- Primary pattern: **Generator**
- Secondary pattern: **Tool Wrapper**

Why this fit works:

- the main job is to produce a structured eval pack another runner can execute repeatedly
- it also packages repository-specific benchmark and skill-eval guidance without bloating the output into a full pipeline
- a Reviewer-only framing would underweight the need for a reusable artifact skeleton

## Inputs

Collect or infer these inputs when you can:

- skill name, description, and path
- what the skill is supposed to do and what it must avoid doing
- primary trigger phrases and adjacent prompts that should not trigger the skill
- definition of done for the skill output
- must-pass commands, file outputs, ordering constraints, or repo cleanliness expectations
- qualitative conventions that need rubric-based grading
- environment or permission assumptions
- known failure modes, regressions, or manual fixes already observed

If some inputs are missing, make the smallest safe assumptions and call them out explicitly instead of pretending the eval pack is already complete.

## Workflow

Use the same sequence each time.

### 1. Frame the eval objective and nondeterminism surface

State what this eval pack must reveal.

Examples:

- whether the skill triggers when it should and stays idle when it should not
- whether the skill follows the expected command and artifact sequence
- whether the resulting repository matches a small style or structure contract
- whether a recent wording change increased false positives or skipped required steps

Do not start from commands or file checks alone. Start from the behavior that must remain stable.

### 2. Define the success contract before refining the skill

Split success into a small set of measurable goals:

- **outcome goals** — task completed, artifact exists, app builds, repo stays clean
- **process goals** — skill invoked correctly, expected commands ran, steps happened in the right order
- **style goals** — output follows the conventions you care about
- **efficiency goals** — no obvious thrashing, prompt bloat, or unnecessary escalation

Keep this must-pass set small and explainable.

### 3. Build a small prompt set with both positive and negative controls

Start with a compact prompt table, typically `4-12` rows.

Include at least:

- one **explicit invocation** case that names the skill directly
- one **implicit invocation** case that relies on the description
- one **contextual invocation** case with realistic noise or domain context
- one **negative control** that should stay outside the skill boundary

Add rows from real misses, not from synthetic variety for its own sake.

### 4. Define deterministic checks first

Specify lightweight, debuggable checks over observable evidence such as:

- whether the skill triggered
- whether required commands ran
- whether expected files or directories exist
- whether key steps happened in the expected order
- whether `git status --porcelain` stays empty or matches an allow list

Prefer checks that fail with a clear explanation instead of a mysterious aggregate score.

### 5. Add a structured qualitative rubric where deterministic checks stop helping

When style, layout, or conventions matter, add a second pass that:

- inspects the resulting repository in read-only mode
- returns a structured JSON result
- uses a small set of check IDs and a pass threshold

Keep the rubric narrow. The goal is stable comparison, not literary criticism.

### 6. Define the runner and artifact contract

Specify what each eval run should capture:

- per-prompt trace artifacts
- per-prompt deterministic check results
- per-prompt rubric output when used
- one summary view that can be compared across revisions

If the pack assumes JSONL traces or structured grading output, say so explicitly.

### 7. Add extension hooks only where risk justifies them

Use optional hooks for:

- command-count or thrashing regressions
- token-budget regressions
- build validation
- runtime smoke checks
- sandbox or permission drift

Do not add every heavy check by default just to make the pack look serious.

### 8. Return the skill eval pack

Use `assets/skill-eval-pack-template.md` as the final output skeleton.

Keep the result small enough to run, clear enough to debug, and structured enough to grow over time.

## Output contract

Return the result using `assets/skill-eval-pack-template.md` in the same section order.

Output rules:

- keep the eval objective explicit
- keep trigger boundaries visible with both positive and negative controls
- keep deterministic checks tied to observable evidence
- keep qualitative grading structured and bounded
- keep artifact capture explicit enough for another runner to automate later
- keep slow or expensive follow-ups optional unless the risk clearly justifies them

## Companion files

- `assets/skill-eval-pack-template.md` — final skill-eval pack skeleton
- `references/source-docs.md` — canonical source roles for skill-eval authoring
- `../benchmark-core/references/benchmark-capability-registry.md` — stable capability naming for repo benchmark work
- `../benchmark-core/references/benchmark-skill-lifecycle.md` — shared handoff map for benchmark skills

## Validation

A good result should satisfy all of the following:

- the eval objective is explicit
- the prompt set includes both should-trigger and should-not-trigger coverage
- deterministic checks are observable and debuggable
- the qualitative rubric is narrow enough to score consistently
- artifact capture is defined clearly enough for later automation
- extension hooks are justified rather than decorative
- the pack grows from real failures or realistic boundaries, not random prompt churn

## Common pitfalls

- writing a broad benchmark campaign instead of a small skill eval pack
- testing only explicit invocation and forgetting implicit trigger behavior
- using only vibes or one final pass/fail verdict
- jumping to model-based grading before defining deterministic checks
- overfitting the prompt set to happy-path prompts
- turning optional heavy checks into mandatory default work for every skill

## Completion rule

This skill is complete when the agent has:

- framed the eval objective and stability risks
- defined a small success contract
- authored a prompt set with positive and negative controls
- specified deterministic checks and any bounded qualitative rubric
- defined artifact capture and optional extension hooks
- returned a reusable skill-eval pack ready for execution or later automation