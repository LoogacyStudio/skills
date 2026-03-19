using Godot;

namespace LoogacyStudio.Skills.Godot.Scenes;

/// <summary>
/// Provides helpers for loading, instantiating, and transitioning between
/// Godot scenes from C# code.
/// </summary>
public static class SceneManager
{
    /// <summary>
    /// Loads a packed scene from the given resource path and instantiates it.
    /// </summary>
    /// <typeparam name="T">The expected root node type of the scene.</typeparam>
    /// <param name="path">The Godot resource path (e.g. <c>"res://scenes/Player.tscn"</c>).</param>
    /// <returns>The instantiated root node cast to <typeparamref name="T"/>.</returns>
    /// <exception cref="InvalidOperationException">
    /// Thrown when the resource cannot be loaded or the root node type does not match.
    /// </exception>
    public static T Instantiate<T>(string path) where T : Node
    {
        var packed = ResourceLoader.Load<PackedScene>(path)
            ?? throw new InvalidOperationException($"Failed to load scene at path: {path}");

        Node instance = packed.Instantiate()
            ?? throw new InvalidOperationException($"Failed to instantiate scene at path: {path}");

        if (instance is not T typed)
        {
            instance.QueueFree();
            throw new InvalidOperationException(
                $"Scene root at '{path}' is of type '{instance.GetType().Name}', expected '{typeof(T).Name}'.");
        }

        return typed;
    }

    /// <summary>
    /// Changes the current scene to the scene at the given resource path.
    /// This is equivalent to calling <see cref="SceneTree.ChangeSceneToFile"/>.
    /// </summary>
    /// <param name="tree">The current <see cref="SceneTree"/>.</param>
    /// <param name="path">The Godot resource path to the new scene file.</param>
    public static void ChangeScene(SceneTree tree, string path)
    {
        tree.ChangeSceneToFile(path);
    }

    /// <summary>
    /// Reloads the currently active scene.
    /// </summary>
    /// <param name="tree">The current <see cref="SceneTree"/>.</param>
    public static void ReloadCurrentScene(SceneTree tree)
    {
        tree.ReloadCurrentScene();
    }

    /// <summary>
    /// Adds an instantiated scene as a child of the specified parent node,
    /// then returns the instance.
    /// </summary>
    /// <typeparam name="T">The expected root node type of the scene.</typeparam>
    /// <param name="parent">The node that will receive the new child.</param>
    /// <param name="path">The Godot resource path to the scene file.</param>
    /// <returns>The instantiated node after being added to the scene tree.</returns>
    public static T AddScene<T>(Node parent, string path) where T : Node
    {
        T instance = Instantiate<T>(path);
        parent.AddChild(instance);
        return instance;
    }
}
