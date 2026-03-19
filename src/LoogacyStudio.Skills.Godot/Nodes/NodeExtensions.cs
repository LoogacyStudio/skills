using Godot;

namespace LoogacyStudio.Skills.Godot.Nodes;

/// <summary>
/// Extension methods for <see cref="Node"/> to simplify common operations
/// in Godot 4 C# projects.
/// </summary>
public static class NodeExtensions
{
    /// <summary>
    /// Tries to get a child node of the specified type by name.
    /// Returns <c>null</c> if not found or the type does not match.
    /// </summary>
    /// <typeparam name="T">The expected node type.</typeparam>
    /// <param name="node">The parent node.</param>
    /// <param name="name">The name of the child node.</param>
    /// <returns>The child node cast to <typeparamref name="T"/>, or <c>null</c>.</returns>
    public static T? GetChildOrNull<T>(this Node node, string name) where T : Node
    {
        Node? child = node.FindChild(name);
        return child as T;
    }

    /// <summary>
    /// Returns the first child of type <typeparamref name="T"/>, or <c>null</c>
    /// if no matching child exists.
    /// </summary>
    /// <typeparam name="T">The type of child to find.</typeparam>
    /// <param name="node">The parent node.</param>
    /// <returns>The first matching child, or <c>null</c>.</returns>
    public static T? GetFirstChildOfType<T>(this Node node) where T : Node
    {
        foreach (Node child in node.GetChildren())
        {
            if (child is T typed)
            {
                return typed;
            }
        }

        return null;
    }

    /// <summary>
    /// Safely queues a node for deletion only if it is currently inside the scene tree.
    /// </summary>
    /// <param name="node">The node to remove.</param>
    public static void SafeQueueFree(this Node node)
    {
        if (global::Godot.GodotObject.IsInstanceValid(node))
        {
            node.QueueFree();
        }
    }

    /// <summary>
    /// Adds a child node and sets its owner to the scene root so the node
    /// is serialised when the scene is saved. This method is intended for
    /// use in <b>editor tool scripts</b> only; at runtime <c>EditedSceneRoot</c>
    /// is <c>null</c> and ownership assignment is skipped.
    /// </summary>
    /// <param name="parent">The node that will receive the new child.</param>
    /// <param name="child">The child node to add.</param>
    public static void AddChildWithOwner(this Node parent, Node child)
    {
        parent.AddChild(child);
        Node? sceneRoot = parent.GetTree().EditedSceneRoot;
        if (sceneRoot is not null)
        {
            child.Owner = sceneRoot;
        }
    }

    /// <summary>
    /// Removes all children from a node and queues them for deletion.
    /// </summary>
    /// <param name="node">The node whose children will be cleared.</param>
    public static void ClearChildren(this Node node)
    {
        foreach (Node child in node.GetChildren())
        {
            node.RemoveChild(child);
            child.QueueFree();
        }
    }
}
