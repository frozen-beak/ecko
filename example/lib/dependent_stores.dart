import 'package:ecko/ecko.dart';
import 'package:flutter/material.dart';

class DependentStores extends StatefulWidget {
  const DependentStores({super.key});

  @override
  State<DependentStores> createState() => _DependentStoresState();
}

class _DependentStoresState extends State<DependentStores> {
  final celsiusStore = Store<double>(0);
  final fahrenheitStore = Store<double>(0);

  @override
  void initState() {
    super.initState();

    // [fahrenheitStore] is now dependent on [celsiusStore]
    celsiusStore.addDependency(fahrenheitStore);

    // auto update function which will be called when state of [celsiusStore] is updated
    fahrenheitStore.setUpdateCallback((value) {
      return (celsiusStore.state * 9 / 5) + 32;
    });
  }

  @override
  void dispose() {
    celsiusStore.dispose();
    fahrenheitStore.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dependent Stores"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Celsius Temperature"),
                  StoreBuilder(
                    store: celsiusStore,
                    widget: (context, value) => Text("$value° C"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StoreBuilder(
                store: celsiusStore,
                widget: (context, value) {
                  return Slider(
                    value: value,
                    onChanged: (val) => celsiusStore.set(val),
                    min: 0,
                    max: 100,
                    divisions: 200,
                  );
                },
              ),
              const SizedBox(height: 25),
              const Text("Fahrenheit Temperature"),
              const SizedBox(height: 10),
              StoreBuilder(
                store: fahrenheitStore,
                widget: (context, value) {
                  return Text("$value° F");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
