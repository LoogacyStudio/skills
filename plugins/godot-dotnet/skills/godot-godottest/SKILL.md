---
name: godot-godottest
description: "Use when a Godot/.NET task needs a Layer 4 overlay skill for GoDotTest-based C# testing, and the agent must write, run, debug, or collect coverage for suites, scene wiring, CLI invocation, VS Code debug configs, or coverage commands instead of guessing xUnit/NUnit patterns that do not apply inside Godot runtime."
---

# Godot GoDotTest

Use this skill when a Godot 4.6 + .NET/C# project uses **Chickensoft GoDotTest** for in-engine testing.

GoDotTest is a C#-first test runner that executes inside the Godot process. It is **not** xUnit, NUnit, or MSTest. Tests extend `TestClass`, use GoDotTest-specific lifecycle attributes, run sequentially inside the scene tree, and are invoked via Godot command-line arguments. Getting this wrong produces tests that compile but silently never execute, or that crash because of wrong scene wiring.

Prefer this skill whenever the task involves writing, scaffolding, running, debugging, or collecting coverage for GoDotTest-based test suites.

## Purpose

This skill is used to:

- write correct GoDotTest test classes with proper lifecycle attributes
- set up the test scene and main-scene redirection for running tests
- produce correct CLI commands for running tests, filtering suites, and collecting coverage
- generate VSCode launch/task configurations for debugging tests
- advise on assertion and mocking library choices compatible with GoDotTest
- guide `GodotTestDriver` usage for integration or UI-style GoDotTest suites
- separate what belongs in GoDotTest (runtime-dependent) from what can stay in pure .NET tests
- scaffold new test suites using the companion template

## Use this skill when

Invoke this skill for tasks such as:

- adding a new GoDotTest test class or test suite
- setting up GoDotTest in a project for the first time
- writing tests that need the scene tree, node references, signals, or engine timing
- configuring VSCode or Visual Studio to debug GoDotTest runs
- running tests from the command line or CI/CD
- collecting code coverage via coverlet for GoDotTest runs
- deciding which tests belong in GoDotTest vs. pure .NET test projects
- troubleshooting tests that do not appear, do not run, or crash on startup

### Trigger examples

- "Add a GoDotTest suite for this node"
- "Set up GoDotTest in my Godot project"
- "How do I debug GoDotTest tests in VSCode?"
- "Run only one test suite from the command line"
- "Collect coverage for my Godot C# tests"
- "My GoDotTest tests are not running"

## Do not use this skill when

Do not use this skill when:

- the test can run as a pure .NET test with no Godot runtime dependency — use a standard test framework instead
- the user wants a test **strategy review** rather than implementation — use `test-strategy-review`
- the user wants to review scene architecture rather than test it — use `scene-architecture-review`
- the task is about xUnit, NUnit, MSTest, or other non-GoDotTest frameworks
- the user only needs assertion library recommendations without writing GoDotTest suites

## Pattern

- Primary pattern: **Tool Wrapper**
- Secondary pattern: **Generator**

Why: the skill mainly packages GoDotTest conventions, lifecycle rules, setup patterns, CLI flags, and debugging/coverage guidance. The Generator secondary produces test suite scaffolds.

## Companion files

- `references/godotest-quick-ref.md` — distilled API reference: attributes, lifecycle order, CLI flags, project setup, coverage commands, and common pitfalls.
- `assets/test-suite-scaffold.md` — fill-in template for a new GoDotTest test class.
- `assets/driver-scaffold.md` — reusable template for custom `GodotTestDriver` drivers and GoDotTest integration-style test usage.

## Inputs

Collect or infer these inputs when available:

| Input | Required | Description |
|---|---|---|
| What to test | Yes | The node, system, signal flow, or behavior under test |
| Project structure | Recommended | Whether tests live in the same project or a separate test project |
| Existing test scene | Recommended | Whether a test scene and main-scene redirect are already wired |
| Godot version | Recommended | Godot 4.x version (affects API surface) |
| GoDotTest version | Recommended | NuGet package version (latest is 2.0.x) |
| Assertion/mock library | Optional | Whether the project uses Shouldly, FluentAssertions, LightMock, LightMoq, GodotTestDriver, or others |
| Integration/UI coverage | Optional | Whether the suite needs fixtures, input simulation, node drivers, or wait helpers |
| Coverage requirement | Optional | Whether coverlet integration is needed |
| CI/CD target | Optional | Whether tests run headless in CI |

If the project has no GoDotTest setup yet, guide the full first-time setup before writing tests.

## Workflow

### 1. Confirm GoDotTest is installed and wired

Check for:

- `Chickensoft.GoDotTest` NuGet reference in the `.csproj`
- a test scene (e.g. `test/Tests.tscn`) with a root node script that calls `GoTest.RunTests`
- main-scene redirection that checks `TestEnvironment.From(OS.GetCmdlineArgs())` and branches into test mode when `--run-tests` is present

If any piece is missing, guide its creation before writing test classes. See `references/godotest-quick-ref.md` § Project setup.

### 2. Write or scaffold the test class

Use `assets/test-suite-scaffold.md` as the starting point.

Rules:

- extend `TestClass`
- accept `Node testScene` in the constructor and pass it to `base(testScene)`
- use GoDotTest attributes only: `[Test]`, `[Setup]`, `[Cleanup]`, `[SetupAll]`, `[CleanupAll]`, `[Failure]`
- do **not** use xUnit, NUnit, or MSTest attributes — they are ignored by GoDotTest
- tests run **in declaration order**, not alphabetically
- tests run **sequentially** — no parallelism
- `async Task` tests are awaited; synchronous tests return `void`
- add nodes to the scene tree via `testScene.AddChild(node)` and clean them up in `[Cleanup]` or `[CleanupAll]`
- nodes that never enter the scene tree must be freed with `Free()`, not `QueueFree()`

### 3. Choose assertion, mocking, and integration tools

GoDotTest is a **test runner only** — it has no built-in assertions or mocks.

Recommended stack:

| Need | Recommended | Notes |
|---|---|---|
| Assertions | `Shouldly` or `FluentAssertions` | Any .NET assertion library works |
| Mocking | `LightMock.Generator` + `LightMoq` | Compile-time mock generation, safe in Godot runtime |
| Integration / UI | `GodotTestDriver` | Adds fixtures, node drivers, input simulation, and wait helpers for Godot runtime tests |

Do not recommend `Moq` — it uses runtime IL emit which can fail in Godot's .NET host.

If the suite is an integration or UI flow test and the project uses `GodotTestDriver`, guide these specifics explicitly:

- add a `Chickensoft.GodotTestDriver` package reference together with `using Chickensoft.GodotTestDriver;`, `using Chickensoft.GodotTestDriver.Drivers;`, and `using Chickensoft.GodotTestDriver.Util;` when wait extensions such as `WithinSeconds` are used
- remember `GodotTestDriver` is **not** a test executor — `GoDotTest` still owns suite discovery and execution
- use `Fixture` to create, load, add, and clean up scenes or nodes safely on the main thread
- call `await fixture.Cleanup()` in a `finally` block or equivalent guaranteed cleanup path when the test allocates runtime objects
- prefer built-in drivers like `ButtonDriver`, `LabelDriver`, `ControlDriver`, or compose custom drivers around producer lambdas
- producer functions should return `null` when a node is absent instead of throwing
- after simulated input, use wait helpers such as `WithinSeconds` or `DuringSeconds` when state changes require more frames to process

See `references/godotest-quick-ref.md` for a ready-to-adapt `GodotTestDriver` example and validation checklist.

### 4. Configure run and debug

Provide or verify:

- **CLI**: `$GODOT --run-tests --quit-on-finish` to run all suites
- **CLI filter**: `$GODOT --run-tests=SuiteName --quit-on-finish` for one suite; `--run-tests=SuiteName.MethodName` for one method
- **VSCode launch.json**: `Debug Tests` and `Debug Current Test` configurations (see quick ref)
- **Visual Studio**: `launchSettings.json` in the test project `Properties/` folder
- **Stop on error**: `--stop-on-error` to halt at first failure
- **Sequential skip**: `--sequential` to skip remaining methods after a failure within a suite

### 5. Collect coverage (when needed)

Guide coverlet setup:

```bash
coverlet \
  "./.godot/mono/temp/bin/Debug" --verbosity detailed \
  --target $GODOT \
  --targetargs "--run-tests --coverage --quit-on-finish" \
  --format "opencover" \
  --output "./coverage/coverage.xml" \
  --exclude-by-file "**/test/**/*.cs" \
  --exclude-by-file "**/*Microsoft.NET.Test.Sdk.Program.cs" \
  --exclude-by-file "**/Godot.SourceGenerators/**/*.cs" \
  --exclude-assemblies-without-sources "missingall"
```

Key: the `--coverage` flag tells GoDotTest to force-exit the process so coverlet can capture data correctly. A few harmless error messages appear on exit — disregard them.

### 6. Exclude tests from release builds

Ensure the `.csproj` excludes test files from `ExportRelease`:

```xml
<PropertyGroup>
  <DefaultItemExcludes Condition="'$(Configuration)' == 'ExportRelease'">
    $(DefaultItemExcludes);test/**/*
  </DefaultItemExcludes>
</PropertyGroup>
```

Adjust the glob if tests live in a different folder.

### 7. Validate

- Build succeeds with `dotnet build --no-restore`
- Tests appear in GoDotTest output when launched with `--run-tests`
- Specific suite filtering works with `--run-tests=SuiteName`
- `[Setup]`/`[Cleanup]` run in the expected order around each test
- Nodes added to the tree in tests are cleaned up
- Coverage report generates without empty results (if coverlet is used)

If the suite uses `GodotTestDriver`, also validate that:

- `Chickensoft.GodotTestDriver` is referenced and the needed namespaces resolve (`Chickensoft.GoDotTest`, `Chickensoft.GodotTestDriver`, `Chickensoft.GodotTestDriver.Drivers`, `Chickensoft.GodotTestDriver.Util`)
- `Fixture` cleanup always runs, even when assertions fail
- driver actions fail with actionable exceptions such as `InvalidOperationException`, not `NullReferenceException`
- simulated input plus `WithinSeconds` / `DuringSeconds` produces the expected state transition
- any custom cleanup steps added through the fixture actually execute

## Output contract

When this skill generates a test class, the output must include:

1. the complete C# test class file
2. any required scene or project setup steps that are missing
3. the CLI command to run the new tests
4. notes on which assertions/mocks are used and why
5. fixture or driver setup notes when the suite uses `GodotTestDriver`

When this skill guides first-time setup, the output must include:

1. NuGet package reference to add
2. test scene script
3. main-scene redirect (if the project is a game, not a package)
4. `.csproj` exclude for release builds
5. VSCode launch/task configurations

## Common pitfalls

- Using xUnit/NUnit attributes alongside GoDotTest — they are silently ignored.
- Forgetting to wire the test scene or main-scene redirect — tests compile but never execute.
- Using `QueueFree()` on nodes that were never added to the tree — they leak because `QueueFree` requires deferred scene-tree processing.
- Expecting parallel test execution — GoDotTest is intentionally sequential to avoid race conditions in engine state.
- Missing `--coverage` flag when running with coverlet — coverage capture fails silently.
- Using `Moq` instead of `LightMock.Generator` — runtime IL emit can fail in Godot's .NET host.
- Test class name not matching the file name — `--run-tests=FileName` filter breaks.
- Forgetting `await` on async test methods — test appears to pass instantly without actually running the async body.
- Not increasing Godot network limits for logging — test output may be truncated.
- Treating `GodotTestDriver` as the test runner — it only helps drive integration tests; `GoDotTest` still executes the suite.
- Clicking or typing with `GodotTestDriver` and then asserting immediately when more frames are needed — use waiting helpers when behavior is asynchronous.
- Writing producer lambdas that throw when the node is missing — drivers should handle absent nodes gracefully until used.
