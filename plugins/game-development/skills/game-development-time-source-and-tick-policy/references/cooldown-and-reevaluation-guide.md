# Cooldown and reevaluation guide

Use this reference when reviewing a proposed time policy and you need sharper language around cooldown clocks, reevaluation cadence, pause behavior, or the difference between polling and invalidation.

## Core principle

A timing model is weak when every recurring question gets answered with either "just run it every frame" or "just use a timer".

A useful review should distinguish at least the choices that change:

- gameplay meaning
- responsiveness
- pause behavior
- debugging clarity
- runtime cost
- drift tolerance

## Cooldown review questions

### 1. Which clock does the cooldown use?

Question:

- is the cooldown measured in scaled time, unscaled time, fixed-step counts, or a custom clock?

Expected design clarity:

- authoritative clock name
- whether UI preview and runtime execution read the same clock
- whether pause changes remaining cooldown time

### 2. When is the cooldown evaluated?

Question:

- is availability checked every frame, at input time, on interval, on state change, or on demand?

Expected design clarity:

- evaluation cadence
- why that cadence is justified
- what caller owns reevaluation

### 3. What happens during pause or slow motion?

Question:

- does cooldown freeze, continue, or partially scale?

Expected design clarity:

- pause rule
- time-scale rule
- whether different subsystems intentionally diverge and why

### 4. How are long frames or missed updates handled?

Question:

- does the system clamp, catch up, skip, or surface late timing explicitly?

Expected design clarity:

- drift handling rule
- whether missed intervals can accumulate
- how reviewers identify timing slippage

## Reevaluation review questions

### 5. Does this logic really need polling?

Question:

- is repeated reevaluation essential, or is state-change invalidation the more honest trigger?

Expected design clarity:

- polling versus event-driven decision
- why constant sampling is or is not justified
- which inputs make the decision become stale

### 6. Who owns the reevaluation schedule?

Question:

- which subsystem decides when this logic runs again?

Expected design clarity:

- scheduler ownership
- read-only consumers versus cadence owners
- boundaries between shared clock and local sampling rules

### 7. Is a hybrid model intentional?

Question:

- does the design combine interval polling with event-triggered invalidation on purpose?

Expected design clarity:

- which work is event-triggered
- which work is interval-triggered
- why the hybrid boundary is worth the complexity

## Cross-foundation handoff prompts

Use these prompts when timing review alone is no longer enough to explain the design risk.

- If cooldown or reevaluation depends on stale truth, observed state age, or blackboard freshness, pair with `game-development-world-state-facts`.
- If the question is really "what change should wake this system up?" rather than "which interval should it use?", pair with `game-development-state-change-notification`.
- If the cadence debate is actually about reusable guard checks or transition eligibility, pair with `game-development-condition-rule-engine`.
- If windows, delays, or timeouts materially change spend, reservation, or refund behavior, pair with `game-development-resource-transaction-system`.

## Minimum acceptable clarity

A time-policy design should be considered under-specified if you cannot answer all of the following:

- what the authoritative clock is
- who owns the cadence
- what uses scaled versus unscaled time
- what pauses and what does not
- how cooldown availability is checked
- how late or skipped updates are handled

## Smells

These are strong warning signs:

- "we just use delta time everywhere"
- one hidden helper deciding pause behavior for unrelated systems
- cooldown UI using a different clock than actual execution
- every system polling every frame because invalidation ownership is unclear
- fixed-step chosen by habit rather than by need
- timers attached to transient objects with no lifetime policy
- reevaluation cadence hidden inside unrelated behavior code
