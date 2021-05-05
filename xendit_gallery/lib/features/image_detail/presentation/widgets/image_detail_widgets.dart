import 'package:flutter/material.dart';
import 'package:xendit_gallery/constants/colors.dart';
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
  dynamic element;
  SectionRow({@required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        color: kPrimaryColor,
        child: Text(element['name']),
      ),
    );
  }
}
