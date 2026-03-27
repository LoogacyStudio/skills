# Repo skill asset — Candidate Review Record Template

Canonical policy context: the active benchmark corpus promotion checklist, workflow doc, and taxonomy doc.

Use this asset as the final candidate review output skeleton.

```md
## Candidate review — <candidate name>

- **Candidate ID:** <CR-001>
- **Candidate class:** <C1-C5>
- **Decision:** <promote-to-candidate | promote-to-official | hold | reject | revert>
- **Date:** <YYYY-MM-DD>
- **Reviewer(s):** <name or role>
- **Target suite:** <suite names>
- **Protected suites:** <suite names>
- **Mutation surface:** <allowed | conditionally-allowed-with-override | disallowed>

### Candidate summary

- **Intended gain:** <one sentence>
- **Observed gain:** <one sentence>
- **Affected artifacts:**
  - <artifact>
  - <artifact>
- **Affected fields or surfaces:**
  - <field or surface>
  - <field or surface>

### Gate summary

- **Acceptance notes:** <short notes>
- **Regression notes:** <short notes>
- **Invariance notes:** <short notes>
- **Robustness notes:** <short notes>
- **Governance notes:** <short notes>

### Evidence

- **Relevant benchmarks:**
  - <benchmark>
  - <benchmark>
- **Related failure clusters:**
  - <cluster id>
  - <cluster id>
- **Supporting run records:**
  - <run record reference>
  - <run record reference>

### Follow-up actions

- <action>
- <action>
- <action>
```
