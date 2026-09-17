import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../core/errors/prediction_locked_exception.dart';
import '../../core/time/clock.dart';
import '../firestore/firestore_collections.dart';
import '../models/prediction.dart';
import 'fixture_repository.dart';

class PredictionRepository {
  PredictionRepository({
    required this.firestore,
    required this.cache,
    required this.fixtureRepository,
    required this.clock,
  });

  final FirebaseFirestore firestore;
  final Box<Prediction> cache;
  final FixtureRepository fixtureRepository;
  final Clock clock;

  CollectionReference<Map<String, dynamic>> get _collection {
    return firestore.collection(FirestoreCollections.predictions);
  }

  Future<Prediction> create(Prediction prediction) {
    return _write(prediction);
  }

  Future<Prediction> update(Prediction prediction) {
    return _write(prediction);
  }

  Future<Prediction?> getById(String id) async {
    try {
      final snapshot = await _collection.doc(id).get();
      if (snapshot.exists) {
        final prediction = Prediction.fromFirestore(snapshot);
        await cache.put(prediction.id, prediction);
        return prediction;
      }
    } catch (_) {
      return cache.get(id);
    }
    return cache.get(id);
  }

  Future<List<Prediction>> getAll() async {
    try {
      final snapshot = await _collection.get();
      final predictions = snapshot.docs.map(Prediction.fromFirestore).toList();
      await cache.putAll({
        for (final prediction in predictions) prediction.id: prediction,
      });
      return predictions;
    } catch (_) {
      return cache.values.toList();
    }
  }

  Future<List<Prediction>> getByUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    final predictions = snapshot.docs.map(Prediction.fromFirestore).toList();
    await cache.putAll({
      for (final prediction in predictions) prediction.id: prediction,
    });
    return predictions;
  }

  Future<List<Prediction>> getByRound(String roundId) async {
    final snapshot = await _collection
        .where('roundId', isEqualTo: roundId)
        .get();
    final predictions = snapshot.docs.map(Prediction.fromFirestore).toList();
    await cache.putAll({
      for (final prediction in predictions) prediction.id: prediction,
    });
    return predictions;
  }

  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
    await cache.delete(id);
  }

  Stream<List<Prediction>> watchAll() async* {
    if (cache.isNotEmpty) {
      yield cache.values.toList();
    }
    yield* _collection.snapshots().asyncMap((snapshot) async {
      final predictions = snapshot.docs.map(Prediction.fromFirestore).toList();
      await cache.putAll({
        for (final prediction in predictions) prediction.id: prediction,
      });
      return predictions;
    });
  }

  Stream<Prediction?> watchById(String id) async* {
    final cached = cache.get(id);
    if (cached != null) {
      yield cached;
    }
    yield* _collection.doc(id).snapshots().asyncMap((snapshot) async {
      if (!snapshot.exists) {
        await cache.delete(id);
        return null;
      }
      final prediction = Prediction.fromFirestore(snapshot);
      await cache.put(prediction.id, prediction);
      return prediction;
    });
  }

  Stream<List<Prediction>> watchByUser(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
          final predictions = snapshot.docs
              .map(Prediction.fromFirestore)
              .toList();
          await cache.putAll({
            for (final prediction in predictions) prediction.id: prediction,
          });
          return predictions;
        });
  }

  Stream<List<Prediction>> watchByRound(String roundId) {
    return _collection
        .where('roundId', isEqualTo: roundId)
        .snapshots()
        .asyncMap((snapshot) async {
          final predictions = snapshot.docs
              .map(Prediction.fromFirestore)
              .toList();
          await cache.putAll({
            for (final prediction in predictions) prediction.id: prediction,
          });
          return predictions;
        });
  }

  Future<Prediction> _write(Prediction prediction) async {
    await _assertWritable(prediction.fixtureId);
    final id = prediction.id.isEmpty ? _collection.doc().id : prediction.id;
    final saved = prediction.copyWith(id: id);
    await _collection.doc(id).set(saved.toFirestore());
    await cache.put(saved.id, saved);
    return saved;
  }

  Future<void> _assertWritable(String fixtureId) async {
    final fixture = await fixtureRepository.getById(fixtureId);
    if (fixture == null) {
      throw StateError('Fixture $fixtureId not found');
    }
    if (!clock.now().toUtc().isBefore(fixture.kickoff.toUtc())) {
      throw PredictionLockedException(
        fixtureId: fixture.id,
        kickoff: fixture.kickoff,
      );
    }
  }
}
