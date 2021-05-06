import 'package:flutter/foundation.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';

class AllImages {
  List<ImageModel> allImages = [];
  AllImages({this.allImages});

  AllImages.fromJson(Map<String, dynamic> json) {
    if (json['hits'] != null) {
      json['hits'].forEach((v) {
        ImageModel imageModel = ImageModel.fromJson(v);
        allImages.add(imageModel);
      });
    }
  }
}

class ImageModel extends NetImage {
  ImageModel({
    @required int id,
    @required String previewURL,
    @required String largeImageURL,
    @required double percentage,
    @required String taskId,
  }) : super(
          id: id,
          previewURL: previewURL,
          largeImageURL: largeImageURL,
          percentage: percentage,
          taskId: taskId,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'previewURL': previewURL,
      'largeImageURL': largeImageURL,
      'percentage': percentage,
      'taskId': taskId,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      previewURL: json['previewURL'],
      largeImageURL: json['largeImageURL'],
      percentage: 0.0,
      taskId: '',
    );
  }
}
