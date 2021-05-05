import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ImageDetailEntity extends Equatable {
  final String id;
  final String previewURL;
  final String largeImageURL;
  final String downloadStatus;
  final String localPreviewPath;
  final String localLargeImagePath;

  ImageDetailEntity(
      {@required this.id,
      @required this.previewURL,
      @required this.largeImageURL,
      @required this.downloadStatus,
      @required this.localPreviewPath,
      @required this.localLargeImagePath});

  @override
  List<Object> get props => [
        id,
        previewURL,
        largeImageURL,
        downloadStatus,
        localPreviewPath,
        localLargeImagePath,
      ];
}
