import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stkodds/app.dart';

void main() {
  testWidgets('HomePage placeholder is shown', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StkOddsApp(),
      ),
    );

    expect(find.text('stkodds'), findsOneWidget);
    expect(find.text('HomePage'), findsOneWidget);
  });
}
