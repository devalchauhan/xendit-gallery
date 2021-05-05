import 'package:xendit_gallery/core/error/exceptions/exceptions.dart';
import 'package:xendit_gallery/core/networking/api_base_helper.dart';
import 'package:xendit_gallery/features/image_list/data/model/image_model.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';

abstract class ImageListRemoteDatasource {
  Future<List<NetImage>> getImageList();
}

class ImageListRemoteDatasourceImpl implements ImageListRemoteDatasource {
  ApiBaseHelper _helper = ApiBaseHelper();
  @override
  Future<List<NetImage>> getImageList() async {
    try {
      final response = await _helper.get();
      return Future.value(AllImages.fromJson(response).allImages);
    } catch (e) {
      throw DownloadException(error: e.error);
    }
  }
}
