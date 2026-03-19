# Loogacy Studio – Godot Skills

A collection of C# utilities, patterns and helper extensions for **Godot 4**
game development with **.NET 8**.

---

## Features

| Module | What it provides |
|--------|-----------------|
| **NodeExtensions** | Typed child lookup, safe `QueueFree`, bulk child removal |
| **SignalExtensions** | `async`/`await` signal helpers, one-shot `ConnectOnce` |
| **SceneManager** | Typed scene instantiation, scene transitions, dynamic child scenes |
| **InputExtensions** | Movement vector assembly, multi-action queries, analogue strength |
| **StateMachine\<T\>** | Fluent, enum-driven finite state machine with enter / exit / update hooks |
| **ObjectPool\<T\>** | Generic object pool with warm-up, max-size cap, and get / return callbacks |
| **Singleton\<T\>** | Type-safe Autoload base class with duplicate-instance protection |
| **ResourceExtensions** | Typed `LoadOrThrow`, `TryLoad`, and `Exists` wrappers |

---

## Requirements

- [.NET 8 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
- [Godot 4.3](https://godotengine.org/) (engine runtime for Godot-dependent features)

---

## Getting Started

### Add the library to your Godot project

1. Copy (or submodule) this repository alongside your Godot project.
2. Edit your Godot project's `.csproj` to add a project reference:

```xml
<ItemGroup>
  <ProjectReference Include="../skills/src/LoogacyStudio.Skills.Godot/LoogacyStudio.Skills.Godot.csproj" />
</ItemGroup>
```

3. Rebuild in Godot or via the .NET CLI:

```bash
dotnet build
```

---

## Usage Examples

### NodeExtensions

```csharp
using LoogacyStudio.Skills.Godot.Nodes;

// Get a typed child by name (returns null if not found or wrong type)
var label = this.GetChildOrNull<Label>("HUD/ScoreLabel");

// Get the first child of a given type
var sprite = this.GetFirstChildOfType<Sprite2D>();

// Remove all children and free them
this.ClearChildren();
```

### SignalExtensions

```csharp
using LoogacyStudio.Skills.Godot.Signals;

// Await a signal inside an async method
await animationPlayer.WaitForSignalAsync(AnimationPlayer.SignalName.AnimationFinished);

// Await a signal that carries a value
string animName = await animationPlayer
    .WaitForSignalAsync<string>(AnimationPlayer.SignalName.AnimationFinished);

// Connect a one-shot callback
button.ConnectOnce(BaseButton.SignalName.Pressed, () => GD.Print("Pressed once!"));
```

### SceneManager

```csharp
using LoogacyStudio.Skills.Godot.Scenes;

// Instantiate a typed scene root
var enemy = SceneManager.Instantiate<Enemy>("res://scenes/Enemy.tscn");
AddChild(enemy);

// Add a scene as a child in one step
var hud = SceneManager.AddScene<HUD>(this, "res://ui/HUD.tscn");

// Transition to another scene
SceneManager.ChangeScene(GetTree(), "res://scenes/MainMenu.tscn");
```

### InputExtensions

```csharp
using LoogacyStudio.Skills.Godot.Input;

public override void _PhysicsProcess(double delta)
{
    Vector2 dir = InputExtensions.GetMovementVector();
    Velocity = dir * Speed;
    MoveAndSlide();

    if (InputExtensions.IsAnyActionJustPressed("jump", "ui_accept"))
        Jump();
}
```

### StateMachine\<T\>

```csharp
using LoogacyStudio.Skills.Godot.Patterns;

public enum PlayerState { Idle, Running, Jumping, Dead }

public partial class Player : CharacterBody2D
{
    private StateMachine<PlayerState> _fsm = null!;

    public override void _Ready()
    {
        _fsm = new StateMachine<PlayerState>(PlayerState.Idle)
            .OnEnter(PlayerState.Jumping, PlayJumpAnimation)
            .OnExit(PlayerState.Running,  StopRunAnimation)
            .AddTransition(PlayerState.Idle,    PlayerState.Running, () => Velocity.X != 0)
            .AddTransition(PlayerState.Running, PlayerState.Idle,    () => Velocity.X == 0)
            .AddTransition(PlayerState.Idle,    PlayerState.Jumping, () => Input.IsActionJustPressed("jump"))
            .AddTransition(PlayerState.Running, PlayerState.Jumping, () => Input.IsActionJustPressed("jump"));
    }

    public override void _PhysicsProcess(double delta) => _fsm.Update();
}
```

### ObjectPool\<T\>

```csharp
using LoogacyStudio.Skills.Godot.Patterns;

// In a spawner node
private readonly ObjectPool<Bullet> _pool = new ObjectPool<Bullet>(
    factory:     () => BulletScene.Instantiate<Bullet>(),
    onGet:       b  => { AddChild(b); b.Visible = true; },
    onReturn:    b  => { RemoveChild(b); b.Visible = false; },
    initialSize: 20);

public void Shoot(Vector2 origin, Vector2 direction)
{
    Bullet bullet = _pool.Get();
    bullet.Launch(origin, direction, () => _pool.Return(bullet));
}
```

### Singleton / Autoload

```csharp
using LoogacyStudio.Skills.Godot.Patterns;

// 1. Define your manager (add it to Project Settings → Autoload)
public partial class AudioManager : Singleton<AudioManager>
{
    public void PlaySfx(string key) { /* … */ }
}

// 2. Access it from anywhere in the project
AudioManager.Instance?.PlaySfx("coin_pickup");
```

### ResourceExtensions

```csharp
using LoogacyStudio.Skills.Godot.Resources;

// Load or throw with a descriptive message
var config = ResourceExtensions.LoadOrThrow<ConfigResource>("res://data/config.tres");

// Graceful load
var skin = ResourceExtensions.TryLoad<Texture2D>("res://skins/hero.png");

// Check existence before loading
if (ResourceExtensions.Exists<AudioStream>("res://audio/theme.ogg"))
    PlayMusic();
```

---

## Running the Tests

The unit tests cover the pure-C# modules (`StateMachine<T>` and `ObjectPool<T>`)
and do not require a Godot installation.

```bash
dotnet test tests/LoogacyStudio.Skills.Godot.Tests
```

---

## Project Structure

```
Skills.sln
├── src/
│   └── LoogacyStudio.Skills.Godot/
│       ├── Nodes/NodeExtensions.cs
│       ├── Signals/SignalExtensions.cs
│       ├── Scenes/SceneManager.cs
│       ├── Input/InputExtensions.cs
│       ├── Patterns/
│       │   ├── StateMachine.cs
│       │   ├── ObjectPool.cs
│       │   └── Singleton.cs
│       └── Resources/ResourceExtensions.cs
└── tests/
    └── LoogacyStudio.Skills.Godot.Tests/
        └── Patterns/
            ├── StateMachineTests.cs
            └── ObjectPoolTests.cs
```

---

## License

MIT © 2026 Loogacy Studio