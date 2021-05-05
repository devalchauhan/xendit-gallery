import 'package:dartz/dartz.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';

abstract class ImageDetailRepository {
  Future<Either<Failure, List<ImageDetailEntity>>> getImageDetail();
}
