import 'package:ecko/src/stores/core/manager.store.ecko.dart';
import 'package:ecko/src/stores/store_impl.store.ecko.dart';
import 'package:ecko/src/utils/logger.util.ecko.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StoreManager Tests', () {
    late StoreManager storeManager;
    late Store rootStore;
    late Store dependentStore;

    setUpAll(() {
      EckoLogger.init(shouldPrintLogs: false);

      storeManager = StoreManager.init();

      rootStore = Store(1);
      dependentStore = Store("");
    });

    // clear the store graph before running every test
    setUp(() {
      storeManager.clearStoreGraph();
    });

    test(
      'createRootNode should create a root node when not already created',
      () {
        expect(storeManager.createRootNode(rootStore), isTrue);
        expect(storeManager.createRootNode(rootStore), isFalse);
      },
    );

    test('deleteRoot should delete root', () {
      storeManager.createRootNode(rootStore);

      expect(storeManager.deleteRoot(rootStore), isTrue);
      expect(storeManager.deleteRoot(rootStore), isFalse);
    });

    test('addDependency should add a dependency', () {
      // add dependency with non existant root node
      expect(storeManager.addDependency(rootStore, dependentStore), isNull);

      // create root node
      storeManager.createRootNode(rootStore);

      // add dependency to the root node
      expect(storeManager.addDependency(rootStore, dependentStore), isTrue);

      // add same dependency to the root node, should not add again
      expect(storeManager.addDependency(rootStore, dependentStore), isFalse);
    });

    test('removeDependency should remove a dependency', () {
      // removing dependency from a non existent root
      expect(storeManager.removeDependency(rootStore, dependentStore), isNull);

      // create root and dependency
      storeManager.createRootNode(rootStore);
      storeManager.addDependency(rootStore, dependentStore);

      // try to remove the dependency
      expect(storeManager.removeDependency(rootStore, dependentStore), isTrue);
      expect(storeManager.removeDependency(rootStore, dependentStore), isFalse);
    });

    test('updateStoreNodes should return set of dependencies if exists', () {
      final Set<dynamic> mockSet = {dependentStore};

      storeManager.createRootNode(rootStore);
      storeManager.addDependency(rootStore, dependentStore);

      expect(storeManager.updateStoreNodes(rootStore), mockSet);
    });

    test('updateStoreNodes should return null if no dependencies exists', () {
      expect(storeManager.updateStoreNodes(rootStore), isNull);
    });
  });
}
