# GodotTestDriver driver scaffold

Use this scaffold when a GoDotTest suite needs a reusable driver instead of hard-coding node lookups throughout the tests.

Drivers should present a stable, test-facing API over a scene subtree. They reduce brittle path churn, improve error messages, and keep tests focused on behavior rather than node plumbing.

## Minimal custom driver

```csharp
using System;
using Godot;
using Chickensoft.GodotTestDriver.Drivers;

/// <summary>Driver for {{ROOT_NODE_TYPE}} rooted at {{ROOT_NODE_PATH_DESCRIPTION}}.</summary>
public sealed class {{DriverName}} : ControlDriver<{{RootNodeType}}>
{
  public {{DriverName}}(Func<{{RootNodeType}}?> producer)
    : base(producer)
  {
    PrimaryButton = new ButtonDriver(
      () => Root?.GetNodeOrNull<Button>("{{NODE_PATH_TO_PRIMARY_BUTTON}}")
    );

    StatusLabel = new LabelDriver(
      () => Root?.GetNodeOrNull<Label>("{{NODE_PATH_TO_STATUS_LABEL}}")
    );
  }

  public ButtonDriver PrimaryButton { get; }
  public LabelDriver StatusLabel { get; }
}
```

## Example usage in a GoDotTest suite

```csharp
using Chickensoft.GoDotTest;
using Chickensoft.GodotTestDriver;
using Chickensoft.GodotTestDriver.Drivers;
using Chickensoft.GodotTestDriver.Util;
using Godot;
using Shouldly;

public class {{TestClassName}} : TestClass
{
  public {{TestClassName}}(Node testScene) : base(testScene) { }

  [Test]
  public async Task PrimaryButtonUpdatesStatus()
  {
    var fixture = new Fixture(TestScene.GetTree());

    try
    {
      var screen = await fixture.LoadAndAddScene<{{RootNodeType}}>("res://{{SCENE_PATH}}.tscn");
      var driver = new {{DriverName}}(() => screen);

      driver.PrimaryButton.ClickCenter();

      await TestScene.GetTree().WithinSeconds(1, () =>
      {
        driver.StatusLabel.Text.ShouldBe("{{EXPECTED_STATUS}}");
      });
    }
    finally
    {
      await fixture.Cleanup();
    }
  }
}
```

## Driver design rules

- producer lambdas should return the node or `null`, never throw
- prefer driver properties over repeating `GetNodeOrNull` in test bodies
- keep driver methods behavior-oriented, e.g. `OpenMenu()`, `ConfirmDelete()`, `EnterName(string)`
- compose child drivers for nested UI instead of exposing raw paths everywhere
- let the driver fail with actionable errors when the UI is not in a clickable/visible state

## Checklist

- [ ] class name matches file name
- [ ] driver base type fits the root node (`ControlDriver<T>`, `NodeDriver<T>`, etc.)
- [ ] producer lambda returns `null` when the node is absent
- [ ] test body interacts with the driver, not scattered direct node lookups
- [ ] post-input assertions that need frame progression use `WithinSeconds` or `DuringSeconds`
- [ ] fixture cleanup is guaranteed with `try/finally`
