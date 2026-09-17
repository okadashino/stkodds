import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/firebase/remote_config_bootstrap.dart';
import 'data/local/hive_bootstrap.dart';
import 'data/repositories/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await initializeHive();

  if (FirebaseAuth.instance.currentUser == null) {
    await ensureAnonymousUser();
  }

  await initializeRemoteConfig();

  runApp(const ProviderScope(child: StkOddsApp()));
}
