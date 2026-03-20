# Godot UI/UX Review Rubric

Use this reference when reviewing a Godot HUD, menu, overlay, prompt flow, or tool UI. The goal is not to judge whether the screen is stylish. The goal is to judge whether users can understand what matters, know what to do next, notice what changed, and recover from mistakes without excess mental load.

## 1. Core review stance

Always review the UI through these questions first:

- What is the user trying to do right now?
- What should they notice first?
- What action should feel most obvious next?
- What feedback should appear after action?
- What happens if they are wrong, interrupted, or hesitant?

If a review cannot answer those questions, it is drifting into surface critique.

## 2. Dimension rubric

Use the dimensions below to structure findings. Mark each one as healthy, watch, or problem if a quick rating helps the report.

### Information hierarchy

Healthy signs:

- the most important information is visually dominant
- urgency, consequence, and frequency are reflected in layout and emphasis
- secondary information supports decisions without competing with primary goals

Warning signs:

- everything looks equally loud
- decorative or low-value elements outrank task-critical information
- users must scan the whole screen to find one important answer

### User focus / attention flow

Healthy signs:

- the eye naturally moves from primary information to the next likely action
- grouping and spacing reduce visual wandering
- motion, color, and contrast guide attention intentionally

Warning signs:

- multiple hotspots compete at once
- important changes happen far away from the interaction point
- users must bounce between unrelated areas to understand one decision

### Interaction clarity

Healthy signs:

- users can tell what is actionable vs informational
- primary, secondary, and destructive actions are distinguishable
- current availability and consequences of actions are visible enough

Warning signs:

- action priority is unclear
- disabled or unavailable actions look broken instead of intentionally unavailable
- labels or icons require guesswork

### State feedback

Healthy signs:

- the interface acknowledges input immediately
- loading, success, warning, error, and selected states are distinguishable
- completed actions leave a visible confirmation or state change

Warning signs:

- interaction produces no visible response
- users cannot tell whether the system is busy, done, or failed
- errors appear without recovery guidance

### Cognitive load

Healthy signs:

- the UI externalizes important state instead of making users remember it
- decisions are chunked into manageable groups
- the screen reveals detail progressively when needed

Warning signs:

- users must remember hidden prerequisites or prior selections
- too many options, numbers, or prompts compete simultaneously
- one decision requires mentally stitching together distant information

### Consistency

Healthy signs:

- similar states and actions look and behave similarly
- emphasis rules remain stable across screens and states
- confirmation, error, and navigation patterns are predictable

Warning signs:

- selected, focused, dangerous, and disabled states use inconsistent signals
- the same action is labeled or placed differently across adjacent screens
- one part of the UI teaches a rule that another part breaks

### Readability / density

Healthy signs:

- text, iconography, and spacing support fast scanning
- content is chunked clearly
- high-frequency information is readable under real usage conditions

Warning signs:

- tiny text, weak contrast, or crowded grouping slows scanning
- labels and numbers blur together
- users must reread to separate categories or meaning

### Critical action discoverability

Healthy signs:

- the most important next action is obvious within seconds
- high-risk actions are visible but appropriately guarded
- escape, cancel, retry, or back paths are easy to find

Warning signs:

- users hesitate because they cannot identify the next step
- destructive actions hide among normal actions
- recovery actions exist but are visually buried

## 3. HUD readable priority principles

Use these principles when reviewing HUDs specifically.

### Prioritize by urgency, not by decoration

Urgent survival, danger, timing, or objective signals should usually outrank ambient progression or flavor information.

### Prioritize by frequency of consultation

Information checked repeatedly during play should be easier to scan than low-frequency status.

### Prioritize by consequence of missing it

If missing a signal causes failure, wasted action, or confusion, its visibility requirement is higher.

### Avoid equal-weight clusters

When many counters, icons, and labels share similar weight, players lose the ability to know what matters now.

### Keep related decision data close together

If users must compare values to act, place those values near each other or make the relationship explicit.

## 4. Focus / flow checkpoints

Use these checkpoints when reviewing screens and interaction sequences.

- Can a user explain the main purpose of the screen in one sentence?
- Within 3–5 seconds, can they point to the most important information?
- Is the next likely action clear without narration?
- Does the UI visually guide users from state awareness to decision to action?
- After acting, does feedback appear near the action or affected state?
- Are optional or advanced controls visually subordinate until needed?
- Do interruptions, warnings, or confirmations appear at the right moment rather than too early or too late?
- Can users re-enter the flow after an error without losing orientation?

## 5. State feedback checklist

Review these states explicitly when possible:

- default / idle
- hover or focus
- active or selected
- pressed / confirming
- loading / processing
- success / completed
- warning / risky
- error / failed
- disabled / unavailable
- empty / no-result
- interrupted / cancelled
- recovered / retried

For each important state, ask:

- Is the state visible?
- Is the meaning understandable?
- Is the response timely?
- Does it suggest the correct next step?
- Can the user recover if needed?

## 6. Quick win vs structural change decision rule

Use this rule to separate recommendations.

### Quick wins

Choose quick wins when the problem can be improved through local changes such as:

- label or helper-copy rewrite
- stronger emphasis for the primary action
- better spacing, grouping, or contrast
- clearer state styling
- placing feedback closer to the action point

### Structural changes

Choose structural changes when the issue comes from deeper problems such as:

- the screen trying to support too many decisions at once
- broken information hierarchy across the whole layout
- a flow that hides the next step until after confusion happens
- feedback or error handling missing from the interaction model itself
- a HUD or menu whose grouping logic no longer matches user tasks

If a problem keeps reappearing in multiple local elements, it usually points to a structural issue, not another small polish pass.

## 7. Review guardrails

Do not let the review degrade into:

- pure art-direction commentary
- a Control-node technical audit
- architecture analysis that ignores user comprehension
- generic advice like "make it cleaner" with no task-based explanation

A good review always ties findings back to:

- understanding
- next-step clarity
- feedback quality
- recovery confidence
- mental effort
