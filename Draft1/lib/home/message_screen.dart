import 'package:flutter/material.dart';
//import 'dart:js_interop';
import 'package:hydroferma5/home/user.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../util/sidebar.dart';
import 'noti.dart';

class MessageScreen extends StatefulWidget {
  // final String id;
  // final String title;
  // final String body;
  final List<NotificationMessages> messages;

  const MessageScreen({
    Key? key,
    required this.messages,
    // required this.id,
    // required this.title,
    // required this.body,
  }) : super(key: key);
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>{
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
                    for (var message in widget.messages)
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
                      child: Column(
                        children: [
                           // Loop over the list of messages
                            Card(
                              margin: const EdgeInsets.all(8),
                              color: const Color(0xccffffff),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          '${message.msgtitle}', // Access the title of the current message
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 13,
                                            left: 6,
                                            right: 16,
                                            bottom: 13,
                                          ),
                                          child: Text(
                                            '${message.msgbody}', // Access the body of the current message
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.6),
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          '${message.time}', // Access the title of the current message
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
// return Scaffold(
//   appBar: AppBar(
//     title: Text('Message Screen' +widget.id),
//   ),
// );