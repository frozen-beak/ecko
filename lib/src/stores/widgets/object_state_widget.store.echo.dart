import 'package:flutter/widgets.dart';

import '../builders/object_builder.store.echo.dart';
import '../features/object_store.store.echo.dart';

///
/// An abstract widget that simplifies the management of an [ObjectStore] within
/// a [StatefulWidget].
///
/// This widget abstracts the creation, initialization, and disposal of an
/// [ObjectStore], allowing developers to focus on building their UI and
/// reacting to state changes with complex objects.
///
/// GenericType [T]: Represents the type of the complex object managed by
/// the [ObjectStore].
///
/// Usage:
///
/// Extend this class to create a stateful widget that has its own [ObjectStore].
/// Implement the `build` method to define the UI and use the provided `state` value.
/// You can also override `onInit` and `onDispose` for additional setup and teardown tasks.
///
/// Example:
/// ```
/// class MyListWidget extends ObjectStateWidget<List<String>> {
///   MyListWidget({required List<String> initialList}) : super(state: initialList);
///
///   @override
///   Widget build(BuildContext context, List<String> state) {
///     return ListView.builder(
///       itemCount: state.length,
///       itemBuilder: (context, index) => ListTile(title: Text(state[index])),
///     );
///   }
/// }
/// ```
///
/// In this example, `MyListWidget` extends `ObjectStateWidget<List<String>>`,
/// managing a list of strings. The `build` method creates a `ListView` that
/// displays the items of the list.
///
abstract class ObjectStateWidget<T> extends StatefulWidget {
  /// The initial state of the widget.
  final T state;

  /// The [ObjectStore] that holds and manages the state of the widget.
  late final ObjectStore<T> store;

  ObjectStateWidget({
    required this.state,
    Key? key,
  }) : super(key: key) {
    store = ObjectStore<T>(state);
  }

  /// The method to build the widget based on the current state.
  ///
  /// Override this method to define the UI of your widget.
  Widget build(BuildContext context, T state);

  /// Called when the widget is inserted into the tree.
  ///
  /// Override to perform initialization that depends on the context or the state.
  void onInit() {}

  /// Called when the widget is removed from the tree permanently.
  ///
  /// Override to perform disposal of resources like controllers, listeners, etc.
  void onDispose() {}

  @override
  StreamStateWidgetState createState() => StreamStateWidgetState();
}

class StreamStateWidgetState<T> extends State<ObjectStateWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  void dispose() {
    widget.onDispose();
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectStoreBuilder<T>(
      store: widget.store as ObjectStore<T>,
      widget: (ctx, state) => widget.build(ctx, state),
    );
  }
}
