import 'package:flutter/material.dart';
import 'package:hydroferma5/home/user.dart';
import 'package:page_transition/page_transition.dart';

import '../util/sidebar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset('images/logo-white.png'),
                    iconSize: 45,
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        iconSize: 35,
                        color: const Color(0xff7aa3c7),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          curve: Curves.linear,
                          type: PageTransitionType.bottomToTop,
                          child: const UserInfo(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xff7aa3c7),
                    borderRadius: BorderRadius.circular(20.0)),
                child: ListView(
                  /// hard-coded dismissible notification
                  children: <Widget>[
                    _dismissed
                        ? const SizedBox.shrink()
                        : Dismissible(
                            key: const Key('Notification'),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              setState(() {
                                _dismissed = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Dismissed'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () {
                                      setState(() {
                                        _dismissed = false;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              color: const Color(0xccffffff),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                      title: Row(
                                    children: [
                                      Text(
                                        'Water & Nutrient Supply',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Expanded(child: Container()),
                                      Text('56m',
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontWeight: FontWeight.w600))
                                    ],
                                  )),
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13,
                                              left: 16,
                                              right: 16,
                                              bottom: 10),
                                          child: Text(
                                            'Your system supplied 0.53 mg of MgPH to the nutrient medium.',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 17),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                // Perform some action
                                              },
                                              child: const Text(
                                                'Okay',
                                                style: TextStyle(
                                                  color: Color(0xFF408FD0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
