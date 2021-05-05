import 'package:xendit_gallery/features/image_detail/data/repositories/image_detail_repository_impl.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';

abstract class ImageDetailDatasource {
  Future<List<ImageDetailEntity>> getImageDetail();
}

class ImageDetailDatasourceImpl implements ImageDetailDatasource {
  @override
  Future<List<ImageDetailEntity>> getImageDetail() {
    // TODO: implement getImageDetail
    throw UnimplementedError();
  }
}
