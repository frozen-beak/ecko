import 'package:ecko/ecko.dart';
import 'package:example/controller_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Ecko.init(printLogs: kDebugMode);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecko Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const SimpleCounterView(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final counter = Store(0);

  @override
  void dispose() {
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
            StoreBuilder(
              store: counter,
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
          FloatingActionButton(
            child: const Icon(Icons.add_rounded),
            onPressed: () {
              counter.update((value) => value + 1);
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.remove_rounded),
            onPressed: () {
              counter.update((value) => value - 1);
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.restore_rounded),
            onPressed: () {
              counter.set(0);
            },
          )
        ],
      ),
    );
  }
}
