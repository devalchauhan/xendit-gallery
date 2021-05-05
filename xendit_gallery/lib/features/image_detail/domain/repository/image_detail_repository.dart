import 'package:dartz/dartz.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';

abstract class ImageDetailRepository {
  Future<Either<Failure, List<DownloadTask>>> getImageDetail();
}
