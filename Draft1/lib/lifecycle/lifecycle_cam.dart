import 'package:flutter/material.dart';
import 'package:hydroferma5/lifecycle/photo_screen.dart';
import 'package:hydroferma5/lifecycle/picture_history.dart';
import 'package:hydroferma5/lifecycle/processing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../home/message_screen.dart';
import '../home/notifications.dart';
import '../home/user.dart';
import '../util/sidebar.dart';
import 'camera_screen.dart';

class LifecycleCam extends StatefulWidget {
  const LifecycleCam({Key? key}) : super(key: key);

  @override
  State<LifecycleCam> createState() => _LifecycleCamState();
}

class _LifecycleCamState extends State<LifecycleCam> {
  int notificationCount = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Open Camera',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      const SizedBox(height: 15),
                      IconButton(
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const CameraScreen()),
                          );
                        },
                        icon: const Icon(Icons.camera_alt_rounded),
                        iconSize: 180,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Select from Gallery',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      const SizedBox(height: 15),
                      IconButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() async {
                              _image = XFile(pickedFile.path);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Loading(photo: _image!),
                                ),
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.add_photo_alternate),
                        iconSize: 200,
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.bottomToTop,
                              child: const PictureHistory(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('History',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 10),
                            // Add some space between the text and icon
                            Image.asset(
                              'images/images.png',
                              width: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

