import 'package:dartz/dartz.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_list/data/datasource/image_list_remote_datasource.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';
import 'package:xendit_gallery/features/image_list/domain/repository/image_list_repository.dart';
import 'package:xendit_gallery/features/image_list/domain/usecases/get_image_list.dart';

class ImageListRepositoryImpl implements ImageListRepository {
  ImageListRemoteDatasource imageListRemoteDatasource;
  ImageListRepositoryImpl({this.imageListRemoteDatasource});
  @override
  Future<Either<Failure, List<NetImage>>> getImageList(
      PageParams params) async {
    try {
      final List<NetImage> _images =
          await imageListRemoteDatasource.getImageList(params);
      return Right(_images);
    } catch (e) {
      return Left(DownloadFailure(error: e.error));
    }
  }
}
