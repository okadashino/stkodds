import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../firestore/firestore_collections.dart';
import '../models/fixture.dart';

class FixtureRepository {
  FixtureRepository({
    required this.firestore,
    required this.cache,
  });

  final FirebaseFirestore firestore;
  final Box<Fixture> cache;

  CollectionReference<Map<String, dynamic>> get _collection {
    return firestore.collection(FirestoreCollections.fixtures);
  }

  Future<Fixture> create(Fixture fixture) async {
    final id = fixture.id.isEmpty ? _collection.doc().id : fixture.id;
    final saved = fixture.copyWith(id: id);
    await _collection.doc(id).set(saved.toFirestore());
    await cache.put(saved.id, saved);
    return saved;
  }

  Future<Fixture?> getById(String id) async {
    try {
      final snapshot = await _collection.doc(id).get();
      if (snapshot.exists) {
        final fixture = Fixture.fromFirestore(snapshot);
        await cache.put(fixture.id, fixture);
        return fixture;
      }
    } catch (_) {
      return cache.get(id);
    }
    return cache.get(id);
  }

  Future<List<Fixture>> getAll() async {
    try {
      final snapshot = await _collection.get();
      final fixtures = _sorted(snapshot.docs.map(Fixture.fromFirestore));
      await cache.putAll({for (final fixture in fixtures) fixture.id: fixture});
      return fixtures;
    } catch (_) {
      return _sorted(cache.values);
    }
  }

  Future<Fixture> update(Fixture fixture) async {
    await _collection.doc(fixture.id).set(fixture.toFirestore());
    await cache.put(fixture.id, fixture);
    return fixture;
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
    await cache.delete(id);
  }

  Stream<List<Fixture>> watchAll() async* {
    if (cache.isNotEmpty) {
      yield _sorted(cache.values);
    }
    yield* _collection.snapshots().asyncMap((snapshot) async {
      final fixtures = _sorted(snapshot.docs.map(Fixture.fromFirestore));
      await cache.putAll({for (final fixture in fixtures) fixture.id: fixture});
      return fixtures;
    });
  }

  Stream<Fixture?> watchById(String id) async* {
    final cached = cache.get(id);
    if (cached != null) {
      yield cached;
    }
    yield* _collection.doc(id).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) {
        await cache.delete(id);
        return null;
      }
      final fixture = Fixture.fromFirestore(snapshot);
      await cache.put(fixture.id, fixture);
      return fixture;
    });
  }

  List<Fixture> _sorted(Iterable<Fixture> fixtures) {
    final items = fixtures.toList()
      ..sort((a, b) => a.kickoff.compareTo(b.kickoff));
    return items;
  }
}
