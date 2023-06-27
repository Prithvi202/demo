import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final List<Uint8List> capturedImages;
  final Function() clearImages;

  ImageScreen({required this.capturedImages, required this.clearImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Images'),
                  content: Text('Are you sure you want to clear all images?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Clear'),
                      onPressed: () {
                        clearImages();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: capturedImages.length,
        itemBuilder: (context, index) {
          return Image.memory(
            capturedImages[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
