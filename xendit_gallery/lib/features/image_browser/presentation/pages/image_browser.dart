import 'package:flutter/material.dart';

class ImageBrowser extends StatelessWidget {
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
      body: Container(
        child: Image.asset(
          'assets/images/default.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
