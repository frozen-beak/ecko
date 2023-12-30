# Ecko 🕸️

[![pub package](https://img.shields.io/pub/v/ecko.svg?logo=dart&logoColor=00b9fc)](https://pub.dev/packages/ecko)
[![CI](https://img.shields.io/github/actions/workflow/status/AdityaMotale/ecko/tests.yaml?branch=main&logo=github-actions&logoColor=white)](https://github.com/AdityaMotale/ecko/actions)
[![Last Commits](https://img.shields.io/github/last-commit/AdityaMotale/ecko?logo=git&logoColor=white)](https://github.com/AdityaMotale/ecko/commits/main)
[![Pull Requests](https://img.shields.io/github/issues-pr/AdityaMotale/ecko?logo=github&logoColor=white)](https://github.com/AdityaMotale/ecko/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/AdityaMotale/ecko?logo=github&logoColor=white)](https://github.com/AdityaMotale/ecko)
[![License](https://img.shields.io/github/license/AdityaMotale/ecko?logo=open-source-initiative&logoColor=green)](https://github.com/AdityaMotale/ecko/blob/main/LICENSE)

Ecko is a graph-based state management library for Flutter applications.

> **⚠️ Important Notice:** Ecko remains in active development and hasn't yet hit `v0.1.0`. Due to frequent updates and enhancements, breaking changes might occur in the public API. Stay tuned for progress updates, and consider contributing ideas or reporting any issues you encounter via GitHub Issues. Thank you for joining me on this exciting journey towards building a 🆒 state management library in Flutter!

### **Table Of Content**

- [Why Ecko?](#why-ecko)
- [Getting Started](#getting-started)
- [Core](#core)
- [Usage](#usage)
  - [Creating `Store`](#creating-store)
  - [Listening to Store Updates with `StoreBuilder`](#listening-to-store-updates-with-storebuilder)
  - [Dependency Between Stores](#dependency-between-stores)
    - [Creating Dependencies](#creating-dependencies)
    - [Creating An `updateCallback`](#creating-an-updatecallback)
    - [Using `autoUpdate`](#using-autoupdate)
  - [Using `StoreStateWidget`](#using-storestatewidget)
  - [Ecko](#ecko)
- [Contributions](#contributions)

## Why Ecko?

### 📚 _Learning Project_:

First and foremost, Ecko was born as a personal learning project. I wanted to dive deep into understanding how state management systems function internally while also improving on my skills along the way.

### ⚡️ _Inspiration_:

I've settled onto GetX for the majority of my time in past, because how easy it is to get started. However, I came to realise that, GetX tries to do many things at the same time, which leads architectural demise in larger projects.

However, sometimes less can be more — I aim to maintain the simplicity of GetX with a different approach to manage state.

### ⚙️ _Decoupled Business Logic_:

One major issue observed with existing libraries is their tendency to encourage tight coupling between business logic and user interface components. This makes code harder to test, refactor, and reuse across different parts of the application.

That's why I designed `ecko` with _principle of separation of concerns_ in mind. Maintaining loose coupling between various layers helps ensure cleaner, easier-to-maintain codebases.

### 🕸️ _Managing Complexity with Directed Graphs:_:

Ecko allows representation of interdependent states effectively through a directed graph structure. It simplifies navigating complex scenarios in contemporary applications while preserving clear separation and convenience in usage.

### 🚀 _(Planned)_ _Out-of-the-box Service Management_:

As experienced developers know, handling external dependencies such as APIs, databases, or other services often requires extra care. Although still under development, one of Ecko's planned features will include an integrated service management system.

The idea behind this feature is to offer a unified methodology for controlling services within your applications similar to _GetX Controllers & Services_, reducing boilerplate code and ensuring consistent design patterns throughout your projects.

## Getting Started

You can directly install _Ecko_ by adding `ecko: ^0.0.1` to your _pubspec.yaml_ dependencies section as shown below,

```yaml
dependencies:
  ecko: ^0.0.1
```

You can also add _Ecko_ in your project by executing fallowing,

```bash
flutter pub add ecko
```

To start using _Ecko_ in your application, make sure to initialise the singleton `Ecko` class as fallowing,

```dart
void main() {
  // Initialize Ecko at the start of your application.
  Ecko.init(printLogs: true);
  // Access the Ecko instance.
  final ecko = Ecko();
  // Use ecko to manage controllers, stores, etc.
  // ...
}
```

Now you are good to go 🔥!

## Core

At the heart of Ecko are _stores_, which are classes that encapsulate and manage state. You can create stores wherever it makes sense for your app, but be aware that you will need to manually call their `dispose()` method when they are no longer needed to avoid memory leaks.

Stores can depend on one another through a _directed acyclic graph (DAG)_ maintained internally by Ecko. This means that if you change the value of a store, any other stores that depend on it will automatically update as well.

Under the hood, Ecko uses `ValueNotifier` and `ChangeNotifier` to enable reactivity and allow components to efficiently rebuild only when necessary. To listen to updates from a specific store, you can use the `StoreBuilder` widget. Alternatively, you can extend the `StoreStateWidget` abstract base class to easily build widgets that subscribe to a single store without having to worry about manual subscription or disposal.

## Usage

### **Creating `Store`**

The building blocks of Ecko are stores. At its simplest form, a store is just an instance of the `Store` class that wraps around your application state. For example, let's say you want to maintain a counter variable:

```dart
// A store to hold the counter state
final counter = Store(0);
```

Feel free to create stores where it makes sense for your app architecture. However, remember to explicitly call their `dispose()` method when the associated state becomes obsolete to prevent potential memory leaks:

```dart
@override
void dispose() {
  // Dispose the `counter` store
  counter.dispose();

  // Perform any additional cleanup required before removing this StatefulWidget
  // ...
}
```

### **Listening to Store Updates with `StoreBuilder`**

Use the `StoreBuilder` widget to listen to updates for a specific store to update applications UI.

It accepts two named parameters – `store` specifies the target store, while `widget` defines the callback responsible for rendering the current store value. In the following example, we display the updated value of the `counter` store inside a `Text` widget:

```dart
Column(
  children: [
    // A widget listening to the `counter` store
    StoreBuilder<int>(
      store: counter,
      builder: (context, value) {
        return Text(value.toString());
      },
    ),

    // More widgets here...
  ],
)
```

ℹ️ Important: Make sure to clean up the `Store` listener along with the corresponding UI element that depends on it. Neglecting this task can cause undesirable side effects due to lingering listeners.

For convenience, consider implementing the `StoreStateWidget` interface instead, which handles automatic subscription behind the scenes. Check out the [API reference below](#using-storestatewidget) for more details.

### **Dependency Between Stores**

Ecko stores can be dependent on other stores with a directed graph which is used internally.

#### **Creating Dependencies**

Introducing a dependency node between two stores helps automatically update the state of the dependent stores when the stores it depends upon are updated.

Let's take an example, we have a `StoreA` which holds current temperature in _Celsius_. Similarly we have a `StoreB` which holds the current temperature in _Fahrenheit_.

Now if we add `StoreB` as a dependency to `StoreA`, whenever now `StoreA` is updated, `StoreB` will update automatically

The new state for the `StoreB` is calculated by executing its `updateCallback`. You'll be learning more about it ahead in the docs. Also can refer [here](#creating-an-updatecallback)

Creating dependency is very easy,

```dart
// store to hold temperature value in `celsius`
final celsiusStore = Store<double>(0);

// store to hold temperature value in `fahrenheit`
final fahrenheitStore = Store<double>(0);
```

Now, if we want to create dependency between `celsiusStore` and `fahrenheitStore`, meaning that `fahrenheitStore` should automatically update when the state of `celsiusStore` is updated, we can added dependency to the `celsiusStore` as fallows,

```dart
// [fahrenheitStore] is now dependent on [celsiusStore]
celsiusStore.addDependency(fahrenheitStore);
```

> **💀 Warning**: If a `storeA` is dependent on `storeB` then `storeB` can not be dependent on `storeA`. This will result in infinite callback of updating states and will throw _Stack Overflow_ error in the end.

#### **Creating An `updateCallback`**

Every store has a `updateCallback` property, which is a function which is called when the store is automatically updated. For ex, when `celsius` store is updated, _updateCallback_ for the `fahrenheit` store is called to update its state, because of its dependency with `celsius` store.

You can set `updateCallback` while creating the store,

```dart
// store to hold temperature value in `celsius`
// when this store is automatically updated, the state will increment by `1`
final fahrenheitStore = Store<double>(0, updateCallback: (val) => val + 1);
```

For every store, `updateCallback` is mutable, hence you can also change it whenever & wherever you like,

```dart
// this sets a new `updateCallback` for the store, it'll then be called
// when the store is automatically updated
fahrenheitStore.setUpdateCallback((value) {
  return (celsiusStore.state * 9 / 5) + 32;
});
```

#### **Using `autoUpdate`**

Every store provides `autoUpdate` function, this function is called internally when updating the states of the store when its dependencies are updated.

You can call `autoUpdate` to update the state of the store according to the `updateCallback`,

```dart
// a store to hold the counter state with an update callback to increment the state by `1`
final counter = Store<int>(0, updateCallback: (val) => val++);

// update the state of the store according to the updateCallback
counter.autoUpdate();
```

### **Using `StoreStateWidget`**

Alternatively, you can extend the `StoreStateWidget` abstract base class to easily build stateless widgets that subscribe to a single store without having to worry about manual subscription or disposal.

```dart
///
/// This is a Slider Widget which has its own store,
///
/// State of this slider is managed internally by this class,
/// you don't need to worry about creating and disposing the store
///
/// This widget offers an alternative way to work with stores,
/// can only be used when a store is completely isolated from other stores
///
class SliderWidget extends StoreStateWidget<double> {
  // init the store the default value 0, by passing it through super
  SliderWidget({Key? key}) : super(state: 0, key: key);

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
```

This widget offers an alternative way to work with stores, but it can only be used when a store is **completely isolated** from other stores.

### **Ecko**

`Ecko` class is used to group everything together in Ecko library. Currently it serves no purpose more then initiating underlying services for `Ecko`.

As stated above, in future updates, `Ecko` will be used to manage services and controllers offering an out-of-the-box service locator.

## Contributions

I welcome contributions! If you'd like to improve Ecko, please open an issue or an PR with your suggested changes on this [repo](https://github.com/AdityaMotale/ecko). Happy Coding 🕸️!
