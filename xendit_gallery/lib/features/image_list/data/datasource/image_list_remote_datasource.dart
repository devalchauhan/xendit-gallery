import 'package:xendit_gallery/core/error/exceptions/exceptions.dart';
import 'package:xendit_gallery/core/networking/api_base_helper.dart';
import 'package:xendit_gallery/features/image_list/data/model/image_model.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';

abstract class ImageListRemoteDatasource {
  Future<List<ImageModel>> getImageList(PageParams params);
}

class ImageListRemoteDatasourceImpl implements ImageListRemoteDatasource {
  List<ImageModel> allImages = [];
  ApiBaseHelper _helper = ApiBaseHelper();
  @override
  Future<List<ImageModel>> getImageList(PageParams params) async {
    try {
      final response = await _helper.get(params.page);
      allImages.addAll(AllImages.fromJson(response).allImages);
      return Future.value(allImages);
    } catch (e) {
      throw DownloadException(error: e.toString());
    }
  }
}
