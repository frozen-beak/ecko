import 'package:flutter_test/flutter_test.dart';
import 'package:echo/src/utils/logger.util.echo.dart';

void main() {
  group('EchoLogger Tests', () {
    test(
      'Attempting to access EchoLogger without initialization throws exception',
      () {
        EchoLogger? logger;
        Exception? exception;

        try {
          logger = EchoLogger();
        } catch (e) {
          exception = e as Exception;
        }

        expect(logger, isNull);
        expect(exception, isNotNull);
      },
    );

    test(
      'EchoLogger initializes successfully with provided configurations',
      () {
        final logger = EchoLogger.init(shouldPrintLogs: true);

        expect(logger, isNotNull);
      },
    );

    test(
      'Singleton instance should be the same',
      () {
        EchoLogger.init(shouldPrintLogs: true);
        final logger1 = EchoLogger();
        final logger2 = EchoLogger();

        expect(identical(logger1, logger2), isTrue);
      },
    );
  });
}
