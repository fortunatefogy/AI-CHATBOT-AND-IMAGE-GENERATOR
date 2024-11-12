// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:luna/model/home_type.dart';
import '../helper/global.dart';

class HomeCard extends StatelessWidget {
  final HomeType homeType;
  const HomeCard({super.key, required this.homeType});

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;

    // Get the text color based on the current theme
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Change this to your preferred dark mode color
        : Colors.black; // Change this to your preferred light mode color

    return Card(
      color: Colors.blue.withOpacity(.2),
      elevation: 0,
      margin: EdgeInsets.only(bottom: mq.height * .01),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: homeType.OnTap,
        child: Row(
          children: [
            Lottie.asset('assets/lottie/${homeType.Lottie}',
                width: mq.width * .35),
            const Spacer(),
            Text(
              homeType.title,
              style: TextStyle(
                color: textColor, // Use dynamic text color
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    ).animate().fade(duration: 1.seconds, curve: Curves.easeIn);
  }
}
