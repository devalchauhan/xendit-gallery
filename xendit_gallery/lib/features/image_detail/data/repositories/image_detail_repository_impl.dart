import 'package:dartz/dartz.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_detail/data/datasource/image_detail_datasource.dart';
import 'package:xendit_gallery/features/image_detail/domain/entities/image_detail.dart';
import 'package:xendit_gallery/features/image_detail/domain/repository/image_detail_repository.dart';

class ImageDetailRepositoryImpl implements ImageDetailRepository {
  ImageDetailDatasource imageDetailDatasource;
  ImageDetailRepositoryImpl({this.imageDetailDatasource});
  @override
  Future<Either<Failure, List<ImageDetailEntity>>> getImageDetail() {
    // TODO: implement getImageDetail
    throw UnimplementedError();
  }
}
