import 'package:flutter_test/flutter_test.dart';
import 'package:echo/src/utils/hash.util.echo.dart';

void main() {
  group('EchoHashUtil Tests', () {
    test('Generate Type Hash returns consistent hash for same type', () {
      final hash1 = EchoHashUtil.generateTypeHash<int>();
      final hash2 = EchoHashUtil.generateTypeHash<int>();

      expect(hash1, equals(hash2));
    });

    test('Generate Type Hash returns different hashes for different types', () {
      final intHash = EchoHashUtil.generateTypeHash<int>();
      final stringHash = EchoHashUtil.generateTypeHash<String>();

      expect(intHash, isNot(equals(stringHash)));
    });

    test('Generate Type Hash handles complex generic types', () {
      final listIntHash = EchoHashUtil.generateTypeHash<List<int>>();
      final listStringHash = EchoHashUtil.generateTypeHash<List<String>>();

      expect(listIntHash, isNot(equals(listStringHash)));
    });
  });
}
