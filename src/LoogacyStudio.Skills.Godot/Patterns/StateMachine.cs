namespace LoogacyStudio.Skills.Godot.Patterns;

/// <summary>
/// A lightweight, general-purpose hierarchical state machine suitable for
/// Godot 4 game objects. States are represented by any comparable type
/// (typically an <c>enum</c>).
/// </summary>
/// <typeparam name="TState">
/// The type used to identify states. An <c>enum</c> is the most common choice.
/// </typeparam>
/// <example>
/// <code>
/// public enum PlayerState { Idle, Running, Jumping }
///
/// var fsm = new StateMachine&lt;PlayerState&gt;(PlayerState.Idle);
/// fsm.AddTransition(PlayerState.Idle,    PlayerState.Running, () => isMoving);
/// fsm.AddTransition(PlayerState.Running, PlayerState.Idle,    () => !isMoving);
/// fsm.OnEnter(PlayerState.Jumping, () => PlayJumpAnimation());
///
/// // In _Process / _PhysicsProcess:
/// fsm.Update();
/// </code>
/// </example>
public sealed class StateMachine<TState> where TState : notnull
{
    private readonly record struct Transition(TState From, TState To, Func<bool> Condition);

    private readonly List<Transition> _transitions = new();
    private readonly Dictionary<TState, Action> _onEnterHandlers = new();
    private readonly Dictionary<TState, Action> _onExitHandlers  = new();
    private readonly Dictionary<TState, Action> _onUpdateHandlers = new();

    /// <summary>Gets the current state of the machine.</summary>
    public TState CurrentState { get; private set; }

    /// <summary>Gets the state the machine was in before the last transition.</summary>
    public TState PreviousState { get; private set; }

    /// <summary>
    /// Raised after every successful state transition.
    /// The first argument is the state that was left; the second is the new state.
    /// </summary>
    public event Action<TState, TState>? StateChanged;

    /// <summary>Initialises the state machine with the given starting state.</summary>
    /// <param name="initialState">The state the machine starts in.</param>
    public StateMachine(TState initialState)
    {
        CurrentState  = initialState;
        PreviousState = initialState;
    }

    /// <summary>
    /// Registers a guarded transition between two states.
    /// On each call to <see cref="Update"/>, if the machine is in
    /// <paramref name="from"/> and <paramref name="condition"/> returns
    /// <c>true</c>, it transitions to <paramref name="to"/>.
    /// </summary>
    public StateMachine<TState> AddTransition(TState from, TState to, Func<bool> condition)
    {
        _transitions.Add(new Transition(from, to, condition));
        return this;
    }

    /// <summary>Registers an action to run when entering <paramref name="state"/>.</summary>
    public StateMachine<TState> OnEnter(TState state, Action handler)
    {
        _onEnterHandlers[state] = handler;
        return this;
    }

    /// <summary>Registers an action to run when exiting <paramref name="state"/>.</summary>
    public StateMachine<TState> OnExit(TState state, Action handler)
    {
        _onExitHandlers[state] = handler;
        return this;
    }

    /// <summary>
    /// Registers an action to run every time <see cref="Update"/> is called
    /// while the machine is in <paramref name="state"/>.
    /// </summary>
    public StateMachine<TState> OnUpdate(TState state, Action handler)
    {
        _onUpdateHandlers[state] = handler;
        return this;
    }

    /// <summary>
    /// Evaluates all registered transitions for the current state, executes
    /// the first matching one, and then calls any per-state update handler.
    /// Call this every game tick (typically from <c>_Process</c> or
    /// <c>_PhysicsProcess</c>).
    /// </summary>
    public void Update()
    {
        foreach (Transition t in _transitions)
        {
            if (EqualityComparer<TState>.Default.Equals(t.From, CurrentState) && t.Condition())
            {
                TransitionTo(t.To);
                break;
            }
        }

        if (_onUpdateHandlers.TryGetValue(CurrentState, out Action? update))
        {
            update();
        }
    }

    /// <summary>
    /// Forces an immediate transition to <paramref name="newState"/>,
    /// ignoring any registered conditions.
    /// </summary>
    public void ForceTransition(TState newState)
    {
        TransitionTo(newState);
    }

    private void TransitionTo(TState newState)
    {
        if (_onExitHandlers.TryGetValue(CurrentState, out Action? exit))
        {
            exit();
        }

        PreviousState = CurrentState;
        CurrentState  = newState;

        StateChanged?.Invoke(PreviousState, CurrentState);

        if (_onEnterHandlers.TryGetValue(CurrentState, out Action? enter))
        {
            enter();
        }
    }
}
