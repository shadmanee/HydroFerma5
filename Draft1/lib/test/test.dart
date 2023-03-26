// import 'dart:async';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// import '../util/sidebar.dart';
//
// class Notifications extends StatefulWidget {
//   const Notifications({Key? key}) : super(key: key);
//
//   @override
//   State<Notifications> createState() => _NotificationsState();
// }
//
// class _NotificationsState extends State<Notifications> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   late FirebaseMessaging _firebaseMessaging;
//   final List<Message> _messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     Firebase.initializeApp();
//     _firebaseMessaging = FirebaseMessaging.instance;
//     _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     Future<String?> getDeviceToken() async {
//       String? token = await FirebaseMessaging.instance.getToken();
//       print('FCM Token: $token');
//       return token;
//     }
//
//     getDeviceToken();
//
//     FirebaseMessaging.onMessage.listen((message) {
//       setState(() {
//         _messages.add(Message(
//           title: message.notification?.title ?? '',
//           body: message.notification?.body ?? '',
//         ));
//       });
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       setState(() {
//         _messages.add(Message(
//           title: message.notification?.title ?? '',
//           body: message.notification?.body ?? '',
//         ));
//       });
//     });
//     // Get any messages that were stored while the app was in the background or terminated
//     FirebaseMessaging.onBackgroundMessage((message)async{
//       setState(() {
//         _messages.add(Message(
//           title: message.notification?.title ?? '',
//           body: message.notification?.body ?? '',
//         ));
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: Sidebar(),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Image.asset('images/logo-white.png'),
//                     iconSize: 45,
//                     onPressed: () {
//                       _scaffoldKey.currentState!.openDrawer();
//                     },
//                   ),
//                   const Spacer(),
//                   Stack(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.notifications),
//                         iconSize: 35,
//                         color: const Color(0xff7aa3c7),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                       _messages.isNotEmpty
//                           ? Positioned(
//                         top: 10,
//                         right: 8,
//                         child: CircleAvatar(
//                           radius: 8,
//                           backgroundColor: Colors.red,
//                           child: Text(
//                             _messages.length.toString(),
//                             style: const  TextStyle(
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       )
//                           : const SizedBox.shrink(),
//                     ],
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.person),
//                     iconSize: 35,
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 15),
//                 child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _messages[index].title,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             _messages[index].body,
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class Message {
//   final String title;
//   final String body;
//
//   Message({required this.title, required this.body});
// }

import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final String title;
  final String description;

  SwipeCard({required this.title, required this.description});

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    return _dismissed
        ? SizedBox.shrink()
        : Dismissible(
      key: Key(widget.title),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        setState(() {
          _dismissed = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dismissed'),
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
        margin: EdgeInsets.all(8),
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
                          color: Colors.black.withOpacity(0.6),
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
    );
  }
}

