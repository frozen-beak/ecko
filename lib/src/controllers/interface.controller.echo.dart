import 'package:flutter/material.dart';

///
/// [EchoController] is an abstract class that serves as a base for custom controllers
/// in the Echo state management library for Flutter. This class provides a structured
/// way to handle lifecycle events and associate a GlobalKey with each controller instance.
///
/// The class is designed to be extended by concrete implementations that define specific
/// behaviors and logic for different parts of your application.
///
abstract class EchoController {
  ///
  /// A [GlobalKey] associated with this controller.
  ///
  /// This key can be used to uniquely identify a widget in the widget tree and
  /// can be useful for accessing the context or state of the widget this controller
  /// is associated with.
  ///
  final GlobalKey key;

  ///
  /// Constructor for [EchoController].
  ///
  /// Initializes a [GlobalKey] for the controller.
  ///
  EchoController() : key = GlobalKey();

  ///
  /// [onInit] is called immediately after the controller is instantiated.
  ///
  /// Override this method in your subclass to perform initialization tasks,
  /// such as setting up listeners, initializing data, etc. This method provides
  /// a convenient place to put setup code that needs to happen once per controller
  /// lifecycle.
  ///
  void onInit() {}

  ///
  /// [onDispose] is called just before the controller is disposed.
  ///
  /// Override this method in your subclass to perform cleanup tasks, such as
  /// removing listeners, cancelling subscriptions, etc. This method provides
  /// a place to free resources that were acquired in [onInit] or during the
  /// controller's lifetime.
  ///
  void onDispose() {}
}
