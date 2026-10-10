import 'package:flutter/material.dart';

class AppTheme {
  // Gold color palette
  static const Color primaryGold = Color(0xFFD4AF37); // Rich gold
  static const Color darkGold = Color(0xFFB8860B); // Dark goldenrod
  static const Color lightGold = Color(0xFFFFD700); // Light gold
  static const Color paleGold = Color(0xFFFFF8DC); // Cornsilk
  static const Color amber = Color(0xFFFFC107); // Amber accent
  
  // Complementary colors
  static const Color deepBrown = Color(0xFF3E2723); // Deep brown
  static const Color warmBrown = Color(0xFF5D4037); // Warm brown
  static const Color cream = Color(0xFFFFFBF0); // Cream
  static const Color ivory = Color(0xFFFFFFF0); // Ivory
  
  // Semantic colors
  static const Color success = Color(0xFFD4AF37);
  static const Color error = Color(0xFFB8860B);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFFD4AF37);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryGold,
      secondary: darkGold,
      tertiary: lightGold,
      surface: Colors.white,
      background: cream,
      error: Colors.red.shade800,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: deepBrown,
      onBackground: deepBrown,
      surfaceVariant: paleGold,
    ),
    scaffoldBackgroundColor: cream,
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGold,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    // Card
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      shadowColor: primaryGold.withOpacity(0.3),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGold,
        side: const BorderSide(color: primaryGold, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGold,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryGold,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: paleGold.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGold.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGold.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade800),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Icon
    iconTheme: const IconThemeData(
      color: primaryGold,
      size: 24,
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: primaryGold.withOpacity(0.2),
      thickness: 1,
    ),

    // Progress Indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryGold,
      linearTrackColor: paleGold,
    ),

    // Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: paleGold,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: primaryGold);
        }
        return IconThemeData(color: Colors.grey.shade600);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: primaryGold,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: Colors.grey.shade600,
          fontSize: 12,
        );
      }),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: paleGold,
      selectedColor: primaryGold,
      labelStyle: const TextStyle(color: deepBrown),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: lightGold,
      secondary: primaryGold,
      tertiary: amber,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: Colors.red.shade400,
      onPrimary: deepBrown,
      onSecondary: deepBrown,
      onSurface: lightGold,
      onBackground: Colors.white,
      surfaceVariant: warmBrown,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: deepBrown,
      foregroundColor: lightGold,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: lightGold,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: lightGold),
    ),

    // Card
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFF1E1E1E),
      shadowColor: lightGold.withOpacity(0.3),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightGold,
        foregroundColor: deepBrown,
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightGold,
        side: const BorderSide(color: lightGold, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightGold,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightGold,
      foregroundColor: deepBrown,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: warmBrown.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightGold.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: lightGold.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Icon
    iconTheme: const IconThemeData(
      color: lightGold,
      size: 24,
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: lightGold.withOpacity(0.2),
      thickness: 1,
    ),

    // Progress Indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: lightGold,
      linearTrackColor: warmBrown,
    ),

    // Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: warmBrown,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: lightGold);
        }
        return IconThemeData(color: Colors.grey.shade400);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: lightGold,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: Colors.grey.shade400,
          fontSize: 12,
        );
      }),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: warmBrown,
      selectedColor: lightGold,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: deepBrown),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  // Gradient decorations
  static BoxDecoration goldGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryGold.withOpacity(0.1),
        paleGold.withOpacity(0.1),
      ],
    ),
  );

  static BoxDecoration darkGoldGradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        warmBrown.withOpacity(0.3),
        deepBrown.withOpacity(0.3),
      ],
    ),
  );

  static LinearGradient goldShimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      darkGold,
      primaryGold,
      lightGold,
      primaryGold,
      darkGold,
    ],
  );
}
