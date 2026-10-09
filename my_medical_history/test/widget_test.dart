import 'package:flutter_test/flutter_test.dart';
import 'package:my_medical_history/main.dart';

void main() {
  testWidgets('App splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyMedicalHistoryApp());

    // Verify that Splash screen title exists
    expect(find.text('MY MEDICAL HISTORY'), findsOneWidget);

    // Advance time past the splash screen timer to cleanly complete
    await tester.pump(const Duration(seconds: 3));
  });
}
