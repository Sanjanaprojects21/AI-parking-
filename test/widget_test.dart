import 'package:ai_parking/main.dart';
import 'package:ai_parking/screens/auth_screen.dart';
import 'package:ai_parking/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> submit(WidgetTester tester) async {
    final button = find.byKey(const ValueKey('submit'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  testWidgets('Sign in validates fields and toggles password visibility', (
    tester,
  ) async {
    await tester.pumpWidget(const AiParkingApp());
    expect(find.text('Welcome back.'), findsOneWidget);
    await submit(tester);
    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    final password = find.byKey(const ValueKey('password'));
    await tester.ensureVisible(password);
    await tester.enterText(password, 'secret-password');
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    final editable = find.descendant(
      of: password,
      matching: find.byType(EditableText),
    );
    expect(tester.widget<EditableText>(editable).obscureText, isFalse);
    expect(
      tester.widget<TextFormField>(password).controller!.text,
      'secret-password',
    );
  });

  testWidgets(
    'Sign up checks matching passwords and reports account availability',
    (tester) async {
      await tester.pumpWidget(const AiParkingApp());
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.text('Start your journey.'), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('name')), 'Taylor');
      await tester.enterText(
        find.byKey(const ValueKey('email')),
        'taylor@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password')),
        'password123',
      );
      await tester.enterText(
        find.byKey(const ValueKey('confirmation')),
        'different',
      );
      await submit(tester);
      expect(find.text('Passwords do not match.'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('confirmation')),
        'password123',
      );
      await submit(tester);
      expect(find.text('RTSP monitor'), findsOneWidget);
    },
  );

  testWidgets('Small displays and enlarged text can reach the full form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: const AuthScreen(),
      ),
    );
    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    await submit(tester);
    expect(find.text('Confirm your password.'), findsOneWidget);
  });
}
