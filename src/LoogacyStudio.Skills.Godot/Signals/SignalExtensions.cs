using Godot;

namespace LoogacyStudio.Skills.Godot.Signals;

/// <summary>
/// Extension methods for working with Godot signals in C# using async/await.
/// </summary>
public static class SignalExtensions
{
    /// <summary>
    /// Awaits a Godot signal by name and returns a <see cref="Task"/> that
    /// completes when the signal is emitted.
    /// </summary>
    /// <param name="source">The object that will emit the signal.</param>
    /// <param name="signalName">The name of the signal to await.</param>
    /// <returns>A task that completes when the signal fires.</returns>
    /// <example>
    /// <code>
    /// await animationPlayer.WaitForSignalAsync(AnimationPlayer.SignalName.AnimationFinished);
    /// </code>
    /// </example>
    public static Task WaitForSignalAsync(this GodotObject source, StringName signalName)
    {
        var tcs = new TaskCompletionSource();

        void OnSignal()
        {
            source.Disconnect(signalName, global::Godot.Callable.From(OnSignal));
            tcs.SetResult();
        }

        source.Connect(signalName, global::Godot.Callable.From(OnSignal));
        return tcs.Task;
    }

    /// <summary>
    /// Awaits a Godot signal by name that provides one argument, and returns
    /// the argument value when the signal fires.
    /// </summary>
    /// <typeparam name="T">The type of the signal argument.</typeparam>
    /// <param name="source">The object that will emit the signal.</param>
    /// <param name="signalName">The name of the signal to await.</param>
    /// <returns>A task that completes with the signal argument value.</returns>
    public static Task<T> WaitForSignalAsync<T>(this GodotObject source, StringName signalName)
    {
        var tcs = new TaskCompletionSource<T>();

        void OnSignal(T arg)
        {
            source.Disconnect(signalName, global::Godot.Callable.From<T>(OnSignal));
            tcs.SetResult(arg);
        }

        source.Connect(signalName, global::Godot.Callable.From<T>(OnSignal));
        return tcs.Task;
    }

    /// <summary>
    /// Connects a signal to a lambda action so that it fires exactly once
    /// and then automatically disconnects itself.
    /// </summary>
    /// <param name="source">The object that emits the signal.</param>
    /// <param name="signalName">The name of the signal.</param>
    /// <param name="action">The action to invoke when the signal fires.</param>
    /// <returns>The <see cref="global::Godot.Callable"/> connected to the signal.</returns>
    public static global::Godot.Callable ConnectOnce(this GodotObject source, StringName signalName, Action action)
    {
        var callable = global::Godot.Callable.From(action);
        source.Connect(signalName, callable, (uint)GodotObject.ConnectFlags.OneShot);
        return callable;
    }
}
