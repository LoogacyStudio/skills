# Migration Notes for Godot / .NET / Export Upgrades

Use this reference to classify upgrade risk, inventory the project before changes, and keep the migration staged instead of heroic.

## 1. Common upgrade risk categories

- **Engine compatibility**
  - Typical examples: Godot patch/minor/major change, project import differences, scene/resource behavior drift
  - Why it matters: Editor behavior, resource loading, serialized project state, and runtime expectations may shift even when code compiles

- **SDK / target framework drift**
  - Typical examples: New .NET SDK, target framework changes, updated build tools, IDE support changes
  - Why it matters: Restore, build, analyzers, language features, and package compatibility may change together

- **C# compatibility**
  - Typical examples: API deprecations, generated binding changes, language version changes, nullable/analyzer behavior differences
  - Why it matters: Code that previously compiled may warn, fail, or behave differently after toolchain upgrades

- **Addon / plugin breakage**
  - Typical examples: Asset-library addons, local plugins, editor plugins, NuGet packages, source generators
  - Why it matters: Third-party dependencies often lag engine/toolchain changes and can become the real blocker

- **Export chain drift**
  - Typical examples: Export templates, Android/iOS/web/native tooling, signing, CI packaging, platform SDK changes
  - Why it matters: A project may run locally yet still fail at export, packaging, or deployment time

- **Environment mismatch**
  - Typical examples: CLI vs editor differences, CI using different SDK/template set, developer machine drift
  - Why it matters: "Works on my machine" gets upgraded into "fails everywhere else" surprisingly fast

- **Verification blind spots**
  - Typical examples: No baseline, no smoke list, no regression focus, no artifact capture
  - Why it matters: Without evidence and checkpoints, every new failure becomes guesswork

## 2. Pre-upgrade inventory checklist

Before recommending sequence, inventory the project state.

### Version and toolchain facts

- current Godot version
- target Godot version
- installed .NET SDK versions
- current target framework and language version
- IDE/editor integration assumptions
- CI image or build agent versions

### Project and dependency facts

- `.csproj` target framework, language version, nullable, analyzers, generators
- NuGet packages with tight framework or SDK expectations
- editor plugins, custom addons, and local tools
- export presets, export templates, signing config, platform SDK/tool dependencies
- custom scripts for build, export, packaging, or post-processing

### Fragility and history facts

- scenes or flows that are known to break easily
- previous upgrade pain points
- platform-specific problem areas
- release-critical paths that cannot regress

If these facts are incomplete, ask only for the items that materially change the upgrade order.

## 3. Addon / plugin review prompts

Check every meaningful addon, plugin, or package with questions like:

- does it explicitly support the target Godot version?
- does it require a minimum or maximum .NET SDK / target framework?
- is it editor-only, runtime-only, or both?
- is it actively maintained or effectively abandonware?
- if it breaks, can the project still open, build, run, or export?
- can it be isolated, disabled temporarily, or upgraded separately?

### Dependency risk hints

- **Explicit compatibility matrix exists** — Confidence increases, but still validate the paths that actually use it.
- **Recent maintenance activity** — Lower risk than abandoned packages, not zero risk.
- **No documented support for target version** — Treat as medium-to-high risk until verified.
- **Editor plugin involved in import/build/export flow** — Breakage can block the whole project very early.
- **Export-related dependency** — Must be validated separately from local run success.

## 4. Export chain review prompts

Treat export as its own compatibility surface.

Check at least:

- export templates match the target Godot version
- export presets still reference valid settings and assets
- platform SDK or signing requirements changed
- CI export scripts still call the right paths, switches, or environment variables
- packaging or notarization/signing steps still work for target platforms
- one important export target can complete a baseline build after the migration step that affects it

Do not assume local editor success means export success.

## 5. Staged upgrade guidance

Prefer this thinking order when risk is non-trivial:

1. capture baseline behavior on the current version
2. create branch/tag/checkpoint before the first risky change
3. upgrade the prerequisite that unlocks later work, but only one major surface at a time
4. verify project open/import/build/run after each step
5. check dependency-specific paths before stacking the next risk surface
6. validate one export target before declaring success
7. clean warnings and follow-up polish after the main path is stable

### When combined steps may be acceptable

A combined step may be acceptable when:

- both moves are patch-level and well-supported
- one move is impossible without the other
- third-party dependency risk is low and documented
- a baseline exists and rollback is cheap

If those conditions are not present, split the steps.

## 6. Smoke test ideas

Use a small, decisive smoke set after each meaningful stage.

### Core smoke checks

- project opens and imports without new blocking errors
- restore/build succeeds
- main scene or main menu runs
- one critical gameplay/tool flow reaches a stable state
- one addon/plugin-backed path is exercised
- one export-related path is validated when export tooling changed

### Good regression targets

Pick 1–3 of these based on actual risk:

- historically fragile startup scene
- save/load or config path
- plugin-driven workflow
- platform-specific export path
- previously broken C# interop or binding-heavy code path
- scene/resource loading path touched by the version change

## 7. Rollback thinking

A rollback plan should answer:

- what exact checkpoint represents the last known-good state?
- at what signal do we stop fixing forward and roll back?
- which steps can be reverted independently?
- what logs, screenshots, exports, or build artifacts should be kept for comparison?
- what issue summary should be recorded before retrying the migration later?

Bad rollback thinking:

- "we can always fix it later"
- "just stash the changes"
- "if build passes, we are done"

Better rollback thinking:

- keep a clean branch or tag before step 1
- define failure signals per stage
- preserve evidence so the next attempt is faster and less emotional
