import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'promo_config.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final remoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  return FirebaseRemoteConfig.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final promoConfigProvider = Provider<PromoConfig>((ref) {
  return PromoConfig.fromRemoteConfig(ref.watch(remoteConfigProvider));
});

final promoEnabledProvider = Provider<bool>((ref) {
  return ref.watch(promoConfigProvider).enabled;
});

final promoUrlProvider = Provider<String>((ref) {
  return ref.watch(promoConfigProvider).url;
});

final promoShowOnLaunchProvider = Provider<bool>((ref) {
  return ref.watch(promoConfigProvider).showOnLaunch;
});

final promoFrequencyProvider = Provider<int>((ref) {
  return ref.watch(promoConfigProvider).frequency;
});
