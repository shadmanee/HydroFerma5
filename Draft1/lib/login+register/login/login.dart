import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  void changeState(bool? val) {
    setState(() {
      this.value = !value;
    });
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
        child: Container(
          padding: MediaQuery.of(context).size.width <= 450
              ? EdgeInsets.fromLTRB(40, 150, 40, 0)
              : EdgeInsets.fromLTRB(100, 200, 100, 0),
          child: Column(
            children: <Widget>[
              Image.asset('images/logo-green.png'),
              SizedBox(
                height: 30,
              ),
              reusableTextField("Email Address", Icons.person_outline_outlined,
                  false, _emailTextController),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Password", Icons.lock_person_outlined, false,
                  _passwordTextController),
              Row(
                children: [
                  Checkbox(
                    value: this.value,
                    onChanged: changeState,
                    activeColor: Color(0xff48BFA3),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => BorderSide(width: 1.5, color: Colors.black45),
                    ),
                  ),
                  GestureDetector(
                    child: Text('Remember Me',
                        style: TextStyle(color: Colors.black45)),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Text('Forgot Password?',
                          style: TextStyle(color: Colors.black45)),
                    ),
                  )
                ],
              ),
              LoginRegisterButton(context, true, () {}),
              SizedBox(
                height: 30,
              ),
              SignUpOption(),
            ],
          ),
        ),
      ),
    );
  }

  static Route<void> _myRouteBuilder(BuildContext context, Object? arguments) {
    return PageTransition(
      curve: Curves.linear,
      type: PageTransitionType.bottomToTop,
      child: SignUpPage(),
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
            Navigator.push(
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
