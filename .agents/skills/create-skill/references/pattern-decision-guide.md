# Pattern Decision Guide

Use this guide to choose the right structure before creating or upgrading a skill.

A skill should not start from a blank template.
It should start from the pattern that best fits the job.

---

## Goal

Choose the simplest pattern that:

- matches the task shape,
- keeps instructions maintainable,
- avoids overloading `SKILL.md`,
- supports future extension without unnecessary complexity.

---

## The 5 Core Patterns

### 1. Tool Wrapper

Use when the skill mainly packages domain knowledge, rules, conventions, or operating guidance.

Best for:

- framework conventions
- repository standards
- coding rules
- deployment rules
- operational guidance

Signals:

- The skill mostly explains how to do something correctly
- Output shape is not the main concern
- Review is optional, not the core function

Typical files:

- `SKILL.md`
- `references/*.md`

Avoid when:

- the skill must generate a structured artifact every time
- the skill must ask discovery questions first
- the skill must enforce strict sequencing

---

### 2. Generator

Use when the skill produces a repeatable output from known inputs.

Best for:

- proposals
- specs
- reports
- changelogs
- issue templates
- migration plans

Signals:

- The output has a stable shape
- Templates or examples are useful
- Quality depends on structure and completeness

Typical files:

- `SKILL.md`
- `assets/template.*`
- optional `references/style-guide.md`

Avoid when:

- requirements are still unclear
- the task is mostly review or critique

---

### 3. Reviewer

Use when the skill evaluates content against a checklist or standard.

Best for:

- code review
- architecture review
- documentation review
- compliance review
- editorial review

Signals:

- The skill's primary job is to inspect, assess, or critique
- Review criteria should be reusable and swappable
- Findings should be structured and traceable

Typical files:

- `SKILL.md`
- `references/review-checklist.md`
- optional `assets/review-template.md`

Avoid when:

- the skill mainly creates content
- there are no clear review criteria

---

### 4. Inversion

Use when the skill should not produce output until it has gathered missing information.

Best for:

- requirement discovery
- ambiguous requests
- client intake
- project scoping
- decision support

Signals:

- The request is under-specified
- Assumptions are dangerous
- The skill should ask questions before generating

Typical files:

- `SKILL.md`
- `assets/intake-questionnaire.md`
- optional `assets/output-template.md`

Avoid when:

- the task already has enough input to proceed
- the skill would just ask obvious or redundant questions

---

### 5. Pipeline

Use when the skill must enforce stages, gates, or mandatory sequence.

Best for:

- generate -> review -> revise
- plan -> approve -> execute
- intake -> draft -> QA -> publish
- workflows with sign-off checkpoints

Signals:

- Order matters
- Some steps must not be skipped
- Quality depends on stage transitions

Typical files:

- `SKILL.md`
- `references/*.md`
- `assets/*.md`
- optional scripts where supported

Avoid when:

- the flow is actually simple
- stages add overhead without reducing risk

---

## Quick Chooser

Use this table first.

| If the skill mainly... | Start with |
|---|---|
| packages guidance, conventions, or know-how | Tool Wrapper |
| produces a structured artifact | Generator |
| evaluates something against standards | Reviewer |
| asks clarifying questions before acting | Inversion |
| enforces ordered stages or gates | Pipeline |

---

## Combination Guide

Many useful skills combine patterns.

### Inversion + Generator

Use when requirements must be clarified before output is produced.

Examples:

- spec writer
- proposal builder
- project intake skill

### Generator + Reviewer

Use when generated output must be checked before return.

Examples:

- code scaffold + validation
- design doc draft + quality review
- release note generator + editorial check

### Inversion + Generator + Reviewer

Use when the task is ambiguous, output is structured, and quality matters.

Examples:

- create a new reusable skill
- produce a project plan from incomplete requirements
- generate a policy doc from stakeholder input

### Pipeline + Any Pattern

Use when stages must be explicit.

Examples:

- intake -> generate -> review -> revise
- gather facts -> draft -> verify -> finalize

---

## Decision Questions

Ask these in order.

### Q1. Is the request clear enough to act on?

- Yes -> continue
- No -> start with **Inversion**

### Q2. Is the output expected to have a repeatable structure?

- Yes -> add **Generator**
- No -> continue

### Q3. Is the primary job to inspect or evaluate?

- Yes -> use **Reviewer**
- No -> continue

### Q4. Do steps need to happen in a fixed order?

- Yes -> wrap the flow in **Pipeline**
- No -> continue

### Q5. Is the skill mostly reusable guidance and conventions?

- Yes -> use **Tool Wrapper**
- No -> continue

---

## Recommended Defaults

When uncertain:

- ambiguous request -> **Inversion**
- stable output -> **Generator**
- quality gate required -> **Reviewer**
- ordered steps -> **Pipeline**
- guidance-heavy skill -> **Tool Wrapper**

Prefer the smallest useful combination.

---

## Decision Tree

### Start here

1. Is the task ambiguous?
   - Yes -> Inversion
   - No -> go to 2

2. Does the task produce a structured deliverable?
   - Yes -> Generator
   - No -> go to 3

3. Does the task mainly inspect or critique?
   - Yes -> Reviewer
   - No -> go to 4

4. Does the process require enforced stages?
   - Yes -> Pipeline
   - No -> go to 5

5. Is the skill mainly packaging knowledge or rules?
   - Yes -> Tool Wrapper
   - No -> choose the simplest fitting pattern and document assumptions

---

## Examples

### Example A: Framework coding conventions

Pattern:

- Primary: Tool Wrapper

Why:

- Main value is guidance, not generation

### Example B: Create release notes from commits

Pattern:

- Primary: Generator
- Secondary: Reviewer

Why:

- Output has a known shape
- Needs completeness and tone checks

### Example C: Build a new project proposal from vague stakeholder input

Pattern:

- Primary: Inversion
- Secondary: Generator

Why:

- Clarification is required before drafting

### Example D: Reusable architecture review skill

Pattern:

- Primary: Reviewer
- Secondary: Tool Wrapper

Why:

- Review is the job
- Rules and principles need references

### Example E: Skill creation meta-skill

Pattern:

- Primary: Inversion
- Secondary: Generator, Reviewer
- Optional wrapper: Pipeline

Why:

- Requirements are often incomplete
- Output is structured
- Quality must be verified before return

---

## Anti-Patterns

### Anti-pattern: starting with Pipeline by default

Problem:

- Adds overhead too early

Better:

- Start simple, add stages only when needed

### Anti-pattern: stuffing everything into `SKILL.md`

Problem:

- Hard to scan, hard to maintain

Better:

- Put bulky rules in `references/`
- Put reusable templates in `assets/`

### Anti-pattern: using Generator when requirements are still vague

Problem:

- Produces polished nonsense

Better:

- Use Inversion first

### Anti-pattern: hardcoding review criteria in prose

Problem:

- Review logic becomes hard to update

Better:

- Extract checklist to `references/review-checklist.md`

---

## Final Rule

Choose the pattern that minimizes:

- ambiguity,
- duplication,
- unnecessary steps,
- maintenance cost.

If two choices seem viable, prefer the simpler one.
