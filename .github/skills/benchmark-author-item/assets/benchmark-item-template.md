# Repo skill asset — Benchmark Item Template

Canonical policy context: the active benchmark corpus taxonomy doc, inventory doc, and workflow doc.

Use this asset as the working output skeleton when drafting a benchmark item through the repo skill.

```md
## <Benchmark ID> — <Short title>

- **Status:** <seed | candidate | official | retired>
- **Task family:** <T1 | T2 | T3 | T4 | T5>
- **Suite coverage:** <acceptance, routing / trigger, output-quality, metamorphic, adversarial, regression>
- **Capability under test:** <skill(s) and/or worker(s)>
- **Preferred execution path(s):** <baseline, skill, worker>
- **Route expectation:** <R1 | R2 | R3 | R4 | R5 | R6>
- **Expected artifact type:** <triage report | architecture review | UX review | test strategy / matrix | upgrade plan | migration-quality plan>
- **Main scoring focus:** <2-5 short dimensions>
- **Metamorphic priority:** <low | medium | high>
- **Adversarial priority:** <low | medium | high>
- **Allowed drift:** <brief summary of hard invariants, soft invariants, and drift budget>
- **Initial status:** <seed>

### Scenario summary

<2-5 sentences describing the black-box scenario. Focus on task shape and evidence available, not hidden solution details.>

### Black-box input package

- **User request shape:** <what the user or coordinator asks for>
- **Evidence included:** <logs, summaries, file excerpts, screenshots, change notes, etc.>
- **Evidence omitted on purpose:** <what is intentionally missing>
- **Trust caveats:** <noise, stale snippets, conflicting hints, or none>

### Route contract

- **Why this route is expected:** <why a skill, worker, or no-escalation path is appropriate>
- **Acceptable alternate route:** <if any>
- **Route failure signs:**
  - <wrong narrow skill>
  - <unnecessary worker escalation>
  - <unnecessary plugin escalation when baseline / host-agent execution is the stronger fit>
  - <wrong-domain plugin trigger>

### Expected artifact contract

- **Must include:**
  - <required section 1>
  - <required section 2>
  - <required section 3>
- **Nice to include:**
  - <optional but useful section>
  - <optional but useful section>
- **Must avoid:**
  - <gold-answer leakage>
  - <unsupported engine/tooling claims>
  - <over-scoped rewrite advice when a bounded next step is expected>

### Primary success signals

- <signal 1>
- <signal 2>
- <signal 3>
- <signal 4>

### Main failure tags

- <F1>
- <F2>
- <F3>
- <F4>

### Scoring rubric

| Dimension | Weight | What good looks like |
| --- | --- | --- |
| Route correctness | <0-2> | <brief description> |
| Structural completeness | <0-2> | <brief description> |
| Judgment quality | <0-2> | <brief description> |
| Actionability | <0-2> | <brief description> |
| Validation quality | <0-2> | <brief description> |

### Metamorphic variant plan

- **Priority:** <low | medium | high>
- **Relevant relations:** <M1, M2, M3, M4, M5>
- **Hard invariants:**
  - <invariant>
  - <invariant>
- **Soft invariants:**
  - <invariant>
  - <invariant>
- **Allowed drift budget:**
  - <rule>
  - <rule>
- **Variant ideas:**
  - <idea>
  - <idea>
- **Invariant expectation:** <what should stay materially the same>

### Adversarial variant plan

- **Priority:** <low | medium | high>
- **Relevant families:** <A1, A2, A3, A4, A5, A6>
- **Variant ideas:**
  - <idea>
  - <idea>
- **Safe-failure expectation:** <how the capability should degrade if stressed>

### Execution notes

- **Baseline path notes:** <if baseline comparison is worth running>
- **Skill path notes:** <what to compare for the single-skill path>
- **Worker path notes:** <what to compare for the worker path>
- **Judge notes:** <notes for evaluators only; do not expose to the generation path>

### Promotion notes

- **Promote to candidate when:**
  - <condition 1>
  - <condition 2>
- **Promote to official when:**
  - <condition 1>
  - <condition 2>
- **Retire when:**
  - <condition 1>
  - <condition 2>

### Benchmark history

- **Created:** <YYYY-MM-DD>
- **Last reviewed:** <YYYY-MM-DD>
- **Material changes:**
  - <date> — <change summary>
```
