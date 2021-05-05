import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';

abstract class ImageListRemoteDatasource {
  Future<List<NetImage>> getImageList();
}

class ImageListRemoteDatasourceImpl implements ImageListRemoteDatasource {
  @override
  Future<List<NetImage>> getImageList() {
    // TODO: implement getImageList
    throw UnimplementedError();
  }
}
