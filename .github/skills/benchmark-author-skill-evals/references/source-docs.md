# Benchmark author skill evals — source docs

These are the canonical source roles this skill should follow.

- skill-under-test contract
  - `SKILL.md` name, description, scope boundaries, and definition of done
  - any optional assets, scripts, or supporting references the skill relies on
- OpenAI skill-eval workflow guidance
  - define success before refining the skill
  - manually test explicit and implicit invocation early
  - start with a small prompt set that includes negative controls
  - write deterministic checks over trace and artifact evidence first
  - add a structured rubric pass only where qualitative checks matter
- OpenAI evaluation best practices
  - define eval objective, dataset, metrics, run/compare loop, and continuous evaluation plan
  - combine automated scoring with human or model-assisted calibration when needed
  - grow coverage from real failures, edge cases, and adversarial or noisy inputs
- active benchmark corpus adapter, when the eval pack must align to the repo's canonical corpus
  - suite naming, scoring terminology, artifact storage, and promotion fit

Use [`../../benchmark-core/references/benchmark-corpus-discovery.md`](../../benchmark-core/references/benchmark-corpus-discovery.md) to resolve the current corpus when corpus alignment matters.

Authoring rule:

- treat the skill-under-test contract and the official OpenAI skill / eval guidance as the primary source of truth
- use this repo skill's asset as a working scaffold rather than as the policy source
- if the pack needs to plug into the active corpus, align naming and storage with the corpus adapter instead of hardcoding a new local convention
