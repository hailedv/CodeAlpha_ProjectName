import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'features/flashcard/presentation/providers/flashcard_providers.dart';
import 'features/flashcard/presentation/screens/flashcard_study_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    DevicePreview(
      enabled: true, // Set to false in production
      builder: (context) => ProviderScope(
        overrides: [
          // Override sharedPreferences provider
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const FlashcardQuizApp(),
      ),
    ),
  );
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz Pro',
      debugShowCheckedModeBanner: false,
      
      // Device Preview Configuration
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const FlashcardStudyScreen(),
    );
  }
}
