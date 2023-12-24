import 'package:paw/paw.dart';

import '../../utils/graph.util.echo.dart';
import 'interface.store.echo.dart';

///
/// A singleton class for managing interdependencies between stores in echo
///
/// This manager uses a directed graph to represent dependencies between different stores.
/// It allows for the creation and deletion of root nodes (stores) in the graph and
/// manages dependencies between these stores, ensuring that updates are propagated correctly.
///
class StoreManager {
  ///
  /// Instance of logger to help logging useful message to the dev
  ///
  final _paw = Paw();

  ///
  /// Private, Static & Singleton instance of [StoreManager]
  ///
  static StoreManager? _instance;

  ///
  /// Private constructor to prevent outside invocations
  ///
  StoreManager._();

  ///
  /// Factory constructor to get the singleton instance.
  ///
  /// Throws an exception if the manager is not initialized.
  ///
  factory StoreManager() {
    if (_instance == null) {
      throw Exception(
        "`Echo` is not yet initialised, initialise it with `Echo.init()`",
      );
    }

    return _instance!;
  }

  ///
  /// Initializes the singleton instance of the store manager.
  ///
  /// **NOTE:** It should be called before any operations with the manager.
  ///
  /// Example:
  /// ```
  /// EchoStoreManager.init();
  /// ```
  ///
  static StoreManager init() {
    _instance ??= StoreManager._();

    return _instance!;
  }

  ///
  /// Private instance of directed graph to help manage inter-dependencies
  /// between stores
  ///
  final EchoGraph _graph = EchoGraph();

  ///
  /// Creates a root node (store) in the graph.
  ///
  /// This should be called when a store is initialized.
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// EchoStoreManager().createRootNode(store);
  /// ```
  ///
  void createRootNode(StoreInterface root) {
    _graph.createRoot(root);
  }

  ///
  /// Deletes a root node (store) from the graph.
  ///
  /// This should be called when a store is disposed.
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// EchoStoreManager().deleteRoot(store);
  /// ```
  ///
  void deleteRoot(StoreInterface root) {
    _graph.deleteRoot(root);
  }

  ///
  /// Adds a dependency for a root node (store).
  ///
  /// This method establishes a directed edge from `node` to `root`.
  ///
  /// Example:
  /// ```
  /// final rootStore = ValueStore();
  /// final dependentStore = ValueStore();
  ///
  /// // Now, dependentStore depends on rootStore
  /// EchoStoreManager().addDependency(rootStore, dependentStore);
  /// ```
  ///
  void addDependency(StoreInterface root, StoreInterface node) {
    // if node is added successfully then log a message to inform the dev
    if (_graph.addNode(root, node)) {
      _paw.info(
        "Created dependency of ${node.toString()} --> ${root.toString()}",
      );
      return; // exit the function call after successful execution
    }

    ///
    /// error log stating dependency is not added
    ///
    /// Error can occur if,
    ///
    /// - root node does not exists
    /// - node is already present in dependencies of root node
    ///
    /// TODO: Log error message according to the exact scenario (separate error logs for each error case)
    ///
    _paw.error(
      "Unable to create dependency of ${node.toString()} --> ${root.toString()}",
      error: "Either dependency already created or root node does not exists",
    );
  }

  ///
  /// Removes a dependency from a root node for a given root node
  ///
  /// Example:
  /// ```
  /// final rootStore = ValueStore();
  /// final dependentStore = ValueStore();
  ///
  /// // Dependency of dependentStore to rootStore is removed
  /// EchoStoreManager().removeDependency(rootStore, dependentStore);
  /// ```
  ///
  void removeDependency(StoreInterface root, StoreInterface node) {
    // if node is removed successfully then log a message to inform the dev
    if (_graph.removeNode(root, node)) {
      _paw.info(
        "Removed dependency of ${node.toString()} -x-> ${root.toString()}",
      );

      return; // exit the function call after successful execution
    }

    ///
    /// error log stating dependency is not removed
    ///
    /// Error can occur if,
    ///
    /// - root node does not exists
    /// - node does not exists in dependencies of root node
    ///
    /// TODO: Log error message according to the exact scenario (separate error logs for each error case)
    ///
    _paw.error(
      "Unable to remove dependency from ${root.toString()}",
      error:
          "No dependency found between ${node.toString()} --> ${root.toString()}",
    );
  }

  ///
  /// Updates all the dependencies of a particular store.
  ///
  /// This is typically called when a store's state changes and it needs to propagate
  /// this change to its dependents.
  ///
  /// **NOTE**: This function is called for every state every time the state is
  ///           updated, it also to be called automatically by internal mechanism.
  ///           To ensure that users debug console is not bombarded with logs regarding
  ///           auto updates of states, **This function does not log info when dependent
  ///           nodes are updated**
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// // Assuming store has dependencies that need to be updated.
  /// EchoStoreManager().updateStoreNodes(store);
  /// ```
  ///
  void updateStoreNodes(StoreInterface root) {
    final dependencies = _graph.getNodes(root);

    // no dependant stores were found
    if (dependencies == null) {
      return;
    }

    ///
    /// Iterate through every dependency of the root node,
    ///
    /// [autoUpdate] is called for every dependency that exists, internally
    /// [autoUpdate] should call [updateCallback] function which then calculates
    /// and updates the state of the node, if [updateCallback] is `null` (which
    /// is by default), then the node will not be updated
    ///
    for (final element in dependencies) {
      element.autoUpdate();
    }
  }
}
