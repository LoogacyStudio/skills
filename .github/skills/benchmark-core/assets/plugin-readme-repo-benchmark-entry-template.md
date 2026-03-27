# Plugin README — repo benchmark / eval work entry template

Use this small template when a market-facing plugin README needs to route readers into the repository's benchmark system without mixing plugin surface, shared framework rules, orchestration roles, and corpus material together.

## Recommended section block

```md
### If you are doing repo benchmark / eval work

- **You need shared benchmark framework rules or capability ownership** → start from `<benchmark-core path>`
- **You need benchmark orchestration, judging, variants, clustering, or gate review** → start from `<repo agents path>` and then use `<benchmark skills index path>` as the specialized skill index
- **You need the canonical corpus, policy, manifests, or stored evidence** → start from the repo-local corpus adapter at `<corpus adapter path>`
```

## Placeholder guide

- `<benchmark-core path>` → shared benchmark framework owner
- `<repo agents path>` → repo-level orchestration agents
- `<benchmark skills index path>` → specialized benchmark skill index
- `<corpus adapter path>` → repo-local corpus adapter for the plugin's eval corpus

## Usage rules

- Keep exactly three entry bullets unless the repo truly has no benchmark framework, no orchestration layer, or no corpus adapter.
- Use the first bullet for shared framework rules only.
- Use the second bullet for orchestration and specialist benchmark execution flow.
- Use the third bullet for corpus policy, manifests, and stored evidence.
- Do not turn this block into a long explanation section; it should stay a routing aid.
- Do not duplicate benchmark-core framework details inline when a pointer is enough.

## Boundary reminder

This block is for **repo benchmark / eval work**, not for the plugin's own shipped worker or skill surface.
