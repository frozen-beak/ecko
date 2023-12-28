import 'package:echo/src/controllers/interface.controller.echo.dart';

///
/// A concrete implementation of EchoController for testing purposes.
///
class TestEchoController extends EchoController {
  bool isInitialized = false;
  bool isDisposed = false;

  @override
  void onInit() {
    isInitialized = true;
  }

  @override
  void onDispose() {
    isDisposed = true;
  }
}
