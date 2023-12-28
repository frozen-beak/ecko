import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecko/ecko.dart';

void main() {
  setUpAll(() {
    Ecko.init(printLogs: false);
  });

  testWidgets(
    'StoreBuilder rebuilds with store value changes',
    (WidgetTester tester) async {
      // Create a Store with an initial value
      final counterStore = Store<int>(0);

      // Define a StoreBuilder widget
      await tester.pumpWidget(
        MaterialApp(
          home: StoreBuilder<int>(
            store: counterStore,
            widget: (context, value) => Text("Current value: $value"),
          ),
        ),
      );

      // Verify the initial state is displayed
      expect(find.text('Current value: 0'), findsOneWidget);

      // Update the store's value
      counterStore.update((value) => value + 1);
      await tester.pump();

      // Verify that the widget updated
      expect(find.text('Current value: 1'), findsOneWidget);
    },
  );
}
