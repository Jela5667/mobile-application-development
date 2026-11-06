import 'package:flutter_test/flutter_test.dart';
import 'package:student_digital_id/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudentDigitalIdApp());

    // Verify that dashboard title is found.
    expect(find.text('Student Campus Dashboard'), findsOneWidget);
  });
}
