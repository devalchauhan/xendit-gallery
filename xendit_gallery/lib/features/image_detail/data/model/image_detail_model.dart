import 'package:flutter/foundation.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';

class ImageDetailModel extends ImageDetailEntity {
  ImageDetailModel(
      {@required String id,
      @required String previewURL,
      @required String largeImageURL,
      @required String downloadStatus,
      @required String localPreviewPath,
      @required String localLargeImagePath})
      : super(
            id: id,
            previewURL: previewURL,
            largeImageURL: largeImageURL,
            downloadStatus: downloadStatus,
            localPreviewPath: localPreviewPath,
            localLargeImagePath: localLargeImagePath);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'previewURL': previewURL,
      'largeImageURL': largeImageURL,
      'downloadStatus': downloadStatus,
      'localPreviewPath': localPreviewPath,
      'localLargeImagePath': localLargeImagePath,
    };
  }
}
