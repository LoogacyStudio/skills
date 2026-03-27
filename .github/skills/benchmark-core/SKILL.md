---
name: benchmark-core
description: Use when a benchmark agent or skill needs the shared benchmark framework rules — capability map, corpus discovery, corpus adapter contract, lifecycle boundaries, or run-record finalization guidance — rather than one benchmark artifact like a judged run or rerun manifest.
---

# Benchmark Core

This is the main shared foundation skill for the repository's benchmark system.

Use it when you need the reusable benchmark framework layer itself:

- capability naming and ownership boundaries
- capability registry lookup
- active corpus discovery rules
- corpus adapter contract guidance
- shared lifecycle routing across benchmark skills
- run-record finalization rules
- portability conventions for benchmark agents and skills

This skill is not the place to author a benchmark item, judge a run, cluster failures, or review a candidate directly.
It is the place to understand the common framework that those specialized benchmark skills share.

## When to use

Use this skill when:

- you are creating or refactoring benchmark agents or benchmark skills
- you need to understand how a benchmark corpus should expose canonical docs
- you need the shared benchmark lifecycle map before choosing a specialized skill
- you need run-record finalization rules
- you are making benchmark tooling more portable across repos or plugins

## When not to use

Do not use this skill when the task is already clearly one of these:

- drafting a benchmark item -> `benchmark-author-item`
- planning a rerun slice -> `benchmark-author-rerun-manifest`
- judging a run -> `benchmark-judge-run`
- authoring variants -> `benchmark-author-variants`
- clustering failures -> `benchmark-cluster-failures`
- reviewing a candidate -> `benchmark-review-candidate`

## Shared references

- `references/benchmark-capability-registry.md` — stable capability IDs and current owning skills
- `references/benchmark-corpus-discovery.md` — how agents and skills should find the active corpus
- `references/benchmark-corpus-adapter-contract.md` — what a corpus adapter must expose
- `references/benchmark-skill-lifecycle.md` — shared lifecycle and ownership boundaries
- `references/run-record-finalization-checklist.md` — bounded checklist for scaffold-to-completed run promotion

## Shared assets

- `assets/plugin-readme-repo-benchmark-entry-template.md` — reusable three-entry routing block for plugin READMEs that need to point to benchmark-core, repo agents, and a repo-local corpus adapter

## Output guidance

When this skill is used, prefer to return:

- a routing recommendation to the correct benchmark capability or specialized skill
- a portability recommendation for benchmark agents or skills
- a corpus-adapter design or review note
- a plugin README routing block that reuses the shared three-entry benchmark / eval template
- a lifecycle or ownership clarification
- a bounded finalization checklist application plan

## Core rule

Treat `benchmark-core` as the main shared benchmark framework skill.

Specialized benchmark skills should keep their domain-specific guidance local, but shared benchmark framework references should live here rather than in a free-floating `.github/skills/references/` directory.
