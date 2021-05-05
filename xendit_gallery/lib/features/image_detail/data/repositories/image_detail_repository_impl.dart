import 'package:dartz/dartz.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/features/image_detail/data/datasource/image_detail_datasource.dart';
import 'package:xendit_gallery/features/image_detail/domain/repository/image_detail_repository.dart';

class ImageDetailRepositoryImpl implements ImageDetailRepository {
  ImageDetailDatasource imageDetailDatasource;
  ImageDetailRepositoryImpl({this.imageDetailDatasource});
  @override
  Future<Either<Failure, List<DownloadTask>>> getImageDetail() async {
    try {
      final List<DownloadTask> _images =
          await imageDetailDatasource.getImageDetail();
      return Right(_images);
    } catch (e) {
      return Left(DownloadFailure(error: e.error));
    }
  }
}
