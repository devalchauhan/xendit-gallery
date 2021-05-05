import 'dart:io';

import 'package:flutter/material.dart';

class ImageBrowser extends StatelessWidget {
  final String imagePath;
  ImageBrowser({@required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Browser'),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
