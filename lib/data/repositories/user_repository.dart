import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> ensureUserDocument(User user) async {
    final doc = _firestore.collection('users').doc(user.uid);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      return;
    }

    await doc.set({
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'isAnonymous': user.isAnonymous,
    });
  }
}
