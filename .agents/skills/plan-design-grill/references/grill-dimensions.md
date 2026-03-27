# Grill Dimensions

Use this reference to choose the **next highest-signal question**.
Do not ask every question. Ask only the questions that can change the decision, sequencing, cost, or confidence.

---

## Branch resolution rule

Treat a branch as resolved only if you can restate all of the following:

- the current decision
- why it holds for now
- what alternative was rejected or deferred
- what evidence supports it
- what would overturn it

If you cannot restate those five points, the branch is still open.

---

## Branch stopping rule

Do not keep drilling a branch just because questions still exist.

Stop and summarize the branch when either of these is true:

- the next question would no longer change the decision, sequencing, cost, or risk posture
- two consecutive answers add wording but no new decision information

When you stop, record:

- what is currently decided
- what caveat still matters
- what future evidence could reopen the branch

---

## Question batching rule

Ask **1 to 5** questions per round.
Prioritize in this order:

1. the branch most likely to change the overall decision
2. the branch hiding the largest assumption
3. the branch with the biggest blast radius if wrong
4. the cheapest branch to disprove quickly
5. only then lower-value polish questions

Do not ask a low-value question while a high-leverage branch is still blurry.

---

## 1. Decision and objective

Use when the proposal is still fuzzy or bundles multiple decisions together.

Ask:

- What exact decision are we trying to make right now?
- What problem does this plan or design solve?
- What happens if we do nothing?
- What outcome would make this feel successful?
- What would make this a bad decision even if implementation is technically clean?

Weak-answer signs:

- the goal is described as activity instead of outcome
- several decisions are bundled into one blob
- success is defined as "shipping it" rather than measurable value

---

## 2. Scope and exclusions

Use when the plan sounds broad, ambitious, or squishy around edges.

Ask:

- What is explicitly in scope?
- What is explicitly out of scope for this round?
- Which edge cases are being deferred on purpose?
- What must stay unchanged while this work happens?
- Where does this plan stop so another plan can begin?

Weak-answer signs:

- scope silently includes future wishlist items
- exclusions are missing or defensive
- the plan expands whenever challenged

---

## 3. Constraints and non-negotiables

Use when hidden constraints could overturn the proposal later.

Ask:

- Which constraints are real and which are preferences?
- What deadlines, platform limits, staffing limits, compatibility needs, or policy requirements apply?
- Which constraint would kill this plan if violated?
- What is the acceptable risk tolerance here?
- Are we optimizing for speed, safety, reversibility, or long-term maintainability?

Weak-answer signs:

- a hard constraint appears only after alternatives were compared
- the team treats preferences like laws
- risk tolerance is assumed rather than stated

---

## 4. Alternatives and trade-offs

Use when the current path sounds inevitable only because other paths were never examined.

Ask:

- What alternatives were considered?
- Why is the current path better right now?
- What do we lose by choosing it?
- What would make one of the rejected options become better later?
- Is this the best path overall or just the least-bad path under current constraints?

Weak-answer signs:

- no credible alternative was named
- trade-offs are described only as benefits
- the proposal is defended with taste words instead of explicit comparison

---

## 5. Assumptions and evidence

Use when confidence seems stronger than the proof behind it.

Ask:

- Which part of this plan depends most on an assumption rather than evidence?
- What evidence already supports the current belief?
- What evidence is missing?
- What is the cheapest way to disprove the key assumption?
- Are we relying on analogy, prior experience, benchmark data, or hope?

Weak-answer signs:

- phrases like "should be fine" or "probably" carry the whole plan
- evidence is anecdotal when the decision needs stronger proof
- no one can name the cheapest falsification step

---

## 6. Dependencies and sequencing

Use when order matters or when upstream prerequisites may block execution.

Ask:

- What has to be true before this can start?
- What must happen in sequence, and what can happen independently?
- Which dependency has the highest chance of blocking us?
- Can the risky part be isolated into an earlier proving step?
- If the first step slips, what downstream steps become invalid?

Weak-answer signs:

- dependencies are discovered late in the conversation
- the plan assumes parallel work where coordination is actually tight
- sequencing is justified by habit rather than risk reduction

---

## 7. Owners and coordination surface

Use when responsibility is fuzzy or success depends on multiple people or systems.

Ask:

- Who owns the decision?
- Who owns implementation?
- Who owns validation and sign-off?
- Who has to be consulted but should not become a bottleneck?
- Where does cross-team or cross-system coordination create hidden change cost?

Weak-answer signs:

- "the team" is the only owner named
- approval and execution ownership are collapsed together accidentally
- no one owns rollback or validation

---

## 8. Failure modes and rollback

Use when the proposal could fail noisily, expensively, or invisibly.

Ask:

- What is the first thing most likely to break?
- Who notices first and how bad is it?
- What is the blast radius if this goes wrong?
- What is the rollback trigger?
- Can we reverse this cleanly, or are we really planning to fix forward?

Weak-answer signs:

- rollback is hand-waved as "we'll just fix it"
- failure modes are generic and not tied to the proposal
- the plan has irreversible steps with no guardrail thinking

---

## 9. Validation and exit criteria

Use when the plan sounds plausible but has no proof standard.

Ask:

- What evidence would make us confident enough to proceed?
- What does "good enough" mean here?
- Which smoke check, benchmark, review, or user outcome matters most?
- What specific result would block approval?
- When do we stop grilling and say the plan is ready?

Weak-answer signs:

- approval depends on vibes rather than checks
- success and exit criteria are different but no one noticed
- no blocking condition exists

---

## 10. Remaining open branches

Use near the end of a round or when the conversation feels close to convergence.

Ask:

- What is still undecided?
- Which open branch matters most before we proceed?
- What information is missing for that branch?
- Who needs to answer it?
- What is the next question, experiment, or artifact that would close it?

Weak-answer signs:

- the conversation ends with unresolved forks disguised as agreement
- the next step is "think more" rather than a concrete action
- multiple open branches exist but none is prioritized

---

## Closing rule

A strong grilling session does **not** end when there are no more questions.
It ends when the remaining questions are clearly named, ranked, and attached to a next action.
