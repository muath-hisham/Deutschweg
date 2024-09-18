import 'dart:io';
import 'package:flutter/material.dart';
import 'package:menschen/shared/text.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;
  final VoidCallback onDelete;

  const FullScreenImageViewer({
    Key? key,
    required this.imagePath,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.imageViewer),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: FileImage(File(imagePath)),
        ),
      ),
    );
  }
}
