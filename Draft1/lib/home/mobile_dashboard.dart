import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/util/buttons.dart';
import 'package:hydroferma5/util/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Future getData() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot qn = await firestore.collection("Users").get();
  // }

  bool flag = false;

  bool checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user == null) {
        flag = false;
      }
      flag = true;
    });
    return flag;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientList,
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(checkUser()? "User is currently signed in" : "User is currently signed out"),
            LoginRegisterButton(context, 'Log Out', () {
              print("Signing Out");
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              });
            }),
          ],
        ),
      ),
    );
  }
}
