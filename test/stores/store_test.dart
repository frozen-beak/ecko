import 'package:echo/echo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Store Tests', () {
    setUpAll(() {
      Echo.init(printLogs: false);
    });

    test('Initializes with correct state', () {
      final store = Store<int>(10);
      expect(store.state, 10);
      expect(store.listener.value, 10);
    });

    test('Updates state correctly', () {
      final store = Store<int>(0);
      store.set(5);
      expect(store.state, 5);
      expect(store.listener.value, 5);

      store.update((val) => val + 5);
      expect(store.state, 10);
      expect(store.listener.value, 10);
    });

    test('Notifies listeners on state change', () {
      final store = Store<String>('initial');
      bool listenerCalled = false;

      store.listener.addListener(() {
        listenerCalled = true;
      });

      store.set('updated');
      expect(listenerCalled, true);
    });

    test('Disposes correctly', () {
      final store = Store<String>('test');
      store.dispose();

      try {
        // Attempt to listen to value of listener after disposing it
        store.listener.value;

        // Fail the test if no exception is thrown
        fail('Adding listener should fail after disposal');
      } on Exception catch (e) {
        // Expect an exception to be thrown
        expect(e, isNotNull);
      }
    });
  });
}
