import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/login+register/register/signup.dart';
import 'package:hydroferma5/util/colors.dart';
import 'package:hydroferma5/util/text_fields.dart';
import 'package:page_transition/page_transition.dart';

import '../../util/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool value = false;
  bool flag = false;
  String error_text = '';

  void changeState(bool? val) {
    setState(() {
      this.value = !value;
    });
  }

  late UserCredential user;

  Future<void> _signIn() async {
    try {
      // Call the signInWithEmailAndPassword method with the user's email and password
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text);
      // Navigate to the home screen if the sign-in is successful
    } on FirebaseAuthException catch (e) {
      // Show a toast message with the error message
      switch (e.code) {
        case 'wrong-password':
          error_text = 'Wrong password';
          break;
        case 'invalid-email':
          error_text = 'Invalid e-mail';
          break;
        case 'user-not-found':
          error_text = 'User Not Found';
          break;
      }
      Fluttertoast.showToast(
        msg: error_text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientList,
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 70.0, left: 20.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black45,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 150-70, 40, 0),
                    child: Column(
                      children: [
                        Image.asset('images/logo-green.png'),
                        SizedBox(
                          height: 30,
                        ),
                        reusableTextField(
                          "Email Address",
                          Icons.person_outline_outlined,
                          false,
                          _emailTextController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                          "Password",
                          Icons.lock_person_outlined,
                          false,
                          _passwordTextController,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: this.value,
                              onChanged: changeState,
                              activeColor: Color(0xff48BFA3),
                              side: MaterialStateBorderSide.resolveWith(
                                    (states) =>
                                    BorderSide(width: 1.5, color: Colors.black45),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'Remember Me',
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                            Expanded(child: Container()),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(right: 15),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            )
                          ],
                        ),
                        LoginRegisterButton(context, 'Log In', () {
                          print("Signing In");
                          _signIn();
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        SignUpOption(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Row SignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't already have an account? ",
            style: TextStyle(color: Colors.black45)),
        GestureDetector(
          onTap: () {
            // print(MediaQuery.of(context).size.width - 80);
            // Navigator.restorablePushReplacement(context, _myRouteBuilder);
            Navigator.pushReplacement(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.bottomToTop,
                child: SignUpPage(),
              ),
            );
          },
          child: Text(
            'Sign Up.',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
