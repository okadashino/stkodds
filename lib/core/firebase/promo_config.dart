import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract final class RemoteConfigKeys {
  static const String promoEnabled = 'promo_enabled';
  static const String promoUrl = 'promo_url';
  static const String promoShowOnLaunch = 'promo_show_on_launch';
  static const String promoFrequency = 'promo_frequency';
}

class PromoConfig {
  const PromoConfig({
    required this.enabled,
    required this.url,
    required this.showOnLaunch,
    required this.frequency,
  });

  const PromoConfig.fromValues({
    required bool promoEnabled,
    required String promoUrl,
    required bool promoShowOnLaunch,
    required int promoFrequency,
  }) : enabled = promoEnabled,
       url = promoUrl,
       showOnLaunch = promoShowOnLaunch,
       frequency = promoFrequency;

  factory PromoConfig.fromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
    return PromoConfig(
      enabled: remoteConfig.getBool(RemoteConfigKeys.promoEnabled),
      url: remoteConfig.getString(RemoteConfigKeys.promoUrl),
      showOnLaunch: remoteConfig.getBool(RemoteConfigKeys.promoShowOnLaunch),
      frequency: remoteConfig.getInt(RemoteConfigKeys.promoFrequency),
    );
  }

  static const Map<String, Object> defaults = {
    RemoteConfigKeys.promoEnabled: false,
    RemoteConfigKeys.promoUrl: '',
    RemoteConfigKeys.promoShowOnLaunch: true,
    RemoteConfigKeys.promoFrequency: 1,
  };

  final bool enabled;
  final String url;
  final bool showOnLaunch;
  final int frequency;
}
