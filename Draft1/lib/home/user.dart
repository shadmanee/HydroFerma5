import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../util/sidebar.dart';
import 'editprofile.dart';
import 'message_screen.dart';
import 'notifications.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late String _photoUrl;
  late String _userName;
  late String _phoneNumber;
  int notificationCount = 1;
  bool passEnable = true;
  TextEditingController myInput = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _photoUrl = _auth.currentUser?.photoURL ?? '';
    _userName = _auth.currentUser?.displayName ?? 'No Name Found';
    _phoneNumber = _auth.currentUser?.phoneNumber ?? 'No Number Found';
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
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
                        icon: const Icon(Icons.notifications_none),
                        iconSize: 35,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const Notifications(),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        right: 8,
                        child: notificationCount == 0
                            ? Container()
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 15,
                                  minHeight: 15,
                                ),
                                child: Text(
                                  notificationCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 35,
                    color: const Color(0xff3cceac),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffC8F4E7),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150.0),
                        border: Border.all(
                          width: 10,
                          color: const Color(0xff2C7C5A),
                        ),
                      ),
                      child: _photoUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_photoUrl),
                            )
                          : Image.asset('images/user-blue.png'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff9AE7C9),
                      ),
                      child: TextButton(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset('images/user2.png'),
                              onPressed: () {},
                            ),
                            Text(_userName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff9AE7C9),
                      ),
                      child: TextButton(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.mail_outline),
                              iconSize: 30,
                              color: Colors.black,
                              onPressed: () {},
                            ),
                            Text(
                              _auth.currentUser?.email ?? 'No Email Found',
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff9AE7C9),
                      ),
                      child: TextButton(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset('images/smartphone.png'),
                              onPressed: () {},
                            ),
                            Text(
                              _phoneNumber,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff9AE7C9),
                      ),
                      child: TextButton(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset('images/padlock.png'),
                              onPressed: () {},
                            ),
                            const Text(
                              // todo: implement password hide/show
                              '*********',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            return const Color(0xff000000);
                          }),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff5791c0);
                            }
                            return const Color(0xff79C5FF);
                          }),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const EditProfilePage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('images/logout.png'),
                          iconSize: 40,
                          onPressed: () {
                            //  todo: log out functionality with pop up asking are you sure
                          },
                        ),
                        IconButton(
                          icon: Image.asset('images/poweroff.png'),
                          iconSize: 40,
                          onPressed: () {
                            //  todo: disconnect from the system
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
