import 'package:dartz/dartz.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_detail/data/model/image_detail_model.dart';

abstract class ImageDetailRepository {
  Future<Either<Failure, List<ImageDetailModel>>> getImageDetail();
}
