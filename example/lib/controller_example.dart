import 'dart:developer';

import 'package:ecko/ecko.dart';
import 'package:flutter/material.dart';

class MyController extends EckoController {
  ///
  /// Store to hold counter state
  ///
  late final Store<int> counter;

  @override
  void onInit() {
    super.onInit();

    log("on init has been called");

    counter = Store(0);
  }

  @override
  void onDispose() {
    ///
    /// dispose counter store when controller is disposed
    ///
    counter.dispose();

    super.onDispose();
  }

  ///
  /// Increments counters state by 1
  ///
  void increment() {
    counter.update((value) => value++);
    log(counter.state.toString());
  }

  ///
  /// Decrements counters state by 1
  ///
  void decrement() {
    counter.update((value) => value--);
  }

  ///
  /// Reset the counter state to 0
  ///
  void reset() {
    counter.set(0);
  }
}

class SimpleCounterView extends StatefulWidget {
  const SimpleCounterView({super.key});

  @override
  State<SimpleCounterView> createState() => _SimpleCounterViewState();
}

class _SimpleCounterViewState extends State<SimpleCounterView> {
  final controller = Ecko().put(() => MyController());

  @override
  void dispose() {
    Ecko().delete<MyController>();

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
              store: controller.counter,
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
              // controller.counter.update((value) => value++);
              controller.increment();
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.remove_rounded),
            onPressed: () {
              controller.decrement();
            },
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            child: const Icon(Icons.restore_rounded),
            onPressed: () {
              controller.reset();
            },
          )
        ],
      ),
    );
  }
}
