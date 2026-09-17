import 'package:flutter_test/flutter_test.dart';
import 'package:stkodds/core/firebase/promo_config.dart';

void main() {
  test('promo Remote Config defaults match the launch contract', () {
    expect(PromoConfig.defaults, {
      'promo_enabled': false,
      'promo_url': '',
      'promo_show_on_launch': true,
      'promo_frequency': 1,
    });
  });

  test('PromoConfig reads values from a Remote Config source', () {
    const config = PromoConfig.fromValues(
      promoEnabled: true,
      promoUrl: 'https://example.com/promo',
      promoShowOnLaunch: false,
      promoFrequency: 3,
    );

    expect(config.enabled, isTrue);
    expect(config.url, 'https://example.com/promo');
    expect(config.showOnLaunch, isFalse);
    expect(config.frequency, 3);
  });
}
