import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:xendit_gallery/core/error/failures/failure.dart';
import 'package:xendit_gallery/core/usecases/usecase.dart';
import 'package:xendit_gallery/features/image_list/domain/entities/image.dart';
import 'package:xendit_gallery/features/image_list/domain/repository/image_list_repository.dart';

class GetImageList implements UseCase<List<NetImage>, NoParams> {
  final ImageListRepository imageListRepository;
  GetImageList({@required this.imageListRepository});

  @override
  Future<Either<Failure, List<NetImage>>> call(NoParams params) async {
    return await imageListRepository.getImageList();
  }
}
