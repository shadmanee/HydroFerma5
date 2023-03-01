import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydroferma5/home/mobile_dashboard.dart';
import 'package:hydroferma5/login+register/login/login.dart';
import 'package:hydroferma5/login+register/register/signup.dart';
import 'package:hydroferma5/util/colors.dart';
import 'package:hydroferma5/util/text_fields.dart';
import 'package:page_transition/page_transition.dart';

import '../../util/buttons.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _unameTextController = TextEditingController();
  bool value = false;

  void changeState(bool? val) {
    setState(() {
      this.value = !value;
    });
  }

  // FirebaseAuth.instance
  //     .createUserWithEmailAndPassword(
  // email: _emailTextController.text,
  // password: _passwordTextController.text)
  //     .then((value) {
  // print("Creating New Account");
  // Navigator.push(context,
  // MaterialPageRoute(builder: (context) => Dashboard()));
  // }).onError((error, stackTrace) {
  // print("Error ${error.toString()}");
  // });

  Future<void> signUpWithEmail(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(displayName);
        print('Signed up user: $displayName');
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } catch (e) {
      print('Sign-up error: $e');
    }
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
        )),
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
                    padding: MediaQuery.of(context).size.width <= 450
                        ? EdgeInsets.fromLTRB(40, 150 - 90, 40,
                            MediaQuery.of(context).size.height - 150)
                        : EdgeInsets.fromLTRB(100, 200, 100, 0),
                    child: Column(
                      children: [
                        Image.asset('images/logo-green.png'),
                        SizedBox(
                          height: 30,
                        ),
                        reusableTextField("Username", Icons.person_outline,
                            false, _unameTextController),
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Email Address", Icons.email, false,
                            _emailTextController),
                        SizedBox(
                          height: 20,
                        ),
                        reusableTextField(
                            "Password",
                            Icons.lock_person_outlined,
                            false,
                            _passwordTextController),
                        Row(
                          children: [
                            Checkbox(
                              value: this.value,
                              onChanged: changeState,
                              activeColor: Color(0xff48BFA3),
                              side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 1.5, color: Colors.black45),
                              ),
                            ),
                            Text('I agree to the ',
                                style: TextStyle(color: Colors.black45)),
                            Text('terms and conditions.',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        LoginRegisterButton(context, 'Sign Up', () {
                          signUpWithEmail(
                              _emailTextController.text,
                              _passwordTextController.text,
                              _unameTextController.text);
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        LogInOption(),
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

  Row LogInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ",
            style: TextStyle(color: Colors.black45)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.bottomToTop,
                child: LoginPage(),
              ),
            );
          },
          child: Text(
            'Log In.',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
