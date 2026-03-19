using LoogacyStudio.Skills.Godot.Patterns;
using Xunit;

namespace LoogacyStudio.Skills.Godot.Tests.Patterns;

public class ObjectPoolTests
{
    private sealed class PooledItem
    {
        public bool IsActive { get; set; } = true;
        public int Id { get; set; }

        public void Reset() => IsActive = true;
        public void Deactivate() => IsActive = false;
    }

    [Fact]
    public void Get_CreatesNewInstance_WhenPoolIsEmpty()
    {
        int nextId = 0;
        var pool = new ObjectPool<PooledItem>(() => new PooledItem { Id = ++nextId });

        PooledItem item = pool.Get();

        Assert.NotNull(item);
        Assert.Equal(1, item.Id);
        Assert.Equal(1, pool.TotalCreated);
    }

    [Fact]
    public void Return_ThenGet_ReusesInstance()
    {
        var pool = new ObjectPool<PooledItem>(() => new PooledItem());

        PooledItem first = pool.Get();
        pool.Return(first);

        PooledItem second = pool.Get();

        Assert.Same(first, second);
        Assert.Equal(1, pool.TotalCreated);
    }

    [Fact]
    public void OnGet_IsCalledWhenInstanceIsAcquired()
    {
        bool onGetCalled = false;
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            onGet: _ => onGetCalled = true);

        pool.Get();

        Assert.True(onGetCalled);
    }

    [Fact]
    public void OnReturn_IsCalledWhenInstanceIsReturned()
    {
        bool onReturnCalled = false;
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            onReturn: _ => onReturnCalled = true);

        PooledItem item = pool.Get();
        pool.Return(item);

        Assert.True(onReturnCalled);
    }

    [Fact]
    public void InitialSize_PreWarms_CorrectNumberOfInstances()
    {
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            initialSize: 5);

        Assert.Equal(5, pool.AvailableCount);
        Assert.Equal(5, pool.TotalCreated);
    }

    [Fact]
    public void AvailableCount_IncreasesAfterReturn()
    {
        var pool = new ObjectPool<PooledItem>(() => new PooledItem());

        PooledItem item = pool.Get();
        Assert.Equal(0, pool.AvailableCount);

        pool.Return(item);
        Assert.Equal(1, pool.AvailableCount);
    }

    [Fact]
    public void MaxSize_LimitsIdleInstances()
    {
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            maxSize: 2);

        PooledItem a = pool.Get();
        PooledItem b = pool.Get();
        PooledItem c = pool.Get();

        pool.Return(a);
        pool.Return(b);
        pool.Return(c); // should be discarded

        Assert.Equal(2, pool.AvailableCount);
    }

    [Fact]
    public void Clear_EmptiesPool()
    {
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            initialSize: 10);

        pool.Clear();

        Assert.Equal(0, pool.AvailableCount);
    }

    [Fact]
    public void Get_CreatesNewInstance_WhenPoolIsExhausted()
    {
        var pool = new ObjectPool<PooledItem>(
            factory: () => new PooledItem(),
            initialSize: 2);

        // Exhaust the pool
        pool.Get();
        pool.Get();

        // Third item must be freshly created
        PooledItem third = pool.Get();
        Assert.NotNull(third);
        Assert.Equal(3, pool.TotalCreated);
    }

    [Fact]
    public void Return_Null_ThrowsArgumentNullException()
    {
        var pool = new ObjectPool<PooledItem>(() => new PooledItem());

        Assert.Throws<ArgumentNullException>(() => pool.Return(null!));
    }

    [Fact]
    public void Constructor_NullFactory_ThrowsArgumentNullException()
    {
        Assert.Throws<ArgumentNullException>(() =>
            new ObjectPool<PooledItem>(null!));
    }
}
