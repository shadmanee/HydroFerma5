import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/util/colors.dart';
import 'package:hydroferma5/util/navbar.dart';
import 'package:hydroferma5/water+nutrient/water.dart';
import 'package:page_transition/page_transition.dart';

class MobileLand extends StatefulWidget {
  const MobileLand({Key? key}) : super(key: key);

  @override
  State<MobileLand> createState() => _MobileLandState();
}

class _MobileLandState extends State<MobileLand> with TickerProviderStateMixin {
  // var _bigger = false;
  late AnimationController controller;
  var move = Random().nextInt(10);

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
      context,
      PageTransition(
        duration: Duration(seconds: 1),
        curve: Curves.linear,
        type: PageTransitionType.bottomToTop,
        child: LoginPage(),
      ),
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
              child: Container(
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
            )
          ],
        ));
  }
}
