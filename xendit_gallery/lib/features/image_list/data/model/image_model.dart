import 'package:flutter/foundation.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';

class ImageModel extends NetImage {
  ImageModel(
      {@required String id,
      @required String previewURL,
      @required String largeImageURL})
      : super(id: id, previewURL: previewURL, largeImageURL: largeImageURL);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'previewURL': previewURL,
      'largeImageURL': largeImageURL,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    final data = json['hits'];
    return ImageModel(
      id: data['id'],
      previewURL: data['previewURL'],
      largeImageURL: data['largeImageURL'],
    );
  }
}
