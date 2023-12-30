import 'package:flutter_test/flutter_test.dart';
import 'package:ecko/src/utils/hash.util.ecko.dart';

void main() {
  group('EckoHashUtil Tests', () {
    test('Generate Type Hash returns consistent hash for same type', () {
      final hash1 = EckoHashUtil.generateTypeHash<int>();
      final hash2 = EckoHashUtil.generateTypeHash<int>();

      expect(hash1, equals(hash2));
    });

    test('Generate Type Hash returns different hashes for different types', () {
      final intHash = EckoHashUtil.generateTypeHash<int>();
      final stringHash = EckoHashUtil.generateTypeHash<String>();

      expect(intHash, isNot(equals(stringHash)));
    });

    test('Generate Type Hash handles complex generic types', () {
      final listIntHash = EckoHashUtil.generateTypeHash<List<int>>();
      final listStringHash = EckoHashUtil.generateTypeHash<List<String>>();

      expect(listIntHash, isNot(equals(listStringHash)));
    });
  });
}
