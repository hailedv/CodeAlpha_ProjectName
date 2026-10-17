import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/flashcard/presentation/providers/flashcard_providers.dart';
import 'features/flashcard/presentation/screens/flashcard_study_screen.dart';

/// Main entry point for Flashcard Quiz App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences for local data storage
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const FlashcardQuizApp(),
    ),
  );
}

/// Root application widget
class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const FlashcardStudyScreen(),
    );
  }
}
