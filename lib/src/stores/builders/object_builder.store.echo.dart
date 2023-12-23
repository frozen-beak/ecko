import 'package:flutter/material.dart';

import '../features/object_store.store.echo.dart';

///
/// A widget that listens to an [ObjectStore] and rebuilds its child when the
/// store's state changes.
///
/// GenericType [T]: Represents the type of the state managed by the [ObjectStore].
///
///
/// Parameters:
/// - [widget]: A function that returns a widget to be rebuilt when the store's state changes.
/// - [store]: The [ObjectStore] instance whose state changes are to be listened to.
///
/// Example:
/// ```
/// final store = ObjectStore<List<int>>([0,1,2,3,4]);
///
/// ObjectStoreBuilder<List<int>>(
///   store: store,
///   widget: (context, data) {
///     return Text(data.toString());
///   },
/// );
/// ```
///
/// In this example, an `ObjectStoreBuilder` is used to create a `Text` widget
/// that displays the current state of `store`. Whenever `store` updates its
/// state, the `Text` widget will automatically rebuild to reflect the new state.
///
class ObjectStoreBuilder<T> extends StatelessWidget {
  ///
  /// A builder function that takes the current build context and the current state,
  /// and returns a widget.
  ///
  /// This function is called every time the [store]'s state changes.
  ///
  final Widget Function(BuildContext context, T state) widget;

  ///
  /// The [ObjectStore] instance to listen to for state changes.
  ///
  final ObjectStore<T> store;

  const ObjectStoreBuilder({
    Key? key,
    required this.widget,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: store.listener,
      initialData: store.state,
      builder: (context, snapshot) {
        // The new state is obtained from the snapshot. If it's null (which is rare),
        // the previous state from the store is used.
        T currentState = snapshot.data ?? store.state;

        // Build the widget with the current state.
        return widget(context, currentState);
      },
    );
  }
}
