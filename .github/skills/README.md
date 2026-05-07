# Repo shared skills

These skills live under `.github/skills/`. Think of this folder as the repo-shared entry layer for benchmark/eval work **and** shared governance / customization workflows.

Framework rules for the benchmark system now live in [`benchmark-core/`](./benchmark-core/).

If you want the current repo's corpus context first, start from the repo-local corpus adapter rather than guessing paths by hand.

## Start here

- Governance-aware customization authoring, review, and controlled self-evolution work → [`skill-authoring`](./skill-authoring/)
- Benchmark framework rules, capability registry, corpus discovery, adapter contract, lifecycle map, and run finalization rules → [`benchmark-core`](./benchmark-core/)
- Repo-local corpus context → [`../../evals/godot-dotnet/README.md`](../../evals/godot-dotnet/README.md)
- Specialized benchmark work → choose one of the skills below

## Available skills

| Skill | Use when | Main output |
| :---- | :------- | :---------- |
| [`skill-authoring`](./skill-authoring/) | A repo customization or governance artifact needs a controlled update, review, or new scaffold, especially for skills, prompts, agents, hooks, instructions, learning notes, or change-log discipline. | Controlled customization change package |
| [`benchmark-core`](./benchmark-core/) | The benchmark framework itself needs guidance: capability registry, corpus discovery, corpus adapter rules, lifecycle boundaries, or run-record finalization conventions. | Framework / routing / portability guidance |
| [`benchmark-author-skill-evals`](./benchmark-author-skill-evals/) | A reusable agent skill needs a small, scoreable eval pack with success criteria, trigger prompts, deterministic checks, rubric-based qualitative grading, and extension hooks. | Skill eval pack |
| [`benchmark-author-item`](./benchmark-author-item/) | A new benchmark item, seed draft, or ad hoc eval case needs to be normalized into the canonical benchmark-item format. | Benchmark item draft |
| [`benchmark-author-rerun-manifest`](./benchmark-author-rerun-manifest/) | A bounded candidate revision needs a concrete rerun manifest with target/protected suites, anchors, execution paths, and conditional follow-up checks before promotion review. | Candidate rerun manifest |
| [`benchmark-judge-run`](./benchmark-judge-run/) | An execution result or variant run needs a route-first judged record, and any completed scaffold-backed slot needs to be finalized into canonical record naming. | Judged run record |
| [`benchmark-review-candidate`](./benchmark-review-candidate/) | A wording, routing-policy, rubric, template, or other candidate revision needs a formal promotion review. | Candidate review record |
| [`benchmark-author-variants`](./benchmark-author-variants/) | A benchmark item or judged run needs metamorphic or adversarial variants authored from the shared family catalog. | `variant_bundle` |
| [`benchmark-cluster-failures`](./benchmark-cluster-failures/) | Multiple judged runs need to be grouped into reusable failure-pattern records. | Failure cluster record |

## Shared framework entry

Use [`benchmark-core`](./benchmark-core/) for shared benchmark framework details. This README is the skill index, not the full rulebook.
