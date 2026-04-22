# Coordinator Design Guide

Use this reference to keep game coordinators bounded, useful, and reviewable instead of letting them mutate into managers that know every object, every rule, and probably your blood type.

## What this pattern family is actually for

A coordinator is strongest when one scene or subsystem needs a **bounded collaboration owner** that exposes a stable seam to the outside world while hiding volatile internals.

Common fits:

- scene roots that should act as a gateway to internal child nodes or components
- encounter, quest, UI, vehicle, inventory, or cutscene subsystems with one obvious public entry surface
- codebases where refactors keep breaking callers because too many systems know too much about one internal structure
- systems where some helper calls, forwarded getters, and bubbled notifications belong at one boundary rather than being scattered everywhere

Weak fits:

- one honest direct dependency between two collaborators
- global notification topology with many unrelated listeners
- request execution, history, or queue semantics as the primary problem
- a class that only wraps one subsystem API and does not own collaboration rules

## Coordinator vs nearby patterns

Use these distinctions aggressively.

| Pattern | Core meaning | Best fit | Main warning sign |
| --- | --- | --- | --- |
| Direct call | One object directly depends on another | One stable, honest relationship | A coordinator would only add ceremony |
| Events / signals | Something happened | Notification topology and subscriber lifecycle | You start centralizing unrelated authority |
| Command flow | Please do this | Request contracts, execution timing, history | You are actually routing bounded subsystem access |
| Facade | Here is a simpler interface | Simplifying a complex subsystem API | No real collaboration rules are owned |
| Coordinator / mediator boundary | This bounded area collaborates through one seam | Scene/subsystem gateway with explicit ownership | The coordinator grows until it owns unrelated domains |

Practical rule:

- If the hard part is **who should hear about something**, start with events.
- If the hard part is **who should execute a request and when**, start with command flow.
- If the hard part is **what outsiders should be allowed to know about a volatile internal surface**, a coordinator is a real candidate.

## Boundary questions

For every proposed coordinator, ask:

- What scene, subsystem, or feature boundary does it own?
- Who is inside that boundary?
- Who is outside it?
- What should outsiders be able to ask for?
- Which internals should remain hidden even if they are convenient today?
- Would a split into smaller coordinators make the boundary clearer?

Healthy boundaries look like:

- one bounded domain or subsystem seam
- a small public surface
- volatile internals protected from outside refactor damage

Unhealthy boundaries look like:

- "this is where miscellaneous scene stuff goes"
- one root script that keeps absorbing unrelated responsibilities
- a coordinator whose only real job is being everyone's mutual friend

## Public surface discipline

A coordinator's public surface should be deliberately narrower than its internals.

Good candidates to expose:

- stable getters that summarize internal state
- helper functions that already require collaboration across multiple internals
- bubbled notifications that belong at the boundary
- narrow registration hooks when runtime-created participants must attach safely

Poor candidates to expose:

- every child node or component reference
- raw access to internals merely because another system asked nicely
- methods that belong to one internal object and do not need boundary ownership

Warning sign:

- the coordinator keeps adding one-to-one forwarded methods until it mirrors the whole subsystem

## Ownership and routing discipline

The coordinator should clarify who owns what.

Ask:

- What does the coordinator own directly?
- What remains owned by child nodes, services, or components?
- Which flows are pure forwarding?
- Which flows require multi-step coordination across internals?
- Which collaborations should still stay direct rather than routed?

Healthy routing:

- centralizes only the collaboration that benefits from a bounded seam
- does not swallow every piece of gameplay logic
- keeps child responsibilities meaningful

Warning signs:

- internal components become thin shells that only call back into the coordinator
- the coordinator decides everything because nobody else is trusted anymore
- bug fixes routinely land in the coordinator even when they belong to domain internals

## Lifecycle and reference discipline

Many coordinators exist to make refactors safer, so lifecycle sloppiness defeats the point.

Ask:

- How does the coordinator acquire internal references?
- What happens when the scene tree changes, objects reload, or runtime instances appear/disappear?
- Are runtime registrations explicit?
- Does the outside world stay insulated from internal rename/restructure churn?

Healthy designs:

- keep internal reference capture local to the coordinator
- re-emit or expose stable boundary signals instead of leaking child signal paths
- make registration and unregistration explicit when runtime-created collaborators exist

Warning signs:

- outside systems still cache deep child references "for convenience"
- the coordinator depends on fragile late lookup chains without guards
- registration rules are implicit and only work until one prefab or scene changes shape

## God-object avoidance rules

Coordinators and god objects are close cousins at uncomfortable family dinners.

Use these safeguards:

- one coordinator per bounded scene/subsystem seam
- split unrelated domains early
- keep a written public-surface inventory
- reject features that merely use the coordinator as a miscellaneous dependency hub
- treat growth in helper methods as a smell, not a victory condition

Good split examples:

- encounter coordination separate from inventory coordination
- quest flow coordination separate from save/load coordination
- UI gateway separate from world interaction authority when those seams differ

## Engine-aware shapes

### Godot / .NET

- Scene roots are natural coordinator candidates because they already sit at a boundary.
- Forwarded getters, bubbled signals, and helper functions are common, engine-friendly tools.
- The coordinator should encapsulate child nodes rather than teaching other systems the tree shape.
- Scene-bound coordinators should usually stay scene-bound, not become autoload singletons.

### Unity

- Coordinators can be `MonoBehaviour` roots, code-owned services, or `ScriptableObject` surfaces depending on whether the boundary is scene-bound or asset-bound.
- Runtime-created participants usually need clear registration/unregistration rules.
- Serialized fields can help coordination, but the coordinator should not become a giant inspector spiderweb.

### Generic C# / engine-neutral

- Prefer interfaces or narrow service contracts for the public seam.
- Keep subsystem internals free to reorganize without forcing external callers to change.
- If a plain facade is enough, do not invent a grander coordination story.

## Rejection heuristics

Reject or down-rank a coordinator recommendation when:

- there is no clear bounded seam
- the design mainly wants global access to lots of unrelated things
- a direct call already expresses the relationship honestly
- the real problem is event topology or command execution
- the coordinator is acting as a dumping ground for mixed domains

## Review checklist

Before approving a coordinator design, verify that:

1. a simpler non-coordinator alternative was considered first
2. the boundary is concrete and bounded
3. the public surface is smaller than the hidden internal surface
4. ownership of internals versus coordinator logic is explicit
5. direct vs event vs command routing is intentional
6. lifecycle and registration rules are clear where relevant
7. refactor resilience is improved by the design
8. god-object growth triggers or split criteria were considered
