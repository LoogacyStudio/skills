# Skill Review Checklist

Use this checklist to review a skill before it is returned, committed, or published.

The goal is to verify that:

- the skill is discoverable,
- the structure matches the job,
- instructions are actionable,
- supporting files are used correctly,
- the result is maintainable.

---

## Review Outcome Scale

Use one of these for each section:

- **Pass** = good enough, no material issue
- **Warn** = usable, but should improve
- **Fail** = must fix before finalizing

Optional severity for findings:

- **Critical**
- **Major**
- **Minor**

---

## 1. Discovery and Triggering

### Check

- [ ] Skill name matches its directory name
- [ ] Frontmatter exists if the runtime expects it
- [ ] Description is trigger-oriented, not vague
- [ ] Description explains both capability and usage context
- [ ] "When to Use" is clear
- [ ] "When Not to Use" is clear

### Common failures

- Description says what the skill is, but not when to invoke it
- Trigger conditions are too broad
- The skill overlaps confusingly with other skills

---

## 2. Pattern Fit

### Check

- [ ] A primary pattern is identifiable
- [ ] Secondary patterns, if any, are justified
- [ ] The structure matches the actual task
- [ ] The skill is not over-engineered

### Common failures

- Pipeline used when a simple Generator would do
- Generator used before requirements are clarified
- Reviewer behavior embedded without a checklist
- Tool Wrapper used for a workflow that really needs stages

---

## 3. `SKILL.md` Quality

### Check

- [ ] `SKILL.md` is focused on operating instructions
- [ ] Main sections are easy to scan
- [ ] Workflow steps are ordered and concrete
- [ ] Inputs are explicit
- [ ] Outputs are explicit
- [ ] Validation criteria are observable
- [ ] The file avoids bulky content that belongs elsewhere

### Common failures

- Too much reference material in `SKILL.md`
- Vague steps such as "analyze thoroughly" without operational guidance
- No output contract
- No clear validation or completion condition

---

## 4. Companion File Usage

### Check

- [ ] Reusable templates are in `assets/`
- [ ] Swappable rules/checklists are in `references/`
- [ ] Companion files are actually referenced from `SKILL.md`
- [ ] No unnecessary empty folders are introduced

### Common failures

- Template content duplicated in multiple places
- Checklist buried inside main instructions
- Supporting files exist but are never mentioned
- Assets contain one-off content that should stay inline

---

## 5. Inversion Quality (if applicable)

### Check

- [ ] The skill asks only high-signal questions first
- [ ] Questions reduce ambiguity materially
- [ ] Questions are grouped logically
- [ ] The skill avoids asking for information it can infer
- [ ] The skill knows when it has enough information to proceed

### Common failures

- Too many low-value questions
- Questions asked in the wrong order
- Requirements gathering never ends
- Obvious defaults are not used

---

## 6. Generator Quality (if applicable)

### Check

- [ ] Output structure is stable and explicit
- [ ] Templates are reusable
- [ ] Required sections are defined
- [ ] The generator includes enough context to avoid shallow output
- [ ] Formatting expectations are clear

### Common failures

- Output template is too generic
- Required sections missing
- No distinction between required and optional content
- Generated content depends on unstated assumptions

---

## 7. Reviewer Quality (if applicable)

### Check

- [ ] Review criteria are explicit
- [ ] Criteria are separated from the review workflow
- [ ] Findings format is clear
- [ ] Severity or priority can be expressed
- [ ] The review goes beyond generic praise/critique

### Common failures

- Review instructions are subjective only
- No reusable checklist
- Findings are unstructured
- Reviewer cannot distinguish critical issues from minor polish

---

## 8. Pipeline Quality (if applicable)

### Check

- [ ] Stages are clearly separated
- [ ] Entry and exit conditions are explicit
- [ ] Mandatory gates are visible
- [ ] The sequence reduces actual risk
- [ ] The pipeline is not more complex than necessary

### Common failures

- Hidden stage transitions
- Steps that can be skipped accidentally
- Review happens after final output instead of before
- Too many stages with no real benefit

---

## 9. Maintainability

### Check

- [ ] The skill can be updated without rewriting the whole file
- [ ] Rules likely to change are extracted into references
- [ ] Templates likely to evolve are extracted into assets
- [ ] There is minimal duplication
- [ ] Naming is consistent across files

### Common failures

- Same content repeated in multiple files
- Hidden dependencies between instructions
- Weak file naming
- Hardcoded repository-specific details without need

---

## 10. Safety and Operational Risks

### Check

- [ ] No secrets, keys, or tokens are embedded
- [ ] No environment-specific private values are hardcoded
- [ ] Unsupported runtime assumptions are avoided
- [ ] Scripts are optional unless guaranteed by the target runtime
- [ ] Risky operations are either gated or explicitly excluded

### Common failures

- Implicit dependence on unsupported tools
- References to local paths that will not exist elsewhere
- Overconfident instructions for destructive actions

---

## Review Report Template

Use this format when reporting findings.

### Summary

- Overall result: Pass / Warn / Fail
- Primary pattern:
- Key risks:
- Recommended action:

### Findings

| Severity | Area | Finding | Recommendation |
|---|---|---|---|
| Critical/Major/Minor | e.g. Discovery, Pattern Fit, Workflow | Brief issue | Concrete fix |

### Strengths

- ...
- ...

### Required Fixes Before Finalizing

- ...
- ...

### Optional Improvements

- ...
- ...

---

## Final Approval Rule

A skill is ready when:

- all critical issues are resolved,
- no major issue blocks correct use,
- the pattern fits the task,
- the workflow is actionable,
- bulky reusable material is extracted appropriately.
