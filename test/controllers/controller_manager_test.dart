import 'package:ecko/src/utils/logger.util.ecko.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecko/src/controllers/manager.controller.ecko.dart';

import 'helpers/mock_controller.dart';

// Test class using the mixin
class TestEckoControllerManager with EckoControllerManagerMixin {}

void main() {
  group('EckoControllerManagerMixin Tests', () {
    late TestEckoControllerManager manager;

    setUp(() {
      // init the [EckoLogger]
      EckoLogger.init(shouldPrintLogs: false);

      manager = TestEckoControllerManager();
    });

    test('put method should create and return a new controller', () {
      final controller = manager.put(() => TestEckoController());

      expect(controller, isA<TestEckoController>());
    });

    test(
      'put method should call the `onInit()` for the initialised controller',
      () {
        final controller = manager.put(() => TestEckoController());

        expect(controller.isInitialized, isTrue);
      },
    );

    test('put method should return existing controller if already created', () {
      final controller1 = manager.put(() => TestEckoController());
      final controller2 = manager.put(() => TestEckoController());

      expect(controller1.hashCode, equals(controller2.hashCode));
    });

    test('delete method should remove the controller', () {
      manager.put(() => TestEckoController());

      expect(manager.delete<TestEckoController>(), isTrue);
    });

    test('delete method should handle non-existent controller', () {
      expect(manager.delete<TestEckoController>(), isFalse);
    });
  });
}
