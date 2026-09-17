import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import 'promo_config.dart';

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults(PromoConfig.defaults);

  try {
    await remoteConfig.fetchAndActivate();
  } on FirebaseException catch (error, stackTrace) {
    debugPrint('Remote Config fetch skipped: ${error.message}');
    debugPrint('$stackTrace');
  }
}
