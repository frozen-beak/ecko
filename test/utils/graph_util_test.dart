import 'package:flutter_test/flutter_test.dart';
import 'package:echo/src/utils/graph.util.echo.dart';

void main() {
  group('[Utils] EchoGraph Tests', () {
    late EchoGraph<MockStore> graph;

    setUpAll(() {
      graph = EchoGraph<MockStore>();
    });

    setUp(() {
      graph.clearGraph();
    });

    test(
      'Creating a root node that already exists should not override existing dependencies',
      () {
        final root = MockStore('root');
        final dependent = MockStore('dependent');

        graph.createRoot(root);
        graph.addNode(root, dependent);

        // Attempt to recreate the same root
        graph.createRoot(root);

        expect(graph.getNodes(root), contains(dependent));
      },
    );

    test('[addNode] Adding a node to an undefined root should return null', () {
      final root = MockStore('root');
      final dependent = MockStore('dependent');

      expect(graph.addNode(root, dependent), isNull);
    });

    test(
      '[removeNode] Removing a non-existent node from a root should return false',
      () {
        final root = MockStore('root');
        final dependent = MockStore('dependent');

        graph.createRoot(root);

        expect(graph.removeNode(root, dependent), isFalse);
      },
    );

    test(
      '[removeNode] Removing a node from a non-existent root should return null',
      () {
        final root = MockStore('root');
        final dependent = MockStore('dependent');

        expect(graph.removeNode(root, dependent), isNull);
      },
    );

    test('[deleteRoot] Deleting a non-existent root should return false', () {
      final root = MockStore('root');

      expect(graph.deleteRoot(root), isFalse);
    });

    test(
      '[getNodes] Fetching nodes from a non-existent root should return null',
      () {
        final root = MockStore('root');

        expect(graph.getNodes(root), isNull);
      },
    );

    test('[createRoot & addNode] Self dependency should be allowed', () {
      final root = MockStore('root');

      graph.createRoot(root);
      graph.addNode(root, root);

      expect(graph.getNodes(root), contains(root));
    });

    test(
      '[createRoot & addNode] Adding multiple different nodes to the same root',
      () {
        final root = MockStore('root');
        final dep1 = MockStore('dep1');
        final dep2 = MockStore('dep2');

        graph.createRoot(root);
        graph.addNode(root, dep1);
        graph.addNode(root, dep2);

        expect(graph.getNodes(root), containsAll([dep1, dep2]));
      },
    );

    test(
      '[createRoot, addNode & removeNode] Adding and then removing a node should result in no dependencies',
      () {
        final root = MockStore('root');
        final dependent = MockStore('dependent');

        graph.createRoot(root);
        graph.addNode(root, dependent);
        graph.removeNode(root, dependent);

        expect(graph.getNodes(root), isNot(contains(dependent)));
      },
    );

    test(
      '[createRoot & addNode] Repeatedly adding the same node should not affect the dependencies count',
      () {
        final root = MockStore('root');
        final dependent = MockStore('dependent');

        graph.createRoot(root);
        graph.addNode(root, dependent);
        graph.addNode(root, dependent);

        expect(graph.getNodes(root)?.length, equals(1));
      },
    );
  });
}

///
/// Mock store class to help testing the graph w/ custom objects
///
class MockStore {
  ///
  /// A name associated with an object
  /// similar to how states are associated with the store
  ///
  final String name;

  ///
  /// Public constructor for [MockStore]
  ///
  MockStore(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockStore &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
