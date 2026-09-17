import 'package:firebase_auth/firebase_auth.dart';

Future<User> ensureAnonymousUser() async {
  final auth = FirebaseAuth.instance;
  final currentUser = auth.currentUser;
  if (currentUser != null) {
    return currentUser;
  }

  final credential = await auth.signInAnonymously();
  final user = credential.user;
  if (user == null) {
    throw StateError('Anonymous sign-in did not return a user.');
  }
  return user;
}
