import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class Land extends StatefulWidget {
  const Land({Key? key}) : super(key: key);
  @override
  State<Land> createState() => _LandState();
}

class _LandState extends State<Land> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 7);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Land()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff77AAD4),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Row(children: [
                Expanded(child: Container()),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.aspectRatio * 600,
                      child: Image.asset('images/logo-blue.png'),
                    ),
                    Text(
                      'Hydroferma',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                          MediaQuery.of(context).size.aspectRatio * 90,
                          color: Colors.white),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 1.7,
                        padding: EdgeInsets.only(top: 30),
                        child: FAProgressBar(
                          progressColor: Colors.white,
                          displayTextStyle:
                          TextStyle(color: Colors.grey[500]),
                          maxValue: 100,
                          currentValue: 100,
                          displayText: '%',
                          direction: Axis.horizontal,
                          animatedDuration: Duration(seconds: 6),
                        ))
                  ],
                ),
                Expanded(child: Container())
              ]),
              Expanded(child: Container())
            ],
          ),
        ));
  }
}