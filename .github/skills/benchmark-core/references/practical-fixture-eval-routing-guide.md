# Practical fixture to eval routing guide

Use this guide when a practical fixture, trial log, or hand-built lab scenario seems useful enough to enter the eval system.

The goal is to avoid two opposite mistakes:

- promoting every interesting fixture into a brand-new benchmark item
- burying a genuinely new benchmark shape inside the notes for an older item

---

## Output options

Choose exactly one primary outcome first.

### 1. New benchmark item

Choose this when the fixture introduces a **materially new benchmark contract**.

Typical signs:

- a distinct task family or capability surface
- a different route expectation than nearby items
- a different expected artifact type
- a different first-failing layer or reasoning center
- a different scoring emphasis that would make judge notes meaningfully different

### 2. Existing item input package

Choose this when the benchmark contract is already represented, but the fixture gives you a better or more realistic **black-box package**.

Typical signs:

- same task family
- same intended capability under test
- same route expectation or close enough alternate route
- same artifact contract
- similar scoring focus
- the fixture mainly improves evidence realism, context quality, or black-box packaging

### 3. Existing item evidence only

Choose this when the fixture mainly adds confidence, examples, or run evidence for an already-modeled benchmark.

Typical signs:

- no meaningful change to route or artifact expectations
- no new judge-facing scoring dimension
- the fixture mostly confirms that an existing item is representative
- the value is historical traceability, not benchmark expansion

---

## Decision workflow

### Step 1: Find the closest existing benchmark item

Compare the fixture against the current inventory by:

- task family
- capability under test
- route expectation
- expected artifact type
- main scoring focus

If you cannot identify a close neighbor, that is already evidence that a new item may be justified.

### Step 2: Compare the contract, not the surface details

Do not decide based only on whether the fixture uses different files, a different lab project, or a more vivid story.

Ask instead:

- would the judge score it with the same rubric emphasis?
- would the same route expectation still make sense?
- would the same artifact type still be accepted?
- would the first useful probe remain materially similar?

If yes, you probably do **not** have a new benchmark item yet.

### Step 3: Check for material novelty

Count the number of material deltas versus the closest existing item.

Examples of **material** deltas:

- runtime triage versus migration planning
- narrow single-skill route versus worker-expected route
- triage report versus validation matrix
- first-failing layer moves from restore/build to scene/resource loading or startup runtime exception
- judge focus shifts from route ambiguity to evidence discipline under degraded logs

Examples of **non-material** deltas on their own:

- different fixture directory
- different filenames only
- richer recent-change note with the same essential benchmark shape
- a prettier reproduction path for the same first-failing layer

Rule of thumb:

- **0 to 1 material delta** -> usually existing item evidence or input package
- **2 or more material deltas** -> consider a new seed benchmark item

### Step 4: Check reproducibility and reset hygiene

Before promoting a fixture into eval, confirm:

- the failing or target state can be recreated intentionally
- the workspace can be reset cleanly after trials
- historical trial evidence is separate from current fixture state
- the input package can be described without depending on hidden session context

If those conditions are weak, keep the fixture as practical evidence first instead of rushing it into the corpus.

### Step 5: Choose the smallest eval mutation

Prefer the least disruptive outcome that still preserves the value:

- evidence note before input package
- input package before new benchmark item
- new seed item before candidate promotion

The eval corpus should grow by distinct contracts, not by enthusiasm alone.

---

## Quick decision matrix

| Question | If yes | If no |
| --- | --- | --- |
| Does the fixture introduce a materially different task family, route, artifact, or scoring focus? | Lean toward **new item** | Compare for input-package or evidence reuse |
| Would an existing benchmark judge rubric still fit with only light wording changes? | Lean toward **existing item input package** | Lean toward **new item** |
| Is the fixture mainly useful because it proves realism or repeated stability? | Lean toward **evidence only** | Continue the comparison |
| Can the fixture be reset and described as a stable black-box package? | Safe to consider eval entry | Keep it as practical-trial evidence until stabilized |

---

## Common pitfalls

| Pitfall | Better approach |
| --- | --- |
| Treating every practical fixture as a benchmark candidate | Compare against the nearest existing benchmark contract first |
| Deciding from filenames or lab identity alone | Decide from route, artifact, scoring, and first-failing-layer differences |
| Using a solved workspace state as the canonical eval scenario by accident | Separate historical evidence from the resettable current fixture state |
| Creating a new benchmark item when only the input package got better | Reuse the item and upgrade the evidence bundle instead |

---

## Decision note template

When returning a recommendation, state it in this shape:

- **Recommended outcome:** `new item` / `existing item input package` / `existing item evidence`
- **Closest existing item(s):** ...
- **Material deltas:** ...
- **Non-material deltas:** ...
- **Reset / reproducibility note:** ...
- **Next benchmark action:** ...
