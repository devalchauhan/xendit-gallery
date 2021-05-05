import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xendit_gallery/constants/colors.dart';
import 'package:xendit_gallery/constants/strings.dart';
import 'package:xendit_gallery/constants/text_styles.dart';

class SectionHeader extends StatelessWidget {
  String groupByValue;
  SectionHeader({@required this.groupByValue});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          groupByValue,
          style: kGroupTitleTextStyle,
        ),
      ),
    );
  }
}

class SectionRow extends StatelessWidget {
  DownloadTask element;
  SectionRow({@required this.element});
  List _popUpItems = ['Delete', 'Cancel'];
  @override
  Widget build(BuildContext context) {
    final headerData = jsonDecode(element.headers);
    return GestureDetector(
      child: Container(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          color: kPrimaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                    imageUrl: headerData['previewURL'],
                    placeholder: (context, url) => Shimmer(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headerData['imageId'],
                      style: kGroupTitleTextStyle,
                    ),
                    Container(
                      width: 120,
                      height: 35,
                      child: Card(
                        color: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Center(
                            child: Text(
                          'Downloaded',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    LinearPercentIndicator(
                      width: 140.0,
                      lineHeight: 8.0,
                      percent: 0.5,
                      backgroundColor: Colors.white,
                      progressColor: Colors.orangeAccent,
                    )
                  ],
                ),
              ),
              PopupMenuButton(
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return List.generate(_popUpItems.length, (index) {
                    return PopupMenuItem(
                      child: Text(_popUpItems[index]),
                    );
                  });
                },
                onSelected: (dynamic index) {
                  print('index is $index');
                },
              ),
            ],
          ), //Text(element['name']
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, IMAGE_BROWSER,
            arguments: element.savedDir + '/' + element.filename);
      },
    );
  }
}
