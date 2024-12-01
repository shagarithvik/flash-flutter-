import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:edtech_app/main.dart';  // Update this import based on your project structure
import 'package:edtech_app/pages/upload_page.dart'; // Import your pages
import 'package:edtech_app/pages/flashcard_page.dart';
import 'package:edtech_app/pages/api_key_page.dart';

void main() {
  testWidgets('App navigation and basic interactions test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that we are on the Upload Page.
    expect(find.byType(UploadPage), findsOneWidget);
    expect(find.text('Select PDF'), findsOneWidget);

    // Simulate tapping the "Select PDF" button.
    await tester.tap(find.text('Select PDF'));
    await tester.pumpAndSettle();

    // Since there's no file picker in the test environment, navigate manually to FlashcardPage.
    await tester.tap(find.byIcon(Icons.arrow_forward)); // Example if you add a navigation button.
    await tester.pumpAndSettle();

    // Verify Flashcard Page is displayed.
    expect(find.byType(FlashcardPage), findsOneWidget);

    // Simulate navigating to API Key Page via app drawer or button.
    await tester.tap(find.text('Enter API Key')); // Or button leading to API Key Page.
    await tester.pumpAndSettle();

    // Verify API Key Page is displayed.
    expect(find.byType(ApiKeyPage), findsOneWidget);
    expect(find.text('OpenAI API Key'), findsOneWidget);

    // Simulate entering API Key and saving it.
    await tester.enterText(find.byType(TextField), 'test-api-key-123');
    await tester.tap(find.text('Save Key'));
    await tester.pump();

    // Verify that the API key was saved (using a SnackBar message or UI indication).
    expect(find.text('API Key Saved'), findsOneWidget);
  });
}
