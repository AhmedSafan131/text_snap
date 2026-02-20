import 'dart:io';
import 'package:flutter/material.dart';
import 'text_extraction_page.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Image'), elevation: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TextExtractionPage(imagePath: imagePath)),
                );
              },
              icon: const Icon(Icons.document_scanner),
              label: const Text('Scan Text'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
