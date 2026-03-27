# Benchmark corpus adapter contract

Use this contract when a repo exposes one or more benchmark corpora and wants reusable benchmark agents or skills to discover the **active corpus** without hardcoded repo-specific paths.

## Purpose

A corpus adapter is the lightweight, discoverable entry document for one benchmark corpus.

Its job is to answer three things fast:

1. What corpus is this?
2. Which canonical docs define policy, workflow, and evidence locations?
3. Which manifests, evidence roots, and capability-layer entry points are current right now?

The default implementation is the corpus-root `README.md`.

## Required behavior

Every benchmark corpus adapter should:

- live at a stable, discoverable entry point for that corpus
- identify the corpus without assuming the reader already knows the repo layout
- map canonical document **roles** to the current concrete docs
- identify active manifests and bounded campaign slices when they exist
- identify run-evidence roots and benchmark corpus roots
- point to the capability layer without duplicating skill-owned assets
- remain valid even if skill names, skill folders, plugin folders, or corpus folder names later change

## Required sections

### 1. Adapter summary

Must include at least:

- **Corpus ID**
- **Status** (`active`, `historical`, `experimental`, or equivalent)
- **Scope**
- **Related plugin or domain surface**
- **What belongs here vs what does not**

### 2. Canonical document role map

Must map these roles to the current concrete docs when they exist:

- taxonomy doc
- workflow doc
- inventory doc
- scoring guide
- variant-family catalog
- promotion checklist
- run-evidence index

Optional roles when relevant:

- corpus-wide benchmark index
- historical campaign log
- corpus-specific glossary

### 3. Active manifests and bounded slices

Must list any current:

- smoke pass manifests
- rerun manifests
- trigger or regression slices
- other bounded campaign documents

If none exist, say so explicitly.

### 4. Evidence surface

Must identify where readers should look for:

- benchmark item corpus
- run evidence
- candidate reviews
- failure clusters
- other suite-specific material if present

### 5. Capability layer handoff

Must explain that templates, examples, and working output skeletons live in the capability layer, not the corpus layer.

Prefer capability wording such as:

- `benchmark.item-authoring`
- `benchmark.run-judging`
- `benchmark.variant-authoring`
- `benchmark.failure-clustering`
- `benchmark.candidate-review`
- `benchmark.rerun-planning`

Prefer the stable IDs from [`benchmark-capability-registry.md`](./benchmark-capability-registry.md) rather than inventing repo-local aliases.

### 6. Discovery notes

Must state how an agent should use the adapter:

- start here when corpus context is needed
- resolve canonical docs by role from this adapter
- avoid guessing repo-specific corpus paths if this adapter is available

## Recommended headings

Use these headings when practical so corpus adapters stay visually consistent:

- `## Adapter summary`
- `## Canonical document role map`
- `## Active manifests and bounded slices`
- `## Evidence surface`
- `## Capability layer handoff`
- `## Discovery notes`

## Minimal example shape

```md
# <Corpus name> Corpus Adapter

## Adapter summary

- **Corpus ID:** `<id>`
- **Status:** `active`
- **Scope:** `<one-sentence scope>`
- **Related plugin or domain surface:** `<plugin/domain>`
- **Keeps here:** `<policy/manifests/corpus/evidence>`
- **Does not keep here:** `<skill-owned assets/plugin payload/etc.>`

## Canonical document role map

| Role | Current doc |
| --- | --- |
| Taxonomy doc | `<link>` |
| Workflow doc | `<link>` |
| Inventory doc | `<link>` |
| Scoring guide | `<link>` |
| Variant-family catalog | `<link>` |
| Promotion checklist | `<link>` |
| Run-evidence index | `<link>` |

## Active manifests and bounded slices

- `<manifest link>` — `<why it matters now>`

## Evidence surface

- Benchmark corpus: `<link>`
- Run evidence: `<link>`
- Candidate reviews: `<link>`
- Failure clusters: `<link>`

## Capability layer handoff

- Use capability `benchmark.run-judging` for judged-run structure.
- Use capability `benchmark.item-authoring` for benchmark item structure.

## Discovery notes

- Start here when corpus context is needed.
- Resolve canonical docs by role from this adapter.
```

## Anti-patterns

Avoid these in corpus adapters:

- using the adapter as a dumping ground for full policy prose already covered elsewhere
- duplicating skill-owned templates or examples into the corpus layer
- forcing every downstream agent to know the corpus folder name in advance
- mixing plugin shipping guidance with corpus policy without marking the boundary
- describing only files, but not the role each file plays

## Relationship to discovery

Use this contract together with [`benchmark-corpus-discovery.md`](./benchmark-corpus-discovery.md):

- the **contract** defines what a valid corpus adapter should expose
- the **discovery reference** defines how agents and skills should find and use that adapter
