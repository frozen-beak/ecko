import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:echo/echo.dart';

// A test widget to implement StoreStateWidget for testing
class TestWidget extends StoreStateWidget<int> {
  TestWidget({super.key, required int initialCount})
      : super(state: initialCount);

  @override
  Widget build(BuildContext context, int state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Center(
        child: ElevatedButton(
          child: Text('Count: $state'),
          onPressed: () => store.update((value) => value + 1),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    Echo.init(printLogs: false);
  });

  testWidgets(
    'StoreStateWidget initializes and updates state correctly',
    (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: TestWidget(initialCount: 0)));

      // Verify that the initial state is displayed.
      expect(find.text('Count: 0'), findsOneWidget);

      // Simulate a button press to increment the count.
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verify that the state has updated.
      expect(find.text('Count: 1'), findsOneWidget);
    },
  );
}
