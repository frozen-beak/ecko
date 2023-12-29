import 'package:flutter/material.dart';
import 'package:ecko/ecko.dart';

class SliderPage extends StatelessWidget {
  const SliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Slider Example w/ State Store Widget"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Simple Slider"),
              const SizedBox(height: 10),
              SliderWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderWidget extends StoreStateWidget<double> {
  SliderWidget({super.key, super.state = 0});

  @override
  Widget build(BuildContext context, double state) {
    return Slider(
      min: 0,
      max: 100,
      value: state,
      onChanged: (val) => store.set(val),
    );
  }
}
