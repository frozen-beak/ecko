import 'package:flutter/material.dart';

import '../utils/logger.util.ecko.dart';
import 'core/interface.store.ecko.dart';

///
/// A specialized implementation of [StoreInterface] for managing and updating
/// single object states such as primitives, custom objects, etc.
///
/// Extends the capabilities of [StoreInterface] by leveraging [ValueNotifier]
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
class Store<T> extends StoreInterface<T> with ChangeNotifier {
  ///
  /// Instance of logger.
  ///
  final _logger = EckoLogger();

  ///
  /// ValueNotifier for reactive updates to the state.
  ///
  late final ValueNotifier<T> _valueNotifier;

  ///
  /// Constructor for [Store].
  ///
  /// Initializes the store with an initial state and an optional update callback.
  /// It sets up a [ValueNotifier] to notify listeners of state changes.
  ///
  /// [state]: The initial state of the store.
  /// [updateCallback]: Optional callback for state updates.
  ///
  Store(T state, {T Function(T value)? updateCallback})
      : super(
          state,
          updateCallback: updateCallback,
        ) {
    // init the valueNotifier with cached state
    _valueNotifier = ValueNotifier<T>(super.state);

    _logger.info("Created ${toString()} - $hashCode");
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

    // Check if T is not int, double, String or bool
    if (!(newState is int ||
        newState is double ||
        newState is String ||
        newState is bool)) {
      // notify only if [T] is object, map, list, etc.
      _valueNotifier.notifyListeners();
    }
  }

  @override
  void dispose() {
    // Dispose the ValueNotifier to release resources.
    _valueNotifier.dispose();

    // Call the dispose method of the base class.
    super.dispose();

    _logger.info("Disposed ${toString()} - $hashCode");
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
