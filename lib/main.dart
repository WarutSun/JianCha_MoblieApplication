import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Web app dark theme colors (from CSS variables)
  static const Color background = Color(0xFF0A0A0A);     // 0 0% 3.6%
  static const Color foreground = Color(0xFFFAFAFA);      // 0 0% 98%
  static const Color card = Color(0xFF161616);             // 0 0% 8.6%
  static const Color cardForeground = Color(0xFFFAFAFA);
  static const Color muted = Color(0xFF262626);            // 0 0% 14.9%
  static const Color mutedForeground = Color(0xFFA3A3A3);  // 0 0% 63.9%
  static const Color border = Color(0xFF262626);           // 0 0% 14.9%
  static const Color primary = Color(0xFFFAFAFA);          // 0 0% 98%
  static const Color primaryForeground = Color(0xFF0A0A0A);
  static const Color destructive = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Naja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        primaryColor: primary,
        colorScheme: ColorScheme.dark(
          primary: primary,
          onPrimary: primaryForeground,
          surface: card,
          onSurface: foreground,
          error: destructive,
        ),
        cardColor: card,
        cardTheme: CardThemeData(
          color: card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: border),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: card,
          foregroundColor: foreground,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: foreground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: card,
          selectedItemColor: primary,
          unselectedItemColor: mutedForeground,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primary),
          ),
          hintStyle: TextStyle(color: mutedForeground),
          labelStyle: TextStyle(color: mutedForeground),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: primaryForeground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: foreground,
            side: BorderSide(color: border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: primary),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: muted,
          selectedColor: primary,
          labelStyle: TextStyle(color: foreground),
          secondaryLabelStyle: TextStyle(color: primaryForeground),
        ),
        dividerColor: border,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: card,
          contentTextStyle: TextStyle(color: foreground),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: border),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: foreground, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: foreground, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: foreground, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: foreground),
          bodyLarge: TextStyle(color: foreground),
          bodyMedium: TextStyle(color: foreground),
          bodySmall: TextStyle(color: mutedForeground),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
