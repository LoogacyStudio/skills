# Benchmark skills lifecycle map

Use this shared map to keep the benchmark skills composable instead of letting any one skill absorb the whole evaluation workflow.

## Primary lifecycle

0. **Author a scoreable eval pack when the target is a reusable skill**
   - skill: `benchmark-author-skill-evals`
   - output: skill-eval pack with success criteria, prompt set, deterministic checks, qualitative rubric pass, and extension hooks

1. **Author the benchmark definition**
   - skill: `benchmark-author-item`
   - output: canonical benchmark item draft

2. **Plan bounded reruns when a candidate exists**
   - skill: `benchmark-author-rerun-manifest`
   - output: bounded rerun manifest with target/protected anchors and conditional follow-ups

3. **Author variants when extra invariance or robustness coverage is justified**
   - skill: `benchmark-author-variants`
   - output: execution-ready variant bundle

4. **Judge each executed run**
   - skill: `benchmark-judge-run`
   - output: canonical judged run record
   - note: if the run was reserved in a scaffold slot and is now complete, `benchmark-judge-run` owns the run-record finalization step

5. **Cluster repeated judged weaknesses**
   - skill: `benchmark-cluster-failures`
   - output: reusable failure cluster record

6. **Review candidate promotion readiness**
   - skill: `benchmark-review-candidate`
   - output: canonical candidate review record

## Ownership boundaries

- `benchmark-author-skill-evals` turns a reusable skill into a measurable eval loop; it does not execute the eval suite or judge benchmark evidence.
- `benchmark-author-item` defines benchmark contracts; it does not score outputs.
- `benchmark-author-rerun-manifest` scopes rerun work; it does not execute or finalize records.
- `benchmark-author-variants` authors transformed inputs; it does not decide whether observed drift is acceptable.
- `benchmark-judge-run` judges one run and finalizes that run record once the execution is complete.
- `benchmark-cluster-failures` groups repeated judged failures; it does not propose or approve the actual candidate revision.
- `benchmark-review-candidate` evaluates promotion readiness; it should consume finalized evidence rather than raw placeholder records.

## Practical routing rules

- If the task starts with **"turn this skill into a measurable eval loop"** -> `benchmark-author-skill-evals`
- If the task starts with **"make the benchmark item"** -> `benchmark-author-item`
- If the task starts with **"define the rerun slice"** -> `benchmark-author-rerun-manifest`
- If the task starts with **"author variants"** -> `benchmark-author-variants`
- If the task starts with **"score or normalize this executed run"** -> `benchmark-judge-run`
- If the task starts with **"group repeated failures"** -> `benchmark-cluster-failures`
- If the task starts with **"decide promote / hold / reject"** -> `benchmark-review-candidate`

## Anti-patterns

- Do not use `benchmark-review-candidate` to silently normalize broken run-file naming.
- Do not use `benchmark-cluster-failures` on unjudged or half-finished records.
- Do not let `benchmark-author-rerun-manifest` grow into a run-finalization tool.
- Do not split scaffold promotion into a separate first-class skill unless it becomes a clearly discoverable workflow with repeated standalone use.
