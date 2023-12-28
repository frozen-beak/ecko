import 'package:ecko/src/controllers/interface.controller.ecko.dart';

///
/// A concrete implementation of EckoController for testing purposes.
///
class TestEckoController extends EckoController {
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
