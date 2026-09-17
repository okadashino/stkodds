import 'package:cloud_firestore/cloud_firestore.dart';

import '../firestore/firestore_collections.dart';
import '../models/standing_entry.dart';

class StandingRepository {
  StandingRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String leagueId) {
    return _firestore.collection(FirestoreCollections.standings(leagueId));
  }

  Future<StandingEntry> create(String leagueId, StandingEntry entry) async {
    await _collection(leagueId).doc(entry.userId).set(entry.toFirestore());
    return entry;
  }

  Future<StandingEntry?> getById(String leagueId, String userId) async {
    final snapshot = await _collection(leagueId).doc(userId).get();
    if (!snapshot.exists) {
      return null;
    }
    return StandingEntry.fromFirestore(snapshot);
  }

  Future<List<StandingEntry>> getByLeague(String leagueId) async {
    final snapshot = await _collection(leagueId).get();
    return _sorted(snapshot.docs.map(StandingEntry.fromFirestore));
  }

  Future<StandingEntry> update(String leagueId, StandingEntry entry) async {
    await _collection(leagueId).doc(entry.userId).set(entry.toFirestore());
    return entry;
  }

  Future<void> delete(String leagueId, String userId) {
    return _collection(leagueId).doc(userId).delete();
  }

  Stream<List<StandingEntry>> watchByLeague(String leagueId) {
    return _collection(leagueId).snapshots().map(
      (snapshot) => _sorted(snapshot.docs.map(StandingEntry.fromFirestore)),
    );
  }

  Stream<StandingEntry?> watchById(String leagueId, String userId) {
    return _collection(leagueId).doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }
      return StandingEntry.fromFirestore(snapshot);
    });
  }

  List<StandingEntry> _sorted(Iterable<StandingEntry> entries) {
    final items = entries.toList()
      ..sort((a, b) {
        final rank = a.rank.compareTo(b.rank);
        if (rank != 0) {
          return rank;
        }
        return b.points.compareTo(a.points);
      });
    return items;
  }
}
