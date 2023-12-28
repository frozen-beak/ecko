import 'package:paw/paw.dart';

///
/// A Singleton class for logging within the [Ecko] library
///
/// `EckoLogger` extends `PawInterface` to provide custom logging functionality.
/// It is designed as a singleton to ensure a single, global point of logging
/// throughout the application. This logger can be customized during its
/// initialization and used across the application for consistent logging.
///
/// Examples:
/// ```
/// final logger = EckoLogger();
///
/// logger.info("This is an info log");
///
/// logger.warn("This is a warning log");
///
/// logger.debug({"name": "Ecko", "version": 0.1})
///
/// logger.error("This is an error message", stackTrace: StackTrace.current);
/// ```
///
class EckoLogger extends PawInterface {
  ///
  /// Private constructor to enforce singleton pattern.
  ///
  EckoLogger._({
    required super.name,
    required super.maxStackTraces,
    required super.shouldIncludeSourceInfo,
    required super.shouldPrintLogs,
    required super.shouldPrintName,
  });

  ///
  /// Static instance to hold the singleton object.
  ///
  static EckoLogger? _instance;

  ///
  /// Factory constructor to access the singleton instance.
  ///
  /// It throws an exception if the logger is accessed before being initialized.
  ///
  /// This ensures that the logger is properly configured before use.
  ///
  factory EckoLogger() {
    // throws an exception if [_instance] is `null`
    if (_instance == null) {
      throw Exception(
        "EckoLogger has not been initialised yet! Initialise it by executing `EckoLogger.init()`",
      );
    }

    return _instance!;
  }

  ///
  /// Initializes the singleton instance of `EckoLogger`.
  ///
  /// This method should be called before any usage of the `EckoLogger`.
  ///
  /// It configures the logger with basic settings and ensures that there is
  /// only one instance of the logger throughout the application.
  ///
  /// [shouldPrintLogs]: Determines whether logs should be printed.
  ///
  /// Returns the singleton instance after initialization.
  ///
  /// Example:
  /// ```
  /// EckoLogger.init(shouldPrintLogs = true);
  /// ```
  ///
  static EckoLogger init({required bool shouldPrintLogs}) {
    // The use of ??= ensures that the logger is only initialized once.
    // Subsequent calls to `init` will not reinitialize the logger.
    _instance ??= EckoLogger._(
      name: "ecko",
      shouldPrintLogs: shouldPrintLogs,
      maxStackTraces: 3,
      shouldIncludeSourceInfo: false,
      shouldPrintName: true,
    );

    return _instance!;
  }
}
