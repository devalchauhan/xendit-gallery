import 'package:xendit_gallery/core/error/exceptions/exceptions.dart';
import 'package:xendit_gallery/features/image_detail/data/model/image_detail_model.dart';

abstract class ImageDetailDatasource {
  Future<List<ImageDetailModel>> getImageDetail();
}

class ImageDetailDatasourceImpl implements ImageDetailDatasource {
  List<ImageDetailModel> allImages = [];
  @override
  Future<List<ImageDetailModel>> getImageDetail() {
    try {
      print('call local db');
      // call local db here
      return Future.value(allImages);
    } catch (e) {
      throw DownloadException(error: e.toString());
    }
  }
}
