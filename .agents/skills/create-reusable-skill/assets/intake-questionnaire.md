# Skill Intake Questionnaire

Use this questionnaire when the request is too vague to safely create or upgrade a skill.

Ask only the highest-signal questions first.
Do not ask every question if the answer can be inferred or is unnecessary.

---

## Minimum Required Questions

These are the default first questions.

1. What repeatable task should this skill help with?
2. What should trigger the skill to be used?
3. What output should the skill produce, if any?
4. What inputs should the skill expect?
5. Are there any constraints, exclusions, or runtime limits?

If these five are answered clearly, proceed unless major ambiguity remains.

---

## Goal and Scope

Ask when the skill's purpose is still unclear.

- What is the main job of the skill?
- What problem should it solve repeatedly?
- What should this skill explicitly not do?
- Is this for a one-off task or a reusable workflow?
- Who or what will invoke the skill?

---

## Trigger Context

Ask when usage conditions are fuzzy.

- In what situation should an agent decide to use this skill?
- What words, intents, or task shapes should trigger it?
- Are there related skills it should not overlap with?
- Should it activate automatically or only in specific contexts?

---

## Output Expectations

Ask when deliverables are unclear.

- Should the skill produce an artifact, advice, a review, or a workflow?
- If it produces files, which files?
- Does the output have a fixed structure?
- Are there required sections, headings, or formats?
- Should the output be concise, detailed, formal, or practical?

---

## Input Expectations

Ask when the skill cannot proceed without defined inputs.

- What inputs are required?
- What inputs are optional?
- What defaults are acceptable?
- What should happen if an input is missing?
- Can the skill infer any inputs from context?

---

## Pattern Discovery

Use these to help choose a pattern.

### For Tool Wrapper

- Is the skill mainly packaging conventions, rules, or domain knowledge?

### For Generator

- Is there a repeatable output shape or template?

### For Reviewer

- Is the main job to inspect something against criteria?

### For Inversion

- Is the request too ambiguous to act on safely?

### For Pipeline

- Do steps need to happen in a fixed order with explicit gates?

---

## Companion File Discovery

Ask only if relevant.

- Which details belong in `SKILL.md`?
- Which rules should live in `references/`?
- Which reusable templates or examples should live in `assets/`?
- Are scripts needed, or should the skill remain script-free?

---

## Validation and Quality Gates

Ask when success criteria are unclear.

- How will we know the skill is good enough?
- What are the most important quality checks?
- Are there failure modes we should guard against?
- Is a review stage required before final output?

---

## Constraints and Risks

Ask when environment or safety concerns matter.

- Does the target runtime support scripts or only markdown files?
- Are there naming conventions to follow?
- Are there repository-specific rules?
- Are there operations the skill must avoid?
- Are there sensitive values or environment assumptions to exclude?

---

## Prioritization Rule

When time is limited, ask in this order:

1. Skill goal
2. Trigger context
3. Output shape
4. Required inputs
5. Constraints
6. Validation criteria
7. Companion file needs

---

## Stop Condition

Stop asking questions and proceed when:

- the task is clear enough to choose a pattern,
- the expected output is defined enough to draft,
- remaining unknowns are minor and safe to handle with defaults.

Do not keep asking questions once the core design is clear.
