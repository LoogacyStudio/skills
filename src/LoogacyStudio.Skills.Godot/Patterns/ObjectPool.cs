namespace LoogacyStudio.Skills.Godot.Patterns;

/// <summary>
/// A generic object pool that reuses instances to reduce garbage-collection
/// pressure in performance-sensitive Godot game loops.
/// </summary>
/// <typeparam name="T">The type of object to pool.</typeparam>
/// <example>
/// <code>
/// // Create a pool of bullets, pre-warmed with 20 instances.
/// var pool = new ObjectPool&lt;Bullet&gt;(
///     factory:  () => new Bullet(),
///     onGet:    b => b.Reset(),
///     onReturn: b => b.Disable(),
///     initialSize: 20);
///
/// // Acquire an instance from the pool.
/// Bullet bullet = pool.Get();
///
/// // Return the instance when done.
/// pool.Return(bullet);
/// </code>
/// </example>
public sealed class ObjectPool<T> where T : class
{
    private readonly Stack<T> _available;
    private readonly Func<T>  _factory;
    private readonly Action<T>? _onGet;
    private readonly Action<T>? _onReturn;
    private readonly int _maxSize;

    /// <summary>Gets the number of instances currently available in the pool.</summary>
    public int AvailableCount => _available.Count;

    /// <summary>Gets the total number of instances created by this pool.</summary>
    public int TotalCreated { get; private set; }

    /// <summary>
    /// Initialises the pool.
    /// </summary>
    /// <param name="factory">
    /// A factory function that creates a new instance when the pool is empty.
    /// </param>
    /// <param name="onGet">
    /// An optional action invoked on an instance just before it is returned by <see cref="Get"/>.
    /// Use this to reset state.
    /// </param>
    /// <param name="onReturn">
    /// An optional action invoked on an instance just after it is passed to <see cref="Return"/>.
    /// Use this to disable/deactivate the object.
    /// </param>
    /// <param name="initialSize">Number of instances to create immediately (warm-up).</param>
    /// <param name="maxSize">
    /// Maximum number of idle instances to keep. Instances returned beyond this
    /// limit are discarded. Use 0 for unlimited.
    /// </param>
    public ObjectPool(
        Func<T> factory,
        Action<T>? onGet    = null,
        Action<T>? onReturn = null,
        int initialSize = 0,
        int maxSize     = 0)
    {
        ArgumentNullException.ThrowIfNull(factory);

        _factory  = factory;
        _onGet    = onGet;
        _onReturn = onReturn;
        _maxSize  = maxSize;
        _available = new Stack<T>(Math.Max(initialSize, 4));

        for (int i = 0; i < initialSize; i++)
        {
            T instance = _factory();
            TotalCreated++;
            _onReturn?.Invoke(instance);
            _available.Push(instance);
        }
    }

    /// <summary>
    /// Returns an instance from the pool, creating one if necessary.
    /// </summary>
    /// <returns>A ready-to-use instance of <typeparamref name="T"/>.</returns>
    public T Get()
    {
        T instance;
        if (_available.Count > 0)
        {
            instance = _available.Pop();
        }
        else
        {
            instance = _factory();
            TotalCreated++;
        }

        _onGet?.Invoke(instance);
        return instance;
    }

    /// <summary>
    /// Returns an instance to the pool so it can be reused.
    /// </summary>
    /// <param name="instance">The instance to return.</param>
    public void Return(T instance)
    {
        ArgumentNullException.ThrowIfNull(instance);

        if (_maxSize > 0 && _available.Count >= _maxSize)
        {
            return;
        }

        _onReturn?.Invoke(instance);
        _available.Push(instance);
    }

    /// <summary>
    /// Empties the pool, discarding all idle instances.
    /// </summary>
    public void Clear()
    {
        _available.Clear();
    }
}
