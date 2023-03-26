import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hydroferma5/util/colors.dart';

import '../login+register/login&register.dart';

class MobileLand extends StatefulWidget {
  const MobileLand({Key? key}) : super(key: key);

  @override
  State<MobileLand> createState() => _MobileLandState();
}

class _MobileLandState extends State<MobileLand> with TickerProviderStateMixin {
  late AnimationController controller;

  late int move = getRandomNumber();

  int getRandomNumber() {
    var rng = Random();
    int min = 1;
    int max = 9;
    int randomNumber = min + rng.nextInt(max - min);
    return randomNumber;
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: move),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: false);
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: move);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LandingPage())
        // PageTransition(
        //   duration: Duration(seconds: 1),
        //   curve: Curves.linear,
        //   type: PageTransitionType.bottomToTop,
        //   child: LoginPage(),
        // ),
        );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: logo_blue,
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 400,
                child: Image.asset('images/logo-blue-bgless.png'),
              ),
            ),
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Circular progress indicator',
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 280),
              child: const Text(
                'HYDROFERMA',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }
}
