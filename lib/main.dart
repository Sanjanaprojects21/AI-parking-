import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AiParkingApp());

class AiParkingApp extends StatelessWidget {
  const AiParkingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AI Parking',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const AuthScreen(),
  );
}
