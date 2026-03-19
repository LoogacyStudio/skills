using Godot;

namespace LoogacyStudio.Skills.Godot.Resources;

/// <summary>
/// Strongly-typed helpers for loading Godot resources with better error messages
/// and caching behaviour.
/// </summary>
public static class ResourceExtensions
{
    /// <summary>
    /// Loads a resource of type <typeparamref name="T"/> from the given path,
    /// throwing a descriptive <see cref="InvalidOperationException"/> if the
    /// resource cannot be found or is of the wrong type.
    /// </summary>
    /// <typeparam name="T">The expected resource type.</typeparam>
    /// <param name="path">The Godot resource path (e.g. <c>"res://data/config.tres"</c>).</param>
    /// <returns>The loaded resource cast to <typeparamref name="T"/>.</returns>
    /// <exception cref="InvalidOperationException">
    /// Thrown when the resource does not exist or is not of type <typeparamref name="T"/>.
    /// </exception>
    public static T LoadOrThrow<T>(string path) where T : Resource
    {
        return ResourceLoader.Load<T>(path)
            ?? throw new InvalidOperationException(
                $"Failed to load resource of type '{typeof(T).Name}' at path: {path}");
    }

    /// <summary>
    /// Tries to load a resource of type <typeparamref name="T"/> from
    /// <paramref name="path"/> and returns <c>null</c> on failure instead of
    /// throwing.
    /// </summary>
    /// <typeparam name="T">The expected resource type.</typeparam>
    /// <param name="path">The Godot resource path.</param>
    /// <returns>The loaded resource, or <c>null</c> if it could not be loaded.</returns>
    public static T? TryLoad<T>(string path) where T : Resource
    {
        return ResourceLoader.Load<T>(path);
    }

    /// <summary>
    /// Returns <c>true</c> if a resource exists at the given path and can be
    /// loaded as type <typeparamref name="T"/>.
    /// </summary>
    /// <typeparam name="T">The resource type to check for.</typeparam>
    /// <param name="path">The Godot resource path to test.</param>
    /// <returns><c>true</c> when the resource is available.</returns>
    public static bool Exists<T>(string path) where T : Resource
    {
        return ResourceLoader.Exists(path, typeof(T).Name);
    }
}
