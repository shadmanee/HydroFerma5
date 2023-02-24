// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hydroferma5/landing/landing.dart';
import 'package:hydroferma5/landing/mobile_land.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({Key? key}) : super(key: key);

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: MobileLand(),
    );
  }
}
