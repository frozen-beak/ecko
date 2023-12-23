import 'package:flutter/widgets.dart';

import '../builders/value_builder.store.echo.dart';
import '../features/value_store.store.echo.dart';

///
/// An abstract widget that simplifies the management of a [ValueStore] within
/// a [StatefulWidget].
///
/// This widget abstracts the creation, initialization, and disposal of a
/// [ValueStore], allowing developers to focus on building their UI and reacting to state changes.
///
/// GenericType [T]: Represents the type of the value managed by the [ValueStore].
///
/// Usage:
///
/// Extend this class to create a stateful widget that has its own [ValueStore].
/// Implement the `build` method to define the UI and use the provided `state`
/// value. You can also override `onInit` and `onDispose` for additional setup
/// and teardown tasks.
///
/// Example:
/// ```
/// class MyCounterWidget extends ValueStateWidget<int> {
///   MyCounterWidget({required int initialCount}) : super(state: initialCount);
///
///   @override
///   Widget build(BuildContext context, int state) {
///     return ElevatedButton(
///       child: Text('Count: $state'),
///       onPressed: () => valueStore.update((value) => value + 1),
///     );
///   }
/// }
/// ```
///
/// In this example, `MyCounterWidget` extends `ValueStateWidget<int>`, managing an integer state.
/// The `build` method creates an `ElevatedButton` that displays the current count and increments it
/// when pressed.
///
abstract class ValueStateWidget<T> extends StatefulWidget {
  /// The initial state of the widget.
  final T state;

  /// The [ValueStore] that holds and manages the state of the widget.
  late final ValueStore<T> valueStore;

  ValueStateWidget({
    required this.state,
    Key? key,
  }) : super(key: key) {
    valueStore = ValueStore<T>(state);
  }

  ///
  /// The method to build the widget based on the current state.
  ///
  /// Override this method to define the UI of your widget.
  ///
  Widget build(BuildContext context, T state);

  ///
  /// Called when the widget is inserted into the tree.
  ///
  /// Override to perform initialization that depends on the context or the state.
  ///
  void onInit() {}

  ///
  /// Called when the widget is removed from the tree permanently.
  ///
  /// Override to perform disposal of resources like controllers, listeners, etc.
  ///
  void onDispose() {}

  @override
  ValueStateWidgetState createState() => ValueStateWidgetState();
}

class ValueStateWidgetState<T> extends State<ValueStateWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    widget.valueStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<T>(
      store: widget.valueStore as ValueStore<T>,
      widget: (ctx, state) => widget.build(ctx, state),
    );
  }
}
