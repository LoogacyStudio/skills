using Godot;

namespace LoogacyStudio.Skills.Godot.Input;

/// <summary>
/// Helper methods for reading player input using Godot's <see cref="global::Godot.Input"/>
/// and <see cref="InputMap"/> systems.
/// </summary>
public static class InputExtensions
{
    /// <summary>
    /// Returns a normalised 2-D movement vector assembled from four named
    /// input actions (e.g. the four arrow keys or WASD).
    /// </summary>
    /// <param name="left">The action name mapped to leftward movement.</param>
    /// <param name="right">The action name mapped to rightward movement.</param>
    /// <param name="up">The action name mapped to upward movement.</param>
    /// <param name="down">The action name mapped to downward movement.</param>
    /// <returns>A unit-length <see cref="Vector2"/>, or <see cref="Vector2.Zero"/> when no input is active.</returns>
    /// <example>
    /// <code>
    /// Vector2 dir = InputExtensions.GetMovementVector("ui_left", "ui_right", "ui_up", "ui_down");
    /// Velocity = dir * Speed;
    /// </code>
    /// </example>
    public static Vector2 GetMovementVector(
        string left  = "ui_left",
        string right = "ui_right",
        string up    = "ui_up",
        string down  = "ui_down")
    {
        return global::Godot.Input.GetVector(left, right, up, down);
    }

    /// <summary>
    /// Returns <c>true</c> if any of the given action names was just pressed
    /// this frame.
    /// </summary>
    /// <param name="actions">One or more input action names.</param>
    /// <returns><c>true</c> when at least one action was pressed this frame.</returns>
    public static bool IsAnyActionJustPressed(params string[] actions)
    {
        foreach (string action in actions)
        {
            if (global::Godot.Input.IsActionJustPressed(action))
            {
                return true;
            }
        }

        return false;
    }

    /// <summary>
    /// Returns <c>true</c> if all of the given action names are currently held.
    /// </summary>
    /// <param name="actions">One or more input action names.</param>
    /// <returns><c>true</c> when every listed action is currently pressed.</returns>
    public static bool AreAllActionsPressed(params string[] actions)
    {
        foreach (string action in actions)
        {
            if (!global::Godot.Input.IsActionPressed(action))
            {
                return false;
            }
        }

        return true;
    }

    /// <summary>
    /// Returns the analogue strength (0–1) of an input action.
    /// Useful for gamepad triggers and analogue sticks mapped to actions.
    /// </summary>
    /// <param name="action">The input action name.</param>
    /// <returns>A value in the range [0, 1].</returns>
    public static float GetActionStrength(string action)
    {
        return global::Godot.Input.GetActionStrength(action);
    }
}
