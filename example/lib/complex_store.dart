import 'package:ecko/ecko.dart';
import 'package:flutter/material.dart';

class ListStoreView extends StatefulWidget {
  const ListStoreView({super.key});

  @override
  State<ListStoreView> createState() => _ListStoreViewState();
}

class _ListStoreViewState extends State<ListStoreView> {
  final listStore = Store([0]);

  @override
  void dispose() {
    listStore.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Store"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StoreBuilder(
              store: listStore,
              widget: (context, value) => Text(
                "Values are \n $value",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              child: const Text("Add Item"),
              onPressed: () {
                listStore.update(
                  (value) => value..add(value.last + 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
