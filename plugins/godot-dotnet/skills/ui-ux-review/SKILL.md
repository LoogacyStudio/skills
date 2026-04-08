---
name: ui-ux-review
description: Use when a Godot HUD, menu, overlay, prompt flow, or tool UI needs a task-oriented UX review that evaluates information hierarchy, focus, interaction clarity, feedback, readability, and player cognitive load, then returns concrete quick wins, structural improvements, and verification ideas.
---

# UI/UX Review

Use this skill when a Godot project needs a **task-flow-oriented review of UI experience quality**.

This skill is for reviewing whether players or users can **understand the screen, identify the next action, notice the most important information, recover from mistakes, and feel clear feedback after interaction**.

It is **not** a pure Control-node audit, a generic art-direction critique, or a catch-all architecture review. Its job is to judge whether the UI helps the user move through the intended task with low confusion and manageable cognitive load.

## Purpose

This skill is used to:

- review HUD, menu, overlay, dialog, prompt, and tool UI flows from the user-task perspective
- evaluate whether the most important information is visually and behaviorally obvious
- detect competing focus, unclear actions, weak feedback, and overloaded screens
- assess whether readability, density, consistency, and critical action discoverability are healthy enough
- produce a structured review that separates quick wins from structural changes and includes verification ideas

## Use this skill when

Invoke this skill for requests such as:

- reviewing a HUD that feels noisy, confusing, or hard to scan
- checking whether a menu or interaction flow makes the next step obvious
- assessing whether players notice state changes, confirmations, warnings, or errors
- evaluating whether a UI is readable under real play pressure, not just in a static screenshot
- identifying whether the screen asks users to hold too many concepts in working memory at once
- improving usability of in-game tools, editors, or menu-heavy utility screens

### Trigger examples

- "This HUD feels too noisy—will players struggle to read it?"
- "The menu flow feels unclear—does the next step read as obvious?"
- "Is the feedback strong enough after each action?"
- "Is this Godot tool UI too dense?"
- "Review this interaction flow and tell me whether the critical action is easy to find"

## Do not use this skill when

Do not use this skill when:

- the request is only about visual style, illustration quality, theme taste, or aesthetics with no usability goal
- the user only wants Control node hierarchy or anchor/container correctness review
- the main problem is runtime failure, scene wiring, or code architecture rather than user comprehension and flow
- the task is implementation of a known UI change rather than review
- the review would blame architecture for every issue instead of focusing on comprehension, flow, and feedback

## Pattern

- Primary pattern: **Reviewer**
- Secondary pattern: **Tool Wrapper**, **Generator**

Why this fit is better than the alternatives:

- the core job is to evaluate an existing UI against explicit UX criteria
- the skill also packages Godot-specific review heuristics for HUDs, menus, overlays, feedback loops, and interaction flow
- the output should be a repeatable structured review rather than loose commentary
- a full Pipeline would add ceremony without enough value, because the ordered review flow can live directly in this file

## Review dimensions that must be covered

Every review must explicitly assess the following areas, even if some are judged healthy:

1. **information hierarchy**
2. **user focus / attention flow**
3. **interaction clarity**
4. **state feedback**
5. **cognitive load**
6. **consistency**
7. **readability / density**
8. **critical action discoverability**

If a dimension is not currently a problem, say so briefly instead of silently skipping it.

## Inputs

Collect or infer these inputs when available:

- the target HUD, menu, overlay, tool screen, or interaction flow
- the user or player task in plain language
- what the user is expected to notice first, decide next, and complete successfully
- screenshots, short videos, scene captures, or flow descriptions showing the relevant states
- important UI states: default, hover/focus, active, disabled, success, warning, error, loading, empty, interrupted
- any reported pain such as missed alerts, wrong clicks, menu hesitation, or screen overload
- platform or context constraints if relevant: controller, mouse, keyboard, touch, couch distance, combat pressure, time pressure, low-resolution display
- any relevant Godot scene or Control hierarchy details only as supporting evidence, not as the main review target

If some details are missing, do not block on perfect context. Infer a first-cut UX reading and call out assumptions that materially affect the review.

## Workflow

Follow this sequence every time.

### 1. Understand the current user task

State what the player or user is trying to accomplish on this screen or in this flow.

Examples:

- monitor health, ammo, and objective status during combat
- choose a save slot and confirm load without accidental overwrite
- inspect inventory, compare options, and equip one item quickly
- configure a tool setting and understand whether the change took effect

Do not start from widgets. Start from the user goal.

### 2. Identify what should be primary on the screen

State the most important information or action the UI should surface first.

Examples:

- imminent danger indicator should outrank secondary progression data
- confirm / cancel decision should outrank decorative labels
- the currently selected item and its consequence should outrank long-form metadata

If the current screen appears to promote multiple things at once, call that out as possible focus competition.

### 3. Check for competing focus and attention drift

Review whether the UI pulls the eye in too many directions.

Check for:

- multiple elements using equally strong contrast, scale, motion, or color urgency
- decorative elements competing with task-critical signals
- alerts, counters, and calls to action fighting for the same visual priority
- unclear grouping that forces the user to re-scan the whole screen
- state changes appearing away from the place where the user acted

Explain whether the current attention flow supports or disrupts the intended task.

### 4. Evaluate interaction clarity and critical action discoverability

Review whether the user can tell:

- what actions are possible now
- which action is primary
- which actions are destructive, irreversible, or high-risk
- how to back out, recover, or retry after an error
- what the next sensible step is after the current state

Do not stop at button presence. Judge whether the action model is understandable under real usage pressure.

### 5. Inspect feedback and state response quality

Check whether the UI gives timely and interpretable feedback after interaction.

Look for:

- immediate acknowledgment after click, tap, confirm, or selection
- visible distinction between idle, focused, loading, success, warning, error, and disabled states
- confirmation of completed actions
- clear indication when something failed and what the user can do next
- recovery support after mistakes, cancellations, or invalid input

If the system changes state silently or too subtly, call it out explicitly.

### 6. Assess readability, density, and cognitive load

Judge whether the UI asks the user to hold too much information in working memory.

Check for:

- too many simultaneous labels, counters, prompts, or decision branches
- dense text blocks or poor chunking
- weak contrast, tiny text, or scan-hostile layout
- repeated re-reading because labels, icons, or grouping are ambiguous
- situations where the user must remember hidden rules because the UI does not externalize them

Distinguish between acceptable depth and unnecessary overload.

### 7. Separate quick wins from structural improvements

Every review must provide both categories.

#### Quick wins

These are small, local changes with high usability payoff.

Examples:

- strengthen the primary call to action
- reduce one noisy label cluster
- improve state contrast for disabled or selected items
- move confirmation feedback closer to the interaction point
- rewrite unclear labels or helper copy

#### Structural improvements

These are broader changes to hierarchy, grouping, state model, flow order, or screen decomposition.

Examples:

- split one overloaded panel into progressive disclosure
- redesign the flow so the next decision is always singular and visible
- re-tier HUD information by urgency and frequency
- separate primary action controls from informational clutter
- add explicit intermediate states for loading, invalid, or recoverable failure paths

Do not recommend structural change for every small issue, and do not pretend quick wins alone solve deep hierarchy problems.

### 8. Define verification ideas

Recommend lightweight ways to validate whether the review findings are real and whether the changes helped.

Examples:

- first-click success rate for the primary action
- time-to-find critical action
- whether users can describe the next step without coaching
- error recovery success after an invalid action
- scan test: what users recall after 3–5 seconds on the screen
- A/B comparison of reduced-density vs current layout
- controller-only or low-resolution pass if the UI must support those contexts

Keep verification practical. The goal is observable improvement, not ceremonial research theater.

## Output contract

Return the review using `assets/ui-ux-review-template.md`.

The review should include:

- `Intended user task`
- `Primary focus`
- `Clarity issues`
- `Feedback gaps`
- `Density/cognitive load concerns`
- `Quick wins`
- `Structural improvements`
- `Validation ideas`
- `Recommended next step`

Output rules:

- judge the UI from the task-flow perspective, not just static layout taste
- separate comprehension issues from architecture issues
- call out both strengths and weaknesses when possible
- explain why each issue matters to user success, speed, confidence, or recovery
- separate local polish opportunities from larger structural changes
- do not reduce the review to "looks good" or "looks bad"

## Godot-specific review heuristics

- Review the UI in terms of **moment-to-moment use**, not only scene tree structure.
- A readable HUD prioritizes **urgency, frequency, and consequence** over symmetry or decoration.
- A menu is clear when users can identify **where they are, what they can do, and what happens next**.
- Feedback should appear close to the interaction or affected state whenever possible.
- If users must remember hidden rules because the UI does not reveal state, the cognitive load is too high.
- Error handling is part of UX quality; unclear recovery paths are a usability failure, not merely a copy issue.
- If the UI problem is actually rooted in scene ownership or coupling, mention it briefly but do not let the review collapse into an architecture audit.

## Companion files

- `references/ui-ux-rubric.md` — Godot UI review rubric, HUD readability principles, focus/flow checkpoints, and state feedback checklist
- `assets/ui-ux-review-template.md` — reusable template for the final UI/UX review output

## Validation

A good review should satisfy all of the following:

- the intended user task is stated clearly
- all eight review dimensions are considered explicitly
- the most important on-screen information or action is identified
- competing focus or attention drift is discussed when relevant
- interaction feedback and recovery are evaluated explicitly
- readability, density, and cognitive load are assessed separately from aesthetics
- quick wins and structural improvements are both present
- at least one concrete verification idea is included
- the result does not degrade into pure art critique, Control-node commentary, or architecture review

## Common pitfalls

- treating visual polish as a substitute for clarity
- reviewing a static screenshot without asking what the user is trying to do
- calling everything an architecture problem and skipping the UX diagnosis
- ignoring post-action feedback because the screen "looks clean"
- recommending bigger fonts or prettier colors without identifying the task failure they solve
- dumping generic advice with no priority between quick wins and structural change

## Completion rule

This skill is complete when the agent has:

- explained the intended user task
- identified what should dominate the user’s attention
- reviewed hierarchy, focus flow, interaction clarity, feedback, cognitive load, consistency, readability, and action discoverability
- separated quick wins from structural improvements
- described how to verify whether the changes improved comprehension and flow
- returned a structured UX review rather than a beauty contest
