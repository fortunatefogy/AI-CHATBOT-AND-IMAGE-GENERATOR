// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luna/helper/global.dart';
import 'package:luna/helper/pref.dart';
import 'package:luna/model/home_type.dart';
import 'package:luna/widget/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;

    // Load the current theme mode from the preferences
    isDarkMode = Pref.isDarkMode;
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      Pref.isDarkMode = isDarkMode;

      // Change the app's theme mode dynamically
      if (isDarkMode) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 20),
            onPressed: _toggleTheme, // Toggle the theme when pressed
            icon: Icon(
              isDarkMode ? Icons.brightness_7 : Icons.brightness_2_rounded, // Switch icon based on theme
              size: 26,
            ),
          )
        ],
        elevation: 1,
        centerTitle: true,
        title: Text(
          appName,
          style: TextStyle(
              color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .02, vertical: mq.height * .015),
        children: HomeType.values
            .map((e) => HomeCard(
                  homeType: e,
                ))
            .toList(),
      ),
    );
  }
}
