import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/responsive/tablet.dart';
import 'landing/mobile_land.dart';
import 'login+register/register/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Hydroferma());
}

class Hydroferma extends StatelessWidget {
  const Hydroferma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ConnectBluetooth(),
      home: AppScreen(),
      // home: ResponsiveLayout(
      //   mobileScaffold: MobileScaffold(),
      //   tabScaffold: TabletScaffold(),
      //   desktopScaffold: DesktopScaffold(),
      // ),
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? LoginPage()
          : TabletScaffold(),
    );
  }
}
