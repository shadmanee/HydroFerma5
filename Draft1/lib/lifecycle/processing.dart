import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydroferma5/lifecycle/lifecycle_cam.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hydroferma5/classifier/classifier.dart';
import 'package:hydroferma5/classifier/classifier_quant.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Loading extends StatefulWidget {
  final XFile photo;

  const Loading({Key? key, required this.photo}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late XFile photo;

  @override
  void initState() {
    super.initState();
    startTimer();
    photo = widget.photo;
  }

  late int move = getRandomNumber();

  int getRandomNumber() {
    var rng = Random();
    int min = 1;
    int max = 5;
    int randomNumber = min + rng.nextInt(max - min);
    return randomNumber;
  }

  startTimer() async {
    var duration = Duration(seconds: move);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Classification(image: photo)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: const <Widget>[
                  Center(
                    child: SpinKitPouringHourGlassRefined(
                      duration: Duration(seconds: 3),
                      color: Colors.green,
                      size: 100.0,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Please wait....",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Classification extends StatefulWidget {
  final XFile image;

  const Classification({Key? key, required this.image}) : super(key: key);

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  late Classifier _classifier;

  Image? _imageWidget;
  Category? _category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierFloat();
    _decodeImage();
  }

  void _decodeImage() async {
    Uint8List bytes = await widget.image.readAsBytes();
    img.Image imageInput = img.decodeImage(bytes)!;
    setState(() {
      _imageWidget = Image.memory(bytes);
      _predict(imageInput);
    });
  }

  void _predict(img.Image image) async {
    var pred = _classifier.predict(image);
    setState(() {
      _category = pred;
    });
  }

  Future<void> saveImage(img.Image image, Category category) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Compress the image
      final compressedImage = await FlutterImageCompress.compressWithList(
          Uint8List.fromList(img.encodeJpg(image, quality: 90)),
          quality: 75);

      // Upload the compressed image and its metadata to Firebase Storage
      final uploadTask = storageRef.putData(
        compressedImage!,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'label': category.label.substring(2),
            'score': '${category.score.toDouble() * 100}',
          },
        ),
      );
      await uploadTask;

      print('Image uploaded to Firebase Storage');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LifecycleCam()));
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: _imageWidget == null
                  ? const Text('No image selected.')
                  : Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery
                        .of(context)
                        .size
                        .height / 2),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: _imageWidget!,
              ),
            ),
            const SizedBox(height: 36),
            Text(
              _category != null
                  ? _category!.label.substring(2)
                  : 'Nothing Found',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _category != null
                  ? 'Confidence: ${(_category!.score.toDouble() * 100)
                  .round()}%'
                  : '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final imageBytes = await File(widget.image.path).readAsBytes();
                final image = img.decodeImage(imageBytes);
                if (image == null) {
                  throw Exception('Failed to decode image');
                }
                await saveImage(image, _category!);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Saved'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () async {
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
                backgroundColor: CupertinoColors.activeGreen,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
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
