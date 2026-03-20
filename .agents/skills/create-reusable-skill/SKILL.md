---
name: create-reusable-skill
description: Creates or upgrades reusable agent skills by selecting the right skill pattern, generating the minimum useful file structure, drafting SKILL.md, and validating the result before returning it. Use when building a new skill, refactoring a weak skill, or scaffolding companion references and assets.
---

# Create Skill

Create or upgrade a reusable skill by choosing the right structure first, then generating only the files that are justified.

This skill is not just a template generator.
It is a meta-skill for designing skills well.

It should:
1. clarify the requested capability,
2. choose the correct pattern,
3. design the minimum useful file structure,
4. draft the main `SKILL.md`,
5. generate companion files when needed,
6. review the result before returning it.

Prefer simple, composable skills over bloated all-in-one instructions.

---

## Core Principles

- Start with the pattern, not the template
- Prefer progressive disclosure over monolithic instructions
- Keep `SKILL.md` focused on operation and flow
- Put bulky or reusable guidance in `references/`
- Put templates, examples, and intake forms in `assets/`
- Use the smallest pattern combination that fits the task
- Do not overbuild a pipeline unless explicit stages reduce risk
- Do not generate polished output on top of unresolved ambiguity

---

## When to Use

Use this skill when:
- creating a new reusable skill from scratch
- upgrading an existing skill that is vague, bloated, or weakly structured
- converting a repeated workflow into a skill
- deciding whether a task should be a Tool Wrapper, Generator, Reviewer, Inversion flow, or Pipeline
- scaffolding companion files such as:
  - `references/pattern-decision-guide.md`
  - `references/skill-review-checklist.md`
  - `assets/skill-template.md`
  - `assets/review-template.md`
  - `assets/intake-questionnaire.md`

---

## When Not to Use

Do not use this skill when:
- making a tiny edit to an existing skill with no structural impact
- solving a one-off task that does not need to become reusable
- writing a custom agent persona instead of a reusable workflow skill
- the user only wants the final work product, not a reusable skill
- the task can be answered directly with no need for skill scaffolding

---

## Inputs

| Input | Required | Description |
|---|---|---|
| Skill goal | Yes | The repeatable capability the skill should provide |
| Trigger context | Recommended | When and why an agent should invoke the skill |
| Intended users/agents | Recommended | Who will use the skill |
| Expected outputs | Recommended | What the skill should produce |
| Source material | Recommended | SOPs, docs, templates, rules, examples |
| Constraints | Recommended | Runtime limits, repo conventions, style rules, no-script environments |
| Existing files | Optional | Existing `SKILL.md`, references, assets, or related docs |
| Preferred pattern | Optional | If the requester already knows the intended pattern |

If key inputs are missing and ambiguity is material, switch to an Inversion-first flow.

---

## Pattern Selection

Choose the simplest pattern that fits the actual job.

### 1. Tool Wrapper

Use when the skill mainly packages conventions, rules, domain knowledge, or operating guidance.

Best for:
- framework conventions
- repository rules
- coding standards
- runbooks
- operational guidance

Typical structure:
- `SKILL.md`
- optional `references/*.md`

Do not start here if the real task is structured generation, review, or staged workflow.

---

### 2. Generator

Use when the skill produces a repeatable structured artifact.

Best for:
- proposals
- specs
- reports
- migration plans
- ticket drafts
- release notes
- skill scaffolds

Typical structure:
- `SKILL.md`
- `assets/template.*`
- optional `references/style-guide.md`

Do not use Generator alone when requirements are still unclear.

---

### 3. Reviewer

Use when the skill evaluates content against explicit criteria.

Best for:
- code review
- architecture review
- documentation review
- compliance review
- editorial review

Typical structure:
- `SKILL.md`
- `references/review-checklist.md`
- optional `assets/review-template.md`

The review criteria should be separable from the review workflow.

---

### 4. Inversion

Use when the skill must gather missing information before producing output.

Best for:
- requirement discovery
- ambiguous requests
- project intake
- scoping
- option selection

Typical structure:
- `SKILL.md`
- `assets/intake-questionnaire.md`
- optional output template files

Use this when assumptions would materially reduce quality or correctness.

---

### 5. Pipeline

Use when the skill must enforce ordered stages and explicit gates.

Best for:
- intake -> generate -> review -> revise
- plan -> approve -> execute
- draft -> QA -> publish
- multi-stage workflows with non-skippable transitions

Typical structure:
- `SKILL.md`
- `references/*.md`
- `assets/*.md`
- optional scripts only if the runtime supports them

Do not use Pipeline just to make the skill look sophisticated.

---

## Default Pattern Heuristics

When uncertain:
- ambiguity first -> **Inversion**
- structured output -> **Generator**
- quality gate required -> **Reviewer**
- enforced sequence -> **Pipeline**
- guidance-heavy skill -> **Tool Wrapper**

Common combinations:
- Inversion + Generator
- Generator + Reviewer
- Inversion + Generator + Reviewer
- Pipeline wrapping any of the above

For this skill, the most common shape is:

- Primary: **Inversion**
- Secondary: **Generator**, **Reviewer**
- Optional wrapper: **Pipeline**

Because skill creation often starts with incomplete requirements, produces structured files, and benefits from self-review before return.

---

## Companion Files

When present, use these files as companion resources:

### References
- `references/pattern-decision-guide.md`  
  Use to choose the right pattern or pattern combination.

- `references/skill-review-checklist.md`  
  Use to review the generated skill before returning it.

### Assets
- `assets/skill-template.md`  
  Use as the baseline skeleton when drafting a new `SKILL.md`.

- `assets/review-template.md`  
  Use when returning structured review findings.

- `assets/intake-questionnaire.md`  
  Use when the request is under-specified and must be clarified first.

Do not duplicate large chunks of these files into `SKILL.md` unless necessary.

---

## Workflow

### Step 1: Understand the requested capability

Extract the following:

- What repeatable task should this skill support?
- What should trigger the skill to be used?
- What should the skill produce?
- What inputs should it expect?
- What constraints or exclusions matter?
- Is there already an existing skill or file to upgrade?

If the request is framed as “make me a skill for X,” do not immediately draft files.
First determine whether X is:
- guidance-heavy,
- generation-heavy,
- review-heavy,
- ambiguity-heavy,
- stage-heavy.

Summarize the capability in one sentence before proceeding.

---

### Step 2: Decide whether clarification is needed

If the request is materially ambiguous, do not guess too early.

Use `assets/intake-questionnaire.md` logic to ask only the highest-signal questions first.

At minimum, clarify:
- skill goal
- trigger context
- expected output
- required inputs
- major constraints

Stop asking once the core design is clear enough to proceed safely.

Do not ask low-value questions that can be inferred from context.

---

### Step 3: Select the pattern

Choose:
- one **primary pattern**
- optional **secondary patterns**

Document the choice in working notes:

- Primary pattern:
- Secondary pattern(s):
- Why this fit is better than the alternatives:

Use `references/pattern-decision-guide.md` when needed.

Prefer the smallest viable pattern combination.

---

### Step 4: Design the file structure

Generate only the files that are justified by the pattern.

Preferred layout:

```text
<skill-name>/
├── SKILL.md
├── references/
│   └── ...
├── assets/
│   └── ...
└── scripts/
    └── ...   # only if supported and actually useful
````

Guidelines:

* Keep `SKILL.md` focused on usage, flow, and operating logic
* Move swappable rules and checklists to `references/`
* Move reusable templates, examples, or questionnaires to `assets/`
* Avoid empty folders unless the repo convention requires them
* Avoid creating scripts unless the target runtime supports them and they materially improve the skill

---

### Step 5: Draft the main `SKILL.md`

Use `assets/skill-template.md` as a starting point when available.

A strong `SKILL.md` should include:

* a clear trigger-oriented description
* scope boundaries
* inputs
* pattern or operating mode
* a concrete workflow
* output contract
* validation criteria
* common pitfalls
* references to companion files

The main file should explain:

* what the skill does
* when to use it
* how to run it correctly
* how to know it is done

The main file should not become a dumping ground for every detail.

---

### Step 6: Generate companion files only where justified

Add files only if they make the skill clearer, more reusable, or easier to maintain.

Typical examples:

* `references/pattern-decision-guide.md`
* `references/skill-review-checklist.md`
* `assets/skill-template.md`
* `assets/review-template.md`
* `assets/intake-questionnaire.md`

Rules:

* if the content is bulky and mainly reference material -> put it in `references/`
* if the content is reusable structure or fill-in scaffold -> put it in `assets/`
* if the content is short and operational -> keep it in `SKILL.md`

---

### Step 7: Review the generated skill

Before returning the result, review it using `references/skill-review-checklist.md` when available.

Check at minimum:

* Is the skill discoverable from its name and description?
* Does the chosen pattern actually match the job?
* Is `SKILL.md` concise enough?
* Are workflow steps concrete and ordered?
* Are inputs and outputs explicit?
* Are review criteria observable?
* Are bulky reusable materials extracted properly?
* Are there assumptions that should have become questions?
* Is the skill maintainable?
* Does it avoid unsupported runtime assumptions?

Revise once before returning if the result is weak.

---

### Step 8: Return the result in a structured way

Return results in this order:

1. Chosen pattern

   * primary pattern
   * secondary pattern(s)
   * rationale

2. Proposed file tree

3. Generated file contents

   * full `SKILL.md`
   * any `references/*`
   * any `assets/*`

4. Validation summary

   * what was checked
   * remaining assumptions
   * remaining risks

If the requester only asked for one file, return that file cleanly without unnecessary extras.

---

## Output Contract

When creating or upgrading a skill, return:

1. **Pattern decision**

   * Primary pattern
   * Secondary pattern(s), if any
   * Brief reason for the choice

2. **Proposed structure**

   * Minimal file tree
   * Note which files are required vs optional

3. **Generated content**

   * Full content for requested files
   * Clean markdown
   * Repo-friendly naming

4. **Validation summary**

   * What passed
   * What assumptions remain
   * What should be improved later, if anything

If the user asked specifically for:

* only `SKILL.md` -> return only the full `SKILL.md`
* full scaffold -> return `SKILL.md` plus references/assets as needed
* review of an existing skill -> return structured findings using reviewer logic

---

## Validation

A good result should satisfy all of the following:

* [ ] The skill name matches the directory name
* [ ] The description is trigger-oriented
* [ ] The pattern choice is explicit and sensible
* [ ] The workflow is concrete and ordered
* [ ] Inputs are explicit enough to act on
* [ ] Outputs are explicit enough to evaluate
* [ ] `SKILL.md` stays focused on operation
* [ ] Reusable bulky material is extracted appropriately
* [ ] Companion files are actually referenced when present
* [ ] The skill is not more complex than the task requires
* [ ] No secrets, tokens, or private values are embedded
* [ ] Unsupported runtime assumptions are avoided

---

## Common Pitfalls

| Pitfall                                                      | Better Approach                                                        |
| ------------------------------------------------------------ | ---------------------------------------------------------------------- |
| Starting from a blank template with no pattern choice        | Choose the pattern first, then scaffold                                |
| Stuffing everything into `SKILL.md`                          | Move bulky rules to `references/` and templates to `assets/`           |
| Using Generator before clarifying requirements               | Use Inversion first                                                    |
| Using Pipeline by default                                    | Add stages only when they reduce actual risk                           |
| Embedding review logic as vague prose                        | Use an explicit checklist in `references/`                             |
| Asking too many low-value intake questions                   | Ask only high-signal questions first                                   |
| Creating unnecessary files to look complete                  | Generate only what the pattern justifies                               |
| Making the skill describe itself but not its trigger context | Write descriptions that explain both capability and invocation context |

---

## Operating Rules

* Prefer simple patterns over complex ones
* Prefer explicit criteria over vague quality language
* Prefer composable files over monolithic instruction walls
* Prefer revisable checklists over hardcoded review prose
* Prefer safe defaults over hidden assumptions
* Prefer generating fewer high-quality files over many shallow files

---

## Completion Rule

This skill is complete when:

* the requested skill capability has been understood,
* the correct pattern has been selected,
* the minimum useful structure has been generated,
* the main `SKILL.md` is actionable,
* companion files are included only where justified,
* the result has been reviewed and is ready to use or refine.