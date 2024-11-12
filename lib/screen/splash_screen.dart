// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:luna/helper/global.dart';
import 'package:luna/helper/pref.dart';
import 'package:luna/screen/home_screen.dart';
// import 'package:luna/screen/home_screen.dart';
import 'package:luna/screen/onboarding_screen.dart';
import 'package:luna/widget/custom_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              Pref.showOnboarding ? const OnboardingScreen() : HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Spacer(),
            Spacer(flex: 2),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(mq.width * .05),
                child: Image.asset('assets/images/logo.png',
                    width: mq.width * .30),
              ),
            ),
            Spacer(),
            CustomLoading(),
            Spacer()
          ],
        ),
      ),
    );
  }
}
