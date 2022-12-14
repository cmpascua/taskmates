// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;

void main() {
  testWidgets("Happy path 1 test", (tester) async {
    // Once user launches the app, a login screen with an email field, password field, login button, and sign up button appears.
    app.main();
    await tester.pumpAndSettle();
    final screenDisplay = find.text("Login");
    final userNameField = find.byKey(const Key("emailFieldL"));
    final passwordField = find.byKey(const Key("passwordFieldL"));
    final loginButton = find.byKey(const Key("loginButton"));
    final signUpButton = find.byKey(const Key("signupButtonL"));

    expect(screenDisplay, findsOneWidget);
    expect(userNameField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);
    expect(signUpButton, findsOneWidget);

    await tester.tap(signUpButton);
    final signupDisplay = find.text("Sign Up");
    expect(signupDisplay, findsOneWidget);
  });
}
