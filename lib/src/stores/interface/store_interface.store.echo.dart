import '../core/manager.store.echo.dart';

///
/// Interface representing a store in echo
///
/// This interface provides barbon's for creating various stores in echo, to manage
/// states using various strategies
///
/// It uses [EchoStoreManager] internally for dependency management
///
/// GenericType [T] Represents the type of state managed by the store.
///
abstract class EchoStoreInterface<T> {
  ///
  /// The store manager instance for managing dependencies and store updates.
  ///
  final EchoStoreManager _echoStore = EchoStoreManager();

  ///
  /// Internal cached state of the store to allow rapid access to store's state
  ///
  T _state;

  ///
  /// Callback function to auto update the state, it's called automatically if
  /// store needs to be updated according to its dependencies
  ///
  /// It's optional and can be set later.
  ///
  T Function(T value)? _updateCallback;

  ///
  /// Constructs an instance of [EchoStoreInterface] and registers it with the
  /// store manager.
  ///
  /// [state] - Initial state of the store.
  ///
  /// [updateCallback] - Optional callback for state updates, can also be set later
  ///
  EchoStoreInterface(
    this._state, {
    T Function(T value)? updateCallback,
  }) {
    // update current callback with new callback
    _updateCallback = updateCallback;

    // create a root node in directed graph to allow existence of dependent stores
    _echoStore.createRootNode(this);
  }

  ///
  /// Gets the current cached state of the store
  ///
  T get state => _state;

  ///
  /// Sets the new state and triggers an update to dependent stores.
  ///
  /// [newState] - The new state to be set.
  ///
  set state(T newState) {
    // update the current state
    _state = newState;

    // update dependent store nodes (if any)
    _echoStore.updateStoreNodes(this);
  }

  ///
  /// Abstract method to set new state. Must be implemented by subclasses.
  ///
  /// [newState] - The new state to be set.
  ///
  void set(T newState);

  ///
  /// Abstract method to update state using a callback. Must be implemented by
  /// subclasses.
  ///
  /// [callback] - Function to update the state.
  ///
  void update(T Function(T value) callback);

  ///
  /// Cleans up the store by removing it from the store manager. Must be
  /// implemented by subclasses to dispose any streams, objects, etc.
  ///
  void dispose() {
    _echoStore.deleteRoot(this);
  }

  ///
  /// Automatically updates the state using the provided or existing callback.
  ///
  /// This method is useful for internal state updates based on external changes.
  ///
  /// _Should not be overridden by subclass_
  ///
  /// **NOTE**: This method is also called internally to update current state of
  ///           the store if current store needs to be updated according to dependencies
  ///
  /// [newCallback] - Optional new callback for updating the state.
  ///
  void autoUpdate([T Function(T value)? newCallback]) {
    _updateCallback = newCallback ?? _updateCallback;
    if (_updateCallback != null) {
      state = _updateCallback!(_state);
    }
  }

  ///
  /// Adds a dependency to another store, establishing a directed relationship.
  ///
  /// [store] - The store which depends on current store
  ///
  /// Example:
  /// ```
  /// final counterStore = ValueStore<int>(1);
  /// final listStore = ObjectStore<List<int>>([]);
  ///
  /// // Adding listStore as a dependency of counterStore.
  /// // This means listStore will be updated when counterStore changes.
  /// counterStore.addDependency(listStore);
  /// ```
  ///
  void addDependency(EchoStoreInterface store) {
    _echoStore.addDependency(this, store);
  }

  ///
  /// Removes a dependency from another store.
  ///
  /// [store] - The store to remove the dependency from current store
  ///
  /// Example:
  /// ```
  /// final counterStore = ValueStore<int>(1);
  /// final listStore = ObjectStore<List<int>>([]);
  ///
  /// counterStore.addDependency(listStore);
  ///
  /// // Removing the dependency when it's no longer needed
  /// counterStore.removeDependency(listStore);
  /// ```
  ///
  void removeDependency(EchoStoreInterface store) {
    _echoStore.removeDependency(this, store);
  }

  ///
  /// Sets or updates the callback function for state updates.
  ///
  /// [callback] - The new callback function.
  ///
  /// Example:
  /// ```
  /// final counterStore = ValueStore<int>(0);
  ///
  /// // Setting a callback to update user's last login time
  /// counterStore.setUpdateCallback((val) {
  ///   return val++;
  /// });
  ///
  /// // Later, the callback can be updated or modified if needed
  /// counterStore.setUpdateCallback((val) {
  ///   return val + 2;
  /// });
  /// ```
  ///
  void setUpdateCallback(T Function(T value) callback) {
    _updateCallback = callback;
  }
}
