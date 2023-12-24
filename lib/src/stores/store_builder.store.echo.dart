import 'package:flutter/material.dart';

import 'store_impl.store.echo.dart';

///
/// A widget that listens to a [Store] and rebuilds its child when the store's value changes.
///
/// GenericType [T]: Represents the type of the value managed by the [Store].
///
/// This widget uses a [ValueListenableBuilder] to listen to changes in the [Store]'s value
/// and rebuilds its child widget accordingly.
///
/// Parameters:
/// - [widget]: A function that returns a widget to be rebuilt when the store's value changes.
/// - [store]: The [Store] instance whose value changes are to be listened to.
///
/// Example:
/// ```
/// final counterStore = Store<int>(0);
///
/// StoreBuilder<int>(
///   store: counterStore,
///   widget: (context, value) {
///     return Text("Current value: $value");
///   },
/// );
/// ```
///
/// In this example, a `StoreBuilder` is used to create a `Text` widget that
/// displays the current value of `counterStore`. Whenever `counterStore` updates its
/// value, the `Text` widget will automatically rebuild to reflect the new value.
///
class StoreBuilder<T> extends StatelessWidget {
  ///
  /// A builder function that takes the current build context and the current value,
  /// and returns a widget.
  ///
  /// This function is called every time the [store]'s value changes.
  ///
  final Widget Function(BuildContext context, T value) widget;

  ///
  /// The [Store] instance to listen to for value changes.
  ///
  final Store<T> store;

  const StoreBuilder({
    Key? key,
    required this.widget,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: store.listener,
      builder: (context, value, _) {
        // Build the widget with the current value.
        return widget(context, value);
      },
    );
  }
}
