import 'package:echo/src/utils/logger.util.echo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo/src/controllers/manager.controller.echo.dart';

import 'helpers/mock_controller.dart';

// Test class using the mixin
class TestEchoControllerManager with EchoControllerManagerMixin {}

void main() {
  group('EchoControllerManagerMixin Tests', () {
    late TestEchoControllerManager manager;

    setUp(() {
      // init the [EchoLogger]
      EchoLogger.init(shouldPrintLogs: false);

      manager = TestEchoControllerManager();
    });

    test('put method should create and return a new controller', () {
      final controller = manager.put(() => TestEchoController());

      expect(controller, isA<TestEchoController>());
    });

    test(
      'put method should call the `onInit()` for the initialised controller',
      () {
        final controller = manager.put(() => TestEchoController());

        expect(controller.isInitialized, isTrue);
      },
    );

    test('put method should return existing controller if already created', () {
      final controller1 = manager.put(() => TestEchoController());
      final controller2 = manager.put(() => TestEchoController());

      expect(controller1.hashCode, equals(controller2.hashCode));
    });

    test('delete method should remove the controller', () {
      manager.put(() => TestEchoController());

      expect(manager.delete<TestEchoController>(), isTrue);
    });

    test('delete method should handle non-existent controller', () {
      expect(manager.delete<TestEchoController>(), isFalse);
    });
  });
}
