import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_detail/domain/repository/image_detail_repository.dart';

class GetImageDetail implements UseCase<List<DownloadTask>, NoParams> {
  final ImageDetailRepository imageDetailRepository;
  GetImageDetail({@required this.imageDetailRepository});

  @override
  Future<Either<Failure, List<DownloadTask>>> call(NoParams params) async {
    return await imageDetailRepository.getImageDetail();
  }
}
