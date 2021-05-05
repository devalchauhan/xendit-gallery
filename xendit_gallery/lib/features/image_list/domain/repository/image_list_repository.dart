import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';
import 'package:dartz/dartz.dart';

abstract class ImageListRepository {
  Future<Either<Failure, List<NetImage>>> getImageList();
}
