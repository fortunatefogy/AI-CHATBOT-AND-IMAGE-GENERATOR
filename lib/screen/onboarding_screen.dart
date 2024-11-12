// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:luna/helper/global.dart';
import 'package:luna/main.dart';
// import 'package:luna/main.dart';
import 'package:luna/model/onboard.dart';
import 'package:luna/screen/home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PageController();
    final list = [
      Onboard(
          title: 'Ask me anything !',
          subtitle:
              'I’m Luna, your new personal assistant. I’m here to help you with everything from answering questions to setting reminders. Ready to get started?',
          lottie: 'on1'),

      // onboarding 2
      Onboard(
          title: 'Imagination to reality!',
          subtitle:
              'I’m your creative companion for generating stunning images. Whether you need artwork, designs, or just something fun, I’ve got you covered. Ready to explore your creative side?"',
          lottie: 'on2'),
    ];

    return Scaffold(
        body: PageView.builder(
      controller: c,
      itemCount: list.length,
      itemBuilder: (ctx, ind) {
        final islast = ind == list.length - 1;
        return Column(
          children: [
            Lottie.asset('assets/lottie/${list[ind].lottie}.json',
                height: mq.height * .6),

            // title
            Text(
              list[ind].title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),

            SizedBox(
              height: mq.height * .015,
            ),

            // subtitle
            SizedBox(
              width: mq.width * .9,
              child: Text(
                list[ind].subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, letterSpacing: 1,color: Theme.of(context).lightTextColor),
              ),
            ),

            const Spacer(),
            //dots

            Wrap(
              spacing: 10,
              children: List.generate(
                  list.length,
                  (i) => Container(
                        width: i == ind ? 15 : 10,
                        height: 8,
                        decoration: BoxDecoration(
                            color: i == ind ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      )),
            ),

            const Spacer(),

            // button
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[500],
                    shape: StadiumBorder(),
                    elevation: 0,
                    minimumSize: Size(mq.width * .4, 50)),
                onPressed: () {
                  if (islast) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  } else {
                    c.nextPage(
                        duration: Duration(milliseconds: 900),
                        curve: Curves.easeIn);
                  }
                },
                child: Text(
                  islast ? 'Finish' : 'Next',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                )),
            const Spacer(
              flex: 2,
            ),
          ],
        );
      },
    ));
  }
}
