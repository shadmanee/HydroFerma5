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
  // Future<void> signInWithEmail(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User? user = userCredential.user;
  //     if (user != null) {
  //       String? displayName = user.displayName;
  //       print('Signed in user: $displayName');
  //       username = displayName!;
  //     }
  //   } catch (e) {
  //     print('Sign-in error: $e');
  //   }
  // }

  String username = '';

  void getCurrentUserDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      username = user.displayName!;
      print('Current user display name: $username');
    }
  }

  bool flag = false;

  bool checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        flag = false;
      }
      else {
        getCurrentUserDisplayName();
        flag = true;
      }
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
            Text(checkUser()
                ? "User $username is currently signed in"
                : "User is currently signed out"),
            LoginRegisterButton(context, 'Log Out', () {
              print("Signing Out");
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              });
            }),
          ],
        ),
      ),
    );
  }
}
