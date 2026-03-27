# Repo skill asset — Candidate Rerun Manifest Template

Canonical policy context: the active benchmark corpus promotion checklist, workflow doc, and taxonomy doc.

Use this asset as the working output skeleton when drafting a bounded candidate rerun manifest through the repo skill.

```md
## <candidate short name> Rerun Manifest

A concrete rerun manifest for the current <candidate short name> draft bundle.

This manifest operationalizes the current follow-up guidance in [<candidate review record>](<relative-link>), the primary target evidence in [<comparison or cluster record>](<relative-link>), and the current protected-suite expectations recorded in [<protected evidence 1>](<relative-link>), [<protected evidence 2>](<relative-link>), and [<protected evidence 3>](<relative-link>).

## Purpose

Use this manifest to rerun the current <candidate class> draft bundle without expanding the mutation surface.

The goals of this rerun pass are to:

- measure whether <candidate goal 1>
- measure whether <candidate goal 2>
- protect <protected behavior 1>
- protect <protected behavior 2>
- avoid <unnecessary rerun expansion>

## Candidate bundle under rerun

- **Candidate ID:** `<CR-001 or local candidate short name>`
- **Candidate class:** `<C1 | C2 | C3 | C5>`
- **Mutation surface:** `<allowed | conditionally-allowed-with-override | disallowed>`
- **Baseline for comparison:** `<existing accepted evidence or current completed run set>`

### Affected files or route rules

- `<file or route rule 1>`
- `<file or route rule 2>`
- `<file or route rule 3>`

### Candidate rule or change under test

1. `<rule or wording change 1>`
2. `<rule or wording change 2>`
3. `<rule or wording change 3>`
4. `<boundary or exclusion that keeps the rerun slice narrow>`

## Suite scope

- **Target suites:** `<acceptance, trigger, ...>`
- **Protected suites:** `<regression, metamorphic, adversarial, ...>`
- **Primary comparison question:** `<what this rerun should resolve>`

## Included benchmark items

### Target rerun anchors

1. [`<benchmark id>`](<relative-link>) — `<why this is a target anchor>`
2. [`<benchmark id>`](<relative-link>) — `<why this is a target anchor>`
3. [`<benchmark id>`](<relative-link>) — `<why this is a target anchor>`

### Protected narrow anchors

1. [`<benchmark id>`](<relative-link>) — `<why this protects a narrow route or bounded artifact>`
2. [`<benchmark id>`](<relative-link>) — `<why this protects a narrow route or bounded artifact>`

### Protected ambiguity anchors

1. [`<benchmark id>`](<relative-link>) — `<why this protects an ambiguity-bearing route boundary>`
2. [`<benchmark id>`](<relative-link>) — `<why this protects an ambiguity-bearing route boundary>`

## Execution matrix

| Benchmark | Baseline | Skill | Worker | Why this rerun matters |
| --- | --- | --- | --- | --- |
| `<Bxxx>` | `<Yes/No/Optional>` | `<Yes/No>` | `<Yes/No>` | `<what this rerun should confirm or reject>` |
| `<Bxxx>` | `<Yes/No/Optional>` | `<Yes/No>` | `<Yes/No>` | `<what this rerun should confirm or reject>` |
| `<Bxxx>` | `<Yes/No/Optional>` | `<Yes/No>` | `<Yes/No>` | `<what this rerun should confirm or reject>` |

## Recommended run order

1. `<first rerun step>`
2. `<second rerun step>`
3. `<third rerun step>`
4. `<protected-anchor checks>`

Explain briefly why this order shows intended gain before protected regressions are judged.

## What to watch for during judging

### Target gain checks

- `<gain signal 1>`
- `<gain signal 2>`
- `<gain signal 3>`

### Regression protection checks

- `<protected check 1>`
- `<protected check 2>`
- `<protected check 3>`

## Conditional protected follow-ups

These follow-ups should be triggered only if the base rerun slice shows route drift, materially weaker justification, or a new robustness problem.

### Metamorphic follow-ups

Run only if `<trigger condition>`:

- `<benchmark / relation>`
- `<benchmark / relation>`
- `<benchmark / relation>`

### Adversarial follow-ups

Run only if `<trigger condition>`:

- `<benchmark / family>`
- `<benchmark / family>`
- `<benchmark / family>`

### Follow-ups to avoid by default

- `<expensive or already-complete follow-up family 1>`
- `<expensive or already-complete follow-up family 2>`

## Recording instructions

For every executed path:

1. create a new run record using capability `benchmark.run-judging`
2. score it using the active benchmark corpus scoring guide
3. store the rerun in the suite folder that best matches the rerun purpose
4. preserve route result, artifact type, five-dimension scores, and failure tags
5. compare against the existing completed evidence, not against fresh benchmark reinterpretation

## Minimum success criteria

This rerun bundle is considered decision-useful when:

- `<target gain condition 1>`
- `<target gain condition 2>`
- `<protected condition 1>`
- `<protected condition 2>`
- `<no-scope-inflation condition>`

## Follow-up outputs

After this rerun pass, produce at least:

- `<updated run records>`
- `<rerun summary or comparison note>`
- `<protected follow-up requests only for drifted anchors>`
- `<updated candidate review note before promotion>`

## Out of scope for this manifest

- `<what this rerun should not silently expand into>`
- `<what needs separate benchmark evidence>`
- `<what should not be promoted from this manifest alone>`
```
