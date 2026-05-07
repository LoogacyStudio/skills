---
name: "review-skill"
description: "Use when a SKILL.md, prompt, agent, instruction, hook, or related governance artifact needs a bounded review for routing clarity, safety, overfitting, hidden assumptions, and validation coverage."
agent: "skill-steward"
---
Review the selected customization or governance artifact.

## Review checks

1. Is the description specific enough for routing or discovery?
2. Does it duplicate always-on instructions or other files unnecessarily?
3. Is it too broad or too vague?
4. Are scripts, references, and assets explicitly referenced?
5. Are there hidden assumptions or unstated project dependencies?
6. Is there a clear output contract or completion criterion?
7. Is there a changelog / learning-note implication?
8. Does the artifact overfit to one previous failure?
9. Should any part move to hooks because it requires deterministic enforcement?
10. Should any part be covered by an eval or checklist?
11. If the artifact routes to a custom agent, is the prompt-local output contract explicit and clearly prioritized over the agent fallback contract?

## Output

### Verdict
- Overall assessment:
- Keep / revise / split / reject:

### Strengths
- Strength 1:
- Strength 2:
- Optional strength 3:

### Issues
- Issue 1:
- Issue 2:
- Optional issue 3:

### Boundary and routing review
- Right layer or wrong layer:
- Duplication risk:
- Hidden context risk:

### Suggested changes
- Smallest change first:
- Secondary improvement:
- What not to change:

### Eval and review follow-up
- Needed eval / checklist:
- Needed approval gate:
- Needed changelog / learning update:

### Risk
- Main regression risk:
- Overfit risk:
- Confidence level:
