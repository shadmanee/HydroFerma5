import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageDetailScreen extends StatefulWidget {
  final String imageUrl;

  const ImageDetailScreen({required this.imageUrl});

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  String _label = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _getImageMetadata();
  }

  Future<void> _getImageMetadata() async {
    // Get the image reference from Firebase Storage
    final ref = FirebaseStorage.instance.refFromURL(widget.imageUrl);

    // Get the metadata for the image
    final metadata = await ref.getMetadata();
    print(
        "\n\n\n${metadata.customMetadata?['label']}\n\n${metadata.customMetadata?['score']}\n\n\n");

    setState(() {
      _label = metadata.customMetadata?['label'] ?? '';
      _confidence = double.parse(metadata.customMetadata?['score'] ?? '0.0');
    });
  }

  Future<void> _deleteImage(String imageUrl) async {
    // Delete the image from Firebase Storage
    await FirebaseStorage.instance.refFromURL(imageUrl).delete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Image.network(
                widget.imageUrl,
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 16),
              Text(
                'Label: $_label',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  await _deleteImage(widget.imageUrl);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: CupertinoColors.destructiveRed,
                ),
                child: const Text(
                  'Delete Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
