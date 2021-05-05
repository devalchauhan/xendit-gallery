import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';

class ImageDetailModel extends ImageDetailEntity {
  ImageDetailModel(
      {@required String id,
      @required String previewURL,
      @required DownloadTask downloadTask})
      : super(id: id, previewURL: previewURL, downloadTask: downloadTask);
}
