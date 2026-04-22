# Repo skill asset — Skill Eval Pack Template

Canonical policy context: the skill-under-test contract, OpenAI skill-eval workflow guidance, and evaluation best-practices guidance.

Use this asset as the working output skeleton when drafting a small, scoreable eval pack for a reusable agent skill.

```md
## Skill eval pack — <skill name>

- **Skill name:** <skill-name>
- **Skill path:** <path/to/SKILL.md>
- **Eval status:** <draft | active | revised>
- **Date:** <YYYY-MM-DD>
- **Primary eval objective:** <one sentence>
- **Primary nondeterminism surface:** <triggering | execution order | artifact quality | permissions | mixed>

### Skill contract summary

- **What the skill should do:**
  - <behavior>
  - <behavior>
- **What the skill should not do:**
  - <boundary>
  - <boundary>
- **Why the skill should trigger:** <one sentence>
- **Why adjacent requests should not trigger it:** <one sentence>
- **Definition of done:**
  - <condition>
  - <condition>

### Success criteria

- **Outcome goals:**
  - <goal>
  - <goal>
- **Process goals:**
  - <goal>
  - <goal>
- **Style goals:**
  - <goal>
  - <goal>
- **Efficiency goals:**
  - <goal>
  - <goal>

### Prompt set

| ID | Should trigger | Prompt | Why this case exists |
| --- | --- | --- | --- |
| `trigger-explicit-01` | `true` | `<explicit $skill invocation>` | `direct invocation regression check` |
| `trigger-implicit-01` | `true` | `<implicit scenario that should match the description>` | `description quality / trigger coverage` |
| `trigger-contextual-01` | `true` | `<realistic noisy prompt that still needs the same skill>` | `contextual robustness` |
| `negative-01` | `false` | `<adjacent request that should not trigger the skill>` | `false-positive guard` |
| `negative-02` | `false` | `<second off-target request>` | `boundary guard` |

### Deterministic checks

| Check ID | Evidence source | Required condition | Failure meaning |
| --- | --- | --- | --- |
| `trigger-selected` | `<trace / metadata>` | `<skill invoked when should_trigger=true>` | `<missed trigger>` |
| `no-false-positive` | `<trace / metadata>` | `<skill not invoked when should_trigger=false>` | `<over-eager trigger>` |
| `expected-command` | `<JSONL command_execution>` | `<required command observed>` | `<skipped critical step>` |
| `expected-artifact` | `<filesystem>` | `<path exists>` | `<missing required output>` |
| `order-constraint` | `<trace ordering>` | `<A happens before B>` | `<broken sequence>` |
| `repo-cleanliness` | `<git status / allow list>` | `<no unexpected changes>` | `<dirty or over-scoped output>` |

### Qualitative rubric pass

- **When to run:** <always | only after deterministic checks pass | selected prompts only>
- **Read-only grading prompt should verify:**
  - <requirement>
  - <requirement>
  - <requirement>
- **Required check ids:**
  - `structure`
  - `conventions`
  - `style`
  - `validation`
- **Pass threshold:** <example: `overall_pass=true` and `score >= 85`>
- **Structured output schema fields:**
  - `overall_pass` — `boolean`
  - `score` — `integer 0-100`
  - `checks[]` — `{ id, pass, notes }`

### Artifact capture

- **Per-prompt trace path:** <path pattern>
- **Per-prompt deterministic result path:** <path pattern>
- **Per-prompt rubric result path:** <path pattern or not-used>
- **Summary report fields:**
  - prompt id
  - expected trigger
  - actual trigger
  - deterministic check outcomes
  - rubric score
  - notes
- **Comparison rule:** compare against the previous accepted pack or baseline run, not against vibes

### Extension hooks

- **Optional deeper checks:**
  - command-count / thrashing regression
  - token-budget regression
  - build validation
  - runtime smoke check
  - repository cleanliness allow list
  - sandbox / permission regression
- **Add new prompt rows from:**
  - manual failures
  - production or usage logs
  - new edge cases
  - adversarial or noisy inputs that exposed real drift

### Out of scope

- <what this pack should not silently expand into>
- <what needs a separate benchmark item or larger corpus workflow>
- <what should not be judged from this pack alone>
```
