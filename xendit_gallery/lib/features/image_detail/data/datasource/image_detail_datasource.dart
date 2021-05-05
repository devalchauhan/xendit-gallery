import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/core/error/exceptions/exceptions.dart';
import 'package:xendit_gallery/features/image_detail/data/model/image_detail_model.dart';

abstract class ImageDetailDatasource {
  Future<List<DownloadTask>> getImageDetail();
}

class ImageDetailDatasourceImpl implements ImageDetailDatasource {
  List<ImageDetailModel> allImages = [];
  @override
  Future<List<DownloadTask>> getImageDetail() async {
    try {
      final tasks = await FlutterDownloader.loadTasks();
      return Future.value(tasks);
    } catch (e) {
      throw DownloadException(error: e.toString());
    }
  }
}
