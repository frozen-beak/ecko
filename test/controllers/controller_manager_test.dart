import 'package:flutter_test/flutter_test.dart';
import 'package:echo/src/controllers/interface.controller.echo.dart';
import 'package:echo/src/controllers/manager.controller.echo.dart';
import 'package:paw/paw.dart';

// Mock EchoController
class MockEchoController extends EchoController {
  @override
  void onInit() {}

  @override
  void onDispose() {}
}

// Test class using the mixin
class TestEchoControllerManager with EchoControllerManagerMixin {}

void main() {
  group('EchoControllerManagerMixin', () {
    late TestEchoControllerManager manager;

    setUp(() {
      Paw.init(shouldPrintLogs: false);

      manager = TestEchoControllerManager();
    });

    test('put method should create and return a new controller', () {
      final controller = manager.put(() => MockEchoController());
      expect(controller, isA<MockEchoController>());
    });

    test('put method should return existing controller if already created', () {
      final controller1 = manager.put(() => MockEchoController());
      final controller2 = manager.put(() => MockEchoController());

      expect(controller1.key.hashCode, isNot(equals(controller2.key.hashCode)));
    });

    test('delete method should remove the controller', () {
      final controller = manager.put(() => MockEchoController());
      manager.delete(controller);
    });

    test('delete method should handle non-existent controller', () {
      final controller = MockEchoController();

      expect(() => manager.delete(controller), returnsNormally);
    });
  });
}
