using LoogacyStudio.Skills.Godot.Patterns;
using Xunit;

namespace LoogacyStudio.Skills.Godot.Tests.Patterns;

public class StateMachineTests
{
    private enum State { Idle, Running, Jumping, Dead }

    [Fact]
    public void InitialState_IsSetCorrectly()
    {
        var fsm = new StateMachine<State>(State.Idle);

        Assert.Equal(State.Idle, fsm.CurrentState);
        Assert.Equal(State.Idle, fsm.PreviousState);
    }

    [Fact]
    public void Update_TransitionsWhenConditionIsTrue()
    {
        bool isMoving = false;
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => isMoving);

        fsm.Update();
        Assert.Equal(State.Idle, fsm.CurrentState);

        isMoving = true;
        fsm.Update();
        Assert.Equal(State.Running, fsm.CurrentState);
    }

    [Fact]
    public void Update_DoesNotTransitionWhenConditionIsFalse()
    {
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => false);

        fsm.Update();

        Assert.Equal(State.Idle, fsm.CurrentState);
    }

    [Fact]
    public void ForceTransition_ChangesStateImmediately()
    {
        var fsm = new StateMachine<State>(State.Idle);

        fsm.ForceTransition(State.Dead);

        Assert.Equal(State.Dead, fsm.CurrentState);
        Assert.Equal(State.Idle, fsm.PreviousState);
    }

    [Fact]
    public void OnEnter_IsCalledWhenStateIsEntered()
    {
        bool entered = false;
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => true);
        fsm.OnEnter(State.Running, () => entered = true);

        fsm.Update();

        Assert.True(entered);
    }

    [Fact]
    public void OnExit_IsCalledWhenStateIsLeft()
    {
        bool exited = false;
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => true);
        fsm.OnExit(State.Idle, () => exited = true);

        fsm.Update();

        Assert.True(exited);
    }

    [Fact]
    public void OnUpdate_IsCalledEachTickInCurrentState()
    {
        int callCount = 0;
        var fsm = new StateMachine<State>(State.Idle);
        fsm.OnUpdate(State.Idle, () => callCount++);

        fsm.Update();
        fsm.Update();
        fsm.Update();

        Assert.Equal(3, callCount);
    }

    [Fact]
    public void StateChanged_EventFires_WithCorrectArguments()
    {
        State? fromState = null;
        State? toState   = null;

        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => true);
        fsm.StateChanged += (from, to) => { fromState = from; toState = to; };

        fsm.Update();

        Assert.Equal(State.Idle,    fromState);
        Assert.Equal(State.Running, toState);
    }

    [Fact]
    public void PreviousState_TracksLastState()
    {
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle,    State.Running, () => true);
        fsm.AddTransition(State.Running, State.Jumping, () => true);

        fsm.Update(); // Idle → Running
        Assert.Equal(State.Idle, fsm.PreviousState);

        fsm.Update(); // Running → Jumping
        Assert.Equal(State.Running, fsm.PreviousState);
    }

    [Fact]
    public void MultipleTransitions_FirstMatchingTransitionWins()
    {
        var fsm = new StateMachine<State>(State.Idle);
        fsm.AddTransition(State.Idle, State.Running, () => true);
        fsm.AddTransition(State.Idle, State.Jumping, () => true);

        fsm.Update();

        Assert.Equal(State.Running, fsm.CurrentState);
    }

    [Fact]
    public void FluentApi_AllowsMethodChaining()
    {
        // Should not throw; verifies that the fluent API returns `this`.
        var fsm = new StateMachine<State>(State.Idle)
            .AddTransition(State.Idle, State.Running, () => false)
            .OnEnter(State.Running, () => { })
            .OnExit(State.Idle, () => { })
            .OnUpdate(State.Idle, () => { });

        Assert.Equal(State.Idle, fsm.CurrentState);
    }
}
