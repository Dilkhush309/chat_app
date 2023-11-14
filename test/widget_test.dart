import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/main.dart';

void main() {
  testWidgets('WebSocket Client Integration Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify initial state
    expect(find.text('Server 1'), findsOneWidget);
    expect(find.text('Server 2 is selected'), findsNothing);

    // Tap Server 2 checkbox
    await tester.tap(find.text('Server 2'));
    await tester.pump();

    // Verify that Server 2 is selected
    expect(find.text('Server 1 is selected'), findsNothing);
    expect(find.text('Server 2'), findsOneWidget);

    // Tap the Connect Server Button
    await tester.tap(find.text('Connect Server Button'));
    await tester.pump();

    // Tap the Authentication Button
    await tester.tap(find.text('Authentication Button'));
    await tester.pump();

    // Tap the Disaster Information Button
    await tester.tap(find.text('Disaster Information Button'));
    await tester.pump();
  });
}
