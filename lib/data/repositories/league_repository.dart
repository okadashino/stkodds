import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore/firestore_collections.dart';
import '../models/league.dart';

class LeagueRepository {
  LeagueRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection(FirestoreCollections.leagues);
  }

  Future<League> create(League league) async {
    final id = league.id.isEmpty ? _collection.doc().id : league.id;
    final saved = league.copyWith(id: id);
    await _collection.doc(id).set(saved.toFirestore());
    return saved;
  }

  Future<League?> getById(String id) async {
    final snapshot = await _collection.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return League.fromFirestore(snapshot);
  }

  Future<List<League>> getAll() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map(League.fromFirestore).toList();
  }

  Future<League> update(League league) async {
    await _collection.doc(league.id).set(league.toFirestore());
    return league;
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }

  Stream<List<League>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs.map(League.fromFirestore).toList(),
    );
  }

  Stream<League?> watchById(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return League.fromFirestore(snapshot);
    });
  }

  Stream<List<League>> watchByMember(String userId) {
    return _collection
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(League.fromFirestore).toList());
  }
}
