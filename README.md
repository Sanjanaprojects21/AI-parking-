# AI Parking

Android Flutter app with a white, cream, and light brown theme.

## Run

With Flutter installed and an Android device or emulator connected:

```sh
flutter pub get
flutter run
```

## Included

- Sign-in and sign-up screens with a responsive layout.
- Email, required-field, password length, and confirmation validation.
- Password visibility controls, autofill hints, and keyboard scrolling.
- Material controls and a consistent light theme.

## Authentication status

These are UI screens. No backend is connected. Submitting valid details displays
an availability message; it does not sign in, create an account, or store/send
credentials. Password recovery also displays an availability message.
Connect an authentication provider in lib/screens/auth_screen.dart before
enabling real accounts. Configure your production Android application ID and
release signing before publishing.

## Checks

```sh
flutter analyze
flutter test
flutter build apk --debug
```
