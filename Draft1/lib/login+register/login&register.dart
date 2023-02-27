import 'package:flutter/material.dart';
import 'package:hydroferma5/login+register/register/signup.dart';
import 'package:hydroferma5/util/buttons.dart';
import 'package:hydroferma5/util/colors.dart';
import 'package:page_transition/page_transition.dart';

import 'login/login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _logoOffsetAnimation;
  late Animation<double> _buttonsOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoSizeAnimation =
        Tween<double>(begin: 400, end: 100).animate(_animationController);

    _logoOffsetAnimation = Tween<double>(begin: 0.0, end: -60.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut)));

    _buttonsOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeIn)));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientList,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, _logoOffsetAnimation.value),
                    child: Image.asset(
                      width: _logoSizeAnimation.value,
                      height: _logoSizeAnimation.value,
                      'images/logo-green.png',
                    ),
                  ),
                  Opacity(
                    opacity: _buttonsOpacityAnimation.value,
                    child: Column(
                      children: [
                        LoginRegisterButton(context, 'Log In', () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: LoginPage(),
                            ),
                          );
                        }),
                        LoginRegisterButton(context, 'Sign Up', () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: SignUpPage(),
                            ),
                          );
                        }),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
