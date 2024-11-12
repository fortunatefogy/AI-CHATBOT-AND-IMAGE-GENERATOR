// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luna/helper/global.dart';
import 'package:luna/helper/pref.dart';
import 'package:luna/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Pref.initialize(); // Ensure Pref is initialized

  bool isDarkMode = Pref.isDarkMode; // Get the saved theme mode

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Pass isDarkMode when calling MyApp
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // Set the initial theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          elevation: 1,
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      home: SplashScreen(), // You can replace this with HomeScreen() if SplashScreen is temporary
    );
  }
}

extension apptheme on ThemeData {
  Color get lightTextColor =>
      brightness == Brightness.dark ? Colors.white70 : Colors.black54;

  Color get buttonColor => brightness == Brightness.dark
      ? const Color.fromARGB(255, 255, 255, 255)
      : const Color.fromARGB(255, 41, 147, 234);
}
