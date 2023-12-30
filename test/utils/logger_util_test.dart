import 'package:flutter_test/flutter_test.dart';
import 'package:ecko/src/utils/logger.util.ecko.dart';

void main() {
  group('EckoLogger Tests', () {
    test(
      'Attempting to access EckoLogger without initialization throws exception',
      () {
        EckoLogger? logger;
        Exception? exception;

        try {
          logger = EckoLogger();
        } catch (e) {
          exception = e as Exception;
        }

        expect(logger, isNull);
        expect(exception, isNotNull);
      },
    );

    test(
      'EckoLogger initializes successfully with provided configurations',
      () {
        final logger = EckoLogger.init(shouldPrintLogs: true);

        expect(logger, isNotNull);
      },
    );

    test(
      'Singleton instance should be the same',
      () {
        EckoLogger.init(shouldPrintLogs: true);
        final logger1 = EckoLogger();
        final logger2 = EckoLogger();

        expect(identical(logger1, logger2), isTrue);
      },
    );
  });
}
