import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'image_detail.dart';

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

