///
/// EchoGraph is a utility class designed for managing relations
/// between stores in echo
///
/// Each node in this graph represents a store, and the edges
/// represent dependencies between these stores. The class provides methods
/// to create, delete, add, and remove these nodes and their dependencies.
///
/// This class is generic, allowing for flexibility in the type of nodes
/// used in the graph.
///
/// Example:
/// ```
/// var graph = EchoGraph<String>();
/// graph.createRoot('rootNode');
/// graph.addNode('rootNode', 'dependentNode');
/// ```
///
class EchoGraph<T> {
  ///
  /// A map to hold key-value pairs of stores and dependent stores
  ///
  final Map<T, Set<T>> _graph;

  ///
  /// Constructor for EchoGraph which initializes the underlying [_graph]
  ///
  EchoGraph() : _graph = {};

  ///
  /// Fetches the dependent nodes for a given root node.
  ///
  /// Returns a [Set] of nodes that are dependent on the provided [root].
  /// If the root node does not exist, returns `null`.
  ///
  /// Example:
  /// ```
  /// var dependents = graph.getNodes('rootNode');
  /// ```
  ///
  Set<T>? getNodes(T root) {
    return _graph[root];
  }

  ///
  /// Initializes the root node in the graph with an empty set of dependencies.
  ///
  /// This method creates a new root node if it does not already exist.
  ///
  /// Example:
  /// ```
  /// graph.createRoot('newRootNode');
  /// ```
  ///
  void createRoot(T root) {
    _graph[root] ??= {};
  }

  ///
  /// Deletes the root node from the graph.
  ///
  /// Returns `true` if the node existed and was deleted, `false` otherwise.
  ///
  /// Example:
  /// ```
  /// bool isDeleted = graph.deleteRoot('rootNode');
  /// ```
  ///
  bool deleteRoot(T root) {
    return _graph.remove(root) != null;
  }

  ///
  /// Adds a dependency node to the specified root node's dependency set.
  ///
  /// Returns `true` if the node was added, `false` if the root node does not exist.
  ///
  /// Example:
  /// ```
  /// bool isAdded = graph.addNode('rootNode', 'dependentNode');
  /// ```
  ///
  bool addNode(T root, T node) {
    return _graph[root]?.add(node) ?? false;
  }

  ///
  /// Removes a dependency node from the specified root node's dependency set.
  ///
  /// Returns `true` if the node was removed, `false` if the root node does not exist or
  /// the node was not a dependency.
  ///
  /// Example:
  /// ```
  /// bool isRemoved = graph.removeNode('rootNode', 'dependentNode');
  /// ```
  ///
  bool removeNode(T root, T node) {
    return _graph[root]?.remove(node) ?? false;
  }
}
