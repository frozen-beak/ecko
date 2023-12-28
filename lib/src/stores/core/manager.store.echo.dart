import '../../utils/graph.util.echo.dart';
import '../../utils/logger.util.echo.dart';
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
  final _logger = EchoLogger();

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
  /// Returns `true` if new root is created and `false` if root already exists
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// EchoStoreManager().createRootNode(store);
  /// ```
  ///
  bool createRootNode(StoreInterface root) {
    return _graph.createRoot(root);
  }

  ///
  /// Deletes a root node (store) from the graph.
  ///
  /// This should be called when a store is disposed.
  ///
  /// Returns `true` if the node existed and was deleted, `false` otherwise.
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// EchoStoreManager().deleteRoot(store);
  /// ```
  ///
  bool deleteRoot(StoreInterface root) {
    return _graph.deleteRoot(root);
  }

  ///
  /// Adds a dependency for a root node (store).
  ///
  /// This method establishes a directed edge from `node` to `root`.
  ///
  /// Dependency is not added if `root` node does not exists in graph
  ///
  /// Returns `true` if dependency is added, `false` if dependency already exists
  /// and `null` if root node does not exists
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
  bool? addDependency(StoreInterface root, StoreInterface node) {
    final isAdded = _graph.addNode(root, node);

    // if node is added successfully then log a message to inform the dev
    if (isAdded == true) {
      _logger.info(
        "Created dependency of ${node.toString()} --> ${root.toString()}",
      );

      return true; // exit the function call after successful execution
    }

    // if dependency between root and node already exists then log error
    if (isAdded == false) {
      _logger.error(
        "Dependency between ${node.toString()} --> ${root.toString()} already exists",
        error: "Dependency between root and node already exists",
      );

      return false; // exit the call after logging an error
    }

    // log error if root node does not exists
    _logger.error(
      "${root.toString()} does not exists, try recreating it",
      error: "Root node does not exists in the graph",
    );

    return null;
  }

  ///
  /// Removes a dependency from a root node for a given root node
  ///
  /// Dependency is not removed if `root` node does not exists in the graph
  ///
  /// Returns `true` if dependency is removed, `false` if dependency wasn't found
  /// and `null` if root node does not exists
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
  bool? removeDependency(StoreInterface root, StoreInterface node) {
    final isRemoved = _graph.removeNode(root, node);
    // if node is removed successfully then log a message to inform the dev
    if (isRemoved == true) {
      _logger.info(
        "Removed dependency of ${node.toString()} -x-> ${root.toString()}",
      );

      return true; // exit the function call after successful execution
    }

    // if dependency between root and node does not exists then log error
    if (isRemoved == false) {
      _logger.error(
        "Dependency between ${node.toString()} --> ${root.toString()} does not exists",
        error: "Dependency between root and node does not exists",
      );

      return false; // exit the call after logging an error
    }

    // log error if root node does not exists
    _logger.error(
      "${root.toString()} does not exists, try recreating it",
      error: "Root node does not exists in the graph",
    );

    return null;
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
  /// Returns `Set<StoreInterface>` if dependencies exists and `null` if no
  /// dependency found
  ///
  /// Example:
  /// ```
  /// final store = ValueStore();
  ///
  /// // Assuming store has dependencies that need to be updated.
  /// EchoStoreManager().updateStoreNodes(store);
  /// ```
  ///
  Set<dynamic>? updateStoreNodes(StoreInterface root) {
    final dependencies = _graph.getNodes(root);

    // no dependant stores were found
    if (dependencies == null) {
      return null;
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

    return dependencies;
  }

  ///
  /// Clears the graph by removing all roots and nodes.
  ///
  /// Example:
  /// ```
  /// EchoStoreManager().clearStoreGraph();
  /// ```
  ///
  void clearStoreGraph() {
    _graph.clearGraph();
  }
}
