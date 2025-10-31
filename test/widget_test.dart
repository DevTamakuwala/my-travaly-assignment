// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_travaly_assignment/main.dart';
import 'package:my_travaly_assignment/screens/google_sign_in_screen.dart';
import 'package:my_travaly_assignment/widgets/google_sign_in_button.dart';

void main() {
  testWidgets('GoogleSignInScreen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We pass `isSignedIn: false` to ensure we start on the GoogleSignInScreen.
    await tester.pumpWidget(const MyApp(isSignedIn: false));

    // Verify that the GoogleSignInScreen is present.
    expect(find.byType(GoogleSignInScreen), findsOneWidget);

    // Verify that the "Welcome!" text is displayed.
    expect(find.text('Welcome!'), findsOneWidget);

    // Verify that the Google Sign-In button is displayed.
    expect(find.byType(GoogleSignInButton), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);

    // Verify that the app logo is present.
    expect(find.byType(Image), findsOneWidget);
  });
}
