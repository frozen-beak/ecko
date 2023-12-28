import 'controllers/manager.controller.echo.dart';
import 'stores/core/manager.store.echo.dart';
import 'utils/logger.util.echo.dart';

///
/// [Echo] is the central class of the library, responsible for initializing and
/// managing services within the application.
///
/// It follows the Singleton pattern to ensure that only one instance of Echo
/// is created and used. This class cannot be instantiated directly by the user.
/// Instead, it should be initialized using the `Echo.init()` method and then
/// accessed via the factory constructor.
///
/// Example:
/// ```
/// void main() {
///   // Initialize Echo at the start of your application.
///   Echo.init(printLogs: true);
///
///   // Access the Echo instance.
///   final echo = Echo();
///
///   // Use echo to manage controllers, stores, etc.
///   // ...
/// }
/// ```
///
class Echo with EchoControllerManagerMixin {
  ///
  /// Determines whether Echo should enable logging.
  ///
  final bool printLogs;

  ///
  /// static instance of [Echo] class
  ///
  static Echo? _instance;

  ///
  /// Private constructor for the Singleton pattern.
  ///
  Echo._({required this.printLogs});

  ///
  /// Factory constructor for accessing the singleton [Echo] instance.
  ///
  /// Throws an exception if [Echo] is accessed before being initialized.
  ///
  /// This ensures that [Echo] is only used after proper initialization.
  ///
  factory Echo() {
    if (_instance == null) {
      throw Exception(
        "`Echo` is not yet initialised. Initialise it with `Echo.init()`.",
      );
    }
    return _instance!;
  }

  ///
  /// Initializes the [Echo] singleton instance.
  ///
  /// This method should be called at the start of your application to set up Echo.
  /// - [printLogs]: If `true`, enables logging. Defaults to `true`.
  ///
  /// The method ensures the singleton pattern is maintained by only initializing
  /// the instance if it hasn't been created yet.
  ///
  /// Example:
  /// ```
  /// void main() {
  ///   Echo.init(printLogs: true);
  ///
  ///   // Rest of your app initialization
  ///   // ...
  /// }
  /// ```
  ///
  static Echo init({bool printLogs = true}) {
    if (_instance == null) {
      // Initialize singleton custom logger
      EchoLogger.init(shouldPrintLogs: printLogs);

      _instance = Echo._(printLogs: printLogs);

      EchoLogger().info("Echo has been initialised");

      // Initialize the store manager.
      StoreManager.init();
    }

    return _instance!;
  }
}
