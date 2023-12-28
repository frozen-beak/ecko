import 'package:ecko/ecko.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ecko Tests', () {
    test('Throws exception if accessed before initialization', () {
      expect(() => Ecko(), throwsException);
    });

    test('Ecko is a Singleton', () {
      Ecko.init(printLogs: false);

      final ecko1 = Ecko();
      final ecko2 = Ecko();

      // Check if both variables hold the same instance or not
      expect(identical(ecko1, ecko2), isTrue);
    });
  });
}
