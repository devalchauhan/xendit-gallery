import 'package:flutter/foundation.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';

class AllImageDetails {
  List<ImageDetailModel> allImageDetails = [];
  AllImageDetails({this.allImageDetails});

  AllImageDetails.fromJson(Map<String, dynamic> json) {
    if (json['hits'] != null) {
      json['hits'].forEach((v) {
        ImageDetailModel imageModel = ImageDetailModel.fromJson(v);
        allImageDetails.add(imageModel);
      });
    }
  }
}

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

  factory ImageDetailModel.fromJson(Map<String, dynamic> json) {
    return ImageDetailModel(
      id: json['id'],
      previewURL: json['previewURL'],
      largeImageURL: json['largeImageURL'],
      downloadStatus: json['downloadStatus'],
      localPreviewPath: json['localPreviewPath'],
      localLargeImagePath: json['localLargeImagePath'],
    );
  }
}
