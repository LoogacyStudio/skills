# GoDotTest quick reference

Distilled API and setup reference for Chickensoft GoDotTest. Source: [github.com/chickensoft-games/GoDotTest](https://github.com/chickensoft-games/GoDotTest).

## Package

```xml
<PackageReference Include="Chickensoft.GoDotTest" Version="2.0.32" />
```

Check [NuGet](https://www.nuget.org/packages/Chickensoft.GoDotTest/) for the latest version.

## Test class anatomy

```csharp
using Chickensoft.GoDotTest;
using Godot;

public class MyFeatureTest : TestClass
{
  // Constructor receives the test scene root node.
  public MyFeatureTest(Node testScene) : base(testScene) { }

  [SetupAll]   // Runs once before the first test in this suite.
  public void SetupAll() { }

  [Setup]      // Runs before each test.
  public void Setup() { }

  [Test]       // A test method. Runs in declaration order.
  public void ShouldDoSomething() { }

  [Test]
  public async Task ShouldDoSomethingAsync()
  {
    await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
  }

  [Cleanup]    // Runs after each test.
  public void Cleanup() { }

  [CleanupAll] // Runs once after all tests in this suite.
  public void CleanupAll() { }

  [Failure]    // Runs whenever any test in this suite fails.
  public void OnFailure() { }
}
```

## Lifecycle attribute execution order

```text
[SetupAll]
  ┌─ [Setup]
  │  [Test] — first test method
  │  [Cleanup]
  ├─ [Setup]
  │  [Test] — second test method
  │  [Cleanup]
  └─ ...
[CleanupAll]
```

If any `[Test]` throws, all `[Failure]` methods in the same suite run after that test's `[Cleanup]`.

## Key rules

- Tests run **sequentially in declaration order**. No parallelism.
- `async Task` tests are awaited. Synchronous tests return `void`.
- The test class name **must match the file name** for `--run-tests=ClassName` filtering.
- Extend `TestClass` — do not use xUnit, NUnit, or MSTest attributes.
- GoDotTest provides **no assertions and no mocks**. Use separate libraries.

## Project setup

### 1. NuGet reference

Add to your `.csproj`:

```xml
<ItemGroup>
  <PackageReference Include="Chickensoft.GoDotTest" Version="2.0.32" />
</ItemGroup>
```

### 2. Test scene

Create `test/Tests.tscn` with a root `Node2D`. Attach this script:

```csharp
using System.Reflection;
using Godot;
using Chickensoft.GoDotTest;

public partial class Tests : Node2D
{
  public override async void _Ready()
    => await GoTest.RunTests(Assembly.GetExecutingAssembly(), this);
}
```

### 3. Main scene redirect (games only)

In your main scene script, check for test arguments and branch:

```csharp
using Godot;
#if DEBUG
using System.Reflection;
using Chickensoft.GoDotTest;
#endif

public partial class Main : Node2D
{
#if DEBUG
  public TestEnvironment Environment = default!;
#endif

  public override void _Ready()
  {
#if DEBUG
    Environment = TestEnvironment.From(OS.GetCmdlineArgs());
    if (Environment.ShouldRunTests)
    {
      CallDeferred("RunTests");
      return;
    }
#endif
    GetTree().ChangeSceneToFile("res://src/Game.tscn");
  }

#if DEBUG
  private void RunTests()
    => _ = GoTest.RunTests(Assembly.GetExecutingAssembly(), this, Environment);
#endif
}
```

For **nuget packages** (not games), skip the main-scene redirect. The test scene calls `GoTest.RunTests` directly.

### 4. Exclude tests from release builds

```xml
<PropertyGroup>
  <DefaultItemExcludes Condition="'$(Configuration)' == 'ExportRelease'">
    $(DefaultItemExcludes);test/**/*
  </DefaultItemExcludes>
</PropertyGroup>
```

## Command-line arguments

| Flag | Purpose |
| --- | --- |
| `--run-tests` | Run all test suites |
| `--run-tests=SuiteName` | Run only the named suite |
| `--run-tests=SuiteName.MethodName` | Run only the named method in the named suite |
| `--quit-on-finish` | Exit the Godot process after tests complete |
| `--stop-on-error` | Stop all testing at the first error in any suite |
| `--sequential` | Skip remaining methods in a suite after a failure |
| `--coverage` | Force-exit for coverlet coverage capture |
| `--listen-trace` | Add `DefaultTraceListener` for Visual Studio output |

## VSCode debug configurations

### tasks.json

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build",
      "command": "dotnet",
      "type": "process",
      "args": ["build", "--no-restore"],
      "problemMatcher": "$msCompile",
      "presentation": { "reveal": "silent" }
    }
  ]
}
```

### launch.json

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Play",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT}",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    },
    {
      "name": "Debug Tests",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT}",
      "args": ["--run-tests", "--quit-on-finish"],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    },
    {
      "name": "Debug Current Test",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${env:GODOT}",
      "args": ["--run-tests=${fileBasenameNoExtension}", "--quit-on-finish"],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false
    }
  ]
}
```

Requires the `GODOT` environment variable pointing to the Godot executable path.

### Visual Studio launchSettings.json

Place in `Properties/` of the test project:

```json
{
  "profiles": {
    "Debug Tests": {
      "commandName": "Executable",
      "executablePath": "%GODOT%",
      "commandLineArgs": "--run-tests --listen-trace --quit-on-finish",
      "workingDirectory": "."
    }
  }
}
```

## Coverage with coverlet

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

The `--coverage` flag is **required** so GoDotTest force-exits the process for coverlet to capture data. Harmless error messages may appear on exit.

## Recommended companion libraries

| Library | Purpose | Notes |
| --- | --- | --- |
| [Shouldly](https://github.com/shouldly/shouldly) | Assertions | Readable, works in Godot runtime |
| [FluentAssertions](https://fluentassertions.com/) | Assertions | Alternative to Shouldly |
| [LightMock.Generator](https://github.com/anton-yashin/LightMock.Generator) | Mocking | Compile-time mock generation, safe for Godot |
| [LightMoq](https://github.com/chickensoft-games/LightMoq) | Moq-like adapter for LightMock | Familiar API surface |
| [GodotTestDriver](https://github.com/chickensoft-games/GodotTestDriver) | Integration / UI testing | Add fixtures, node drivers, simulated input, and wait helpers for runtime tests |

Avoid `Moq` — runtime IL emit can fail in Godot's .NET host.

## Using GodotTestDriver with GoDotTest

`GodotTestDriver` is a companion library for **integration and UI testing**. It is **not** a test executor. `GoDotTest` still discovers and runs the suite.

### Package reference

```xml
<PackageReference Include="Chickensoft.GodotTestDriver" Version="3.1.66" />
```

Use the `GodotTestDriver` namespace in C#:

```csharp
using Chickensoft.GodotTestDriver;
using Chickensoft.GodotTestDriver.Drivers;
using Chickensoft.GodotTestDriver.Util;
```

If you target `netstandard2.1`, the upstream docs say to also add:

```xml
<PropertyGroup>
  <CopyLocalLockFileAssemblies>true</CopyLocalLockFileAssemblies>
</PropertyGroup>
```

### What it adds

- `Fixture` for creating, loading, adding, auto-freeing, and cleaning up nodes/scenes on the main thread
- built-in drivers like `ButtonDriver`, `LabelDriver`, and `ControlDriver`
- custom driver composition around producer functions
- input simulation helpers for mouse, keyboard, controller, and mapped actions
- wait helpers such as `WithinSeconds` and `DuringSeconds`

### Minimal GoDotTest + GodotTestDriver pattern

```csharp
using Chickensoft.GoDotTest;
using Chickensoft.GodotTestDriver;
using Chickensoft.GodotTestDriver.Drivers;
using Chickensoft.GodotTestDriver.Util;
using Godot;
using Shouldly;

public class ConfirmDialogTest : TestClass
{
  public ConfirmDialogTest(Node testScene) : base(testScene) { }

  [Test]
  public async Task ClickingConfirmClosesDialog()
  {
    var fixture = new Fixture(TestScene.GetTree());

    try
    {
      var dialog = await fixture.LoadAndAddScene<Control>("res://ui/ConfirmDialog.tscn");
      var confirmButton = new ButtonDriver(
        () => dialog.GetNodeOrNull<Button>("VBox/ConfirmButton")
      );

      confirmButton.ClickCenter();

      await TestScene.GetTree().WithinSeconds(1, () =>
      {
        dialog.Visible.ShouldBeFalse();
      });
    }
    finally
    {
      await fixture.Cleanup();
    }
  }
}
```

### Fixture guidance

- `var fixture = new Fixture(TestScene.GetTree());`
- use `LoadAndAddScene<T>(...)` when the scene must enter the tree
- use `LoadScene<T>(...)` when you need the node but want to add it manually
- use `AutoFree(new SomeNode())` for nodes created in code
- use `AddCleanupStep(...)` for files or other side effects created during the test
- prefer `await fixture.Cleanup()` in a `finally` block so cleanup still runs when assertions fail

### Driver guidance

Producer functions should return the target node or `null` when it is absent. They should **not throw**.

```csharp
var saveButton = new ButtonDriver(
  () => Root?.GetNodeOrNull<Button>("HUD/Menu/SaveButton")
);
```

Drivers delay node lookup until used. That makes them resilient to dynamic scene changes and gives better errors than direct node access.

### Input and waiting patterns

Most input helpers do **not** wait for extra frames by themselves. After clicking, typing, or starting an action, use a waiting helper when the game needs time to react.

```csharp
viewport.ClickMouseAt(new Vector2(100, 100));
TestScene.TypeKey(Key.A);
await TestScene.HoldActionFor(1.0f, "jump");

await TestScene.GetTree().WithinSeconds(2, () =>
{
  // assertion repeated every frame until it passes or times out
});
```

Useful helpers from the upstream docs include:

- `viewport.MoveMouseTo(...)`
- `viewport.ClickMouseAt(...)`
- `viewport.DragMouse(...)`
- `node.PressKey(...)`, `ReleaseKey(...)`, `TypeKey(...)`
- `node.StartAction(...)`, `EndAction(...)`, `HoldActionFor(...)`
- `node.PressJoypadButton(...)`, `TapJoypadButton(...)`, `MoveJoypadAxisTo(...)`
- `GetTree().WithinSeconds(...)`, `GetTree().DuringSeconds(...)`

### Validation checklist for GodotTestDriver usage

- `Chickensoft.GodotTestDriver` appears in the `.csproj`
- the required namespaces resolve without missing-type errors: `Chickensoft.GoDotTest`, `Chickensoft.GodotTestDriver`, `Chickensoft.GodotTestDriver.Drivers`, `Chickensoft.GodotTestDriver.Util`
- `Fixture` cleanup is guaranteed on both pass and fail paths
- drivers operate through producer lambdas instead of direct brittle node grabs inside assertions
- missing nodes produce actionable driver errors, not `NullReferenceException`
- post-input assertions that need frame progression use `WithinSeconds` or `DuringSeconds`
- custom cleanup steps run for files or other persistent side effects created by the test

## Common pitfalls

- **xUnit/NUnit attributes ignored**: GoDotTest only recognizes its own `[Test]`, `[Setup]`, etc.
- **Tests never run**: usually a missing test scene or main-scene redirect.
- **Node leak**: `QueueFree()` on a node never added to the tree does nothing. Use `Free()`.
- **Async test passes instantly**: forgetting `await` — the method returns immediately.
- **Truncated output**: increase Godot's Network Limits (Max Chars per Second, Max Queued Messages, etc.) in Project Settings → Advanced.
- **Coverage empty**: missing `--coverage` flag, or the test scene is not wired correctly.
- **Filter not matching**: class name ≠ file name → `--run-tests=ClassName` finds nothing.
- **Confusing driver and runner roles**: `GodotTestDriver` drives scenes and inputs; `GoDotTest` executes the suite.
- **Driver producer throws**: return `null` when the node is absent and let the driver raise a better runtime error when used.
- **Immediate assertion after simulated input**: use waiting helpers when the scene needs extra frames to react.
