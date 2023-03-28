import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:camera/camera.dart';
import '../home/notifications.dart';
import '../home/user.dart';
import '../util/sidebar.dart';

class LifecycleCam extends StatefulWidget {
  const LifecycleCam({Key? key}) : super(key: key);

  @override
  State<LifecycleCam> createState() => _LifecycleCamState();
}

class _LifecycleCamState extends State<LifecycleCam> {
  int notificationCount = 1;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late List<CameraDescription> _cameras;
  late CameraController _controller;

  void _takePicture() async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/image.jpg';
    await _controller.takePicture();
    // do something with the image file
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      margin: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(300),
                          color: CupertinoColors.systemGrey5),
                      child: IconButton(
                        onPressed: () {
                          _takePicture();
                        },
                        icon: const Icon(Icons.camera_alt_outlined, size: 200),
                        iconSize: 250,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Center(
            //     child: SizedBox(
            //       height: 400,
            //       width: 300,
            //       child: CameraPreview(_controller),
            //     )
            // )
          ],
        ),
      ),
    );
  }
}
