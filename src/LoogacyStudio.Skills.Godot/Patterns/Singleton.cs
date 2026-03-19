using Godot;

namespace LoogacyStudio.Skills.Godot.Patterns;

/// <summary>
/// Base class for implementing the Singleton / Autoload pattern in Godot 4 C#.
/// </summary>
/// <remarks>
/// <para>
/// In Godot, the recommended way to create global singletons is to add a scene
/// or script to the <c>Project → Project Settings → Globals → Autoload</c> list.
/// This class wraps that mechanism so the singleton instance can be retrieved
/// with a type-safe property.
/// </para>
/// <para>
/// To use this pattern:
/// <list type="number">
///   <item>Derive your manager class from <c>Singleton&lt;T&gt;</c>.</item>
///   <item>Register the script in Godot's Autoload list.</item>
///   <item>Access the instance via <c>MyManager.Instance</c>.</item>
/// </list>
/// </para>
/// </remarks>
/// <typeparam name="T">The concrete singleton type.</typeparam>
/// <example>
/// <code>
/// public partial class GameManager : Singleton&lt;GameManager&gt;
/// {
///     public int Score { get; private set; }
/// }
///
/// // Elsewhere:
/// GameManager.Instance.Score += 10;
/// </code>
/// </example>
public abstract partial class Singleton<T> : Node where T : Singleton<T>
{
    private static T? _instance;

    /// <summary>
    /// Gets the singleton instance. Returns <c>null</c> if the node has not yet
    /// entered the scene tree.
    /// </summary>
    public static T? Instance => _instance;

    /// <inheritdoc/>
    public override void _EnterTree()
    {
        if (_instance is not null && _instance != this)
        {
            GD.PushWarning(
                $"[Singleton] A second instance of '{typeof(T).Name}' was created and will be removed.");
            QueueFree();
            return;
        }

        _instance = (T)this;
    }

    /// <inheritdoc/>
    public override void _ExitTree()
    {
        if (_instance == this)
        {
            _instance = null;
        }
    }
}
