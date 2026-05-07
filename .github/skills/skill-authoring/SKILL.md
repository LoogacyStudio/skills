---
name: skill-authoring
description: Use when a repo customization or governance artifact needs a controlled update, review, or new scaffold, especially for skills, prompts, agents, hooks, instructions, learning notes, or change-log discipline.
---

# Skill Authoring

This repo-local skill packages the repository's **controlled self-evolution rules** for authoring or reviewing customization artifacts.

Use it when the work is not just "write a file," but "write or evolve the right customization artifact in the right layer with the right review trail."

## Use when

Use this skill when:

- creating or updating `SKILL.md` files for this repository
- creating or updating `.prompt.md`, `.agent.md`, `.instructions.md`, or hook policy artifacts
- deciding whether a recurring issue belongs in docs, prompts, agents, skills, hooks, or evals
- reviewing a governance-related artifact for boundary fit, overfitting, or hidden assumptions
- extracting reusable learning from completed work
- preparing change-log and approval-ready closeout notes

## Do not use when

Do not use this skill when:

- the task is a narrow benchmark artifact already covered by benchmark-specific skills
- the task is a one-off code edit with no reusable governance implication
- the request is pure implementation work with no customization or self-evolution question

## Primary references

- `docs/ai-governance/skill-authoring-contract.md`
- `docs/ai-governance/controlled-self-evolution-checklist.md`
- `docs/ai-governance/controlled-self-evolution-plan.md`
- `docs/ai-governance/controlled-self-evolution-task-list.md`
- `docs/ai-governance/skill-change-log.md`
- `docs/ai-governance/learning-notes.md`
- `docs/ai-governance/hook-policy.md`

## Workflow

1. Frame the observed problem or request in plain language.
2. Decide whether a reusable change is needed at all.
3. Classify the smallest correct destination:
   - docs
   - instructions
   - prompts
   - agents
   - skills
   - hooks
   - evals
4. If prompts route to custom agents, verify that any prompt-local output contract is explicit and overrides the agent fallback schema when both define structure.
5. State before / after behavior explicitly.
6. Name regression, overfit, and hidden-assumption risks.
7. Attach learning-note, eval, and change-log implications.
8. Preserve human approval gates for governance changes.

## Output contract

Return:

- the chosen destination
- the smallest useful change
- before / after behavior
- risks and guardrails
- eval or checklist follow-up
- change-log / learning-note implications

## Validation

A good result should:

- choose the correct layer before drafting changes
- avoid broadening Layer 0 without evidence
- avoid using hooks for reasoning problems
- avoid using skills for deterministic enforcement problems
- check routed prompt / agent output-contract precedence when both surfaces define structure
- include review and closeout implications

## Common pitfalls

- treating every awkward task as proof a new skill is needed
- hiding important behavior in unreferenced scripts or notes
- skipping the change-log because "the change is obvious"
- widening always-on context when a prompt or agent would suffice
- forgetting that routed prompts may carry explicit output contracts that must override an agent fallback schema

## Completion rule

This skill is complete when the proposed or reviewed customization change is correctly classified, minimally scoped, and tied to review, validation, and closeout discipline.
