// ignore_for_file: unnecessary_import, avoid_print

// import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Pref {
  static late Box _box;
  static bool _isInitialized = false;

  // Initialize the Hive box
  static Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox('mydata');
      _isInitialized = true;
      print("Pref initialized successfully");
    } catch (e) {
      print("Pref initialization error: $e");
      rethrow;
    }
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception(
          "Pref not initialized. Call Pref.initialize() before using it.");
    }
  }

  static bool get isDarkMode {
    _ensureInitialized();
    return _box.get('isDarkMode', defaultValue: false);
  }

  static set isDarkMode(bool v) {
    _ensureInitialized();
    _box.put('isDarkMode', v);
  }

  static bool get showOnboarding {
    _ensureInitialized();
    return _box.get('showOnboarding', defaultValue: true);
  }

  static set showOnboarding(bool v) {
    _ensureInitialized();
    _box.put('showOnboarding', v);
  }
}
