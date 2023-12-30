import 'package:ecko/ecko.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize Ecko with logging enabled only in debug mode
  Ecko.init(printLogs: kDebugMode);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecko Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // Instantiate a new `Store` from Ecko containing an integer value initialized at 0
  final counter = Store(0);

  @override
  void dispose() {
    // Call the `dispose` method of the store to clean it up
    counter.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter w/ Ecko 🕸️"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Build UI based on the current value of the `counter` store
            StoreBuilder<int>(
              // Pass the `counter` store instance
              store: counter,
              // Render the text representation of the store's value
              widget: (context, value) {
                return Text(value.toString());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Increase button
          FloatingActionButton(
            // Button icon
            child: const Icon(Icons.add_rounded),
            // Handle click event
            onPressed: () {
              setState(() {
                // Increment the stored value
                counter.update((value) => value + 1);
              });
            },
          ),
          const SizedBox(height: 10),
          // Decrease button
          FloatingActionButton(
            // Button icon
            child: const Icon(Icons.remove_rounded),
            // Handle click event
            onPressed: () {
              setState(() {
                // Decrement the stored value
                counter.update((value) => value - 1);
              });
            },
          ),
          const SizedBox(height: 10),
          // Reset button
          FloatingActionButton(
            // Button icon
            child: const Icon(Icons.restore_rounded),
            // Handle click event
            onPressed: () {
              setState(() {
                // Reset the stored value to its initial value
                counter.set(0);
              });
            },
          ),
        ],
      ),
    );
  }
}
