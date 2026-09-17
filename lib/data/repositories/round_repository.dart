import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore/firestore_collections.dart';
import '../models/round.dart';

class RoundRepository {
  RoundRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection(FirestoreCollections.rounds);
  }

  Future<Round> create(Round round) async {
    final id = round.id.isEmpty ? _collection.doc().id : round.id;
    final saved = round.copyWith(id: id);
    await _collection.doc(id).set(saved.toFirestore());
    return saved;
  }

  Future<Round?> getById(String id) async {
    final snapshot = await _collection.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Round.fromFirestore(snapshot);
  }

  Future<List<Round>> getAll() async {
    final snapshot = await _collection.get();
    return _sorted(snapshot.docs.map(Round.fromFirestore));
  }

  Future<List<Round>> getByLeague(String leagueId) async {
    final snapshot = await _collection
        .where('leagueId', isEqualTo: leagueId)
        .get();
    return _sorted(snapshot.docs.map(Round.fromFirestore));
  }

  Future<Round> update(Round round) async {
    await _collection.doc(round.id).set(round.toFirestore());
    return round;
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }

  Stream<List<Round>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => _sorted(snapshot.docs.map(Round.fromFirestore)),
    );
  }

  Stream<Round?> watchById(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return Round.fromFirestore(snapshot);
    });
  }

  Stream<List<Round>> watchByLeague(String leagueId) {
    return _collection
        .where('leagueId', isEqualTo: leagueId)
        .snapshots()
        .map((snapshot) => _sorted(snapshot.docs.map(Round.fromFirestore)));
  }

  List<Round> _sorted(Iterable<Round> rounds) {
    final items = rounds.toList()
      ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    return items;
  }
}
