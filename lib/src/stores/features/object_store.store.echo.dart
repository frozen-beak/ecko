import 'dart:async';
import 'package:paw/paw.dart';

import '../interface/store_interface.store.echo.dart';

///
/// A specialized implementation of [EchoStoreInterface] for managing and updating
/// complex object states like list, maps, objects etc.
///
/// It extends the capabilities of [EchoStoreInterface] by introducing
/// stream-based state updates and lifecycle logging.
///
/// This store is suitable for complex state objects and provides a stream for
/// listening to state changes. It's useful in scenarios where widgets or other
/// components need to reactively update when the state changes.
///
/// GenericType [T]: Represents the type of complex state managed by the store.
///
/// Example:
/// ```
/// // store to hold list of int
/// final store = ObjectStore<List<int>>([1,2])
/// ```
///
class ObjectStore<T> extends EchoStoreInterface<T> {
  ///
  /// Instance of logger.
  ///
  final _paw = Paw();

  ///
  /// StreamController for broadcasting state changes.
  ///
  late final StreamController<T> _streamController;

  ///
  /// Constructor for [ObjectStore].
  ///
  /// Initializes the store with an initial state and optional update callback.
  /// It also sets up a broadcast stream controller for state changes.
  ///
  /// [state]: The initial state of the store.
  /// [updateCallback]: Optional callback for state updates.
  ///
  ObjectStore(T state, {T Function(T value)? updateCallback})
      : super(
          state,
          updateCallback: updateCallback,
        ) {
    // init the stream for the store
    _streamController = StreamController<T>.broadcast();

    // add cached state to the streamController
    _streamController.add(super.state);

    _paw.info("Created ${toString()} - $hashCode");
  }

  ///
  /// Provides a stream to listen to state changes.
  ///
  /// Returns a broadcast stream that emits updates when the state changes.
  ///
  /// **NOTE**: To be used internally by the builder to listen to state changes
  ///
  Stream<T> get listener => _streamController.stream;

  @override
  set state(T newState) {
    super.state = newState;

    // initiate the streamController with current state
    _streamController.add(super.state);
  }

  @override
  void dispose() {
    // Close the stream controller on disposal to avoid memory leaks.
    _streamController.close();

    // Call the dispose method of the base class.
    super.dispose();

    _paw.info("Disposed ${toString()} - $hashCode");
  }

  ///
  /// Function to update current state with newState
  ///
  /// Example:
  /// ```
  /// // store to hold list of int
  /// final store = ObjectStore<List<int>>([1,2])
  ///
  /// // update current list with an empty list
  /// store.set([])
  /// ```
  @override
  void set(T newState) => state = newState;

  ///
  /// Function to update current state with an update callback
  ///
  /// Example:
  /// ```
  /// // store to hold list of int
  /// final store = ObjectStore<List<int>>([1,2])
  ///
  /// // add 3 to a current list of item
  /// store.update((val) => val..add(3));
  /// ```
  @override
  void update(T Function(T value) callback) => state = callback(super.state);

  @override
  String toString() {
    // Provides a string representation of the ObjectStore for debugging purposes.
    return "ObjectStore<$T>";
  }
}
