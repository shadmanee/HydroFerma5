import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydroferma5/lifecycle/processing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:camera/camera.dart';

class PhotoScreen extends StatelessWidget {
  final XFile photo;

  const PhotoScreen(this.photo, {super.key});

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}');
      List<int> imageData = await imageFile.readAsBytes();
      UploadTask uploadTask =
          storageReference.putData(Uint8List.fromList(imageData));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print("\n\n\n\nDOWNLOAD URL: $downloadUrl\n\n\n\n");
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> sendImageToStreamlit(String imageUrl) async {
    try {
      await launch(
          Uri.encodeFull("http://192.168.223.43:8501/?imageUrl=$imageUrl"));
    } catch (e) {
      print("\n\n\n\nError: $e\n\n\n\n");
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
                String? imgUrl =
                    await uploadImageToFirebaseStorage(File(photo.path));
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Saved'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () async {
                            //TODO: go to processing page
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Loading(photo: photo),
                              ),
                            );
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
                'Save & Process',
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
