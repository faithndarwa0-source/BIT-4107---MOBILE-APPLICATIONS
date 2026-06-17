import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'database_helper.dart';

// Global notifier for theme management
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('isDark') ?? false;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wonderful Glass Mart',
          themeMode: currentMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: const Color(0xFF0D47A1),
              secondary: Colors.black,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.blue.shade400,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: const Color(0xFF0D47A1),
              secondary: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: const Color(0xFF121212),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.blue.shade200,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
