import 'package:echo/echo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Echo Tests', () {
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
  });
}
