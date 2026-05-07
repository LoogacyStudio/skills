---
name: "propose-skill-improvement"
description: "Use when a repeated failure, ambiguity, or workflow gap suggests a controlled update to a skill, prompt, agent, hook, instruction, or eval, and a smallest-effective proposal is needed."
agent: "skill-steward"
---
Given an observed failure, ambiguity, or repeated friction, produce a **controlled improvement proposal**.

## Rules

- Do not directly rewrite governance or skill files unless the caller explicitly asks for edits.
- Prefer the smallest effective change.
- Classify the correct destination before proposing a patch.
- Include before / after behavior.
- Include at least one eval, checklist, or review gate suggestion.
- Flag if the issue belongs in instructions, prompts, agents, hooks, or evals instead of a skill.

## Output

### Problem
- What is going wrong:
- Why it matters:
- Evidence:

### Current behavior
- Current destination or file:
- Current observable behavior:
- Why it is insufficient:

### Desired behavior
- Desired observable behavior:
- Scope boundary:
- Non-goals:

### Recommended destination
- Chosen layer:
- Specific file or new file:
- Why this destination is correct:
- Why alternatives are weaker:

### Proposed change package
- Minimal patch summary:
- Files changed:
- Approval requirement:
- Rollback note:

### Before / after summary
- Before:
- After:

### Risk review
- Regression risk:
- Overfit risk:
- Hidden-assumption risk:

### Eval or checklist addition
- Proposed eval / checklist:
- Failure mode covered:

### Change-log entry draft
- Scope:
- Reason:
- Reviewer:
- Approval status:
