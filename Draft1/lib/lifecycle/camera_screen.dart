import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/lifecycle/photo_screen.dart';
import 'package:hydroferma5/lifecycle/processing.dart';
import 'package:hydroferma5/test/test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:camera/camera.dart';
import '../home/notifications.dart';
import '../home/user.dart';
import '../util/sidebar.dart';
import 'package:http/http.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Get the first camera available on the device.
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        // Initialize the camera controller.
        _controller = CameraController(cameras[0], ResolutionPreset.max);
        _initializeControllerFuture = _controller!.initialize();
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                )
              ],
            ),
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _controller != null
                      ? Container(
                      height: MediaQuery.of(context).size.height * .75,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: CameraPreview(_controller!))
                      : const Text("No Camera");
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            _controller != null
                ? ElevatedButton(
              onPressed: () async {
                // Take the picture.
                final XFile picture = await _controller!.takePicture();

                // Navigate to the photo screen.
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Loading(photo: picture),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
                backgroundColor: CupertinoColors.systemGrey4,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 54,
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }
}


