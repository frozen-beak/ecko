import 'package:echo/echo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paw/paw.dart';

void main() {
  group('Echo Tests', () {
    setUp(() {
      Paw.init(shouldPrintLogs: false);
    });

    test('Throws exception if accessed before initialization', () {
      expect(() => Echo(), throwsException);
    });

    test('Echo is a Singleton', () {
      Echo.init(printLogs: false);

      final echo1 = Echo();
      final echo2 = Echo();

      // Check if both variables hold the same instance or not
      expect(identical(echo1, echo2), isTrue);
    });

    test('Initializes correctly with default parameters', () {
      final echo = Echo.init();

      expect(echo, isNotNull);
    });
  });
}
