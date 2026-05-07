---
name: "extract-learning"
description: "Use when a completed task should be converted into reusable learning, including recurring friction, missing guidance, destination classification, and follow-up suggestions."
agent: "skill-steward"
---
Review the completed task and extract reusable learning without inflating one-off incidents into permanent rules.

## Output

### 1. Task summary
- What was attempted:
- What changed or was reviewed:
- Why this task mattered:

### 2. Repeated friction or mistake
- Observed friction:
- Evidence that this may recur:
- Confidence level:

### 3. Root cause classification
Choose one or more and justify briefly:

- Missing always-on instruction
- Missing file-scoped instruction
- Missing prompt file
- Missing custom agent
- Missing skill
- Missing hook enforcement
- Missing eval
- Poor routing
- Poor architecture context
- Human process gap
- No reusable change needed

### 4. Recommended destination
Choose the **smallest correct destination**:

- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `.github/prompts/*.prompt.md`
- `.github/agents/*.agent.md`
- `.github/skills/*/SKILL.md`
- `.github/hooks/*.json`
- `scripts/copilot-hooks/*.ps1`
- `evals/*`
- `docs/ai-governance/*`
- no change needed

### 5. Minimal proposed change
- Smallest useful change:
- Why this layer is the right one:
- Why broader changes are unnecessary:

### 6. Regression and overfit risk
- Main risk:
- Overfitting risk:
- Containment / rollback note:

### 7. Eval or checklist suggestion
- Suggested eval or checklist:
- What it should catch:

### 8. Change-log note
- Scope:
- Reason:
- Approval needed:

## Rules

- Do not recommend Layer 0 changes unless smaller layers are insufficient.
- Do not propose hooks for problems that are mainly reasoning or workflow problems.
- Do not convert a one-off surprise into a universal rule without evidence.
- Prefer no change over cargo-culting a new file.
