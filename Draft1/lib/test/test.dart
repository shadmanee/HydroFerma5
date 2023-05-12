import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:hydroferma5/classifier/classifier.dart';
import 'package:hydroferma5/classifier/classifier_quant.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ImageClassifier extends StatefulWidget {
  final XFile image;

  const ImageClassifier({Key? key, required this.image}) : super(key: key);

  @override
  _ImageClassifierState createState() => _ImageClassifierState();
}

class _ImageClassifierState extends State<ImageClassifier> {
  late Classifier _classifier;

  var logger = Logger();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TfLite Flutter Helper',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: _imageWidget == null
                ? Text('No image selected.')
                : Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: _imageWidget!,
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Text(
            _category != null ? _category!.label : 'Nothing Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            _category != null
                ? 'Confidence: ${_category!.score.toStringAsFixed(3)}'
                : '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
