import 'stores/core/manager.store.ecko.dart';
import 'utils/logger.util.ecko.dart';

///
/// [Ecko] is the central class of the library, responsible for initializing and
/// managing services within the application.
///
/// It follows the Singleton pattern to ensure that only one instance of Ecko
/// is created and used. This class cannot be instantiated directly by the user.
/// Instead, it should be initialized using the `Ecko.init()` method and then
/// accessed via the factory constructor.
///
/// Example:
/// ```
/// void main() {
///   // Initialize Ecko at the start of your application.
///   Ecko.init(printLogs: true);
///
///   // Access the Ecko instance.
///   final ecko = Ecko();
///
///   // Use ecko to manage controllers, stores, etc.
///   // ...
/// }
/// ```
///
class Ecko {
  ///
  /// Determines whether Ecko should enable logging.
  ///
  final bool printLogs;

  ///
  /// static instance of [Ecko] class
  ///
  static Ecko? _instance;

  ///
  /// Private constructor for the Singleton pattern.
  ///
  Ecko._({required this.printLogs});

  ///
  /// Factory constructor for accessing the singleton [Ecko] instance.
  ///
  /// Throws an exception if [Ecko] is accessed before being initialized.
  ///
  /// This ensures that [Ecko] is only used after proper initialization.
  ///
  factory Ecko() {
    if (_instance == null) {
      throw Exception(
        "`Ecko` is not yet initialised. Initialise it with `Ecko.init()`.",
      );
    }
    return _instance!;
  }

  ///
  /// Initializes the [Ecko] singleton instance.
  ///
  /// This method should be called at the start of your application to set up Ecko.
  /// - [printLogs]: If `true`, enables logging. Defaults to `true`.
  ///
  /// The method ensures the singleton pattern is maintained by only initializing
  /// the instance if it hasn't been created yet.
  ///
  /// Example:
  /// ```
  /// void main() {
  ///   Ecko.init(printLogs: true);
  ///
  ///   // Rest of your app initialization
  ///   // ...
  /// }
  /// ```
  ///
  static Ecko init({bool printLogs = true}) {
    if (_instance == null) {
      // Initialize singleton custom logger
      EckoLogger.init(shouldPrintLogs: printLogs);

      _instance = Ecko._(printLogs: printLogs);

      EckoLogger().info("Ecko has been initialised");

      // Initialize the store manager.
      StoreManager.init();
    }

    return _instance!;
  }
}
