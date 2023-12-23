import 'package:flutter/material.dart';
import 'package:paw/paw.dart';

import '../interface/store_interface.store.echo.dart';

///
/// A specialized implementation of [EchoStoreInterface] for managing and updating
/// single object states such as primitives, custom objects, etc.
///
/// Extends the capabilities of [EchoStoreInterface] by leveraging [ValueNotifier]
/// for reactive state updates and lifecycle logging.
///
/// This store is ideal for simpler, single-value states, providing a [ValueNotifier]
/// for widgets to rebuild reactively when the state changes.
///
/// GenericType [T]: Represents the type of the state managed by the store.
///
/// Example:
/// ```
/// // Store to hold an integer value
/// final counterStore = ValueStore<int>(0);
/// ```
///
class ValueStore<T> extends EchoStoreInterface<T> {
  ///
  /// Instance of logger.
  ///
  final _paw = Paw();

  ///
  /// ValueNotifier for reactive updates to the state.
  ///
  late final ValueNotifier<T> _valueNotifier;

  ///
  /// Constructor for [ValueStore].
  ///
  /// Initializes the store with an initial state and an optional update callback.
  /// It sets up a [ValueNotifier] to notify listeners of state changes.
  ///
  /// [state]: The initial state of the store.
  /// [updateCallback]: Optional callback for state updates.
  ///
  ValueStore(T state, {T Function(T value)? updateCallback})
      : super(
          state,
          updateCallback: updateCallback,
        ) {
    // init the valueNotifier with cached state
    _valueNotifier = ValueNotifier<T>(super.state);

    _paw.info("Created ${toString()} - $hashCode");
  }

  ///
  /// Provides a [ValueNotifier] to listen to state changes.
  ///
  /// Returns a [ValueNotifier] that can be used by Flutter widgets to rebuild
  /// reactively when the state changes.
  ///
  ValueNotifier<T> get listener => _valueNotifier;

  @override
  set state(T newState) {
    super.state = newState;

    // Update the ValueNotifier with the new state.
    _valueNotifier.value = super.state;
  }

  @override
  void dispose() {
    // Dispose the ValueNotifier to release resources.
    _valueNotifier.dispose();

    // Call the dispose method of the base class.
    super.dispose();

    _paw.info("Disposed ${toString()} - $hashCode");
  }

  ///
  /// Function to update the current state with newState.
  ///
  /// Example:
  /// ```
  /// // Store to hold an integer value
  /// final counterStore = ValueStore<int>(0);
  ///
  /// // Update the value to 5
  /// counterStore.set(5);
  /// ```
  @override
  void set(T newState) => state = newState;

  ///
  /// Function to update the current state with an update callback.
  ///
  /// Example:
  /// ```
  /// // Store to hold an integer value
  /// final counterStore = ValueStore<int>(0);
  ///
  /// // Increment the current value by 1
  /// counterStore.update((val) => val + 1);
  /// ```
  @override
  void update(T Function(T value) callback) => state = callback(super.state);

  @override
  String toString() {
    return "ValueStore<$T>";
  }
}
