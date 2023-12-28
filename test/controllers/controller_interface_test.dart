import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_controller.dart';

void main() {
  group('EchoController Tests', () {
    test('onInit is called when controller is created', () {
      final controller = TestEchoController();
      controller.onInit();

      expect(controller.isInitialized, isTrue);
    });

    test('onDispose can be called and works correctly', () {
      final controller = TestEchoController();
      controller.onDispose();

      expect(controller.isDisposed, isTrue);
    });
  });
}
