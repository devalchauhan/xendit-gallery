import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NetImage extends Equatable {
  final int id;
  final String previewURL;
  final String largeImageURL;
  double percentage;
  String taskId;

  NetImage(
      {@required this.id,
      @required this.previewURL,
      @required this.largeImageURL,
      @required this.percentage,
      @required this.taskId});

  @override
  List<Object> get props => [
        id,
        previewURL,
        largeImageURL,
        percentage,
        taskId,
      ];
}
