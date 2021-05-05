import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class ImageDetailEntity extends Equatable {
  final String id;
  final String previewURL;
  final DownloadTask downloadTask;

  ImageDetailEntity(
      {@required this.id,
      @required this.previewURL,
      @required this.downloadTask});

  @override
  List<Object> get props => [
        id,
        previewURL,
        downloadTask,
      ];
}
