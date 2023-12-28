import '../utils/hash.util.echo.dart';
import '../utils/logger.util.echo.dart';
import 'interface.controller.echo.dart';

///
/// [EchoControllerManagerMixin] is a mixin that provides functionality to manage
/// EchoControllers within the Echo state management framework
///
/// This mixin allows for creating, retrieving, and disposing of EchoController
/// instances.
///
/// It ensures that each controller is uniquely identified and properly managed
/// throughout its lifecycle.
///
mixin EchoControllerManagerMixin {
  ///
  /// A private instance of the Paw logger for logging purposes.
  ///
  final EchoLogger _logger = EchoLogger();

  ///
  /// A map to store the active EchoController instances, keyed by their GlobalKey.
  ///
  final Map<int, EchoController> _controllers = {};

  ///
  /// Puts (or retrieves) a controller of type [T] into the controllers map.
  ///
  /// If a controller of the same type and key already exists, it returns the
  /// existing instance.
  ///
  /// Otherwise, it creates a new instance using the provided [create] function,
  /// initializes it, and then returns it.
  ///
  /// - [create]: A function that returns a new instance of the controller.
  /// - Returns: An instance of the controller of type [T].
  ///
  /// Example:
  /// ```
  /// class MyController extends EchoController {}
  ///
  /// final manager = EchoControllerManagerMixin();
  /// final myController = manager.put(() => MyController());
  /// ```
  ///
  T put<T extends EchoController>(T Function() create) {
    final key = EchoHashUtil.generateTypeHash<T>();

    var controller = _controllers[key];

    if (controller != null) {
      _logger.info(
        "Fetched already created instance of $controller:$key",
      );

      return controller as T;
    }

    // if not already present, create a new controller
    controller = create();

    // add controller in the map
    _controllers[key] = controller;

    controller.onInit();

    _logger.info("Created $controller:$key");

    return controller as T;
  }

  ///
  /// Deletes an existing controller from the controllers map.
  ///
  /// Calls the `onDispose` method of the controller and removes it from the map.
  /// Logs an error if the controller is not found or has already been deleted.
  ///
  /// - [controller]: The controller instance to delete.
  ///
  /// Example:
  /// ```
  /// class MyController extends EchoController {}
  ///
  /// final manager = EchoControllerManagerMixin();
  ///
  /// // put your controller on memory
  /// final myController = manager.put(() => MyController());
  ///
  /// // Later, when the controller is no longer needed:
  /// manager.delete<MyController>();
  /// ```
  ///
  bool delete<T>() {
    final key = EchoHashUtil.generateTypeHash<T>();
    final ctrl = _controllers[key];

    if (ctrl != null) {
      ctrl.onDispose();

      _controllers.remove(key);

      _logger.info("$ctrl:$key has been deleted");
      return true;
    }

    _logger.error(
      "Error occurred while deleting the controller",
      error: Exception("Controller with id $key not found"),
    );

    return false;
  }
}
