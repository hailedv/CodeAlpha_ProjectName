import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:device_preview/device_preview.dart';  // Temporarily disabled
import 'providers/app_provider.dart';
import 'screens/home_screen_new.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FlashcardQuizApp());  // Simplified - no DevicePreview
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..initialize(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return MaterialApp(
            title: 'Flashcard Quiz Pro',
            debugShowCheckedModeBanner: false,
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const HomeScreenNew(),
          );
        },
      ),
    );
  }
}


