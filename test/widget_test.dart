
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FoxLanguageApp()));

    // Wait a bit for initial builds/animations, but don't wait for infinite ones to settle.
    await tester.pump(const Duration(seconds: 2));

    // Verify that the Fox greeting is present
    expect(find.textContaining('journey'), findsOneWidget);
    
    // Verify bottom navigation exists
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
  });
}
