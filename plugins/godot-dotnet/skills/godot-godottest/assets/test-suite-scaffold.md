# GoDotTest suite scaffold

Fill in the placeholders to create a new GoDotTest test class.

```csharp
using Chickensoft.GoDotTest;
using Godot;
// using Shouldly;  // uncomment if using Shouldly for assertions

/// <summary>Tests for {{FEATURE_OR_NODE_NAME}}.</summary>
public class {{TestClassName}}Test : TestClass
{
  public {{TestClassName}}Test(Node testScene) : base(testScene) { }

  // --- per-suite lifecycle (optional) ---

  [SetupAll]
  public void SetupAll()
  {
    // Runs once before the first test in this suite.
  }

  [CleanupAll]
  public void CleanupAll()
  {
    // Runs once after all tests in this suite.
  }

  // --- per-test lifecycle (optional) ---

  [Setup]
  public void Setup()
  {
    // Runs before each [Test].
  }

  [Cleanup]
  public void Cleanup()
  {
    // Runs after each [Test]. Free nodes here if created in Setup.
  }

  // --- tests (in declaration order) ---

  [Test]
  public void ShouldDescribeExpectedBehavior()
  {
    // Arrange

    // Act

    // Assert
  }

  [Test]
  public async Task ShouldHandleAsyncOperation()
  {
    // Arrange

    // Act — await engine operations
    await ToSignal(TestScene.GetTree(), SceneTree.SignalName.ProcessFrame);

    // Assert
  }

  // --- failure handler (optional) ---

  [Failure]
  public void OnFailure()
  {
    // Runs when any test in this suite fails.
    // Useful for screenshots, diagnostics, or error reporting.
  }
}
```

## Checklist for new suites

- [ ] Class name matches file name
- [ ] Extends `TestClass`
- [ ] Constructor accepts `Node testScene` and calls `base(testScene)`
- [ ] Uses only GoDotTest attributes (`[Test]`, `[Setup]`, `[Cleanup]`, `[SetupAll]`, `[CleanupAll]`, `[Failure]`)
- [ ] No xUnit / NUnit / MSTest attributes present
- [ ] Nodes added to the tree in tests are removed and freed in `[Cleanup]` or `[CleanupAll]`
- [ ] Nodes never added to the tree are freed with `Free()`, not `QueueFree()`
- [ ] Async tests return `Task` and use `await`
- [ ] Test scene and main-scene redirect are wired (see `references/godotest-quick-ref.md`)

## Optional: integration / UI scaffold with GodotTestDriver

Use this variant when the suite needs fixtures, node drivers, input simulation, or wait helpers.

```csharp
using Chickensoft.GoDotTest;
using Godot;
using Chickensoft.GodotTestDriver;
using Chickensoft.GodotTestDriver.Drivers;
using Chickensoft.GodotTestDriver.Util;
using Shouldly;

/// <summary>Integration/UI tests for {{FEATURE_OR_NODE_NAME}}.</summary>
public class {{TestClassName}}DriverTest : TestClass
{
  public {{TestClassName}}DriverTest(Node testScene) : base(testScene) { }

  [Test]
  public async Task ShouldDriveTheUiFlow()
  {
    var fixture = new Fixture(TestScene.GetTree());

    try
    {
      var screen = await fixture.LoadAndAddScene<Control>("res://{{SCENE_PATH}}.tscn");
      var primaryButton = new ButtonDriver(
        () => screen.GetNodeOrNull<Button>("{{NODE_PATH_TO_BUTTON}}")
      );

      primaryButton.ClickCenter();

      await TestScene.GetTree().WithinSeconds(1, () =>
      {
        // Replace with the post-interaction assertion you expect.
        screen.Visible.ShouldBeFalse();
      });
    }
    finally
    {
      await fixture.Cleanup();
    }
  }
}
```

### Extra checklist when using GodotTestDriver

- [ ] `.csproj` includes `Chickensoft.GodotTestDriver`
- [ ] `using Chickensoft.GodotTestDriver;` resolves, plus `Chickensoft.GodotTestDriver.Drivers` for driver types and `Chickensoft.GodotTestDriver.Util` for wait helpers
- [ ] `Fixture` cleanup runs in a `finally` block or another guaranteed path
- [ ] Driver producer lambdas return the node or `null`, never throw
- [ ] Simulated input that needs frame progression is followed by `WithinSeconds` / `DuringSeconds`
- [ ] File or save-data side effects are removed with `fixture.AddCleanupStep(...)` when needed
