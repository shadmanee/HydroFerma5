import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/home/notifications.dart';
import 'package:hydroferma5/lifecycle/lifecycle_cam.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/responsive/tablet.dart';
import 'package:hydroferma5/test/test.dart';
import 'package:hydroferma5/util/waterchart.dart';
import 'package:hydroferma5/water+nutrient/water.dart';
// import 'package:hydroferma5/test/test.dart';
import 'landing/mobile_land.dart';
import 'login+register/login&register.dart';
import 'login+register/register/signup.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(Hydroferma());
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message ${message.messageId}');
// }

class Hydroferma extends StatelessWidget {
  const Hydroferma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ResponsiveLayout(
      //   mobileScaffold: MobileScaffold(),
      //   tabScaffold: TabletScaffold(),
      //   desktopScaffold: DesktopScaffold(),
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => AppScreen(),
        '/home': (context) => Dashboard(),
        // add other routes here
      },
    );
  }
}

class AppScreen extends StatelessWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? const MobileLand()
          : const TabletScaffold(),
    );
  }
}
