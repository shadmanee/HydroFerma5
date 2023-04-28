import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
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
                        'Tap to open camera.',
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
                        iconSize: 250,
                      ),
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
                            const Text('All Images',
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
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PhotoScreen(picture),
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

class PhotoScreen extends StatelessWidget {
  final XFile photo;

  const PhotoScreen(this.photo, {super.key});

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      // Create a reference to the Firebase Storage location where the image will be stored.
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');

      // Get the image data as bytes.
      List<int> imageData = await imageFile.readAsBytes();

      // Upload the image data to Firebase Storage.
      UploadTask uploadTask =
          storageReference.putData(Uint8List.fromList(imageData));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Return the download URL of the image that was just uploaded.
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
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
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Image.file(
                File(photo.path),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await uploadImageToFirebaseStorage(File(photo.path));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Saved'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: CupertinoColors.systemGrey4,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PictureHistory extends StatefulWidget {
  const PictureHistory({Key? key}) : super(key: key);

  @override
  State<PictureHistory> createState() => _PictureHistoryState();
}

class _PictureHistoryState extends State<PictureHistory> {
  List<String> _imageUrls =
      []; // List to store image URLs retrieved from Firebase Storage

  @override
  void initState() {
    super.initState();
    _getImageUrls(); // Function to retrieve image URLs from Firebase Storage
  }

  Future<void> _getImageUrls() async {
    // Retrieve image URLs from Firebase Storage
    final ListResult result =
        await FirebaseStorage.instance.ref().child('images/').listAll();
    final List<Reference> allFiles = result.items;
    final List<String> urls = [];

    for (final Reference ref in allFiles) {
      final String url = await ref.getDownloadURL();
      urls.add(url);
    }

    setState(() {
      _imageUrls = urls;
    });
  }

  Future<void> clearFirebaseStorage() async {
    // Get a reference to the Firebase Storage bucket
    final ref = FirebaseStorage.instance.ref().child('images/');

    // Get a list of all files in the bucket
    final ListResult result = await ref.listAll();
    final List<Reference> allFiles = result.items;

    // Delete each file in the bucket
    for (final Reference ref in allFiles) {
      await ref.delete();
    }
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
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            _imageUrls.isNotEmpty
                ? InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Clear History'),
                            content: const Text(
                                'Are you sure you want to clear your history?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Clear'),
                                onPressed: () {
                                  clearFirebaseStorage();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Delete All'),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(Icons.delete_forever_outlined,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  )
                : Container(),
            _imageUrls.isNotEmpty
                ? Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _imageUrls.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageDetailScreen(
                                  imageUrl: _imageUrls[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              _imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text(
                        'No Images',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;

  const ImageDetailScreen({super.key, required this.imageUrl});

  Future<void> _deleteImage(BuildContext context) async {
    try {
      // Delete image from Firebase Storage
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print(e);
    }
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
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Hero(
                tag: imageUrl,
                child: Image.network(imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: CupertinoColors.destructiveRed,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Image'),
                        content: const Text(
                            'Are you sure you want to delete this image?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              _deleteImage(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
