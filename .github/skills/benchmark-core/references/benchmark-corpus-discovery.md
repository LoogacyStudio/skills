# Benchmark corpus discovery

Use this reference when a benchmark agent or skill needs canonical policy, corpus, or evidence docs from the **current benchmark corpus**.

## Portability rule

Reusable benchmark agents and skills should not hardcode:

- a repo-specific corpus name
- a specific corpus root such as `evals/<name>/`
- a specific plugin name
- duplicated `*-template.md` or `*-example.md` files in the corpus root

Instead, depend on:

- stable capability IDs for reusable workflows
- canonical document roles inside the active corpus
- semantic discovery when the exact repo layout differs

Use [`benchmark-corpus-adapter-contract.md`](./benchmark-corpus-adapter-contract.md) as the required shape for any repo-local corpus adapter.

## Canonical document roles

When a benchmark workflow needs corpus context, resolve these roles rather than fixed paths:

- **Corpus adapter or corpus index** — explains which corpus is active and where the canonical docs live
- **Taxonomy doc** — route, output, failure, invariance, robustness, and mutation-surface policy
- **Workflow doc** — lifecycle, role boundaries, and run control flow
- **Inventory doc** — benchmark portfolio, anchor selection, and suite coverage
- **Scoring guide** — route-first judging order and rubric guidance
- **Variant family catalog** — metamorphic and adversarial family definitions
- **Promotion checklist** — gate sequence, candidate classes, governance, and regression protection
- **Run-evidence index** — suite folders, naming guidance, and storage conventions
- **Active manifests** — current smoke pass, rerun slice, or other bounded campaign docs when relevant

## Discovery order

1. Prefer a corpus named explicitly by the user or task.
2. Otherwise, prefer a repo-local corpus adapter that follows the adapter contract.
3. Otherwise, discover the canonical docs semantically by their document role.
4. If multiple corpora remain plausible, keep the ambiguity explicit and narrow the work before judging, rerunning, or gating.
5. If no corpus exists, use only the capability layer and report the missing corpus context instead of inventing policy.

## Capability layer versus corpus layer

- **Capability layer** = reusable skills and their working assets
- **Corpus layer** = canonical policy, manifests, corpus items, and stored evidence

Templates, examples, and working output skeletons belong to the capability layer.

Taxonomy, workflow, scoring policy, benchmark inventory, manifests, and stored evidence belong to the corpus layer.

## Practical rule for future repos

If a new repo or plugin adopts these benchmark agents and skills:

- keep the capability IDs stable if possible
- provide one discoverable corpus adapter or corpus index
- make the corpus expose the canonical document roles above
- avoid forcing every agent and skill to know the repo-specific corpus path in advance
